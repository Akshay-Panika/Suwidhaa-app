// lib/feature/ott_platform/home/screen/view_all_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/ott_content_controller.dart';
import '../../search/screen/search_movie_screen.dart';
import 'play_dashboard_screen.dart';

class OttViewAllScreen extends StatefulWidget {
  /// null = all categories
  /// 'movie', 'cartoon', 'sport', 'sci_fi', 'webseries'
  final String? categoryType;

  /// 'trending', 'recommended', 'all'
  final String filterType;

  /// Title shown in AppBar
  final String title;

  const OttViewAllScreen({
    super.key,
    this.categoryType,
    required this.filterType,
    required this.title,
  });

  @override
  State<OttViewAllScreen> createState() => _OttViewAllScreenState();
}

class _OttViewAllScreenState extends State<OttViewAllScreen> {
  final OttContentController controller = Get.find<OttContentController>();

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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              // 🔹 1. Filter by category
              var list = controller.contents.toList();
            
              if (widget.categoryType != null) {
                list = list
                    .where((c) => c.contentType == widget.categoryType)
                    .toList();
              }
            
              // 🔹 2. Filter by trending / recommended / all
              switch (widget.filterType) {
                case 'trending':
                  list = list.where((c) => c.isTrending).toList();
                  break;
                case 'recommended':
                  list = list.where((c) => c.isRecommended).toList();
                  break;
                case 'all':
                default:
                  break;
              }
            
              if (list.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.movie_outlined, color: Colors.grey, size: 60),
                      SizedBox(height: 12),
                      Text(
                        'No content available',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }
            
              // 🔹 3. Grid layout
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final content = list[index];
                  return _buildCard(
                    contentId: content.categoryId,
                    title: content.title,
                    contentType: content.contentType,
                    rating: content.rating,
                    imageUrl: content.thumbnailVertical,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required int contentId,
    required String contentType,
    required String rating,
    required String imageUrl,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayDashboardScreen(
              contentId: contentId,
              contentType: contentType,
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