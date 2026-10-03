// lib/feature/ott/home/widget/my_watchlist_content_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/ott_content_controller.dart';

class SuggestionContentCard extends StatefulWidget {
  final int? contentId;           // 🔹 currently playing id
  final String contentType;
  final void Function(int id, int categoryId, String contentType)? onItemTap;

  const SuggestionContentCard({
    super.key,
    required this.contentType,
    required this.contentId,
    this.onItemTap,
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

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          childAspectRatio: 0.8,
        ),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final item = suggestions[index];

          // 🔹 Match by contentId (categoryId) OR id
          final isWatching = widget.contentId != null &&
              (item.categoryId == widget.contentId ||
                  item.id == widget.contentId);

          return _buildMovieCard(item, index, isWatching);
        },
      );
    });
  }

  Widget _buildMovieCard(dynamic content, int index, bool isWatching) {
    return InkWell(
      // onTap: () {
      //   widget.onItemTap?.call(
      //     content.id,
      //     content.categoryId,
      //     content.contentType,
      //   );
      // },
      onTap: isWatching
          ? null
          : () {
        widget.onItemTap?.call(
          content.id,
          content.categoryId,
          content.contentType,
        );
      },
      child: Stack(
        children: [
          // ── Thumbnail ──
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
              child: Icon(Icons.movie, color: Colors.grey, size: 40),
            )
                : null,
          ),

          // ── Red border + dim overlay when watching ──
            if (isWatching)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red, width: 1),
                  color: Colors.black.withOpacity(0.35),
                ),
              ),
            ),

          // ── Top-right: contentType badge ──
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.85),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text( isWatching ?'WATCHING':
                (content.contentType ?? '').toUpperCase(),
                style:  TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),


          // ── Center: equalizer icon ──
          if (isWatching)
            const Positioned.fill(
              child: Center(
                child: Icon(
                  Icons.equalizer_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
        ],
      ),
    );
  }
}