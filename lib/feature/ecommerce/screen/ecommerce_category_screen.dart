import 'package:flutter/material.dart';

import 'ecommerce_details_screen.dart';

class EcommerceCategoryScreen extends StatefulWidget {
  final String? initialCategory;

  const EcommerceCategoryScreen({super.key, this.initialCategory});

  @override
  State<EcommerceCategoryScreen> createState() => _EcommerceCategoryScreenState();
}

class _EcommerceCategoryScreenState extends State<EcommerceCategoryScreen> {
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Set initial category from widget parameter, default to 'All'
    _selectedCategory = widget.initialCategory ?? 'All';
  }

  final List<Map<String, dynamic>> categories = [
    // 'All' category at the top for easy access
    {'name': 'All', 'icon': Icons.dashboard, 'color': const Color(0xFFE63E3E)},
    {'name': 'Grocery', 'icon': Icons.local_grocery_store_rounded, 'color': const Color(0xFF10B981)},
    {'name': 'Fashion', 'icon': Icons.checkroom_rounded, 'color': const Color(0xFF7C3AED)},
    {'name': 'Electronics', 'icon': Icons.devices_other_rounded, 'color': const Color(0xFF2563EB)},
    {'name': 'Pharmacy', 'icon': Icons.medical_services_rounded, 'color': const Color(0xFFE63E3E)},
    {'name': 'Home', 'icon': Icons.home_rounded, 'color': const Color(0xFFF59E0B)},
    {'name': 'Beauty', 'icon': Icons.spa_rounded, 'color': const Color(0xFFEC4899)},
    {'name': 'Books', 'icon': Icons.menu_book_rounded, 'color': const Color(0xFF8B5CF6)},
    {'name': 'Sports', 'icon': Icons.sports_soccer_rounded, 'color': const Color(0xFFEF4444)},
    {'name': 'Toys', 'icon': Icons.toys_rounded, 'color': const Color(0xFFF472B6)},
    {'name': 'Automotive', 'icon': Icons.car_repair_rounded, 'color': const Color(0xFF3B82F6)},
    {'name': 'Furniture', 'icon': Icons.chair_rounded, 'color': const Color(0xFFD97706)},
    {'name': 'Pet Supplies', 'icon': Icons.pets_rounded, 'color': const Color(0xFF34D399)},
    {'name': 'Stationery', 'icon': Icons.edit_rounded, 'color': const Color(0xFF6366F1)},
    {'name': 'Baby Products', 'icon': Icons.baby_changing_station_rounded, 'color': const Color(0xFFF43F5E)},
    {'name': 'Garden', 'icon': Icons.grass_rounded, 'color': const Color(0xFF22C55E)},
    {'name': 'Kitchen', 'icon': Icons.kitchen_rounded, 'color': const Color(0xFFF97316)},
    {'name': 'Jewelry', 'icon': Icons.diamond_rounded, 'color': const Color(0xFFEAB308)},
    {'name': 'Footwear', 'icon': Icons.circle, 'color': const Color(0xFF8B5CF6)},
    {'name': 'Office', 'icon': Icons.business_center_rounded, 'color': const Color(0xFF64748B)},
    {'name': 'Health', 'icon': Icons.favorite_rounded, 'color': const Color(0xFFEF4444)},
    {'name': 'Travel', 'icon': Icons.flight_rounded, 'color': const Color(0xFF0EA5E9)},
    {'name': 'Food', 'icon': Icons.restaurant_menu_rounded, 'color': const Color(0xFFF59E0B)},
    {'name': 'Beverages', 'icon': Icons.local_drink_rounded, 'color': const Color(0xFF06B6D4)},
    {'name': 'Cleaning', 'icon': Icons.cleaning_services_rounded, 'color': const Color(0xFF94A3B8)},
    {'name': 'Tools', 'icon': Icons.handyman_rounded, 'color': const Color(0xFFF97316)},
  ];

  // Sample products data - Added more products for All category
  final List<Map<String, dynamic>> allProducts = [
    // Grocery Products
    {
      'title': 'Fresh Organic Apples',
      'price': '\$4.99',
      'oldPrice': '\$6.99',
      'imageUrl': 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?q=80&w=200',
      'category': 'Grocery',
      'rating': 4.8,
      'reviews': 89,
      'badge': 'Organic',
      'color': const Color(0xFF10B981),
      'shop': 'Fresh Mart Grocery',
      'description': 'Fresh organic apples grown without pesticides. Rich in fiber and vitamins.',
    },
    {
      'title': 'Organic Avocado',
      'price': '\$3.99',
      'oldPrice': '\$5.99',
      'imageUrl': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?q=80&w=200',
      'category': 'Grocery',
      'rating': 4.9,
      'reviews': 67,
      'badge': 'Fresh',
      'color': const Color(0xFF10B981),
      'shop': 'Fresh Mart Grocery',
      'description': 'Fresh organic avocados sourced directly from farms. Rich in healthy fats and nutrients.',
    },
    {
      'title': 'Fresh Organic Bananas',
      'price': '\$2.99',
      'oldPrice': '\$4.49',
      'imageUrl': 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?q=80&w=200',
      'category': 'Grocery',
      'rating': 4.7,
      'reviews': 45,
      'badge': 'Organic',
      'color': const Color(0xFF10B981),
      'shop': 'Fresh Mart Grocery',
      'description': 'Fresh organic bananas packed with potassium and natural sweetness.',
    },
    // Electronics Products
    {
      'title': 'Wireless Headphones',
      'price': '\$49.99',
      'oldPrice': '\$79.99',
      'imageUrl': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=200',
      'category': 'Electronics',
      'rating': 4.7,
      'reviews': 120,
      'badge': 'Hot',
      'color': const Color(0xFF2563EB),
      'shop': 'TechHub Electronics',
      'description': 'Premium wireless headphones with noise cancellation and long battery life.',
    },
    {
      'title': 'Smart Watch',
      'price': '\$89.99',
      'oldPrice': '\$149.99',
      'imageUrl': 'https://images.unsplash.com/photo-1546868871-704132a5d082?q=80&w=200',
      'category': 'Electronics',
      'rating': 4.6,
      'reviews': 95,
      'badge': 'Best Seller',
      'color': const Color(0xFF2563EB),
      'shop': 'TechHub Electronics',
      'description': 'Advanced smart watch with fitness tracking, heart rate monitor, and GPS.',
    },
    {
      'title': 'Bluetooth Speaker',
      'price': '\$29.99',
      'oldPrice': '\$49.99',
      'imageUrl': 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?q=80&w=200',
      'category': 'Electronics',
      'rating': 4.8,
      'reviews': 78,
      'badge': 'Sale',
      'color': const Color(0xFF2563EB),
      'shop': 'TechHub Electronics',
      'description': 'Portable Bluetooth speaker with rich sound and deep bass.',
    },
    // Fashion Products
    {
      'title': 'Cotton T-Shirt',
      'price': '\$19.99',
      'oldPrice': '\$29.99',
      'imageUrl': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=200',
      'category': 'Fashion',
      'rating': 4.5,
      'reviews': 56,
      'badge': 'Trending',
      'color': const Color(0xFF7C3AED),
      'shop': 'Vogue Apparel',
      'description': 'Comfortable cotton t-shirt perfect for everyday wear.',
    },
    {
      'title': 'Denim Jeans',
      'price': '\$39.99',
      'oldPrice': '\$59.99',
      'imageUrl': 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?q=80&w=200',
      'category': 'Fashion',
      'rating': 4.4,
      'reviews': 43,
      'badge': 'Premium',
      'color': const Color(0xFF7C3AED),
      'shop': 'Vogue Apparel',
      'description': 'High-quality denim jeans with perfect fit and comfort.',
    },
    {
      'title': 'Summer Dress',
      'price': '\$34.99',
      'oldPrice': '\$49.99',
      'imageUrl': 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?q=80&w=200',
      'category': 'Fashion',
      'rating': 4.6,
      'reviews': 78,
      'badge': 'New',
      'color': const Color(0xFF7C3AED),
      'shop': 'Vogue Apparel',
      'description': 'Elegant summer dress perfect for any occasion.',
    },
    // Pharmacy Products
    {
      'title': 'Vitamin C Supplement',
      'price': '\$12.99',
      'oldPrice': '\$19.99',
      'imageUrl': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=200',
      'category': 'Pharmacy',
      'rating': 4.9,
      'reviews': 89,
      'badge': 'Essential',
      'color': const Color(0xFFE63E3E),
      'shop': 'HealthPlus Pharmacy',
      'description': 'High-quality Vitamin C supplement for immune support.',
    },
    {
      'title': 'Pain Relief Gel',
      'price': '\$8.99',
      'oldPrice': '\$12.99',
      'imageUrl': 'https://images.unsplash.com/photo-1631549916768-4119b2e5f926?q=80&w=200',
      'category': 'Pharmacy',
      'rating': 4.7,
      'reviews': 56,
      'badge': 'Best',
      'color': const Color(0xFFE63E3E),
      'shop': 'HealthPlus Pharmacy',
      'description': 'Fast-acting pain relief gel for muscles and joints.',
    },
    {
      'title': 'Hand Sanitizer',
      'price': '\$3.99',
      'oldPrice': '\$5.99',
      'imageUrl': 'https://images.unsplash.com/photo-1584483766114-2cea6facdf57?q=80&w=200',
      'category': 'Pharmacy',
      'rating': 4.8,
      'reviews': 34,
      'badge': 'Essential',
      'color': const Color(0xFFE63E3E),
      'shop': 'HealthPlus Pharmacy',
      'description': 'Alcohol-based hand sanitizer for daily hygiene.',
    },
    // Home Products
    {
      'title': 'Decorative Wall Clock',
      'price': '\$34.99',
      'oldPrice': '\$49.99',
      'imageUrl': 'https://images.unsplash.com/photo-1563861826100-9cb868fdbe1c?q=80&w=200',
      'category': 'Home',
      'rating': 4.3,
      'reviews': 28,
      'badge': 'Decor',
      'color': const Color(0xFFF59E0B),
      'shop': 'HomeStyle Decor',
      'description': 'Modern decorative wall clock for your living room.',
    },
    {
      'title': 'LED Desk Lamp',
      'price': '\$24.99',
      'oldPrice': '\$39.99',
      'imageUrl': 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?q=80&w=200',
      'category': 'Home',
      'rating': 4.2,
      'reviews': 34,
      'badge': 'Sale',
      'color': const Color(0xFFF59E0B),
      'shop': 'HomeStyle Decor',
      'description': 'Modern LED desk lamp with adjustable brightness.',
    },
    {
      'title': 'Cushion Set',
      'price': '\$19.99',
      'oldPrice': '\$29.99',
      'imageUrl': 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=200',
      'category': 'Home',
      'rating': 4.5,
      'reviews': 45,
      'badge': 'Premium',
      'color': const Color(0xFFF59E0B),
      'shop': 'HomeStyle Decor',
      'description': 'Soft and comfortable cushion set for your home.',
    },
    // Beauty Products
    {
      'title': 'Face Cream',
      'price': '\$14.99',
      'oldPrice': '\$24.99',
      'imageUrl': 'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=200',
      'category': 'Beauty',
      'rating': 4.7,
      'reviews': 67,
      'badge': 'Organic',
      'color': const Color(0xFFEC4899),
      'shop': 'Beauty Store',
      'description': 'Natural face cream for glowing and healthy skin.',
    },
    {
      'title': 'Lipstick Set',
      'price': '\$9.99',
      'oldPrice': '\$16.99',
      'imageUrl': 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=200',
      'category': 'Beauty',
      'rating': 4.6,
      'reviews': 56,
      'badge': 'Trending',
      'color': const Color(0xFFEC4899),
      'shop': 'Beauty Store',
      'description': 'Premium lipstick set with long-lasting colors.',
    },
    // Books Products
    {
      'title': 'Fiction Novel',
      'price': '\$12.99',
      'oldPrice': '\$18.99',
      'imageUrl': 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?q=80&w=200',
      'category': 'Books',
      'rating': 4.8,
      'reviews': 89,
      'badge': 'Bestseller',
      'color': const Color(0xFF8B5CF6),
      'shop': 'Book Store',
      'description': 'A gripping fiction novel that keeps you on the edge of your seat.',
    },
    {
      'title': 'Cookbook',
      'price': '\$18.99',
      'oldPrice': '\$27.99',
      'imageUrl': 'https://images.unsplash.com/photo-1512820790803-83ca734da794?q=80&w=200',
      'category': 'Books',
      'rating': 4.7,
      'reviews': 45,
      'badge': 'Best',
      'color': const Color(0xFF8B5CF6),
      'shop': 'Book Store',
      'description': 'Delicious recipes from around the world.',
    },
    // Sports Products
    {
      'title': 'Yoga Mat',
      'price': '\$22.99',
      'oldPrice': '\$34.99',
      'imageUrl': 'https://images.unsplash.com/photo-1601925260368-ae1f83fc8b0c?q=80&w=200',
      'category': 'Sports',
      'rating': 4.6,
      'reviews': 34,
      'badge': 'Sale',
      'color': const Color(0xFFEF4444),
      'shop': 'Sports Zone',
      'description': 'Premium yoga mat for comfortable exercise sessions.',
    },
    {
      'title': 'Dumbbell Set',
      'price': '\$34.99',
      'oldPrice': '\$54.99',
      'imageUrl': 'https://images.unsplash.com/photo-1586401100295-7a8096fd231a?q=80&w=200',
      'category': 'Sports',
      'rating': 4.8,
      'reviews': 56,
      'badge': 'Premium',
      'color': const Color(0xFFEF4444),
      'shop': 'Sports Zone',
      'description': 'Complete dumbbell set for home workouts.',
    },
    // Toys Products
    {
      'title': 'Building Blocks',
      'price': '\$16.99',
      'oldPrice': '\$24.99',
      'imageUrl': 'https://images.unsplash.com/photo-1587654780291-39c9404d746b?q=80&w=200',
      'category': 'Toys',
      'rating': 4.9,
      'reviews': 78,
      'badge': 'Top Pick',
      'color': const Color(0xFFF472B6),
      'shop': 'Toy Store',
      'description': 'Creative building blocks for kids of all ages.',
    },
    {
      'title': 'Plush Teddy Bear',
      'price': '\$11.99',
      'oldPrice': '\$19.99',
      'imageUrl': 'https://images.unsplash.com/photo-1558584673-c834fb2cc3a7?q=80&w=200',
      'category': 'Toys',
      'rating': 4.8,
      'reviews': 67,
      'badge': 'Cute',
      'color': const Color(0xFFF472B6),
      'shop': 'Toy Store',
      'description': 'Soft and cuddly teddy bear for children.',
    },
    // Garden Products
    {
      'title': 'Rose Plant',
      'price': '\$6.99',
      'oldPrice': '\$9.99',
      'imageUrl': 'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?q=80&w=200',
      'category': 'Garden',
      'rating': 4.7,
      'reviews': 45,
      'badge': 'Fresh',
      'color': const Color(0xFF22C55E),
      'shop': 'Green Garden Nursery',
      'description': 'Beautiful rose plant with vibrant flowers.',
    },
    {
      'title': 'Garden Tools Set',
      'price': '\$24.99',
      'oldPrice': '\$34.99',
      'imageUrl': 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?q=80&w=200',
      'category': 'Garden',
      'rating': 4.5,
      'reviews': 34,
      'badge': 'Kit',
      'color': const Color(0xFF22C55E),
      'shop': 'Green Garden Nursery',
      'description': 'Complete garden tools set for all your gardening needs.',
    },
  ];

  // Get filtered products based on selected category
  List<Map<String, dynamic>> get filteredProducts {
    if (_selectedCategory == 'All') {
      return allProducts;
    }
    return allProducts.where((product) =>
    product['category'] == _selectedCategory
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Categories',
          style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Row(
        children: [
          // ====== CATEGORY LIST (Left Side) ======
          Container(
            width: 100,
            color: Colors.white,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedCategory == category['name'];
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category['name'];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE63E3E).withOpacity(0.08)
                          : Colors.transparent,
                      border: Border(
                        left: BorderSide(
                          color: isSelected
                              ? const Color(0xFFE63E3E)
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFE63E3E).withOpacity(0.2)
                                : category['color'].withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            category['icon'],
                            color: isSelected
                                ? const Color(0xFFE63E3E)
                                : category['color'],
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFFE63E3E)
                                : const Color(0xFF666666),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ====== PRODUCT GRID (Right Side) ======
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category header with count
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedCategory,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          '${filteredProducts.length} items',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Product Grid
                  Expanded(
                    child: filteredProducts.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_rounded,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No products in this category',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                        : GridView.builder(
                      padding: const EdgeInsets.all(4),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return _buildProductCard(product);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EcommerceDetailsScreen(
              product: {
                'title': product['title'] ?? product['name'] ?? 'Product',
                'imageUrl': product['imageUrl'] ?? product['image'] ?? '',
                'shop': product['shop'] ?? 'Unknown Shop',
                'price': product['price'] ?? '\$0.00',
                'oldPrice': product['oldPrice'] ?? '',
                'badge': product['badge'] ?? 'Featured',
                'rating': product['rating'] ?? 4.5,
                'reviews': product['reviews'] ?? 50,
                'color': product['color'] ?? const Color(0xFFE63E3E),
                'description': product['description'] ?? 'This premium item is carefully selected and quality checked. Packed with high-grade materials to ensure best customer satisfaction and durability.',
              },
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  children: [
                    Image.network(
                      product['imageUrl'] ?? product['image'] ?? '',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported_rounded,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // Category tag
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product['category'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    // Badge
                    if (product['badge'] != null)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: (product['color'] ?? const Color(0xFFE63E3E)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            product['badge'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    // Rating badge
                    Positioned(
                      bottom: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
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
                              (product['rating'] ?? 4.5).toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Favorite button
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          size: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Product Details
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title'] ?? product['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        product['price'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE63E3E),
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (product['oldPrice'] != null && product['oldPrice'] != '')
                        Text(
                          product['oldPrice'],
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF999999),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  // Reviews count
                  if (product['reviews'] != null)
                    Row(
                      children: [
                        Text(
                          '${product['reviews']} reviews',
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF999999),
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