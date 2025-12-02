class ApiConstants {
  static const String baseUrl =
      "https://music-app-backend-aijn.onrender.com/api";

  static const String auth = "$baseUrl/auth";
  static const String songs = "$baseUrl/songs";
  static const String playlists = "$baseUrl/playlists";
  static const String folders = "$baseUrl/folders";
  static const String comments = "$baseUrl/comments";
  static const String reports = "$baseUrl/reports";
  static const String profile = "$baseUrl/profile";
  static const String favorites = "$baseUrl/favorites";

  // Web Client ID của Google OAuth (type: Web) dùng để lấy idToken trên mobile
  // Hãy thay bằng Client ID của bạn từ Google Cloud Console
  static const String googleWebClientId =
      "1064772484660-k8h85fs2o68l5fn6ildd4ak2v6kvlnnj.apps.googleusercontent.com";
}
