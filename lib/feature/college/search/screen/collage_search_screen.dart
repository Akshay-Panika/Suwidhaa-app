import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_color.dart';
import '../../controller/college_controller.dart';
import '../../model/college_model.dart';
import '../../screen/college_view_screen.dart';

class CollageSearchScreen extends StatefulWidget {
  const CollageSearchScreen({super.key});

  @override
  State<CollageSearchScreen> createState() => _CollageSearchScreenState();
}

class _CollageSearchScreenState extends State<CollageSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final CollegeController _controller = Get.find<CollegeController>();

  String _searchQuery = '';
  bool _isSearching = false;

  // Get filtered search results
  List<College> get _searchResults {
    List<College> results = _controller.colleges;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      results = results
          .where((college) =>
      college.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          college.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (college.category?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
          .toList();
    }

    return results;
  }

  // Get recommended colleges (only from recommended list)
  List<College> get _recommendedColleges {
    return _controller.recommendedColleges;
  }

  @override
  void initState() {
    super.initState();
    // Fetch colleges if not already loaded
    if (_controller.colleges.isEmpty) {
      _controller.fetchColleges();
    }
    // Auto-focus on search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CollegeColors.primary,
        elevation: 0,
        title: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: CollegeColors.border),
            boxShadow: [
              BoxShadow(
                color: CollegeColors.primary.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search colleges...',
              hintStyle: const TextStyle(color: CollegeColors.textSecondary),
              prefixIcon: const Icon(Icons.search_rounded, color: CollegeColors.textSecondary),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear_rounded, color: CollegeColors.textSecondary),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _isSearching = value.isNotEmpty;
              });
            },
          ),
        ),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_searchQuery.isNotEmpty)
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _isSearching = false;
                });
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: CollegeColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Obx(() {
        // Show loading
        if (_controller.isLoading.value && _controller.colleges.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(CollegeColors.primary),
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading colleges...',
                  style: TextStyle(
                    color: CollegeColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        // Show error
        if (_controller.errorMessage.isNotEmpty && _controller.colleges.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: CollegeColors.secondaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    size: 44,
                    color: CollegeColors.secondary,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    _controller.errorMessage.value,
                    style: const TextStyle(
                      fontSize: 15,
                      color: CollegeColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _controller.fetchColleges(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CollegeColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Results
            Expanded(
              child: _isSearching
                  ? _buildSearchResults()
                  : _buildInitialContent(),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSearchResults() {
    final results = _searchResults;

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: CollegeColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 46,
                color: CollegeColors.primary.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No colleges found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your search',
              style: TextStyle(
                fontSize: 14,
                color: CollegeColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '"$_searchQuery"',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: CollegeColors.primary,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Result count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Text(
              '${results.length} result${results.length > 1 ? 's' : ''} found',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: CollegeColors.textSecondary,
              ),
            ),
          ),
          // Results Grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.85,
              ),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final college = results[index];
                return _buildCollegeCard(college);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recommended Colleges Section (only if recommended colleges exist)
          if (_recommendedColleges.isNotEmpty) ...[
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Recommended Colleges',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _recommendedColleges.length,
                itemBuilder: (context, index) {
                  final college = _recommendedColleges[index];
                  return _buildRecommendedCard(college);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // All Colleges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'All Colleges',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${_controller.colleges.length}',
                style: const TextStyle(
                  fontSize: 14,
                  color: CollegeColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: _controller.colleges.length > 6 ? 6 : _controller.colleges.length,
            itemBuilder: (context, index) {
              final college = _controller.colleges[index];
              return _buildCollegeCard(college);
            },
          ),
          if (_controller.colleges.length > 6)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  'Scroll to see all colleges',
                  style: TextStyle(
                    fontSize: 12,
                    color: CollegeColors.textSecondary.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildRecommendedCard(College college) {
    String imageUrl = college.images.isNotEmpty
        ? college.images.first.url
        : 'https://via.placeholder.com/400x300?text=No+Image';

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CollegeColors.border, width: 0.6),
        boxShadow: [
          BoxShadow(
            color: CollegeColors.primary.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CollegeViewScreen(
                collegeId: college.id.toString(),
                collegeName: college.name,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // College Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.network(
                imageUrl,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 80,
                    color: CollegeColors.primaryLight,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: CollegeColors.primary,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 80,
                    color: CollegeColors.primaryLight,
                    child: Icon(
                      Icons.school_rounded,
                      size: 30,
                      color: CollegeColors.primary.withOpacity(0.5),
                    ),
                  );
                },
              ),
            ),
            // College Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    college.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          college.category ?? 'General',
                          style: const TextStyle(
                            fontSize: 10,
                            color: CollegeColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star_rounded,
                          size: 10,
                          color: Colors.white,
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

  Widget _buildCollegeCard(College college) {
    String imageUrl = college.images.isNotEmpty
        ? college.images.first.url
        : 'https://via.placeholder.com/400x300?text=No+Image';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CollegeColors.border, width: 0.6),
        boxShadow: [
          BoxShadow(
            color: CollegeColors.primary.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CollegeViewScreen(
                collegeId: college.id.toString(),
                collegeName: college.name,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // College Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Stack(
                  children: [
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: CollegeColors.primaryLight,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                              color: CollegeColors.primary,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: CollegeColors.primaryLight,
                          child: Icon(
                            Icons.school_rounded,
                            size: 35,
                            color: CollegeColors.primary.withOpacity(0.5),
                          ),
                        );
                      },
                    ),
                    if (college.isRecommended)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 10,
                                color: Colors.white,
                              ),
                              SizedBox(width: 2),
                              Text(
                                'Top',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // College Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // College Name with highlighted search
                  _buildHighlightedText(
                    college.name,
                    _searchQuery,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    highlightStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: CollegeColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    college.address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: CollegeColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: CollegeColors.secondaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          college.category ?? 'General',
                          style: const TextStyle(
                            fontSize: 8,
                            color: CollegeColors.secondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: CollegeColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'View',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
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

  Widget _buildHighlightedText(String text, String highlight, {
    required TextStyle style,
    required TextStyle highlightStyle,
  }) {
    if (highlight.isEmpty || !text.toLowerCase().contains(highlight.toLowerCase())) {
      return Text(text, style: style, maxLines: 1, overflow: TextOverflow.ellipsis);
    }

    final index = text.toLowerCase().indexOf(highlight.toLowerCase());
    final before = text.substring(0, index);
    final match = text.substring(index, index + highlight.length);
    final after = text.substring(index + highlight.length);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: before, style: style),
          TextSpan(text: match, style: highlightStyle),
          TextSpan(text: after, style: style),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}