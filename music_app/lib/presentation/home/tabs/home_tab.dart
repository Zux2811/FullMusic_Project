import 'package'
    ':flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Không cần 'final size' nữa nếu chúng ta dùng chiều cao cố định,
    // nhưng có thể giữ lại nếu bạn vẫn muốn dùng
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: Row(
          children: const [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/avatar.jpg'),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back !',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  'Chandrama',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          Icon(Icons.bar_chart_rounded, color: Colors.white),
          SizedBox(width: 12),
          Icon(Icons.notifications_none, color: Colors.white),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),

            // === Phần 1: Continue Listening ===
            const _SectionTitle(title: "Continue Listening"),
            const SizedBox(height: 12),
            SizedBox(
              // Dùng chiều cao cố định thường dễ quản lý hơn % màn hình
              height: 90,
              // Dùng ListView.builder để tối ưu hiệu suất
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: continueListeningItems.length,
                itemBuilder: (context, index) {
                  final title = continueListeningItems[index];
                  return _ContinueListeningCard(title: title);
                },
              ),
            ),
            const SizedBox(height: 30),

            // === Phần 2: Your recent rotation ===
            const _SectionTitle(title: "Your recent rotation"),
            const SizedBox(height: 12),
            SizedBox(
              height: 170, // Chiều cao cố định
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mixItems.length,
                itemBuilder: (context, index) {
                  final mix = mixItems[index];
                  return _MixCard(
                    title: mix['title']!,
                    imagePath: mix['image']!,
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // === Phần 3: Based on your recent listening ===
            const _SectionTitle(title: "Based on your recent listening"),
            const SizedBox(height: 12),
            SizedBox(
              height: 190, // Chiều cao cố định
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recentItems.length,
                itemBuilder: (context, index) {
                  final item = recentItems[index];
                  return _RecentItemCard(imagePath: item['image']!);
                },
              ),
            ),
            const SizedBox(height: 30), // Thêm khoảng đệm cuối
          ],
        ),
      ),
    );
  }
}

// --- TÁCH DỮ LIỆU RA KHỎI PHẦN BUILD ---
// (Trong app thật, cái này sẽ đến từ API hoặc State Management)

final continueListeningItems = [
  "Coffee & Jazz",
  "Anything Goes",
  "Harry's House",
  "Lo-fi Beats",
];

final mixItems = [
  {"title": "Pop Mix", "image": "assets/logo/test_im.png"},
  {"title": "Chill Mix", "image": "assets/logo/test_im.png"},
  {"title": "Workout Mix", "image": "assets/logo/test_im.png"},
];

final recentItems = [
  {"image": "assets/logo/test_im.png"},
  {"image": "assets/logo/test_im.png"},
  {"image": "assets/logo/test_im.png"},
];

// --- TÁCH CÁC WIDGET CON ---

// Widget cho tiêu đề mỗi mục
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }
}

// Widget cho mục "Continue Listening"
class _ContinueListeningCard extends StatelessWidget {
  final String title;
  const _ContinueListeningCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

// Widget cho mục "Mix Section"
class _MixCard extends StatelessWidget {
  final String title;
  final String imagePath;

  const _MixCard({required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          backgroundColor: Colors.black45, // Thêm nền để dễ đọc
        ),
      ),
    );
  }
}

// Widget cho mục "Recent Section"
class _RecentItemCard extends StatelessWidget {
  final String imagePath;
  const _RecentItemCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }
}
