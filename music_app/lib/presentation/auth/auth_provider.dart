import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:music_app/core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.auth}/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];

        // Verify token is present before saving
        if (token == null || token.isEmpty) {
          _errorMessage = 'Server returned empty token';
          _isLoading = false;
          notifyListeners();
          return false;
        }

        // Lưu token vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        try {
          final errorData = json.decode(response.body);
          _errorMessage = errorData['message'] ?? 'Đăng nhập thất bại.';
        } catch (e) {
          _errorMessage =
              'HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Unknown error'}';
        }
      }
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi kết nối: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    notifyListeners();
  }
}
