// lib/feature/college/screen/collage_home_screen.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/widget/contact_helper.dart';
import '../../category/screen/college_category_list_screen.dart';
import '../../controller/college_controller.dart';
import '../../model/college_model.dart';
import '../../screen/college_view_screen.dart';
import '../../search/screen/collage_search_screen.dart';
import '../../widget/screen/collage_banner_card.dart';

class CollageHomeScreen extends StatefulWidget {
  final Function(int index)? onNavigate;
  const CollageHomeScreen({super.key, this.onNavigate});

  @override
  State<CollageHomeScreen> createState() => _CollageHomeScreenState();
}

class _CollageHomeScreenState extends State<CollageHomeScreen> {
  String _selectedFilter = 'All';
  final CollegeController _controller = Get.find<CollegeController>();

  // Get filtered colleges based on selected category
  List<College> get _filteredColleges {
    if (_selectedFilter == 'All') {
      return _controller.colleges;
    }
    return _controller.colleges
        .where(
          (college) =>
      college.category?.toLowerCase() == _selectedFilter.toLowerCase(),
    )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // Fetch colleges if not already loaded
    if (_controller.colleges.isEmpty) {
      _controller.fetchColleges();
    }
  }

  final List<Map<String, dynamic>> _collegeCategory = [
    {
      'name': 'Engineering',
      'icon': Icons.engineering,
    },
    {
      'name': 'Medical',
      'icon': Icons.local_hospital,
    },
    {
      'name': 'Arts',
      'icon': Icons.palette,
    },
    {
      'name': 'Commerce',
      'icon': Icons.account_balance,
    },
    {
      'name': 'Agriculture',
      'icon': Icons.agriculture,
    },
    {
      'name': 'Science',
      'icon': Icons.science,
    },
    {
      'name': 'Law',
      'icon': Icons.gavel,
    },
    {
      'name': 'Management',
      'icon': Icons.business_center,
    },
    {
      'name': 'Computer Science',
      'icon': Icons.computer,
    },
    {
      'name': 'Pharmacy',
      'icon': Icons.medication,
    },
    {
      'name': 'Nursing',
      'icon': Icons.health_and_safety,
    },
    {
      'name': 'Education',
      'icon': Icons.school,
    },
    {
      'name': 'Architecture',
      'icon': Icons.architecture,
    },
    {
      'name': 'Hotel Management',
      'icon': Icons.hotel,
    },
    {
      'name': 'Design',
      'icon': Icons.design_services,
    },
    {
      'name': 'Veterinary',
      'icon': Icons.pets,
    },
    {
      'name': 'Paramedical',
      'icon': Icons.medical_services,
    },
    {
      'name': 'Dental',
      'icon': Icons.health_and_safety,
    },
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        // Show shimmer while loading
        if (_controller.isLoading.value && _controller.colleges.isEmpty) {
          return _buildShimmerLoading();
        }

        // Show error if any
        if (_controller.errorMessage.isNotEmpty &&
            _controller.colleges.isEmpty) {
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
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    _controller.errorMessage.value,
                    style: TextStyle(
                      fontSize: 15,
                      color: CollegeColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () => _controller.fetchColleges(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CollegeColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            /// Banner
            SliverAppBar(
              floating: true,
              expandedHeight: 200,
              backgroundColor: CollegeColors.primary,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: CollegeColors.primary,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                )
                              ),
                            ),

                          ),
                          Expanded(
                            child: Container(
                              color: Colors.white,
                            ),

                          ),
                        ],
                      ),
                      CollageBannerCard()
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 10,),),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CollageSearchScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: CollegeColors.border,width: 0.6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: CollegeColors.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Search colleges by name...',
                          style: TextStyle(
                            color: CollegeColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: CollegeColors.textSecondary,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Container(
                          height: 18,
                          width: 5,
                          decoration: BoxDecoration(
                            color: CollegeColors.primary,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const Text(
                          "Category",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    InkWell(onTap: () {
                      widget.onNavigate?.call(1);
                    }, child: Text("View All", style: TextStyle(color: CollegeColors.secondary),))
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 10,),),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 270,
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _collegeCategory.length,
                  itemBuilder: (context, index) {
                    final category = _collegeCategory[index];

                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CollegeCategoryListScreen(
                          collegeCategory: category['name'] ,
                        ),));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: CollegeColors.primary,
                            width: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              category['icon'],
                              size: 30,
                              color: CollegeColors.primary,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              category['name'],
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 10,),),

            /// Recommended Colleges Section (only if recommended colleges exist)
            if (_controller.recommendedColleges.isNotEmpty) ...[
              /// Recommended Colleges Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      Container(
                        height: 18,
                        width: 5,
                        decoration: BoxDecoration(
                          color: CollegeColors.primary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const Text(
                        "Recommended Colleges",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10,),),

              /// Recommended Colleges Horizontal List
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 155,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _controller.recommendedColleges.length,
                    itemBuilder: (context, index) {
                      final college = _controller.recommendedColleges[index];
                      return _buildRecommendedCollegeCard(college);
                    },
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 8)),
            ],

            /// Sticky Search box with Filter Chips
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickySearchDelegate(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildChip(
                                'All',
                                _selectedFilter == 'All',
                                Icons.apps_rounded,
                              ),
                              _buildChip(
                                'Engineering',
                                _selectedFilter == 'Engineering',
                                Icons.engineering_rounded,
                              ),
                              _buildChip(
                                'Medical',
                                _selectedFilter == 'Medical',
                                Icons.local_hospital_rounded,
                              ),
                              _buildChip(
                                'Arts',
                                _selectedFilter == 'Arts',
                                Icons.art_track_rounded,
                              ),
                              _buildChip(
                                'Commerce',
                                _selectedFilter == 'Commerce',
                                Icons.attach_money_rounded,
                              ),
                              _buildChip(
                                'Science',
                                _selectedFilter == 'Science',
                                Icons.science_rounded,
                              ),
                              _buildChip(
                                'Law',
                                _selectedFilter == 'Law',
                                Icons.gavel_rounded,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Colleges Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    Container(
                      height: 18,
                      width: 5,
                      decoration: BoxDecoration(
                        color: CollegeColors.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Text(
                      "Colleges (${_filteredColleges.length})",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 10,),),

            /// Colleges Grid
            SliverToBoxAdapter(
              child: _filteredColleges.isEmpty
                  ? Container(
                height: 200,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 50,
                      color: CollegeColors.textSecondary.withOpacity(0.6),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No colleges found for "$_selectedFilter"',
                      style: const TextStyle(
                        fontSize: 16,
                        color: CollegeColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
                  : GridView.builder(
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
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),
          ],
        );
      }),
    );
  }

  // Shimmer Loading Widget
  Widget _buildShimmerLoading() {
    return CustomScrollView(
      slivers: [
        /// Banner Shimmer
        SliverAppBar(
          floating: true,
          expandedHeight: 200,
          backgroundColor: CollegeColors.background,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            background: Shimmer.fromColors(
              baseColor: CollegeColors.primaryLight,
              highlightColor: Colors.white,
              child: Container(
                color: Colors.white,
                child: const Center(
                  child: Icon(Icons.school, size: 50, color: Colors.grey),
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Shimmer.fromColors(
            baseColor: CollegeColors.primaryLight,
            highlightColor: Colors.white,
            child: Container(
              margin: const EdgeInsets.all(12),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        /// Search Bar Shimmer
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickySearchDelegate(
            child: Container(
              color: CollegeColors.background,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          7,
                              (index) => Shimmer.fromColors(
                            baseColor: CollegeColors.primaryLight,
                            highlightColor: Colors.white,
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 60,
                                    height: 13,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        /// Colleges Shimmer
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Shimmer.fromColors(
                  baseColor: CollegeColors.primaryLight,
                  highlightColor: Colors.white,
                  child: Container(width: 180, height: 24, color: Colors.white),
                ),
                Shimmer.fromColors(
                  baseColor: CollegeColors.primaryLight,
                  highlightColor: Colors.white,
                  child: Container(width: 60, height: 20, color: Colors.white),
                ),
              ],
            ),
          ),
        ),

        /// Colleges Grid Shimmer
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.3,
              ),
              itemCount: 3,
              itemBuilder: (context, index) {
                return _buildShimmerCollegeCard();
              },
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  // Shimmer College Card
  Widget _buildShimmerCollegeCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: CollegeColors.primaryLight,
            highlightColor: Colors.white,
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: CollegeColors.primaryLight,
                    highlightColor: Colors.white,
                    child: Container(height: 14, width: 120, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Shimmer.fromColors(
                    baseColor: CollegeColors.primaryLight,
                    highlightColor: Colors.white,
                    child: Container(height: 12, width: 80, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Shimmer.fromColors(
                        baseColor: CollegeColors.primaryLight,
                        highlightColor: Colors.white,
                        child: Container(
                          height: 16,
                          width: 60,
                          color: Colors.white,
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: CollegeColors.primaryLight,
                        highlightColor: Colors.white,
                        child: Container(
                          height: 16,
                          width: 40,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? CollegeColors.primary : CollegeColors.border,
              width: 0.9,
            ),
            color: isSelected ? CollegeColors.primary : Colors.white,
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: CollegeColors.primary.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? Colors.white : CollegeColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : CollegeColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedCollegeCard(College college) {
    String imageUrl = college.images.isNotEmpty
        ? college.images.first.url
        : 'https://via.placeholder.com/400x300?text=No+Image';

    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CollegeColors.border, width: 0.6),
        boxShadow: [
          BoxShadow(
            color: CollegeColors.primary.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
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
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  imageUrl,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 100,
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
                      height: 100,
                      color: CollegeColors.primaryLight,
                      child: Icon(
                        Icons.school_rounded,
                        size: 40,
                        color: CollegeColors.primary.withOpacity(0.5),
                      ),
                    );
                  },
                ),
              ),
            ),
            // College Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          college.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
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
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    college.category ?? 'General',
                    style: const TextStyle(
                      fontSize: 11,
                      color: CollegeColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
}

// Custom SliverPersistentHeaderDelegate for sticky search
class _StickySearchDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickySearchDelegate({required this.child});

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return child;
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(_StickySearchDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}