import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/app_color.dart';
import '../../../../core/widget/contact_helper.dart';
import '../../controller/college_controller.dart';
import '../../model/college_model.dart';
import '../../screen/college_view_screen.dart';
import '../../search/screen/collage_search_screen.dart';

class CollegeCategoryListScreen extends StatefulWidget {
  final String collegeCategory;
  const CollegeCategoryListScreen({super.key, required this.collegeCategory});

  @override
  State<CollegeCategoryListScreen> createState() =>
      _CollegeCategoryListScreenState();
}

class _CollegeCategoryListScreenState extends State<CollegeCategoryListScreen> {
  final CollegeController _controller = Get.find<CollegeController>();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchCollegesByCategory(widget.collegeCategory);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<College> get _filteredColleges {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return _controller.categoryColleges;
    return _controller.categoryColleges.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.address.toLowerCase().contains(q) ||
          (c.category?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CollegeColors.primary,
        foregroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 18),
        ),
        title: Row(
          spacing: 20,
          children: [
            Text(
              widget.collegeCategory,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Expanded(child: _buildSearchBar()),
            SizedBox(width: 10,)
          ],
        ),
        actions: [
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Expanded(
            child: Obx(() {
              if (_controller.isCategoryLoading.value &&
                  _controller.categoryColleges.isEmpty) {
                return _buildShimmerList();
              }

              if (_controller.categoryErrorMessage.isNotEmpty &&
                  _controller.categoryColleges.isEmpty) {
                return _buildErrorState();
              }

              final list = _filteredColleges;

              if (list.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                color: CollegeColors.primary,
                onRefresh: () =>
                    _controller.fetchCollegesByCategory(widget.collegeCategory),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.8,
                  ),
                  itemCount: _filteredColleges.length,
                  itemBuilder: (context, index) {
                    final college = _filteredColleges[index];
                    return _buildCollegeCard(college);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ==================== SEARCH BAR ====================
  Widget _buildSearchBar() {
    return TextField(
      readOnly:  true,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CollageSearchScreen(),));
      },
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: "Search in ${widget.collegeCategory}...",
        hintStyle: TextStyle(fontSize: 12, color: Colors.grey[500]),
        prefixIcon: const Icon(Icons.search_rounded,
            color: CollegeColors.primary, size: 20),
        filled: true,
        fillColor: Colors.grey.shade100,
        isDense: true,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CollegeColors.primary, width: 1.2),
        ),
      ),
    );
  }

  Widget _buildCollegeCard(College college) {
    // Get first image URL or use placeholder
    String imageUrl = college.images.isNotEmpty
        ? college.images.first.url
        : 'https://via.placeholder.com/400x300?text=No+Image';

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: CollegeColors.border, width: 0.6),
            boxShadow: [
              BoxShadow(
                color: CollegeColors.primary.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CollegeViewScreen(
                  collegeId: college.id.toString(),
                  collegeName: college.name,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // College Image
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 90,
                          width: double.infinity,
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
                          height: 90,
                          width: double.infinity,
                          color: CollegeColors.primaryLight,
                          child: Center(
                            child: Icon(
                              Icons.school_rounded,
                              size: 35,
                              color: CollegeColors.primary.withOpacity(0.5),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // College Info
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              college.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      Row(
                        spacing: 10,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.school,
                            size: 12,
                            color: CollegeColors.textSecondary,
                          ),
                          Expanded(
                            child: Text(
                              college.address,
                              style: const TextStyle(
                                fontSize: 12,
                                color: CollegeColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (college.website.isNotEmpty) ...[
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.language_rounded,
                                    size: 16,
                                    color: CollegeColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => ContactHelper.openWebsite(
                                        college.website,
                                      ),
                                      child: Text(
                                        college.website,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: CollegeColors.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: CollegeColors.secondaryLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              college.category ?? 'General',
                              style: const TextStyle(
                                fontSize: 12,
                                color: CollegeColors.secondary,
                                fontWeight: FontWeight.w700,
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
        ),
        Positioned(
          left: 10,
          child: Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CollegeColors.border, width: 0.6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
              image: DecorationImage(
                image: NetworkImage(college.logoUrl.toString()),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: CollegeColors.primaryLight,
          highlightColor: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover
                AspectRatio(
                  aspectRatio: 16 / 7,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                  ),
                ),
                // Info
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 14, width: 160, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(height: 12, width: 120, color: Colors.white),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(height: 12, width: 90, color: Colors.white),
                          Container(height: 16, width: 60, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==================== ERROR ====================
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            Text(
              _controller.categoryErrorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: CollegeColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () =>
                  _controller.fetchCollegesByCategory(widget.collegeCategory),
              style: ElevatedButton.styleFrom(
                backgroundColor: CollegeColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== EMPTY ====================
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CollegeColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school_outlined,
                size: 44,
                color: CollegeColors.primary.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No colleges match "$_searchQuery"'
                  : 'No colleges found in ${widget.collegeCategory}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try a different search or pull to refresh.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: CollegeColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}