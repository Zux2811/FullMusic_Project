import 'package:flutter/material.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    final topGenres = [
      {
        "title": "Kpop",
        "color": Colors.greenAccent,
        "image": "assets/images/kpop.jpg",
      },
      {
        "title": "Indie",
        "color": Colors.purpleAccent,
        "image": "assets/images/indie.jpg",
      },
      {
        "title": "R&B",
        "color": Colors.blueAccent,
        "image": "assets/images/rnb.jpg",
      },
      {
        "title": "Pop",
        "color": Colors.orangeAccent,
        "image": "assets/images/pop.jpg",
      },
    ];

    final browseAll = [
      {
        "title": "Made for You",
        "color": Colors.lightBlueAccent,
        "image": "assets/images/for_you.jpg",
      },
      {
        "title": "RELEASED",
        "color": Colors.purpleAccent,
        "image": "assets/images/released.jpg",
      },
      {
        "title": "Music Charts",
        "color": Colors.indigoAccent,
        "image": "assets/images/charts.jpg",
      },
      {
        "title": "Podcasts",
        "color": Colors.redAccent,
        "image": "assets/images/podcast.jpg",
      },
      {
        "title": "Bollywood",
        "color": Colors.brown,
        "image": "assets/images/bollywood.jpg",
      },
      {
        "title": "Pop Fusion",
        "color": Colors.teal,
        "image": "assets/images/popfusion.jpg",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Search",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Songs, Artists, Podcasts & More",
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Your Top Genres",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildGrid(topGenres),
            const SizedBox(height: 20),
            const Text(
              "Browse All",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildGrid(browseAll),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List<Map<String, dynamic>> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          decoration: BoxDecoration(
            color: item["color"],
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage(item["image"]),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            ),
          ),
          child: Center(
            child: Text(
              item["title"],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}
