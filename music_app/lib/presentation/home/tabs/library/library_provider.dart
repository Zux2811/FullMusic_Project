import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:music_app/core/constants/api_constants.dart';
import 'package:music_app/data/models/folder.dart';
import 'package:music_app/data/models/playlist.dart';
import 'package:music_app/data/models/player_state_model.dart';
import 'package:music_app/data/sources/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LibraryProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  Playlist _favoritesPlaylist = Playlist(
    id: 'favorites',
    name: 'Bài hát đã thích',
  );
  List<Folder> _folders = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Playlist get favoritesPlaylist => _favoritesPlaylist;
  List<Folder> get folders => _folders;

  // Helper để lấy headers kèm token
  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      // Ném lỗi hoặc xử lý trường hợp không có token
      throw Exception('Người dùng chưa đăng nhập hoặc token không tồn tại.');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> fetchLibrary() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('[LIBRARY] Fetching library...');
      final response = await http.get(
        Uri.parse(ApiConstants.folders),
        headers: await _getAuthHeaders(),
      );

      print('[LIBRARY] Fetch response status: ${response.statusCode}');
      print('[LIBRARY] Fetch response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _folders =
            data.map((folderData) => Folder.fromJson(folderData)).toList();
        print('[LIBRARY] Loaded ${_folders.length} folders');
        // TODO: Tải playlist yêu thích từ một endpoint riêng
      } else {
        _errorMessage = 'Lỗi ${response.statusCode}: ${response.body}';
        print('[LIBRARY] Error: $_errorMessage');
      }
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi kết nối: $e';
      print('[LIBRARY] Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createFolder(String name, {String? parentId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      print('[LIBRARY] Creating folder: $name parent=$parentId');
      final headers = await _getAuthHeaders();

      final body = <String, dynamic>{'name': name};
      if (parentId != null) {
        final pidNum = int.tryParse(parentId);
        body['parentId'] = pidNum ?? parentId;
      }

      final response = await http.post(
        Uri.parse(ApiConstants.folders),
        headers: headers,
        body: json.encode(body),
      );

      print('[LIBRARY] Create folder status: ${response.statusCode}');
      print('[LIBRARY] Create folder body: ${response.body}');

      if (response.statusCode == 201) {
        await fetchLibrary(); // reload after create
      } else {
        _errorMessage = 'Lỗi ${response.statusCode}: ${response.body}';
      }
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi kết nối: $e';
      print('[LIBRARY] Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPlaylist(String name, String folderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      print('[LIBRARY] Creating playlist: $name in folder: $folderId');
      // Gọi API flat: POST /playlists kèm folderId (number), user lấy từ JWT
      final folderIdNum = int.tryParse(folderId);
      final response = await http.post(
        Uri.parse(ApiConstants.playlists),
        headers: await _getAuthHeaders(),
        body: json.encode({'name': name, 'folderId': folderIdNum ?? folderId}),
      );

      print('[LIBRARY] Response status: ${response.statusCode}');
      print('[LIBRARY] Response body: ${response.body}');

      if (response.statusCode == 201) {
        print('[LIBRARY] Playlist created successfully');
        await fetchLibrary();
      } else {
        _errorMessage = 'Lỗi ${response.statusCode}: ${response.body}';
        print('[LIBRARY] Error: $_errorMessage');
      }
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi kết nối: $e';
      print('[LIBRARY] Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> renameFolder(String folderId, String newName) async {
    _isLoading = true;
    notifyListeners();
    try {
      final idNum = int.tryParse(folderId);
      final response = await http.put(
        Uri.parse('${ApiConstants.folders}/${idNum ?? folderId}'),
        headers: await _getAuthHeaders(),
        body: json.encode({'name': newName}),
      );
      if (response.statusCode == 200) {
        await fetchLibrary();
      } else {
        _errorMessage =
            'Lỗi ${response.statusCode}: Không thể đổi tên thư mục.';
      }
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi kết nối: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> moveFolder(String folderId, String? newParentId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final idNum = int.tryParse(folderId);
      final parentNum = newParentId != null ? int.tryParse(newParentId) : null;
      final response = await http.put(
        Uri.parse('${ApiConstants.folders}/${idNum ?? folderId}'),
        headers: await _getAuthHeaders(),
        body: json.encode({'parentId': parentNum ?? newParentId}),
      );
      if (response.statusCode == 200) {
        await fetchLibrary();
      } else {
        _errorMessage =
            'Lỗi ${response.statusCode}: Không thể di chuyển thư mục.';
      }
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi kết nối: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteFolder(String folderId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final idNum = int.tryParse(folderId);
      final response = await http.delete(
        Uri.parse('${ApiConstants.folders}/${idNum ?? folderId}'),
        headers: await _getAuthHeaders(),
      );
      if (response.statusCode == 200) {
        await fetchLibrary();
      } else {
        _errorMessage = 'Lỗi ${response.statusCode}: Không thể xóa thư mục.';
      }
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi kết nối: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> renamePlaylist(String playlistId, String newName) async {
    final idNum = int.tryParse(playlistId);
    if (idNum == null) {
      _errorMessage = 'Playlist ID không hợp lệ.';
      notifyListeners();
      return;
    }

    final success = await ApiService.renamePlaylist(idNum, newName);
    if (success) {
      // Find and update the local playlist name
      for (var folder in _folders) {
        for (var playlist in folder.playlists) {
          if (playlist.id == playlistId) {
            playlist.name = newName;
            notifyListeners();
            return;
          }
        }
      }
    } else {
      _errorMessage = 'Không thể đổi tên playlist. Vui lòng thử lại.';
      notifyListeners();
    }
  }

  Future<void> deletePlaylist(String playlistId) async {
    final idNum = int.tryParse(playlistId);
    if (idNum == null) {
      _errorMessage = 'Playlist ID không hợp lệ.';
      notifyListeners();
      return;
    }

    final success = await ApiService.deletePlaylist(idNum);
    if (success) {
      // Remove from local list to update UI instantly
      for (var folder in _folders) {
        folder.playlists.removeWhere((p) => p.id == playlistId);
      }
      notifyListeners();
    } else {
      _errorMessage = 'Không thể xóa playlist. Vui lòng thử lại.';
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Song song) async {
    try {
      final isFavorite = _favoritesPlaylist.songs.any((s) => s.id == song.id);
      bool ok = false;
      if (isFavorite) {
        ok = await ApiService.removeFavorite(song.id);
        if (ok) {
          _favoritesPlaylist.songs.removeWhere((s) => s.id == song.id);
        }
      } else {
        ok = await ApiService.addFavorite(song.id);
        if (ok) {
          _favoritesPlaylist.songs.add(song);
        }
      }
      if (!ok) {
        _errorMessage = 'Không thể cập nhật yêu thích. Vui lòng thử lại.';
      }
    } catch (e) {
      _errorMessage = 'Lỗi khi cập nhật yêu thích: $e';
    }
    notifyListeners();
  }
}
