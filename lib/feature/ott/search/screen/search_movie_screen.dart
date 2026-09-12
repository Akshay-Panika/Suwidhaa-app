import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/ott_content_controller.dart';
import '../../home/screen/play_dashboard_screen.dart';
import '../../home/screen/play_movie_screen.dart';

class SearchMovieScreen extends StatefulWidget {
  const SearchMovieScreen({super.key});

  @override
  State<SearchMovieScreen> createState() => _SearchMovieScreenState();
}

class _SearchMovieScreenState extends State<SearchMovieScreen> {
  final OttContentController controller = Get.find<OttContentController>();

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  /// 🔹 Local filtered results — UI mein hi manage
  List<dynamic> _filteredResults = [];
  bool _isSearching = false;

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _focusNode.requestFocus();
  //   });
  // }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// 🔹 Search logic — title + contentType par match
  void _onSearchChanged(String query) {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) {
      setState(() {
        _filteredResults = [];
        _isSearching = false;
      });
      return;
    }

    final results = controller.contents.where((c) {
      final title = (c.title ?? '').toString().toLowerCase();
      final type = (c.contentType ?? '').toString().toLowerCase();

      return title.contains(q) || type.contains(q);
    }).toList();

    setState(() {
      _filteredResults = results;
      _isSearching = true;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _filteredResults = [];
      _isSearching = false;
    });
    _focusNode.requestFocus();
  }

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
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Container(
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          onChanged: _onSearchChanged,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Search movies, web series...',
            hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: Colors.white, size: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
      actions: [
        if (_searchController.text.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear, color: Colors.white),
            onPressed: _clearSearch,
          ),
      ],
    );
  }

  Widget _buildBody() {
    // 🔹 Empty state — before typing
    if (!_isSearching) {
      final recommended = controller.contents
          .where((c) => c.isRecommended == true)
          .toList();

      final trending = controller.contents
          .where((c) => c.isTrending == true)
          .toList();

      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // 🔹 Recommended header
            _buildSectionHeader('Recommended'),
            const SizedBox(height: 12),
            _buildHorizontalGrid(recommended),

            const SizedBox(height: 24),

            // 🔹 Trending header
            _buildSectionHeader('Trending'),
            const SizedBox(height: 12),
            _buildHorizontalGrid(trending),

            const SizedBox(height: 24),
          ],
        ),
      );
    }

    // 🔹 No results
    if (_filteredResults.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.movie_filter, color: Colors.grey, size: 70),
            SizedBox(height: 12),
            Text(
              'No results found',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    // 🔹 Results grid
    return _buildResultsGrid(_filteredResults);
  }

  /// 🔹 Section header — red bar + title
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            color: Colors.red,
            height: 16,
            width: 3,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 HORIZONTAL SCROLLING GRID — 2 rows
  Widget _buildHorizontalGrid(List<dynamic> contents) {
    if (contents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Text(
          'No content available',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    const cardWidth = 150.0;
    const rowHeight = 200.0;
    const spacing = 12.0;
    const rows = 2;

    return SizedBox(
      height: (rowHeight * rows) + spacing + 10,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: (contents.length / rows).ceil(),
        itemBuilder: (context, colIndex) {
          final startIdx = colIndex * rows;
          final endIdx = (startIdx + rows).clamp(0, contents.length);

          return Container(
            width: cardWidth,
            margin: const EdgeInsets.only(right: spacing),
            child: Column(
              children: [
                for (int i = startIdx; i < endIdx; i++) ...[
                  SizedBox(
                    height: rowHeight,
                    child: _buildMovieCard(contents[i]),
                  ),
                  if (i < endIdx - 1) const SizedBox(height: spacing),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  /// 🔹 VERTICAL GRID (search results ke liye)
  Widget _buildResultsGrid(List<dynamic> contents) {
    if (contents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Text(
          'No content available',
          style: TextStyle(color: Colors.grey, fontSize: 14),
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
          childAspectRatio: 0.9,
        ),
        itemCount: contents.length,
        itemBuilder: (context, index) {
          return _buildMovieCard(contents[index]);
        },
      ),
    );
  }

  Widget _buildMovieCard(dynamic content) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[900],
      ),
      child: InkWell(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      content.thumbnailVertical,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: Colors.grey[900],
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.red,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stack) => Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.movie,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    ),

                    // 🔹 CONTENT TYPE BADGE (top-left)
                    if (content.contentType != null &&
                        content.contentType.toString().isNotEmpty)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            content.contentType.toString().toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      content.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 12),
                      const SizedBox(width: 3),
                      Text(
                        content.rating,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
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