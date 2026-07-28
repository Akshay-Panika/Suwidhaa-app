import 'package:flutter/material.dart';
import 'package:untitled/feature/ecommerce/screen/ecommerce_details_screen.dart';

class EcommerceCategoryScreen extends StatefulWidget {
  final int initialIndex; // Parameter accept karne ke liye variable

  const EcommerceCategoryScreen({super.key, required this.initialIndex});

  @override
  State<EcommerceCategoryScreen> createState() => _EcommerceCategoryScreenState();
}

class _EcommerceCategoryScreenState extends State<EcommerceCategoryScreen> {
  late int _selectedCategoryIndex; // State variable

  @override
  void initState() {
    super.initState();
    // Jo index piche se pass hui hai use yahan assign kiya gya hai
    _selectedCategoryIndex = widget.initialIndex;
  }

  // 1. Main Categories List
  final List<Map<String, dynamic>> categories = [
    {'name': 'Groceries', 'icon': Icons.local_grocery_store_outlined, 'color': const Color(0xFF10B981)},
    {'name': 'Fashion', 'icon': Icons.checkroom_rounded, 'color': const Color(0xFF6366F1)},
    {'name': 'Electronics', 'icon': Icons.devices_other_rounded, 'color': const Color(0xFF0EA5E9)},
    {'name': 'Pharmacy', 'icon': Icons.medical_services_outlined, 'color': const Color(0xFFF43F5E)},
  ];

  // 2. Category wise Product List
  final Map<int, List<Map<String, dynamic>>> productsByCategory = {
    0: [
      {
        'title': 'Organic Avocado Pack',
        'imageUrl': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?q=80&w=400',
        'price': '\$5.49',
        'badge': 'Fresh',
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Fresh Strawberries',
        'imageUrl': 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?q=80&w=400',
        'price': '\$3.99',
        'badge': 'Top Seller',
        'color': const Color(0xFF10B981),
      },
    ],
    1: [
      {
        'title': 'Casual Comfort Hoodie',
        'imageUrl': 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?q=80&w=400',
        'price': '\$34.00',
        'badge': 'Trending',
        'color': const Color(0xFF6366F1),
      },
      {
        'title': 'Classic Denim Jacket',
        'imageUrl': 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?q=80&w=400',
        'price': '\$45.99',
        'badge': 'New',
        'color': const Color(0xFF6366F1),
      },
    ],
    2: [
      {
        'title': 'Premium Wireless Buds',
        'imageUrl': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=400',
        'price': '\$29.99',
        'badge': 'Hot Deal',
        'color': const Color(0xFF0EA5E9),
      },
      {
        'title': 'Smart Vitality Watch',
        'imageUrl': 'https://images.unsplash.com/photo-1546868871-704132a5d082?q=80&w=400',
        'price': '\$59.99',
        'badge': 'Best Seller',
        'color': const Color(0xFF0EA5E9),
      },
    ],
    3: [
      {
        'title': 'Multivitamin Tablets',
        'imageUrl': 'https://images.unsplash.com/photo-1584017911766-d451b3d0e843?q=80&w=400',
        'price': '\$12.50',
        'badge': 'Essential',
        'color': const Color(0xFFF43F5E),
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final currentProducts = productsByCategory[_selectedCategoryIndex] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          categories[_selectedCategoryIndex]['name'],
          style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Row(
        children: [
          // ================= LEFT SIDE: CATEGORY NAVIGATION =================
          Container(
            width: 95,
            color: Colors.white,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                bool isSelected = _selectedCategoryIndex == index;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFF8FAFC) : Colors.white,
                      border: Border(
                        left: BorderSide(
                          color: isSelected ? cat['color'] : Colors.transparent,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected ? cat['color'] : cat['color'].withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                              cat['icon'],
                              color: isSelected ? Colors.white : cat['color'],
                              size: 22
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            cat['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF64748B)
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ================= RIGHT SIDE: DYNAMIC PRODUCT GRID =================
          Expanded(
            child: currentProducts.isEmpty
                ? const Center(child: Text("No products found in this category"))
                : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: currentProducts.length,
              itemBuilder: (context, index) {
                final item = currentProducts[index];
                return InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EcommerceDetailsScreen(product: item,),)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ],
                      border: Border.all(color: Colors.grey.withOpacity(0.08)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: item['color'].withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      item['imageUrl'],
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)));
                                      },
                                      errorBuilder: (context, error, stackTrace) =>
                                          Icon(Icons.broken_image_outlined, size: 30, color: item['color']),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  left: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      item['badge'],
                                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: item['color']),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  item['price'],
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1E293B),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.add_rounded, color: Colors.white, size: 14),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}