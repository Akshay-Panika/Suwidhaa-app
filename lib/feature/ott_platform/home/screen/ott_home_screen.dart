import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/feature/ott_platform/home/screen/play_list_screen.dart';

import '../../controller/ott_content_controller.dart';
import '../../search/screen/search_movie_screen.dart';
import '../widget/movie_banner.dart';

class OttHomeScreen extends StatefulWidget {
  const OttHomeScreen({super.key});

  @override
  State<OttHomeScreen> createState() => _OttHomeScreenState();
}

class _OttHomeScreenState extends State<OttHomeScreen> {
  int _selectedIndex = 0;

  final OttContentController controller = Get.find<OttContentController>();


  final List<Map<String, String?>> _categories = [
    {'label': 'Home', 'type': null},
    {'label': 'Movies', 'type': 'movie'},
    {'label': 'SCI-FI', 'type': 'sci_fi'},
    {'label': 'WebSeries', 'type': 'web_series'},
    {'label': 'Sports', 'type': 'sport'},
    {'label': 'Cartoons', 'type': 'cartoon'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // ---------------------------------------------------------------
  // APP BAR
  // ---------------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.dashboard, color: Colors.white),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'OTT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchMovieScreen(),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    SizedBox(width: 12),
                    Icon(Icons.search, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Search...',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // BODY
  // ---------------------------------------------------------------
  Widget _buildBody() {
    return Obx(() {
      if (controller.isLoading.value && controller.contents.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.red),
        );
      }

      // 🔹 Apply the category filter first
      final selectedType = _categories[_selectedIndex]['type'];

      final filteredContents = selectedType == null
          ? controller.contents.toList() // Home → everything
          : controller.contents
          .where((c) => c.contentType == selectedType)
          .toList();

      // 🔹 Then split by trending / recommended
      final trendingContents =
      filteredContents.where((c) => c.isTrending).toList();
      final recommendedContents =
      filteredContents.where((c) => c.isRecommended).toList();

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Banner
            const MovieBanner(),
            const SizedBox(height: 16),

            // Categories
            _buildCategories(),
            const SizedBox(height: 24),

            // Trending Now
            _buildSectionHeader('Trending Now', 'View All'),
            const SizedBox(height: 12),
            _buildTrendingSlider(trendingContents),
            const SizedBox(height: 24),

            // Recommended Shows
            _buildSectionHeader('Recommended Shows', 'View All'),
            const SizedBox(height: 12),
            _buildRecommendedGrid(recommendedContents),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  // ---------------------------------------------------------------
  // CATEGORIES
  // ---------------------------------------------------------------
  Widget _buildCategories() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.grey[800]!,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  _categories[index]['label']!,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.grey,
                    fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------
  // SECTION HEADER
  // ---------------------------------------------------------------
  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              // TODO: navigate to "View All" screen
            },
            child: Text(
              action,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // TRENDING SLIDER
  // ---------------------------------------------------------------
  Widget _buildTrendingSlider(List<dynamic> trendingContents) {
    if (trendingContents.isEmpty) {
      return const SizedBox(
        height: 150,
        child: Center(
          child: Text(
            'No trending content',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: trendingContents.length,
        itemBuilder: (context, index) {
          final content = trendingContents[index];
          return _buildMovieCard(
            contentId: content.id,
            categoryId: content.categoryId,
            contentType: content.contentType,
            title: content.title,
            rating: content.rating,
            imageUrl: content.thumbnailVertical,
            width: 200,
            imageHeight: 150,
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------
  // RECOMMENDED GRID
  // ---------------------------------------------------------------
  Widget _buildRecommendedGrid(List<dynamic> recommendedContents) {
    if (recommendedContents.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No recommended content',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: recommendedContents.length,
        itemBuilder: (context, index) {
          final content = recommendedContents[index];
          return _buildMovieCard(
            contentId: content.id,
            title: content.title,
            categoryId: content.categoryId,
            contentType: content.contentType,
            rating: content.rating,
            imageUrl: content.thumbnailVertical,
            width: double.infinity,
            imageHeight: 160,
            isGrid: true,
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------
  // REUSABLE MOVIE CARD
  // ---------------------------------------------------------------
  Widget _buildMovieCard({
    required String title,
    required int contentId,
    required int categoryId,
    required String contentType,
    required String rating,
    required String imageUrl,
    required double width,
    required double imageHeight,
    bool isGrid = false,
  }) {
    return Container(
      width: isGrid ? null : width,
      margin: isGrid ? null : const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[900],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PlayListScreen(
            contentId: categoryId,
            contentType: contentType,
          ),));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      imageUrl,
                      height: imageHeight,
                      width: isGrid ? double.infinity : width,
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: imageHeight,
                          width: isGrid ? double.infinity : width,
                          color: Colors.grey[900],
                          child: const Center(
                            child: CircularProgressIndicator(color: Colors.red),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: imageHeight,
                          width: isGrid ? double.infinity : width,
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.movie,
                            color: Colors.grey,
                            size: 50,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        (contentType ?? '').toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: isGrid ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}