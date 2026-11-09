import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../content/controller/ott_content_controller.dart';
import '../../content/model/ott_content_model.dart';
import '../../home/screen/play_dashboard_screen.dart';

class SearchMovieScreen extends StatefulWidget {
  const SearchMovieScreen({super.key});

  @override
  State<SearchMovieScreen> createState() => _SearchMovieScreenState();
}

class _SearchMovieScreenState extends State<SearchMovieScreen> {
  final OttContentController controller = Get.find<OttContentController>();

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // ✅ Type-safe lists
  List<OttContentModel> _filteredResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ✅ Search — title + categoryName match
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
      return c.title.toLowerCase().contains(q) ||
          c.categoryName.toLowerCase().contains(q);
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
    // ── Before typing ──
    if (!_isSearching) {
      final recommended = controller.contents
          .where((c) => c.isRecommended == true)
          .toList();

      final trending = controller.contents
          .where((c) => c.isTrending == true)
          .toList();

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildSectionHeader('Recommended'),
            const SizedBox(height: 12),
            _buildHorizontalGrid(recommended),
            const SizedBox(height: 24),
            _buildSectionHeader('Trending'),
            const SizedBox(height: 12),
            _buildHorizontalGrid(trending),
            const SizedBox(height: 24),
          ],
        ),
      );
    }

    // ── No results ──
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

    // ── Results ──
    return _buildResultsGrid(_filteredResults);
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(color: Colors.red, height: 16, width: 3),
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

  // Horizontal 2-row grid
  Widget _buildHorizontalGrid(List<OttContentModel> contents) {
    if (contents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Text(
          'No content available',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    const cardWidth = 120.0;
    const rowHeight = 160.0;
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

  // Vertical results grid
  Widget _buildResultsGrid(List<OttContentModel> contents) {
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: contents.length,
        itemBuilder: (context, index) {
          return _buildMovieCard(contents[index]);
        },
      ),
    );
  }

  // ✅ Type-safe card + working navigation
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
            // Poster (prefer vertical, fallback horizontal)
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

            // Category badge top-right
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
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}