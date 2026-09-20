import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/ott_content_controller.dart';
import '../../home/screen/play_dashboard_screen.dart';
import '../../home/screen/play_movie_screen.dart';

class OttMovieScreen extends StatefulWidget {
  const OttMovieScreen({super.key});

  @override
  State<OttMovieScreen> createState() => _OttMovieScreenState();
}

class _OttMovieScreenState extends State<OttMovieScreen> {
  final OttContentController controller = Get.find<OttContentController>();

  final List<Map<String, String?>> _categories = [
    {'label': 'Home', 'type': null},
    {'label': 'Movies', 'type': 'movie'},
    {'label': 'SCI-FI', 'type': 'sci_fi'},
    {'label': 'WebSeries', 'type': 'web_series'},
    {'label': 'Sports', 'type': 'sport'},
    {'label': 'Cartoons', 'type': 'cartoon'},
  ];

  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text(
        'Movies',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: Colors.white),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.filter_list, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Obx(() {
      // 🔹 Loading — only when nothing has loaded yet
      if (controller.isLoading.value && controller.contents.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.red),
        );
      }

      // 🔹 Filter logic
      final selectedType = _categories[_selectedCategory]['type'];

      final filteredContents = selectedType == null
          ? controller.contents.toList()
          : controller.contents
          .where((c) => c.contentType == selectedType)
          .toList();

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // 🔹 Categories — ALWAYS visible
            _buildCategories(),
            const SizedBox(height: 16),

            // 🔹 Grid OR empty message (only this part changes)
            if (filteredContents.isEmpty)
              _buildEmptyState()
            else
              _buildMovieGrid(filteredContents),

            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  // ---------------------------------------------------------------
  // EMPTY STATE (inside the body, below categories)
  // ---------------------------------------------------------------
  Widget _buildEmptyState() {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 100),
            Icon(Icons.movie_creation_outlined,size: 50,color: Colors.grey,),
            const SizedBox(height: 12),

            Text(
              'No ${_categories[_selectedCategory]['label']} available',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
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
          final isSelected = _selectedCategory == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected ? Colors.red : Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.red : Colors.grey[800]!,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  _categories[index]['label']!,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
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
  // GRID
  // ---------------------------------------------------------------
  Widget _buildMovieGrid(List<dynamic> contents) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: contents.length,
        itemBuilder: (context, index) {
          return _buildMovieCard(contents[index]);
        },
      ),
    );
  }
  Widget _buildMovieCard(dynamic content) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PlayDashboardScreen(
          contentId: content.categoryId,
          contentType: content.contentType,
        ),));
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[900],
                image:  DecorationImage(image: NetworkImage(content.thumbnailVertical),fit: BoxFit.fill)
            ),
            child: content.thumbnailVertical.isEmpty?Center(child: Icon(Icons.movie,color: Colors.grey,size: 40,)):null,
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
                (content.contentType ?? '').toUpperCase(),
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