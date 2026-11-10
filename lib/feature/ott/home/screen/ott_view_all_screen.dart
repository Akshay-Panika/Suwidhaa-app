// lib/feature/ott/home/screen/ott_view_all_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../content/controller/ott_content_controller.dart';
import '../../content/model/ott_content_model.dart';
import '../../search/screen/search_movie_screen.dart';
import 'play_dashboard_screen.dart';

class OttViewAllScreen extends StatefulWidget {
  final String? categoryType;
  final String filterType;
  final String title;
  final List<OttContentModel>? items;

  const OttViewAllScreen({
    super.key,
    this.categoryType,
    required this.filterType,
    required this.title,
    this.items,
  });

  @override
  State<OttViewAllScreen> createState() => _OttViewAllScreenState();
}

class _OttViewAllScreenState extends State<OttViewAllScreen> {
  final OttContentController controller = Get.find<OttContentController>();

  List<OttContentModel> _resolveList() {
    if (widget.items != null) return widget.items!;

    var list = controller.contents.toList();

    if (widget.categoryType != null && widget.categoryType!.isNotEmpty) {
      final target = widget.categoryType!.toLowerCase();
      list = list
          .where((c) => c.categoryName.toLowerCase() == target)
          .toList();
    }

    switch (widget.filterType) {
      case 'trending':
        list = list.where((c) => c.isTrending).toList();
        break;
      case 'recommended':
        list = list.where((c) => c.isRecommended).toList();
        break;
      case 'new':
        list = list.where((c) => c.isSomethingNew).toList();
        break;
      case 'family':
        list = list.where((c) => c.isFamily).toList();
        break;
      case 'premium':
        list = list.where((c) => c.isLock).toList();
        break;
      case 'all':
      default:
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Row(
          children: [
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
                        builder: (_) => const SearchMovieScreen(),
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
                        style:
                        TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // ✅ SINGLE Obx wraps everything → GetX sees at least one obs read
      body: Obx(() {
        // Force reactive read (needed for Obx)
        final _ = controller.contents.length;

        final list = _resolveList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                children: [
                  Container(color: Colors.red, height: 14, width: 3),
                  const SizedBox(width: 8),
                  // ✅ Wrap in Expanded so long titles ellipsis
                  Expanded(
                    child: Text(
                      widget.title.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // ✅ No nested Obx — this is inside the outer Obx
                  Text(
                    '${list.length} items',
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.movie_outlined,
                        color: Colors.grey, size: 60),
                    SizedBox(height: 12),
                    Text(
                      'No content available',
                      style: TextStyle(
                          color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              )
                  : GridView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 0.62,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) =>
                    _buildCard(context, list[index]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCard(BuildContext context, OttContentModel content) {
    final img = content.thumbnailVertical.isNotEmpty
        ? content.thumbnailVertical
        : content.thumbnailHorizontal;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Get.to(() => PlayDashboardScreen(content: content));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.grey[900],
                child: img.isNotEmpty
                    ? Image.network(
                  img,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.movie,
                        color: Colors.white24, size: 40),
                  ),
                )
                    : const Center(
                  child: Icon(Icons.movie,
                      color: Colors.white24, size: 40),
                ),
              ),
            ),

            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.55, 1.0],
                  ),
                ),
              ),
            ),

            Positioned(
              left: 6,
              right: 6,
              bottom: 6,
              child: Text(
                content.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            if (content.categoryName.isNotEmpty)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    content.categoryName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            if (content.isLock)
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child:
                  const Text('🔒', style: TextStyle(fontSize: 9)),
                ),
              ),

            if (content.videoDuration.isNotEmpty)
              Positioned(
                bottom: 30,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    content.videoDuration,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}