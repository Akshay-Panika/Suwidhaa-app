import 'package:flutter/material.dart';
import 'donation_details_screen.dart';

class DonationAllCategoryScreen extends StatefulWidget {
  final String? initialCategory;

  const DonationAllCategoryScreen({super.key, this.initialCategory});

  @override
  State<DonationAllCategoryScreen> createState() => _DonationAllCategoryScreenState();
}

class _DonationAllCategoryScreenState extends State<DonationAllCategoryScreen> {
  String _selectedCategory = "All";

  // Using the same categories from NgoHomeScreen
  final List<Map<String, dynamic>> _categories = [
    {"name": "All", "icon": Icons.apps, "color": Colors.teal},
    {"name": "Education", "icon": Icons.school, "color": Colors.blue},
    {"name": "Health", "icon": Icons.health_and_safety, "color": Colors.red},
    {"name": "Environment", "icon": Icons.nature, "color": Colors.green},
    {"name": "Animal Welfare", "icon": Icons.pets, "color": Colors.orange},
    {"name": "Women Empowerment", "icon": Icons.woman, "color": Colors.purple},
    {"name": "Child Care", "icon": Icons.child_care, "color": Colors.pink},
  ];

  // Static NGO data with proper structure
  final List<Map<String, dynamic>> _allDonations = [
    {
      "name": "Education For All",
      "category": "Education",
      "rating": 4.5,
      "color": Colors.blue,
      "raised": 7500,
      "target": 10000,
      "description": "Providing quality education to underprivileged children",
      "imageUrl": "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=400",
      "icon": Icons.school,
    },
    {
      "name": "Health First",
      "category": "Health",
      "rating": 4.8,
      "color": Colors.red,
      "raised": 4500,
      "target": 8000,
      "description": "Free healthcare services for rural communities",
      "imageUrl": "https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=400",
      "icon": Icons.health_and_safety,
    },
    {
      "name": "Green Planet",
      "category": "Environment",
      "rating": 4.2,
      "color": Colors.green,
      "raised": 3000,
      "target": 5000,
      "description": "Planting trees for a greener future",
      "imageUrl": "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400",
      "icon": Icons.nature,
    },
    {
      "name": "Animal Rescue",
      "category": "Animal Welfare",
      "rating": 4.7,
      "color": Colors.orange,
      "raised": 2000,
      "target": 6000,
      "description": "Providing shelter and care for stray animals",
      "imageUrl": "https://images.unsplash.com/photo-1545249390-6bdfa286032f?w=400",
      "icon": Icons.pets,
    },
    {
      "name": "Women Rise",
      "category": "Women Empowerment",
      "rating": 4.9,
      "color": Colors.purple,
      "raised": 12000,
      "target": 15000,
      "description": "Empowering women through education and skill development",
      "imageUrl": "https://images.unsplash.com/photo-1573496799652-408c2ac9fe98?w=400",
      "icon": Icons.woman,
    },
    {
      "name": "Child Hope",
      "category": "Child Care",
      "rating": 4.6,
      "color": Colors.pink,
      "raised": 8000,
      "target": 10000,
      "description": "Ensuring every child gets access to quality education",
      "imageUrl": "https://images.unsplash.com/photo-1588072432836-e10032774350?w=400",
      "icon": Icons.child_care,
    },
    {
      "name": "Clean Water Initiative",
      "category": "Environment",
      "rating": 4.4,
      "color": Colors.cyan,
      "raised": 5000,
      "target": 7000,
      "description": "Providing clean drinking water to remote villages",
      "imageUrl": "https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=400",
      "icon": Icons.water_drop,
    },
    {
      "name": "Food Distribution",
      "category": "Health",
      "rating": 4.3,
      "color": Colors.orange,
      "raised": 6000,
      "target": 9000,
      "description": "Distributing food to homeless and needy families",
      "imageUrl": "https://images.unsplash.com/photo-1593113598332-cd288d649433?w=400",
      "icon": Icons.restaurant,
    },
    {
      "name": "Digital Education",
      "category": "Education",
      "rating": 4.1,
      "color": Colors.indigo,
      "raised": 2500,
      "target": 5000,
      "description": "Providing digital learning resources to rural schools",
      "imageUrl": "https://images.unsplash.com/photo-1509062522246-3755977927d7?w=400",
      "icon": Icons.computer,
    },
    {
      "name": "Mental Health Support",
      "category": "Health",
      "rating": 4.6,
      "color": Colors.deepPurple,
      "raised": 3500,
      "target": 7000,
      "description": "Providing mental health counseling and support",
      "imageUrl": "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400",
      "icon": Icons.psychology,
    },
    {
      "name": "Wildlife Protection",
      "category": "Environment",
      "rating": 4.7,
      "color": Colors.brown,
      "raised": 4500,
      "target": 8000,
      "description": "Protecting endangered species and their habitats",
      "imageUrl": "https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=400",
      "icon": Icons.park,
    },
    {
      "name": "Girl Child Education",
      "category": "Women Empowerment",
      "rating": 4.8,
      "color": Colors.deepPurple,
      "raised": 9000,
      "target": 12000,
      "description": "Promoting education for girl children in rural areas",
      "imageUrl": "https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=400",
      "icon": Icons.female,
    },
  ];

  List<Map<String, dynamic>> get _filteredDonations {
    if (_selectedCategory == "All") {
      return _allDonations;
    }
    return _allDonations.where((donation) => donation["category"] == _selectedCategory).toList();
  }

  @override
  void initState() {
    super.initState();
    // Set initial category if provided
    if (widget.initialCategory != null) {
      final category = _categories.firstWhere(
            (cat) => cat["name"] == widget.initialCategory,
        orElse: () => _categories.first,
      );
      _selectedCategory = category["name"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _selectedCategory == "All" ? "Categories" : _selectedCategory,
        ),
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {

            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Category List
            Container(
              width: 110,
              color: Colors.grey.shade50,
              child: ListView.builder(
                itemCount: _categories.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category["name"];
                  final categoryCount = category["name"] == "All"
                      ? _allDonations.length
                      : _allDonations.where((donation) => donation["category"] == category["name"]).length;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category["name"];
                      });
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            elevation: 0.3,
                            color: isSelected ? category["color"] : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      category["icon"],
                                      size: 20,
                                      color: isSelected ? Colors.white : category["color"],
                                    ),
                                  ),
                                  Text(
                                    category["name"],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? Colors.white : Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,left: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white.withOpacity(0.2) : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              categoryCount.toString(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Donations Grid
            Expanded(
              child: _filteredDonations.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No donations found",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Try selecting a different category",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
                  : GridView.builder(
                 padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _filteredDonations.length,
                itemBuilder: (context, index) {
                  return _buildDonationCard(_filteredDonations[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Using the same card design from NgoHomeScreen
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
            color: Colors.white,
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
                              donation["icon"] ?? Icons.image_not_supported,
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

                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: donation["color"].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      donation["category"],
                      style: TextStyle(
                        fontSize: 9,
                        color: donation["color"],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

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

                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      Text(
                        " ${donation["rating"]}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
                onTap: () {

                },
                child: const Icon(Icons.bookmark_border),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

