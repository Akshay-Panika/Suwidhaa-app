import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/feature/ott/home/screen/play_dashboard_screen.dart';
import '../../controller/ott_content_controller.dart';
import '../../search/screen/search_movie_screen.dart';
import '../widget/movie_banner.dart';
import 'ott_view_all_screen.dart';

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
    {'label': 'WebSeries', 'type': 'webseries'},
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
            _buildSectionHeader(
              'Trending Now',
              'View All',
              categoryType: selectedType,
              filterType: 'trending',
            ),
            const SizedBox(height: 12),
            _buildTrendingSlider(trendingContents),
            const SizedBox(height: 24),

            // Recommended Shows
            _buildSectionHeader(
              'Recommended Shows',
              'View All',
              categoryType: selectedType,
              filterType: 'recommended',
            ),
            const SizedBox(height: 12),
            _buildRecommendedGrid(recommendedContents),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

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
                borderRadius: BorderRadius.circular(12),
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
  Widget _buildSectionHeader(
      String title,
      String action, {
        String? categoryType,
        required String filterType,
      }) {
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OttViewAllScreen(
                    categoryType: categoryType,
                    filterType: filterType,
                    title: title,
                  ),
                ),
              );
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

    return Container(
      height: 320,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        // shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        scrollDirection:Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.2,
        ),
        itemCount: trendingContents.length,
        itemBuilder: (context, index) {
          final content = trendingContents[index];
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

    return Container(
      height: 380,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
         scrollDirection: Axis.horizontal,
        // shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.6,
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
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PlayDashboardScreen(
          contentId: categoryId,
          contentType: contentType,
        ),));
      },
      child: Stack(
        children: [
          Container(
            width: isGrid ? null : width,
            margin: isGrid ? null : const EdgeInsets.only(right: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[900],
              image:  DecorationImage(image: NetworkImage(imageUrl),fit: BoxFit.fill)
            ),
            child: imageUrl.isEmpty?Center(child: Icon(Icons.movie,color: Colors.grey,size: 40,)):null,
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
    );
  }
}