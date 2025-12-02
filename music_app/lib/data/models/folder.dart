import 'playlist.dart';

class Folder {
  final String id;
  String name;
  final List<Playlist> playlists;

  Folder({required this.id, required this.name, List<Playlist>? playlists})
    : playlists = playlists ?? [];

  factory Folder.fromJson(Map<String, dynamic> json) {
    // Handle both int and string IDs from backend
    final id = json['id'];
    final idStr = id is int ? id.toString() : (id ?? '').toString();

    // Backend may return nested playlists under 'Playlists' (Sequelize include)
    final rawPlaylists = (json['playlists'] ?? json['Playlists'] ?? []) as List;
    final playlistList =
        rawPlaylists.isNotEmpty
            ? rawPlaylists.map((i) => Playlist.fromJson(i)).toList()
            : <Playlist>[];

    return Folder(id: idStr, name: json['name'] ?? '', playlists: playlistList);
  }
}
