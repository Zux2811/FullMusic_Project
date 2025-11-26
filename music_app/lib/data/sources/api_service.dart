import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';

class ApiService {
  // Đăng ký tài khoản
  static Future<Map<String, dynamic>> signUp(
    String username,
    String email,
    String password,
  ) async {
    final url = Uri.parse("${ApiConstants.auth}/register");
    try {
      final res = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 20));

      final contentType = res.headers['content-type'] ?? '';
      Map<String, dynamic> data;
      if (contentType.contains('application/json')) {
        data = jsonDecode(res.body) as Map<String, dynamic>;
      } else {
        data = {
          'message': res.body,
          'statusCode': res.statusCode,
        };
      }
      return data;
    } catch (e) {
      return {'message': e.toString()};
    }
  }

  // Đăng nhập
  static Future<Map<String, dynamic>> signIn(
    String email,
    String password,
  ) async {
    final url = Uri.parse("${ApiConstants.auth}/login");
    try {
      final res = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 20));

      final contentType = res.headers['content-type'] ?? '';
      Map<String, dynamic> data;
      if (contentType.contains('application/json')) {
        data = jsonDecode(res.body) as Map<String, dynamic>;
      } else {
        // Ví dụ: Render trả về "Not Found" (text/plain)
        data = {
          'message': res.body.isNotEmpty ? res.body : res.reasonPhrase,
          'statusCode': res.statusCode,
        };
      }

      if (res.statusCode == 200 && data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        return data;
      }

      // trả về thông điệp lỗi rõ ràng
      return {
        'message': data['message'] ?? 'HTTP ${res.statusCode}: ${res.reasonPhrase ?? 'Unknown'}',
        'statusCode': res.statusCode,
      };
    } catch (e) {
      return {'message': e.toString()};
    }
  }

  // Google Sign-In: gửi idToken nhận từ Google lên backend để đổi JWT
  static Future<Map<String, dynamic>> signInWithGoogle(String idToken) async {
    final url = Uri.parse("${ApiConstants.auth}/google");
    try {
      final res = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'idToken': idToken}),
          )
          .timeout(const Duration(seconds: 20));

      final contentType = res.headers['content-type'] ?? '';
      Map<String, dynamic> data;
      if (contentType.contains('application/json')) {
        data = jsonDecode(res.body) as Map<String, dynamic>;
      } else {
        data = {
          'message': res.body.isNotEmpty ? res.body : res.reasonPhrase,
          'statusCode': res.statusCode,
        };
      }

      if (res.statusCode == 200 && data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
      }
      return data;
    } catch (e) {
      return {'message': e.toString()};
    }
  }

  // Lấy token hiện tại
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Đăng xuất
  static Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
