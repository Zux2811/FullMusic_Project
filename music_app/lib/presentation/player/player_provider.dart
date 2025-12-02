// lib/presentation/player/player_provider.dart

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as ja;
import '../../data/models/player_state_model.dart';
import '../../data/repositories/player_repository.dart';

class PlayerProvider extends ChangeNotifier {
  final PlayerRepository _repository = PlayerRepository();

  // Audio engine
  final ja.AudioPlayer _player = ja.AudioPlayer();

  PlayerState _state = PlayerState();

  PlayerState get state => _state;
  Song? get currentSong => _state.currentSong;
  bool get isPlaying => _state.isPlaying;
  bool get isFavorite => _state.isCurrentSongFavorite;
  RepeatMode get repeatMode => _state.repeatMode;
  bool get isShuffle => _state.isShuffle;

  PlayerProvider() {
    _attachPlayerListeners();
  }

  void _attachPlayerListeners() {
    // Position updates
    _player.positionStream.listen((pos) {
      _updateState(_state.copyWith(currentPosition: pos));
    });

    // Duration updates
    _player.durationStream.listen((dur) {
      if (dur != null) {
        _updateState(_state.copyWith(totalDuration: dur));
      }
    });

    // Play/pause state
    _player.playerStateStream.listen((st) {
      final playing = st.playing;
      _updateState(
        _state.copyWith(
          playbackState: playing ? PlaybackState.playing : PlaybackState.paused,
        ),
      );
    });

    // Index changes (when skipping)
    _player.currentIndexStream.listen((idx) {
      if (idx != null && idx >= 0 && idx < _state.playlist.length) {
        _updateState(
          _state.copyWith(currentIndex: idx, currentPosition: Duration.zero),
        );
      }
    });
  }

  // Khởi tạo, nạp danh sách bài hát và set vào audio engine (không tự động phát)
  Future<void> initializePlaylist() async {
    _updateState(_state.copyWith(isLoading: true));
    try {
      final songs = await _repository.getSongs();
      final favorites = await _repository.getFavorites();

      _updateState(
        _state.copyWith(
          playlist: songs,
          favorites: Set<int>.from(favorites),
          isLoading: false,
        ),
      );

      if (songs.isNotEmpty) {
        final sources =
            songs
                .map((s) => ja.AudioSource.uri(Uri.parse(s.audioUrl)))
                .toList();
        await _player.setAudioSource(
          ja.ConcatenatingAudioSource(children: sources),
          initialIndex: 0,
          initialPosition: Duration.zero,
        );
        _updateState(_state.copyWith(currentIndex: 0));
      }
    } catch (e) {
      _updateState(
        _state.copyWith(isLoading: false, errorMessage: e.toString()),
      );
    }
  }

  // Phát/Tạm dừng
  void togglePlayPause() {
    if (_player.playing) {
      _player.pause();
      _updateState(_state.copyWith(playbackState: PlaybackState.paused));
    } else {
      _player.play();
      _updateState(_state.copyWith(playbackState: PlaybackState.playing));
    }
  }

  // Bài tiếp theo
  void nextTrack() {
    _player.seekToNext();
  }

  // Bài trước
  void previousTrack() {
    _player.seekToPrevious();
  }

  // Chuyển đổi chế độ Shuffle
  Future<void> toggleShuffle() async {
    final enabled = !_state.isShuffle;
    await _player.setShuffleModeEnabled(enabled);
    _updateState(_state.copyWith(isShuffle: enabled));
  }

  // Chuyển đổi chế độ Repeat (map sang LoopMode của just_audio)
  Future<void> toggleRepeatMode() async {
    final nextMode =
        _state.repeatMode == RepeatMode.noRepeat
            ? RepeatMode.repeatAll
            : _state.repeatMode == RepeatMode.repeatAll
            ? RepeatMode.repeatOne
            : RepeatMode.noRepeat;

    final loop =
        nextMode == RepeatMode.noRepeat
            ? ja.LoopMode.off
            : nextMode == RepeatMode.repeatAll
            ? ja.LoopMode.all
            : ja.LoopMode.one;
    await _player.setLoopMode(loop);

    _updateState(_state.copyWith(repeatMode: nextMode));
  }

  // Cập nhật vị trí phát
  void updatePosition(Duration position) {
    _player.seek(position);
    _updateState(_state.copyWith(currentPosition: position));
  }

  // Chuyển đến bài hát cụ thể
  Future<void> playTrackAtIndex(int index) async {
    if (index >= 0 && index < _state.playlist.length) {
      await _player.seek(Duration.zero, index: index);
      await _player.play();
      _updateState(
        _state.copyWith(
          currentIndex: index,
          currentPosition: Duration.zero,
          playbackState: PlaybackState.playing,
        ),
      );
    }
  }

  // Thêm/Xóa yêu thích
  Future<void> toggleFavorite() async {
    if (_state.currentSong == null) return;

    try {
      final songId = _state.currentSong!.id;
      final isFavorite = _state.isCurrentSongFavorite;

      if (isFavorite) {
        await _repository.removeFromFavorites(songId);
      } else {
        await _repository.addToFavorites(songId);
      }

      final newFavorites = Set<int>.from(_state.favorites);
      if (isFavorite) {
        newFavorites.remove(songId);
      } else {
        newFavorites.add(songId);
      }

      _updateState(_state.copyWith(favorites: newFavorites));
    } catch (e) {
      _updateState(_state.copyWith(errorMessage: e.toString()));
    }
  }

  // Thêm vào playlist
  Future<bool> addToPlaylist(int playlistId) async {
    if (_state.currentSong == null) return false;

    try {
      await _repository.addToPlaylist(playlistId, _state.currentSong!.id);
      return true;
    } catch (e) {
      _updateState(_state.copyWith(errorMessage: e.toString()));
      return false;
    }
  }

  // Tải xuống bài hát
  Future<void> downloadCurrentSong() async {
    if (_state.currentSong == null) return;

    try {
      await _repository.downloadSong(_state.currentSong!);
    } catch (e) {
      _updateState(_state.copyWith(errorMessage: e.toString()));
    }
  }

  // Lấy thông tin nghệ sĩ
  Future<Map<String, dynamic>> getArtistInfo() async {
    if (_state.currentSong == null) {
      return {};
    }

    try {
      return await _repository.getArtistInfo(_state.currentSong!.artist);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Thiết lập playlist và phát bài hát chỉ định
  Future<void> setPlaylistAndPlay(
    List<Song> playlist, {
    Song? currentSong,
    int? index,
  }) async {
    int playIndex = index ?? 0;
    if (currentSong != null) {
      final idx = playlist.indexWhere((s) => s.id == currentSong.id);
      if (idx != -1) playIndex = idx;
    }

    final sources =
        playlist.map((s) => ja.AudioSource.uri(Uri.parse(s.audioUrl))).toList();

    await _player.setAudioSource(
      ja.ConcatenatingAudioSource(children: sources),
      initialIndex: playIndex,
      initialPosition: Duration.zero,
    );
    await _player.play();

    _updateState(
      _state.copyWith(
        playlist: playlist,
        currentIndex: playIndex,
        currentPosition: Duration.zero,
        playbackState: PlaybackState.playing,
      ),
    );
  }

  // Phát 1 bài cụ thể (giữ nguyên playlist hiện tại, nếu không tồn tại thì thêm vào cuối)
  Future<void> playSong(Song song) async {
    final list = List<Song>.from(_state.playlist);
    int idx = list.indexWhere((s) => s.id == song.id);
    if (idx == -1) {
      list.add(song);
      idx = list.length - 1;
    }
    await setPlaylistAndPlay(list, index: idx);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _updateState(PlayerState newState) {
    _state = newState;
    notifyListeners();
  }

  void clearError() {
    _updateState(_state.copyWith(errorMessage: null));
  }
}
