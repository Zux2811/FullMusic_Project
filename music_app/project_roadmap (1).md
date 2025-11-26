# 📘 Project Roadmap — Flutter Music App + Node.js + MySQL + Cloudinary

Version: **2025**  
Author: **Anh Vũ Ngô**

---

# 🧩 1. Tổng quan dự án
Dự án là một ứng dụng nghe nhạc được xây dựng bằng **Flutter**, sử dụng **Node.js** làm backend và **MySQL** làm database. File nhạc và ảnh được lưu trữ trên **Cloudinary**.

Ứng dụng có các chức năng chính:
- Đăng ký / đăng nhập ( JWT backend)
- Hiển thị danh sách bài hát từ MySQL
- Phát nhạc theo URL Cloudinary
- Lặp lại / chuyển bài / tua bài
- Playlist riêng theo từng tài khoản
- Comment, thả tim (like) bài hát

---

# 🏗 2. Kiến trúc hệ thống
```
Flutter App  →  Node.js API (Render.com)  →  MySQL (Railway)  →  Cloudinary (Audio + Image)
```

---

# 📌 3. Lộ trình triển khai (chi tiết từ A → Z)

## ✅ **Bước 1 — Thiết kế Database MySQL**
Bảng chính:
- **users** (tài khoản)
- **songs** (danh sách bài hát)
- **playlists** (từng playlist của user)
- **playlist_items** (bài hát trong playlist)

Bảng `songs` gồm:
- id
- title
- artist
- image_url (Cloudinary)
- audio_url (Cloudinary)
- duration (không bắt buộc, Flutter tự đọc được)

> Bạn đã hoàn thành bước này.

---

## ✅ **Bước 2 — Backend Node.js (Express + Sequelize)**
Các API chính:
- POST `/auth/register`
- POST `/auth/login`
- GET `/songs`
- POST `/songs/upload` (upload Cloudinary)
- POST `/playlist/add`
- GET `/playlist/:userId`

Tính năng:
- JWT authentication
- Trả danh sách bài hát từ MySQL
- Upload file nhạc và ảnh lên Cloudinary

> Bạn đã làm xong backend cơ bản.

---

## 🚀 **Bước 3 — Deploy Backend lên Render.com**
Cấu hình cần có:
- Build: `npm install`
- Start: `node src/server.js`
- Environment Variables:
  - `DB_HOST`
  - `DB_USER`
  - `DB_PASS`
  - `DB_NAME`
  - `CLOUDINARY_CLOUD_NAME`
  - `CLOUDINARY_API_KEY`
  - `CLOUDINARY_API_SECRET`
  - `JWT_SECRET`

> Render không lưu được file nên phải dùng Cloudinary để lưu audio + ảnh.

---

# ☁ 4. Cấu hình Cloudinary
Cài thư viện:
```bash
npm install cloudinary multer multer-storage-cloudinary
```

API upload mẫu:
```js
cloudinary.uploader.upload(file.path, {
    resource_type: "auto"
});
```

Cloudinary trả về:
```json
{
  "url": "https://res.cloudinary.com/.../song.mp3"
}
```

URL này sẽ lưu vào MySQL và Flutter sẽ phát nhạc từ URL đó.

---

# 📱 5. Flutter App

## 5.1 Authentication UI
- `signin.dart`
- `signup.dart`

## 5.2 Home Page
- Lấy danh sách bài hát từ API Render
- Hiển thị ảnh + tên bài hát

## 5.3 Player Page
Chức năng:
- Phát nhạc từ URL Cloudinary
- Tua / pause / next / previous
- Like (đổi icon trái tim sang đỏ)

## 5.4 Playlist Page
- Mỗi user có playlist riêng lưu trong MySQL
- Add/remove bài hát từ playlist

---

# 🎨 6. Tính năng nâng cao (tuỳ chọn)
- Bình luận bài hát (Realtime Firebase)
- Gợi ý nhạc dựa trên hành vi
- Tìm kiếm nâng cao
- Chế độ Dark Mode

---

# 🔧 7. Trang Admin (tuỳ chọn)
- Upload nhạc
- Upload ảnh
- Quản lý playlist người dùng
- Quản lý user

Có thể viết bằng Flutter Web hoặc ReactJS.

---

# 📌 8. Công việc bạn đã hoàn thành
- Thiết kế MySQL ✔
- Backend CRUD cơ bản ✔
- Đã push backend lên GitHub ✔
- Đã tạo Web Service trên Render ✔
- Đã làm UI signin/signup ✔

---

# 🎯 9. Công việc bạn cần làm **ngay bây giờ**
## 🔥 Việc quan trọng nhất:
### **1. Thêm Cloudinary vào backend (upload audio + image)**
### **2. Sửa API `/songs` để trả về URL Cloudinary**
### **3. Sửa Flutter để phát nhạc từ URL backend trả về**

---

# 🧪 10. Test End-to-End
- Upload một bài nhạc bằng API → MySQL lưu → Flutter lấy URL → nghe nhạc thành công.

---

////////////////////////////////////////////////////////

Tuyệt, đây là lộ trình (roadmap) rõ ràng về những gì bạn đã làm xong và những việc cần làm tiếp theo cho dự án.

NHỮNG VIỆC ĐÃ LÀM XONG

Kiến trúc dự án
3 phần: Flutter mobile (music_app), Backend Node.js + Sequelize (music-app-backend), React Admin (admin-dashboard).
Backend
Auth cơ bản (register/login) với JWT.
Sửa lỗi đăng nhập admin: chuyển toàn bộ controller từ cú pháp MongoDB sang Sequelize; dùng admin.id thay vì _id; thêm tài liệu và script tạo admin.
Kết nối Sequelize, routes chính: /api/auth, /api/songs, /api/admin, /api/comments, /api/reports.
Flutter
Màn hình Splash, Auth (SignIn/SignUp), Home shell + bottom tabs.
Sửa ApiService: không còn jsonDecode mù quáng để tránh FormatException khi server trả về “Not Found”; thêm timeout và thông báo lỗi rõ ràng.
Android build
Nâng Kotlin lên 2.1.0, dùng Java 17; đồng bộ Gradle plugin và kotlin plugin id.
Tài liệu hỗ trợ
Thêm các file hướng dẫn: QUICK_FIX.txt, FIX_ADMIN_LOGIN.md, README_ADMIN_FIX.md, DETAILED_FIX_GUIDE.md, SUMMARY.txt.
VIỆC CẦN LÀM NGAY (ưu tiên trong hôm nay)

Cấu hình đúng baseUrl cho môi trường đang test
File: music_app/lib/core/constants/api_constants.dart
Chọn 1 trong các giá trị:
Android emulator: http://10.0.2.2:5000/api
iOS simulator/Web/Desktop: http://localhost:5000/api
Thiết bị thật: http://IP-may-tinh:5000/api
Hoặc Render: https://music-app-backend.onrender.com/api
Khởi chạy backend cục bộ và kiểm tra
cd music-app-backend
Tạo .env (DB_HOST, DB_USER, DB_PASS, DB_NAME, DB_PORT, JWT_SECRET, CLOUDINARY_* nếu có)
npm install && npm run dev
Test Postman:
POST /api/auth/register (user thường)
POST /api/auth/login → nhận token JSON
Tạo admin và kiểm tra quyền
node src/utils/createAdmin.js
POST /api/admin/login → nhận token admin.
Hot restart Flutter và thử đăng nhập
flutter clean && flutter pub get && flutter run
Đăng nhập → vào Home; nếu lỗi hiển thị SnackBar nội dung lỗi (không còn FormatException).
KẾ HOẠCH NGẮN HẠN (1–3 ngày tới)

Tích hợp Cloudinary upload (backend)
Hoàn thiện config cloudinary.js, middleware upload (multer-storage-cloudinary).
API POST /api/songs/upload trả về {audioUrl, imageUrl}.
Lưu URL vào bảng songs (đã có cột audioUrl, imageUrl).
Seed dữ liệu mẫu
Tạo 5–10 bài hát mẫu (dùng URL từ Cloudinary) để test hiển thị.
Flutter: hoàn thiện Home
Gọi GET /api/songs, hiển thị danh sách với ảnh + tiêu đề + nghệ sĩ.
Loading/empty/error state.
Splash/Guard
Nếu có token hợp lệ → chuyển thẳng Home; nếu không → SignIn.
KẾ HOẠCH TRUNG HẠN (4–7 ngày)

Trình phát nhạc (Flutter)
Thêm dependency: just_audio (+ audio_session) hoặc audioplayers.
Player cơ bản: play/pause/seek, next/prev, hiển thị tiến độ.
Playlist cá nhân
Xác thực các routes playlist trên backend; thêm/loại bài hát khỏi playlist.
UI trang Library hiển thị playlist của user.
Bình luận và báo cáo
Kết nối /api/comments và /api/reports; UI nhập bình luận, hiển thị danh sách và gửi report.
Admin Dashboard
Đăng nhập admin, thiết lập axios baseURL.
Trang Users/Songs/Reports hoạt động với API thật.
Upload bài hát từ dashboard (gọi API upload).
KẾ HOẠCH DÀI HẠN (tuần tới)

Deploy & cấu hình Production
Render: đảm bảo biến môi trường DB_* / JWT_SECRET / CLOUDINARY_*.
Railway (MySQL): cho phép SSL nếu cần (DB_SSL=true).
CORS: giới hạn origin hợp lệ (app và dashboard).
Kiểm thử E2E
Kịch bản: đăng ký → đăng nhập → xem danh sách bài hát → phát nhạc → tạo playlist → thêm bài hát → comment → report → admin xử lý.
Chất lượng & tài liệu
README hướng dẫn run dev/prod.
Tối thiểu CI: lint backend và Flutter.
CHECKLIST NHANH ĐỂ TIẾN TỚI HOME

Sửa ApiConstants.baseUrl đúng môi trường test
npm run dev backend chạy OK, /api/auth/login trả JSON
node src/utils/createAdmin.js tạo admin (nếu cần)
flutter run không còn cảnh báo Kotlin (đã nâng); dùng JDK 17
Đăng nhập trong app: nhận token, chuyển Home
LỆNH THAM KHẢO

Backend: npm run dev
Tạo admin: node src/utils/createAdmin.js
Flutter: flutter clean && flutter pub get && flutter run
Bạn muốn mình tự động cập nhật baseUrl theo môi trường bạn đang dùng (emulator/localhost/Render) không? Nếu có, cho mình biết bạn đang test ở đâu để mình chỉnh đúng file và đẩy commit giúp bạn.