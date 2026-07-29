import 'package:flutter/material.dart';
import 'package:untitled/feature/ecommerce/screen/ecommerce_details_screen.dart';

class LocalShopScreen extends StatefulWidget {
  final Map<String, dynamic>? store;

  const LocalShopScreen({super.key, this.store});

  @override
  State<LocalShopScreen> createState() => _LocalShopScreenState();
}

class _LocalShopScreenState extends State<LocalShopScreen> {
  // Store items mapped by store name
  final Map<String, List<Map<String, dynamic>>> shopProducts = {
    'Fresh Mart Grocery': [
      {
        'title': 'Organic Avocado Pack',
        'imageUrl': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?q=80&w=400',
        'shop': 'Fresh Mart Grocery',
        'price': '\$5.49',
        'oldPrice': '\$7.99',
        'badge': 'Fresh',
        'rating': 4.9,
        'reviews': 89,
        'color': const Color(0xFF10B981),
        'description': 'Fresh organic avocados sourced directly from farms. Rich in healthy fats and nutrients.',
      },
      {
        'title': 'Fresh Strawberries Pack',
        'imageUrl': 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?q=80&w=400',
        'shop': 'Fresh Mart Grocery',
        'price': '\$3.99',
        'oldPrice': '\$5.49',
        'badge': 'Top Seller',
        'rating': 4.8,
        'reviews': 67,
        'color': const Color(0xFF10B981),
        'description': 'Fresh organic strawberries packed with vitamins and antioxidants.',
      },
      {
        'title': 'Organic Apples',
        'imageUrl': 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?q=80&w=400',
        'shop': 'Fresh Mart Grocery',
        'price': '\$3.99',
        'oldPrice': '\$5.99',
        'badge': 'Organic',
        'rating': 4.7,
        'reviews': 45,
        'color': const Color(0xFF10B981),
        'description': 'Crisp and juicy organic apples grown without pesticides.',
      },
      {
        'title': 'Fresh Milk',
        'imageUrl': 'https://images.unsplash.com/photo-1550583724-b2692b85b150?q=80&w=400',
        'shop': 'Fresh Mart Grocery',
        'price': '\$2.49',
        'oldPrice': '\$3.49',
        'badge': 'Fresh',
        'rating': 4.6,
        'reviews': 34,
        'color': const Color(0xFF10B981),
        'description': 'Fresh pasteurized milk from local dairy farms.',
      },
    ],
    'TechHub Electronics': [
      {
        'title': 'Premium Wireless Buds',
        'imageUrl': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=400',
        'shop': 'TechHub Electronics',
        'price': '\$29.99',
        'oldPrice': '\$49.99',
        'badge': 'Hot Deal',
        'rating': 4.8,
        'reviews': 120,
        'color': const Color(0xFF3B82F6),
        'description': 'Premium wireless earbuds with noise cancellation and long battery life.',
      },
      {
        'title': 'Smart Vitality Watch',
        'imageUrl': 'https://images.unsplash.com/photo-1546868871-704132a5d082?q=80&w=400',
        'shop': 'TechHub Electronics',
        'price': '\$59.99',
        'oldPrice': '\$89.99',
        'badge': 'Best Seller',
        'rating': 4.7,
        'reviews': 95,
        'color': const Color(0xFF3B82F6),
        'description': 'Advanced smart watch with fitness tracking and heart rate monitor.',
      },
      {
        'title': 'USB-C Cable',
        'imageUrl': 'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?q=80&w=400',
        'shop': 'TechHub Electronics',
        'price': '\$5.99',
        'oldPrice': '\$9.99',
        'badge': 'Sale',
        'rating': 4.5,
        'reviews': 56,
        'color': const Color(0xFF3B82F6),
        'description': 'High-speed USB-C charging and data transfer cable.',
      },
    ],
    'Vogue Apparel': [
      {
        'title': 'Casual Hoodie',
        'imageUrl': 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?q=80&w=400',
        'shop': 'Vogue Apparel',
        'price': '\$34.00',
        'oldPrice': '\$45.00',
        'badge': 'Trending',
        'rating': 4.7,
        'reviews': 67,
        'color': const Color(0xFF7C3AED),
        'description': 'Comfortable cotton hoodie perfect for casual wear.',
      },
      {
        'title': 'Denim Jeans',
        'imageUrl': 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?q=80&w=400',
        'shop': 'Vogue Apparel',
        'price': '\$39.99',
        'oldPrice': '\$49.99',
        'badge': 'Premium',
        'rating': 4.6,
        'reviews': 43,
        'color': const Color(0xFF7C3AED),
        'description': 'High-quality denim jeans with perfect fit and comfort.',
      },
      {
        'title': 'Summer Dress',
        'imageUrl': 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?q=80&w=400',
        'shop': 'Vogue Apparel',
        'price': '\$24.99',
        'oldPrice': '\$34.99',
        'badge': 'New',
        'rating': 4.8,
        'reviews': 78,
        'color': const Color(0xFF7C3AED),
        'description': 'Elegant summer dress perfect for any occasion.',
      },
    ],
    'HealthPlus Pharmacy': [
      {
        'title': 'Vitamin C Supplement',
        'imageUrl': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=400',
        'shop': 'HealthPlus Pharmacy',
        'price': '\$12.99',
        'oldPrice': '\$16.99',
        'badge': 'Essential',
        'rating': 4.9,
        'reviews': 89,
        'color': const Color(0xFFE63E3E),
        'description': 'High-quality Vitamin C supplement for immune support.',
      },
      {
        'title': 'Pain Relief Gel',
        'imageUrl': 'https://images.unsplash.com/photo-1631549916768-4119b2e5f926?q=80&w=400',
        'shop': 'HealthPlus Pharmacy',
        'price': '\$8.99',
        'oldPrice': '\$11.99',
        'badge': 'Best',
        'rating': 4.7,
        'reviews': 56,
        'color': const Color(0xFFE63E3E),
        'description': 'Fast-acting pain relief gel for muscles and joints.',
      },
    ],
    'HomeStyle Decor': [
      {
        'title': 'Table Lamp',
        'imageUrl': 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?q=80&w=400',
        'shop': 'HomeStyle Decor',
        'price': '\$19.99',
        'oldPrice': '\$29.99',
        'badge': 'Sale',
        'rating': 4.5,
        'reviews': 34,
        'color': const Color(0xFFF59E0B),
        'description': 'Modern LED table lamp with adjustable brightness.',
      },
      {
        'title': 'Wall Art',
        'imageUrl': 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?q=80&w=400',
        'shop': 'HomeStyle Decor',
        'price': '\$24.99',
        'oldPrice': '\$34.99',
        'badge': 'Premium',
        'rating': 4.6,
        'reviews': 28,
        'color': const Color(0xFFF59E0B),
        'description': 'Beautiful wall art to enhance your home decor.',
      },
    ],
    'Green Garden Nursery': [
      {
        'title': 'Rose Plant',
        'imageUrl': 'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?q=80&w=400',
        'shop': 'Green Garden Nursery',
        'price': '\$6.99',
        'oldPrice': '\$9.99',
        'badge': 'Fresh',
        'rating': 4.8,
        'reviews': 45,
        'color': const Color(0xFF22C55E),
        'description': 'Beautiful rose plant with vibrant flowers.',
      },
      {
        'title': 'Garden Tools Set',
        'imageUrl': 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?q=80&w=400',
        'shop': 'Green Garden Nursery',
        'price': '\$24.99',
        'oldPrice': '\$34.99',
        'badge': 'Kit',
        'rating': 4.7,
        'reviews': 34,
        'color': const Color(0xFF22C55E),
        'description': 'Complete garden tools set for all your gardening needs.',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final storeData = widget.store ?? {
      'name': 'Fresh Mart Grocery',
      'tags': 'Organic • Daily Essentials',
      'rating': '4.8',
      'deliveryTime': '15-25 min',
      'minOrder': '\$5.00',
      'deliveryFee': '\$1.99',
      'icon': Icons.storefront_rounded,
      'accent': const Color(0xFF10B981),
      'isOpen': true,
    };

    final products = shopProducts[storeData['name']] ?? [];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // ================= 1. PREMIUM HEADER BANNER =================
              SliverAppBar(
                expandedHeight: 240,
                pinned: true,
                elevation: 0,
                backgroundColor: storeData['accent'],
                leading: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.share_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          storeData['accent'],
                          storeData['accent'].withOpacity(0.75),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -30,
                          bottom: -10,
                          child: Icon(
                            storeData['icon'],
                            size: 180,
                            color: Colors.white.withOpacity(0.12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      storeData['isOpen'] ? '● Open Now' : '● Closed',
                                      style: TextStyle(
                                        color: storeData['isOpen']
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.7),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      storeData['deliveryFee'] == '\$0.00'
                                          ? 'Free Delivery'
                                          : storeData['deliveryFee'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                storeData['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                storeData['tags'],
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ================= 2. STORE STATS OVERLAY CARD =================
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                storeData['rating'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Rating",
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 24,
                        width: 1,
                        color: const Color(0xFFE2E8F0),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_filled_rounded,
                                color: Color(0xFF64748B),
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                storeData['deliveryTime'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Delivery Time",
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 24,
                        width: 1,
                        color: const Color(0xFFE2E8F0),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.verified_user_rounded,
                                color: Color(0xFF10B981),
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                "100%",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Verified Shop",
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ================= 3. STICKY CATEGORY TABS =================
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: storeData['accent'],
                    unselectedLabelColor: const Color(0xFF94A3B8),
                    indicatorColor: storeData['accent'],
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(text: 'All Items'),
                      Tab(text: 'Popular'),
                      Tab(text: 'Offers'),
                    ],
                  ),
                ),
              ),
            ];
          },

          // ================= 4. TAB VIEWS & PRODUCT LISTINGS =================
          body: TabBarView(
            children: [
              _buildProductGrid(context, products),
              _buildProductGrid(
                context,
                products.where((p) => p['badge'] == 'Best Seller' || p['badge'] == 'Trending' || p['badge'] == 'Popular').toList(),
              ),
              _buildProductGrid(
                context,
                products.where((p) => p['oldPrice'] != null && p['oldPrice'] != '').toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Common Product Grid Builder
  Widget _buildProductGrid(BuildContext context, List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              "No products found",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Check back later for new items",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final product = items[index];
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EcommerceDetailsScreen(
                product: {
                  'title': product['title'],
                  'imageUrl': product['imageUrl'],
                  'shop': product['shop'],
                  'price': product['price'],
                  'oldPrice': product['oldPrice'],
                  'badge': product['badge'],
                  'rating': product['rating'] ?? 4.8,
                  'reviews': product['reviews'] ?? 120,
                  'color': product['color'],
                  'description': product['description'] ?? 'This premium item is carefully selected and quality checked.',
                },
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.grey.withOpacity(0.06),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: product['color'].withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              product['imageUrl'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  Center(
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 30,
                                      color: product['color'],
                                    ),
                                  ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                product['badge'],
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: product['color'],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
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
                  const SizedBox(height: 10),
                  Text(
                    product['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        (product['rating'] ?? 4.8).toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "(${product['reviews'] ?? 0})",
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['price'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          if (product['oldPrice'] != null)
                            Text(
                              product['oldPrice'],
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[400],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: product['color'],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Persistent Header Delegate for TabBar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overridesParagraphs) {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}