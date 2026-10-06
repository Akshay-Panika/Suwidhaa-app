import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controller/ngo_category_controller.dart';
import '../../services/controller/ngo_service_controller.dart';
import '../../services/model/ngo_service_model.dart';
import '../../services/screen/donation_details_screen.dart';

class NGOCategoryScreen extends StatefulWidget {
  final String? initialCategory;

  const NGOCategoryScreen({super.key, this.initialCategory});

  @override
  State<NGOCategoryScreen> createState() => _NGOCategoryScreenState();
}

class _NGOCategoryScreenState extends State<NGOCategoryScreen> {
  final NgoCategoryController categoryController = Get.find<NgoCategoryController>();
  final NgoServiceController serviceController = Get.find<NgoServiceController>();

  /// Currently selected category NAME (null means "All")
  String? _selectedCategoryName;

  @override
  void initState() {
    super.initState();
    _selectedCategoryName = widget.initialCategory;
  }

  // ═══════════════════════════════════════════════════════════════
  // FILTER SERVICES BY SELECTED CATEGORY
  // ═══════════════════════════════════════════════════════════════
  List<NgoServiceData> get _filteredServices {
    if (_selectedCategoryName == null || _selectedCategoryName == "All") {
      return serviceController.services;
    }
    return serviceController.services
        .where((s) =>
    (s.categoryName ?? '')
        .toLowerCase()
        .trim() ==
        _selectedCategoryName!.toLowerCase().trim())
        .toList();
  }

  /// Count services per category name
  int _countServicesForCategory(String? categoryName) {
    if (categoryName == null || categoryName == "All") {
      return serviceController.services.length;
    }
    return serviceController.services
        .where((s) =>
    (s.categoryName ?? '')
        .toLowerCase()
        .trim() ==
        categoryName.toLowerCase().trim())
        .length;
  }

  // ═══════════════════════════════════════════════════════════════
  // ICON & COLOR FALLBACK MAPS
  // ═══════════════════════════════════════════════════════════════
  IconData _getIconForCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains("education")) return Icons.school;
    if (lower.contains("health") || lower.contains("medical")) {
      return Icons.health_and_safety;
    }
    if (lower.contains("environment") || lower.contains("nature")) {
      return Icons.nature;
    }
    if (lower.contains("animal")) return Icons.pets;
    if (lower.contains("women")) return Icons.woman;
    if (lower.contains("child")) return Icons.child_care;
    if (lower.contains("elderly")) return Icons.elderly;
    if (lower.contains("water")) return Icons.water_drop;
    if (lower.contains("food")) return Icons.restaurant;
    if (lower.contains("sport")) return Icons.sports_soccer;
    return Icons.category;
  }

  Color _getColorForCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains("education")) return Colors.blue;
    if (lower.contains("health") || lower.contains("medical")) {
      return Colors.red;
    }
    if (lower.contains("environment")) return Colors.green;
    if (lower.contains("animal")) return Colors.orange;
    if (lower.contains("women")) return Colors.purple;
    if (lower.contains("child")) return Colors.pink;
    if (lower.contains("elderly")) return Colors.brown;
    if (lower.contains("water")) return Colors.cyan;
    if (lower.contains("food")) return Colors.orange;
    if (lower.contains("sport")) return Colors.indigo;
    return Colors.teal;
  }

  // ═══════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        // Loading state
        if ((categoryController.isLoading.value &&
            categoryController.categories.isEmpty) ||
            (serviceController.isLoading.value &&
                serviceController.services.isEmpty)) {
          return const Center(child: CircularProgressIndicator());
        }

        // Empty state
        if (categoryController.categories.isEmpty) {
          return const Center(child: Text('No categories found'));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // ── LEFT: Category List ──
              Container(
                width: 110,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: categoryController.categories.length + 1,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    // "All" tab (always first)
                    if (index == 0) {
                      return _buildCategoryTile(
                        name: "All",
                        image: null,
                        icon: Icons.apps,
                        color: Colors.teal,
                        isSelected:
                        _selectedCategoryName == null ||
                            _selectedCategoryName == "All",
                        count: _countServicesForCategory("All"),
                      );
                    }

                    final category = categoryController.categories[index - 1];
                    return _buildCategoryTile(
                      name: category.name,
                      image: category.image,
                      icon: _getIconForCategory(category.name),
                      color: _getColorForCategory(category.name),
                      isSelected: _selectedCategoryName == category.name,
                      count: _countServicesForCategory(category.name),
                    );
                  },
                ),
              ),

              // ── RIGHT: Services Grid ──
              Expanded(
                child: _filteredServices.isEmpty
                    ? _buildEmptyState()
                    : GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _filteredServices.length,
                  itemBuilder: (context, index) {
                    return _buildServiceCard(_filteredServices[index]);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // EMPTY STATE
  // ═══════════════════════════════════════════════════════════════
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "No services found",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try selecting a different category",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // CATEGORY TILE
  // ═══════════════════════════════════════════════════════════════
  Widget _buildCategoryTile({
    required String name,
    String? image,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required int count,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategoryName = name;
        });
      },
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 0.3,
              color: isSelected ? color : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    image != null && image.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            icon,
                            size: 20,
                            color: isSelected ? Colors.white : color,
                          );
                        },
                      ),
                    )
                        : Icon(
                      icon,
                      size: 35,
                      color: isSelected ? Colors.white : color,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
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
            top: 5,
            left: 5,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
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
  }

  // ═══════════════════════════════════════════════════════════════
  // SERVICE CARD — uses NgoServiceData from API
  // ═══════════════════════════════════════════════════════════════
  Widget _buildServiceCard(NgoServiceData service) {
    final progress = service.progress;
    final primaryImage = service.images.isNotEmpty ? service.images.first : null;
    final color = service.categoryName != null
        ? _getColorForCategory(service.categoryName!)
        : Colors.teal;
    final icon = service.categoryName != null
        ? _getIconForCategory(service.categoryName!)
        : Icons.category;

    // For details screen we still pass a map (compatible with old code)
    final donationData = {
      "name": service.name,
      "category": service.categoryName ?? "",
      "raised": progress.totalAmount,
      "target": progress.targetAmount,
      "description": service.description ?? "",
      "imageUrl": primaryImage ?? "",
      "images": service.images,
      "choose_amount": service.chooseAmount,
      "keys": service.keys.map((k) => {
        "key": k.key,
        "icon": k.icon,
        "value": k.value,
      }).toList(),
      "progress": {
        "target_amount": progress.targetAmount,
        "total_amount": progress.totalAmount,
        "donor": progress.donor,
      },
    };

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DonationDetailsScreen(
              serviceId: service.id,
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
                  // Main Image
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: primaryImage != null && primaryImage.isNotEmpty
                          ? Image.network(
                        primaryImage,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(icon, color: color, size: 40),
                          );
                        },
                        loadingBuilder:
                            (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: color,
                              ),
                            ),
                          );
                        },
                      )
                          : Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(icon, color: color, size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (service.categoryName != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            service.categoryName!,
                            style: TextStyle(
                              fontSize: 9,
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Description
                  Text(
                    service.description ?? "",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Donor count (instead of rating)
                  Row(
                    children: [
                      const Icon(Icons.people,
                          color: Colors.amber, size: 14),
                      Text(
                        " ${progress.donor}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Progress
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹${progress.totalAmount}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            "/ ₹${progress.targetAmount}",
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
                          value: progress.progressRatio,
                          backgroundColor: Colors.grey[200],
                          color: color,
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
        ],
      ),
    );
  }
}