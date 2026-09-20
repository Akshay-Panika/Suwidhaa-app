// lib/feature/ott/home/widget/suggestion_contant_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/ott_content_controller.dart';
import '../screen/play_dashboard_screen.dart';

class SuggestionContentCard extends StatefulWidget {
  final String contentType;

  const SuggestionContentCard({
    super.key,
    required this.contentType,
  });

  @override
  State<SuggestionContentCard> createState() => _SuggestionContentCardState();
}

class _SuggestionContentCardState extends State<SuggestionContentCard> {
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

      // ── Filter: same contentType only ──
      final suggestions = controller.contents
          .where((c) => c.contentType == widget.contentType)
          .toList();

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
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return _buildMovieCard(suggestions[index]);
        },
      );
    });
  }

  Widget _buildMovieCard(dynamic content) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayDashboardScreen(
              contentId: content.categoryId,
              contentType: content.contentType,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[900],
              image: (content.thumbnailVertical != null &&
                  content.thumbnailVertical.isNotEmpty)
                  ? DecorationImage(
                image: NetworkImage(content.thumbnailVertical),
                fit: BoxFit.fill,
              )
                  : null,
            ),
            child: (content.thumbnailVertical == null ||
                content.thumbnailVertical.isEmpty)
                ? const Center(
              child: Icon(
                Icons.movie,
                color: Colors.grey,
                size: 40,
              ),
            )
                : null,
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