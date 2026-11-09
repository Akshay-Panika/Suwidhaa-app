// lib/feature/ott/home/widget/my_watchlist_content_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../content/controller/ott_content_controller.dart';
import '../../content/model/ott_content_model.dart';
import '../../home/screen/play_dashboard_screen.dart';

class MyWatchlistContentCard extends StatelessWidget {
  MyWatchlistContentCard({super.key});

  final OttContentController controller = Get.find<OttContentController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ── Loading ──
      if (controller.isLoading.value && controller.contents.isEmpty) {
        return const SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(color: Colors.red),
          ),
        );
      }

      // ── All contents ──
      final suggestions = controller.contents;

      // ── Empty ──
      if (suggestions.isEmpty) {
        return const SizedBox.shrink();
      }

      // ── Grid ──
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 0.8,
        ),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return _buildMovieCard(context, suggestions[index]);
        },
      );
    });
  }

  Widget _buildMovieCard(BuildContext context, OttContentModel content) {
    return InkWell(
      // ✅ Navigation add kiya — full content object pass kiya
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
                  child: Icon(
                    Icons.movie,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
            ),

            // ── Gradient bottom (title ke liye) ──
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 40,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
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

            // ── Title bottom-left ──
            Positioned(
              bottom: 6,
              left: 6,
              right: 6,
              child: Text(
                content.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
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