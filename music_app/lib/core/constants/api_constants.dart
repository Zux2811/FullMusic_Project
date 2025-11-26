class ApiConstants {
  // static const String baseUrl = "https://music-app-backend.onrender.com/api";
  static const String baseUrl = "http://10.0.2.2:5000/api";

  static const String auth = "$baseUrl/auth";
  static const String songs = "$baseUrl/songs";
  static const String playlists = "$baseUrl/playlists";
  static const String folders = "$baseUrl/folders";
  static const String comments = "$baseUrl/comments";
  static const String profile = "$baseUrl/profile";

  // Web Client ID của Google OAuth (type: Web) dùng để lấy idToken trên mobile
  // Hãy thay bằng Client ID của bạn từ Google Cloud Console
  static const String googleWebClientId = "REPLACE_WITH_YOUR_WEB_CLIENT_ID";

}
