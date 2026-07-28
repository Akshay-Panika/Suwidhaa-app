import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'donation_all_category_screen.dart';
import 'donation_details_screen.dart';

class NgoHomeScreen extends StatefulWidget {
  const NgoHomeScreen({super.key});

  @override
  State<NgoHomeScreen> createState() => _NgoHomeScreenState();
}

class _NgoHomeScreenState extends State<NgoHomeScreen> {
  final List<Map<String, dynamic>> _categories = [
    {"name": "Education", "icon": Icons.school, "color": Colors.blue},
    {"name": "Health", "icon": Icons.health_and_safety, "color": Colors.red},
    {"name": "Environment", "icon": Icons.nature, "color": Colors.green},
    {"name": "Animal Welfare", "icon": Icons.pets, "color": Colors.orange},
    {"name": "Women Empowerment", "icon": Icons.woman, "color": Colors.purple},
    {"name": "Child Care", "icon": Icons.child_care, "color": Colors.pink},
    {"name": "All", "icon": Icons.apps, "color": Colors.teal},
  ];

  final List<Map<String, dynamic>> _banners = [
    {
      "title": "Support Education",
      "subtitle": "Help children access quality education",
      "image": "📚",
      "color": Colors.blue,
      "buttonText": "Donate Now",
    },
    {
      "title": "Save Environment",
      "subtitle": "Join the green revolution",
      "image": "🌍",
      "color": Colors.green,
      "buttonText": "Plant Trees",
    },
    {
      "title": "Health for All",
      "subtitle": "Provide healthcare to the needy",
      "image": "🏥",
      "color": Colors.red,
      "buttonText": "Support Health",
    },
  ];

  final List<Map<String, dynamic>> _openDonations = [
    {
      "name": "Education Fund",
      "raised": 7500,
      "target": 10000,
      "color": Colors.blue,
      "imageUrl": "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=400",
      "description": "Providing quality education to underprivileged children"
    },
    {
      "name": "Medical Camp",
      "raised": 4500,
      "target": 8000,
      "color": Colors.red,
      "imageUrl": "https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=400",
      "description": "Free healthcare services for rural communities"
    },
    {
      "name": "Tree Plantation",
      "raised": 3000,
      "target": 5000,
      "color": Colors.green,
      "imageUrl": "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400",
      "description": "Planting trees for a greener future"
    },
    {
      "name": "Animal Shelter",
      "raised": 2000,
      "target": 6000,
      "color": Colors.orange,
      "imageUrl": "https://images.unsplash.com/photo-1545249390-6bdfa286032f?w=400",
      "description": "Providing shelter and care for stray animals"
    },
    {
      "name": "Education Fund",
      "raised": 7500,
      "target": 10000,
      "color": Colors.blue,
      "imageUrl": "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=400",
      "description": "Providing quality education to underprivileged children"
    },
    {
      "name": "Medical Camp",
      "raised": 4500,
      "target": 8000,
      "color": Colors.red,
      "imageUrl": "https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=400",
      "description": "Free healthcare services for rural communities"
    },
    {
      "name": "Tree Plantation",
      "raised": 3000,
      "target": 5000,
      "color": Colors.green,
      "imageUrl": "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400",
      "description": "Planting trees for a greener future"
    },
    {
      "name": "Animal Shelter",
      "raised": 2000,
      "target": 6000,
      "color": Colors.orange,
      "imageUrl": "https://images.unsplash.com/photo-1545249390-6bdfa286032f?w=400",
      "description": "Providing shelter and care for stray animals"
    },
  ];

  final List<Map<String, dynamic>> _allDonations = [
    {
      "name": "Women Empowerment",
      "raised": 12000,
      "target": 15000,
      "color": Colors.purple,
      "imageUrl": "https://images.unsplash.com/photo-1573496799652-408c2ac9fe98?w=400",
      "description": "Empowering women through education and skill development"
    },
    {
      "name": "Child Education",
      "raised": 8000,
      "target": 10000,
      "color": Colors.pink,
      "imageUrl": "https://images.unsplash.com/photo-1588072432836-e10032774350?w=400",
      "description": "Ensuring every child gets access to quality education"
    },
    {
      "name": "Clean Water",
      "raised": 5000,
      "target": 7000,
      "color": Colors.cyan,
      "imageUrl": "https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=400",
      "description": "Providing clean drinking water to remote villages"
    },
    {
      "name": "Food Distribution",
      "raised": 6000,
      "target": 9000,
      "color": Colors.orange,
      "imageUrl": "https://images.unsplash.com/photo-1593113598332-cd288d649433?w=400",
      "description": "Distributing food to homeless and needy families"
    },
    {
      "name": "Women Empowerment",
      "raised": 12000,
      "target": 15000,
      "color": Colors.purple,
      "imageUrl": "https://images.unsplash.com/photo-1573496799652-408c2ac9fe98?w=400",
      "description": "Empowering women through education and skill development"
    },
    {
      "name": "Child Education",
      "raised": 8000,
      "target": 10000,
      "color": Colors.pink,
      "imageUrl": "https://images.unsplash.com/photo-1588072432836-e10032774350?w=400",
      "description": "Ensuring every child gets access to quality education"
    },
    {
      "name": "Clean Water",
      "raised": 5000,
      "target": 7000,
      "color": Colors.cyan,
      "imageUrl": "https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=400",
      "description": "Providing clean drinking water to remote villages"
    },
    {
      "name": "Food Distribution",
      "raised": 6000,
      "target": 9000,
      "color": Colors.orange,
      "imageUrl": "https://images.unsplash.com/photo-1593113598332-cd288d649433?w=400",
      "description": "Distributing food to homeless and needy families"
    },
  ];

  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentBannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Carousel/Banner Slider using carousel_slider_plus
          SliverToBoxAdapter(
            child: Column(
              children: [
                CarouselSlider(
                  controller: _carouselController,
                  items: _banners.map((banner) => _buildBannerCard(banner)).toList(),
                  options: CarouselOptions(
                    height: 180,
                    viewportFraction: 1,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentBannerIndex = index;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // Carousel Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _banners.length,
                        (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentBannerIndex == index ? 24 : 8,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentBannerIndex == index
                            ? Colors.teal
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // Sticky Search Box
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickySearchBoxDelegate(
              onSearchTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: const Text('Search'),
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      body: const Center(
                        child: Text('Search Screen'),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Categories Grid
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Center(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                      ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        return _buildCategoryCard(index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Open Donations - Horizontal GridView with 2 columns
          SliverToBoxAdapter(
            child: Container(
              color: Colors.teal.shade50,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Open Donations",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 500,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _openDonations.length,
                      itemBuilder: (context, index) {
                        return _buildDonationCard(_openDonations[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // All Donations - Horizontal GridView with 2 columns
          SliverToBoxAdapter(
            child: Container(
              color: Colors.teal.shade100,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "All Donations",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 500,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _allDonations.length,
                      itemBuilder: (context, index) {
                        return _buildDonationCard(_allDonations[index]);
                      },
                    ),
                  ),
                ],
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

  Widget _buildBannerCard(Map<String, dynamic> banner) {
    return Card(
      elevation: 0.3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: banner["color"],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          banner["title"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          banner["subtitle"],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DonationDetailsScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: banner["color"],
                          ),
                          child: Text(banner["buttonText"]),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    banner["image"],
                    style: const TextStyle(fontSize: 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(int index) {
    final category = _categories[index];
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DonationAllCategoryScreen(
              initialCategory: category["name"],
            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: category["color"].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                category["icon"],
                color: category["color"],
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category["name"],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDonationCard(Map<String, dynamic> donation) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DonationDetailsScreen(
              donationData: donation,
            ),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Card(
            elevation: 0.3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Donation Image
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        donation["imageUrl"],
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: donation["color"].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.image_not_supported,
                              color: donation["color"],
                              size: 40,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: donation["color"].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: donation["color"],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Donation Name
                  Text(
                    donation["name"],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Description
                  Text(
                    donation["description"] ?? "",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Progress Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${donation["raised"]}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            "/ \$${donation["target"]}",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: donation["raised"] / donation["target"],
                          backgroundColor: Colors.grey[200],
                          color: donation["color"],
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: Card(
              elevation: 0,
              color: Colors.white,
              child: InkWell(
                child: const Icon(Icons.bookmark_border),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${donation["name"]} bookmarked'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom SliverPersistentHeaderDelegate for sticky search box
class _StickySearchBoxDelegate extends SliverPersistentHeaderDelegate {
  final VoidCallback onSearchTap;

  _StickySearchBoxDelegate({required this.onSearchTap});

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: InkWell(
          onTap: onSearchTap,
          child: Card(
            elevation: 1,
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.grey[600],
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Search here...",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "⌘K",
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}