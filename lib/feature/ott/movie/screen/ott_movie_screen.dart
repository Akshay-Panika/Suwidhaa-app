import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../category/controller/ott_category_controller.dart';
import '../../category/widget/ott_category_widget.dart';
import '../../content/controller/ott_content_controller.dart';
import '../../content/model/ott_content_model.dart';
import '../../home/screen/play_dashboard_screen.dart';

class OttMovieScreen extends StatefulWidget {
  const OttMovieScreen({super.key});

  @override
  State<OttMovieScreen> createState() => _OttMovieScreenState();
}

class _OttMovieScreenState extends State<OttMovieScreen> {
  final categoryCtrl = Get.find<OttCategoryController>();
  final contentCtrl = Get.find<OttContentController>();

  @override
  void initState() {
    super.initState();

    // ✅ Category change → content refetch
    ever(categoryCtrl.selectedCategoryId, (id) {
      contentCtrl.getContents(categoryId: id);
    });

    // Initial fetch (if not already loaded)
    Future.microtask(() {
      if (contentCtrl.contents.isEmpty) {
        contentCtrl.getContents(
          categoryId: categoryCtrl.selectedCategoryId.value,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // ==================== APP BAR ====================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text(
        'Browse',
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

  // ==================== BODY ====================
  Widget _buildBody() {
    return Obx(() {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // ✅ Dynamic category tabs (shared with home)
            const OttCategoryWidget(),
            const SizedBox(height: 16),

            // ✅ Loading -> Shimmer | Empty -> Empty State | Success -> Grid
            if (contentCtrl.isLoading.value)
              _buildShimmerGrid()
            else if (contentCtrl.contents.isEmpty)
              _buildEmptyState()
            else
              _buildMovieGrid(contentCtrl.contents),

            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  // ==================== SHIMMER GRID (SKELETON) ====================
  Widget _buildShimmerGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 0.8, // Same as real grid
        ),
        itemCount: 9, // Show 9 skeleton cards
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[900]!, // Dark base color
            highlightColor: Colors.grey[700]!, // Shimmer highlight color
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // This white color gets masked by Shimmer
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Mock Category Badge (Top Right)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 45,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  // Mock Title (Bottom Left)
                  Positioned(
                    bottom: 8,
                    left: 6,
                    right: 35, // Leave room for duration
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Mock Duration (Bottom Right)
                  Positioned(
                    bottom: 8,
                    right: 6,
                    child: Container(
                      width: 25,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ==================== EMPTY STATE ====================
  Widget _buildEmptyState() {
    final currentCategoryName = categoryCtrl.categories
        .firstWhereOrNull(
          (c) => c.id == categoryCtrl.selectedCategoryId.value,
    )
        ?.name;

    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 100),
            const Icon(
              Icons.movie_creation_outlined,
              size: 50,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              currentCategoryName != null
                  ? 'No ${currentCategoryName} available'
                  : 'No content available',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== GRID ====================
  Widget _buildMovieGrid(List<OttContentModel> contents) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 0.8, // portrait poster ratio
        ),
        itemCount: contents.length,
        itemBuilder: (context, index) {
          return _buildMovieCard(contents[index]);
        },
      ),
    );
  }

  // ==================== MOVIE CARD ====================
  Widget _buildMovieCard(OttContentModel content) {
    return InkWell(
      onTap: () {
        Get.to(() => PlayDashboardScreen(content: content));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Poster (prefer vertical, fallback horizontal) ──
            Image.network(
              content.thumbnailVertical.isNotEmpty
                  ? content.thumbnailVertical
                  : content.thumbnailHorizontal,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[900],
                child: const Center(
                  child: Icon(Icons.movie, color: Colors.grey, size: 40),
                ),
              ),
            ),

            // ── Gradient bottom (for title readability) ──
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),

            // ── Category badge top-right ──
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  content.categoryName.isNotEmpty
                      ? content.categoryName.toUpperCase()
                      : 'CONTENT',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // ── Duration bottom-right ──
            if (content.videoDuration.isNotEmpty)
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    content.videoDuration,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            // ── Title bottom-left ──
            Positioned(
              bottom: 6,
              left: 6,
              right: 60, // leave room for duration badge
              child: Text(
                content.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}