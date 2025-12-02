import 'package:music_app/data/models/player_state_model.dart';

class Playlist {
  final String id;
  String name;
  final List<Song> songs;

  Playlist({required this.id, required this.name, List<Song>? songs})
    : songs = songs ?? [];

  factory Playlist.fromJson(Map<String, dynamic> json) {
    final idStr = (json['id'] ?? '').toString();
    final songsFromJson = json['songs'] as List? ?? [];
    final songsList =
        songsFromJson.isNotEmpty
            ? songsFromJson.map((i) => Song.fromJson(i)).toList()
            : <Song>[];

    return Playlist(id: idStr, name: json['name'] ?? '', songs: songsList);
  }
}
