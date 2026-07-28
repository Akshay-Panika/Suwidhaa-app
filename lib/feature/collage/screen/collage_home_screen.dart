import 'package:flutter/material.dart';
import '../../../core/utils/app_color.dart';
import 'collage_view_screen.dart';

class CollageHomeScreen extends StatefulWidget {
  const CollageHomeScreen({super.key});

  @override
  State<CollageHomeScreen> createState() => _CollageHomeScreenState();
}

class _CollageHomeScreenState extends State<CollageHomeScreen> {
  String _selectedFilter = 'All';

  // Get filtered nearby colleges based on selected category
  List<CollegeModel> get _filteredNearbyColleges {
    if (_selectedFilter == 'All') {
      return _nearbyColleges;
    }
    return _nearbyColleges
        .where((college) => college.category == _selectedFilter)
        .toList();
  }

  // Get filtered best colleges based on selected category
  List<CollegeModel> get _filteredBestColleges {
    if (_selectedFilter == 'All') {
      return _bestColleges;
    }
    return _bestColleges
        .where((college) => college.category == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: CustomScrollView(
        slivers: [
          /// Map
          SliverAppBar(
            expandedHeight: 400,
            backgroundColor: Colors.green,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.green.shade700,
                      Colors.green.shade400,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Simulated map with pins
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.map_rounded,
                            color: Colors.white,
                            size: 60,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Colleges Near You",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${_filteredNearbyColleges.length} colleges found in your area",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Map pins
                    Positioned(
                      top: 60,
                      left: 40,
                      child: _buildMapPin(),
                    ),
                    Positioned(
                      top: 100,
                      right: 50,
                      child: _buildMapPin(),
                    ),
                    Positioned(
                      bottom: 60,
                      left: 80,
                      child: _buildMapPin(isSelected: true),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Sticky Search box with Filter Chips
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickySearchDelegate(
              child: Container(
                color: AppColors.background,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        readOnly: true,
                        onChanged: (value) {
                          // Search logic can be added here
                        },
                        decoration: InputDecoration(
                          hintText: 'Search colleges...',
                          hintStyle: TextStyle(color: AppColors.textSecondary),
                          prefixIcon: Icon(Icons.search_rounded, color: AppColors.textSecondary),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.tune_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildChip('All', _selectedFilter == 'All', Icons.apps_rounded),
                            _buildChip('Engineering', _selectedFilter == 'Engineering', Icons.engineering_rounded),
                            _buildChip('Medical', _selectedFilter == 'Medical', Icons.local_hospital_rounded),
                            _buildChip('Arts', _selectedFilter == 'Arts', Icons.art_track_rounded),
                            _buildChip('Commerce', _selectedFilter == 'Commerce', Icons.attach_money_rounded),
                            _buildChip('Science', _selectedFilter == 'Science', Icons.science_rounded),
                            _buildChip('Law', _selectedFilter == 'Law', Icons.gavel_rounded),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Nearby Colleges Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Nearby Colleges (${_filteredNearbyColleges.length})",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Nearby Colleges Horizontal Grid
          SliverToBoxAdapter(
            child: _filteredNearbyColleges.isEmpty
                ? Container(
              height: 200,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 50,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No colleges found for "${_selectedFilter}"',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
                : SizedBox(
              height: 350,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: _filteredNearbyColleges.length,
                itemBuilder: (context, index) {
                  final college = _filteredNearbyColleges[index];
                  return _buildCollegeCard(college);
                },
              ),
            ),
          ),

          /// Best Colleges in Jabalpur Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Best Colleges in Jabalpur (${_filteredBestColleges.length})",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Best Colleges Horizontal Grid
          SliverToBoxAdapter(
            child: _filteredBestColleges.isEmpty
                ? Container(
              height: 200,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 50,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No best colleges found for "${_selectedFilter}"',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
                : SizedBox(
              height: 350,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: _filteredBestColleges.length,
                itemBuilder: (context, index) {
                  final college = _filteredBestColleges[index];
                  return _buildCollegeCard(college);
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPin({bool isSelected = false}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isSelected ? Colors.red : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? Colors.red : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.location_on,
        color: isSelected ? Colors.white : Colors.red,
        size: 14,
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
              width: 1.5,
            ),
            color: isSelected ? AppColors.primary : Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
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

  Widget _buildCollegeCard(CollegeModel college) {
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
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CollageViewScreen(
          collageName: college.name,
        ),)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // College Image with rating
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  // Network image with placeholder
                  Image.network(
                    college.imageUrl,
                    height: 90,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 90,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 90,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: Center(
                          child: Icon(
                            Icons.school_rounded,
                            size: 35,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            college.rating.toString(),
                            style: const TextStyle(
                              fontSize: 10,
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
                  Text(
                    college.location,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
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
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          college.category,
                          style: TextStyle(
                            fontSize: 8,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (college.distance != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                color: Colors.red,
                                size: 10,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                college.distance!,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
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

// Data Models
class CollegeModel {
  final String name;
  final String location;
  final String category;
  final double rating;
  final String? distance;
  final String imageUrl;

  CollegeModel({
    required this.name,
    required this.location,
    required this.category,
    required this.rating,
    this.distance,
    required this.imageUrl,
  });
}

// Custom SliverPersistentHeaderDelegate for sticky search
class _StickySearchDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickySearchDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 135;

  @override
  double get minExtent => 135;

  @override
  bool shouldRebuild(_StickySearchDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}

// Sample Data with Random Network Images
final List<CollegeModel> _nearbyColleges = [
  CollegeModel(
    name: "Jabalpur Engineering College",
    location: "Ranital, Jabalpur",
    category: "Engineering",
    rating: 4.3,
    distance: "1.2 km",
    imageUrl: "https://images.unsplash.com/photo-1562774053-701939374585?w=400&h=300&fit=crop",
  ),
  CollegeModel(
    name: "Netaji Subhash Medical College",
    location: "Garha, Jabalpur",
    category: "Medical",
    rating: 4.5,
    distance: "2.8 km",
    imageUrl: "https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=400&h=300&fit=crop",
  ),
  CollegeModel(
    name: "Rani Durgavati University",
    location: "Pachpedi, Jabalpur",
    category: "Arts",
    rating: 4.1,
    distance: "3.5 km",
    imageUrl: "https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=400&h=300&fit=crop",
  ),
  CollegeModel(
    name: "Shri Ram Institute of Technology",
    location: "Madan Mahal, Jabalpur",
    category: "Engineering",
    rating: 4.0,
    distance: "4.1 km",
    imageUrl: "https://images.unsplash.com/photo-1592823680328-7b67d7d76c14?w=400&h=300&fit=crop",
  ),
  CollegeModel(
    name: "Global Institute of Technology",
    location: "Adhartal, Jabalpur",
    category: "Engineering",
    rating: 4.2,
    distance: "5.0 km",
    imageUrl: "https://images.unsplash.com/photo-1523050854058-8df90110c7f1?w=400&h=300&fit=crop",
  ),
  CollegeModel(
    name: "Mahatma Gandhi Memorial Medical College",
    location: "Civic Center, Jabalpur",
    category: "Medical",
    rating: 4.6,
    distance: "6.2 km",
    imageUrl: "https://images.unsplash.com/photo-1582822370839-f9b2b2959c9e?w=400&h=300&fit=crop",
  ),
  CollegeModel(
    name: "Government Science College",
    location: "Civil Lines, Jabalpur",
    category: "Science",
    rating: 4.3,
    distance: "7.5 km",
    imageUrl: "https://images.unsplash.com/photo-1541823709867-1b206113eafd?w=400&h=300&fit=crop",
  ),
  CollegeModel(
    name: "Institute of Management Studies",
    location: "Vijay Nagar, Jabalpur",
    category: "Commerce",
    rating: 4.2,
    distance: "8.0 km",
    imageUrl: "https://images.unsplash.com/photo-1562774053-701939374585?w=400&h=300&fit=crop",
  ),
];

final List<CollegeModel> _bestColleges = [
  CollegeModel(
    name: "Rani Durgavati University",
    location: "Pachpedi, Jabalpur",
    category: "Arts & Science",
    rating: 4.8,
    imageUrl: "https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=400&h=300&fit=crop",
  ),
  CollegeModel(
    name: "Jabalpur Engineering College",
    location: "Ranital, Jabalpur",
    category: "Engineering",
    rating: 4.7,
    imageUrl: "https://images.unsplash.com/photo-1562774053-701939374585?w=400&h=300&fit=crop",
  ),
  CollegeModel(
    name: "Netaji Subhash Medical College",
    location: "Garha, Jabalpur",
    category: "Medical",
    rating: 4.6,
    imageUrl: "https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=400&h=300&fit=crop",
  ),
  CollegeModel(
    name: "Shri Ram Institute of Technology",
    location: "Madan Mahal, Jabalpur",
    category: "Engineering",
    rating: 4.4,
    imageUrl: "https://images.unsplash.com/photo-1592823680328-7b67d7d76c14?w=400&h=300&fit=crop",
  ),
  CollegeModel(
    name: "Government Science College",
    location: "Civil Lines, Jabalpur",
    category: "Science",
    rating: 4.3,
    imageUrl: "https://images.unsplash.com/photo-1541823709867-1b206113eafd?w=400&h=300&fit=crop",
  ),
  CollegeModel(
    name: "Institute of Management Studies",
    location: "Vijay Nagar, Jabalpur",
    category: "Commerce",
    rating: 4.2,
    imageUrl: "https://images.unsplash.com/photo-1523050854058-8df90110c7f1?w=400&h=300&fit=crop",
  ),
];