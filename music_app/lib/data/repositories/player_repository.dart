// lib/data/repositories/player_repository.dart

import '../sources/api_service.dart';
import '../models/player_state_model.dart';

class PlayerRepository {
  // ignore: unused_field
  final ApiService _apiService = ApiService();

  // Lấy danh sách bài hát
  Future<List<Song>> getSongs() async {
    try {
      final songsData = await ApiService.getSongs();
      return songsData.map((json) => Song.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load songs: $e');
    }
  }

  // Thêm bài hát vào yêu thích
  Future<void> addToFavorites(int songId) async {
    try {
      final ok = await ApiService.addFavorite(songId);
      if (!ok) {
        throw Exception('Backend rejected add favorite');
      }
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  // Xóa bài hát khỏi yêu thích
  Future<void> removeFromFavorites(int songId) async {
    try {
      final ok = await ApiService.removeFavorite(songId);
      if (!ok) {
        throw Exception('Backend rejected remove favorite');
      }
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  // Lấy danh sách yêu thích (danh sách ID bài hát)
  Future<List<int>> getFavorites() async {
    try {
      return await ApiService.getFavoritesIds();
    } catch (e) {
      throw Exception('Failed to load favorites: $e');
    }
  }

  // Thêm bài hát vào playlist
  Future<void> addToPlaylist(int playlistId, int songId) async {
    try {
      final ok = await ApiService.addSongToPlaylist(playlistId, songId);
      if (!ok) {
        throw Exception('Backend rejected add to playlist');
      }
    } catch (e) {
      throw Exception('Failed to add to playlist: $e');
    }
  }

  // Tải xuống bài hát
  Future<void> downloadSong(Song song) async {
    try {
      // TODO: Implement download functionality
      print('Downloading song: ${song.title}');
    } catch (e) {
      throw Exception('Failed to download song: $e');
    }
  }

  // Lấy thông tin nghệ sĩ
  Future<Map<String, dynamic>> getArtistInfo(String artistName) async {
    try {
      // TODO: Implement API call when backend endpoint is ready
      return {
        'name': artistName,
        'bio': 'Artist bio coming soon',
        'image': null,
      };
    } catch (e) {
      throw Exception('Failed to load artist info: $e');
    }
  }
}
