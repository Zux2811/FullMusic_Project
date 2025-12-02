# Flutter App - Backend Integration Updates

## 📋 Tóm tắt các thay đổi

Đã cập nhật Flutter app để tương thích hoàn toàn với backend Node.js/Express/Sequelize.

## 🔄 Các file đã sửa

### 1. **api_service.dart** - Mở rộng API methods
- ✅ Thêm `getSongs()` - Lấy danh sách bài hát
- ✅ Thêm `addComment()` - Thêm bình luận
- ✅ Thêm `getComments()` - Lấy bình luận theo bài hát
- ✅ Thêm `likeComment()` - Like bình luận
- ✅ Thêm `reportComment()` - Báo cáo bình luận
- ✅ Tất cả methods đều tự động gắn JWT token vào header

### 2. **api_constants.dart** - Thêm endpoint
- ✅ Thêm `reports` endpoint: `/api/reports`

### 3. **home_tab.dart** - Hiển thị danh sách bài hát từ API
- ✅ Đổi từ StatelessWidget → StatefulWidget
- ✅ Sử dụng `FutureBuilder` để load dữ liệu từ API
- ✅ Hiển thị loading state
- ✅ Hiển thị error state
- ✅ Tạo `_SongCard` widget hiển thị bài hát với ảnh từ Cloudinary

### 4. **search_tab.dart** - Tìm kiếm bài hát
- ✅ Load tất cả bài hát từ API khi mở tab
- ✅ Tìm kiếm real-time theo title hoặc artist
- ✅ Hiển thị danh sách bài hát dạng tile
- ✅ Click vào bài hát → mở `SongDetailPage`

### 5. **library_tab.dart** - Quản lý playlist
- ✅ Hiển thị danh sách playlist
- ✅ Hiển thị danh sách bài hát yêu thích
- ✅ Nút tạo playlist mới (dialog)
- ✅ TODO: Integrate với backend API

## [object Object]song_detail_page.dart** - Chi tiết bài hát
- ✅ Hiển thị ảnh bìa bài hát
- ✅ Hiển thị thông tin: title, artist, album
- ✅ Nút play bài hát
- ✅ Phần bình luận:
  - Thêm bình luận mới
  - Hiển thị danh sách bình luận
  - Hiển thị số lượt like
  - Hiển thị tên người dùng

## 🔌 API Integration

### Authentication
```dart
// Login
final res = await ApiService.signIn(email, password);
// Token tự động lưu vào SharedPreferences

// Google Sign-In
final res = await ApiService.signInWithGoogle(idToken);

// Logout
await ApiService.signOut();
```

### Songs
```dart
// Lấy tất cả bài hát
final songs = await ApiService.getSongs();
```

### Comments
```dart
// Thêm bình luận
await ApiService.addComment(
  songId: 1,
  playlistId: null,
  content: 'Great song!',
);

// Lấy bình luận
final comments = await ApiService.getComments(songId: 1);

// Like bình luận
await ApiService.likeComment(commentId);
```

### Reports
```dart
// Báo cáo bình luận
await ApiService.reportComment(
  commentId: 1,
  message: 'Inappropriate content',
);
```

## 🚀 Cách sử dụng

### 1. Cập nhật API Base URL
Sửa trong `lib/core/constants/api_constants.dart`:
```dart
// Cho development (Android emulator)
static const String baseUrl = "http://10.0.2.2:5000/api";

// Cho production
// static const String baseUrl = "https://your-backend.com/api";
```

### 2. Cấu hình Google Sign-In
Sửa trong `lib/core/constants/api_constants.dart`:
```dart
static const String googleWebClientId = "YOUR_GOOGLE_WEB_CLIENT_ID";
```

### 3. Chạy ứng dụng
```bash
flutter pub get
flutter run
```

## 📝 TODO - Tính năng cần hoàn thành

- [ ] Integrate playlist API (create, get, delete)
- [ ] Implement audio player (audioplayers package)
- [ ] Add liked songs functionality
- [ ] Implement user profile page
- [ ] Add offline mode support
- [ ] Implement push notifications
- [ ] Add share functionality
- [ ] Implement user follow system

## 🔐 Token Management

Token được tự động:
- ✅ Lưu vào SharedPreferences sau khi login
- ✅ Gắn vào Authorization header của mọi request
- ✅ Xóa khi logout

## 🎨 UI/UX Improvements

- ✅ Sử dụng NetworkImage cho ảnh từ Cloudinary
- ✅ Error handling cho ảnh không load được
- ✅ Loading indicators
- ✅ Gradient overlay trên ảnh bài hát
- ✅ Responsive design

## 🐛 Known Issues

- Playlist API chưa được integrate (TODO)
- Audio player chưa được implement
- User profile chưa hoàn thành

## 📚 Dependencies

Đảm bảo các package sau đã được thêm vào `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.5.0
  shared_preferences: ^2.5.3
  google_sign_in: ^6.2.1
```

## ✨ Features

### Home Tab
- Hiển thị danh sách bài hát từ backend
- Scroll ngang để xem thêm bài hát
- Click vào bài hát để xem chi tiết

### Search Tab
- Tìm kiếm bài hát theo title hoặc artist
- Hiển thị tất cả bài hát nếu không tìm kiếm
- Kết quả tìm kiếm real-time

### Library Tab
- Quản lý playlist
- Xem danh sách bài hát yêu thích
- Tạo playlist mới

### Settings Tab
- Đăng xuất
- Cài đặt chung (TODO)

## 🔗 Backend Endpoints Used

- `POST /api/auth/login` - Đăng nhập
- `POST /api/auth/register` - Đăng ký
- `POST /api/auth/google` - Google Sign-In
- `GET /api/songs` - Lấy danh sách bài hát
- `POST /api/comments` - Thêm bình luận
- `GET /api/comments` - Lấy bình luận
- `POST /api/comments/:id/like` - Like bình luận
- `POST /api/reports/:id` - Báo cáo bình luận

