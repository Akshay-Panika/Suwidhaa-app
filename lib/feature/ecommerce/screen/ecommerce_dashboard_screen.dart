// main.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

// ============ DASHBOARD SCREEN ============
class EcommerceDashboardScreen extends StatefulWidget {
  const EcommerceDashboardScreen({super.key});

  @override
  State<EcommerceDashboardScreen> createState() => _EcommerceDashboardScreenState();
}

class _EcommerceDashboardScreenState extends State<EcommerceDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MeesoHomeScreen(),
    const MeesoCategoryScreen(),
    const MeesoWishlistScreen(),
    const MeesoProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFE63E3E),
          unselectedItemColor: const Color(0xFF888888),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_rounded),
              activeIcon: Icon(Icons.category_rounded),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded),
              activeIcon: Icon(Icons.favorite_rounded),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// ============ HOME SCREEN ============
class MeesoHomeScreen extends StatefulWidget {
  const MeesoHomeScreen({super.key});

  @override
  State<MeesoHomeScreen> createState() => _MeesoHomeScreenState();
}

class _MeesoHomeScreenState extends State<MeesoHomeScreen> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentBannerIndex = 0;

  final List<Map<String, dynamic>> banners = [
    {
      'image': 'https://images.unsplash.com/photo-1607082350899-7e105aa886ae?q=80&w=600',
      'title': 'Fresh Groceries',
      'subtitle': 'Up to 40% off',
      'color': const Color(0xFFE63E3E),
      'tag': '⚡ Mega Sale',
    },
    {
      'image': 'https://images.unsplash.com/photo-1607083206968-1366d8b9f4a1?q=80&w=600',
      'title': 'Electronics',
      'subtitle': 'Best deals on gadgets',
      'color': const Color(0xFF2563EB),
      'tag': '🔥 Hot Deals',
    },
    {
      'image': 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=600',
      'title': 'Fashion',
      'subtitle': 'New arrivals',
      'color': const Color(0xFF7C3AED),
      'tag': '👗 New Collection',
    },
  ];

  final List<Map<String, dynamic>> categories = [
    {'name': 'Grocery', 'icon': Icons.local_grocery_store_rounded, 'color': const Color(0xFF10B981)},
    {'name': 'Fashion', 'icon': Icons.checkroom_rounded, 'color': const Color(0xFF7C3AED)},
    {'name': 'Electronics', 'icon': Icons.devices_other_rounded, 'color': const Color(0xFF2563EB)},
    {'name': 'Pharmacy', 'icon': Icons.medical_services_rounded, 'color': const Color(0xFFE63E3E)},
    {'name': 'Home', 'icon': Icons.home_rounded, 'color': const Color(0xFFF59E0B)},
    {'name': 'Beauty', 'icon': Icons.spa_rounded, 'color': const Color(0xFFEC4899)},
  ];

  final List<Map<String, dynamic>> flashDeals = [
    {'title': 'Wireless Buds', 'price': '\$19.99', 'oldPrice': '\$49.99', 'image': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=200', 'discount': '60%'},
    {'title': 'Smart Watch', 'price': '\$39.99', 'oldPrice': '\$89.99', 'image': 'https://images.unsplash.com/photo-1546868871-704132a5d082?q=80&w=200', 'discount': '55%'},
    {'title': 'Hoodie', 'price': '\$24.99', 'oldPrice': '\$45.00', 'image': 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?q=80&w=200', 'discount': '44%'},
  ];

  final List<Map<String, dynamic>> topPicks = [
    {
      'title': 'Premium Wireless Buds',
      'imageUrl': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=400',
      'shop': 'Apex Digital',
      'price': '\$29.99',
      'oldPrice': '\$49.99',
      'rating': 4.8,
      'badge': 'Hot',
      'color': const Color(0xFF2563EB),
    },
    {
      'title': 'Organic Avocado Pack',
      'imageUrl': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?q=80&w=400',
      'shop': 'Fresh Mart',
      'price': '\$5.49',
      'oldPrice': '\$7.99',
      'rating': 4.9,
      'badge': 'Fresh',
      'color': const Color(0xFF10B981),
    },
    {
      'title': 'Casual Hoodie',
      'shop': 'Vogue Apparel',
      'imageUrl': 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?q=80&w=400',
      'price': '\$34.00',
      'oldPrice': '\$45.00',
      'rating': 4.7,
      'badge': 'Trending',
      'color': const Color(0xFF7C3AED),
    },
    {
      'title': 'Smart Watch',
      'shop': 'TechHub',
      'imageUrl': 'https://images.unsplash.com/photo-1546868871-704132a5d082?q=80&w=400',
      'price': '\$59.99',
      'oldPrice': '\$89.99',
      'rating': 4.6,
      'badge': 'Best',
      'color': const Color(0xFFE63E3E),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // ====== APP BAR ======
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE63E3E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.location_on_rounded, color: Color(0xFFE63E3E), size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Deliver to',
                        style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Mumbai',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE63E3E),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down_rounded, color: Color(0xFFE63E3E), size: 20),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Color(0xFF333333)),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF333333)),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search_rounded, color: Color(0xFF999999), size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search for products...',
                            hintStyle: TextStyle(color: Color(0xFF999999), fontSize: 14),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ====== BANNER CAROUSEL ======
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    CarouselSlider(
                      controller: _carouselController,
                      options: CarouselOptions(
                        height: 180,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 600),
                        pauseAutoPlayOnTouch: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentBannerIndex = index;
                          });
                        },
                      ),
                      items: banners.map((banner) {
                        return GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${banner['title']} Banner Tapped')),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  banner['color'],
                                  banner['color'].withOpacity(0.7),
                                ],
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: 0.3,
                                    child: Image.network(
                                      banner['image'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          banner['tag'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        banner['title'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        banner['subtitle'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          'Shop Now →',
                                          style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: banners.asMap().entries.map((entry) {
                          return Container(
                            width: _currentBannerIndex == entry.key ? 24 : 8,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: _currentBannerIndex == entry.key
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ====== CATEGORIES GRID ======
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 0.9,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeesoCategoryDetailScreen(
                            categoryName: cat['name'],
                            categoryColor: cat['color'],
                          ),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: cat['color'].withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            cat['icon'],
                            color: cat['color'],
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cat['name'],
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // ====== FLASH DEALS ======
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.flash_on_rounded, color: Color(0xFFE63E3E)),
                          SizedBox(width: 4),
                          Text(
                            'Flash Deals',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE63E3E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: flashDeals.length,
                      itemBuilder: (context, index) {
                        final deal = flashDeals[index];
                        return Container(
                          width: 120,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F8F8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                    child: Image.network(
                                      deal['image'],
                                      height: 80,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        height: 80,
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.image_not_supported_rounded),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    left: 4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE63E3E),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        deal['discount'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      deal['title'],
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF333333),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          deal['price'],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFE63E3E),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          deal['oldPrice'],
                                          style: const TextStyle(
                                            fontSize: 9,
                                            color: Color(0xFF999999),
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ====== TOP PICKS ======
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '🔥 Top Picks for You',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFFE63E3E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final product = topPicks[index];
                  return _buildProductCard(product);
                },
                childCount: topPicks.length,
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
            builder: (context) => MeesoProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      product['imageUrl'],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported_rounded, size: 40),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: product['color'],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product['badge'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
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
                        size: 16,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product['shop'],
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF999999),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        product['rating'].toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product['price'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE63E3E),
                        ),
                      ),
                      const SizedBox(width: 4),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ CATEGORY SCREEN ============
class MeesoCategoryScreen extends StatelessWidget {
  const MeesoCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Grocery', 'icon': Icons.local_grocery_store_rounded, 'color': const Color(0xFF10B981), 'count': '1,234'},
      {'name': 'Fashion', 'icon': Icons.checkroom_rounded, 'color': const Color(0xFF7C3AED), 'count': '2,456'},
      {'name': 'Electronics', 'icon': Icons.devices_other_rounded, 'color': const Color(0xFF2563EB), 'count': '3,789'},
      {'name': 'Pharmacy', 'icon': Icons.medical_services_rounded, 'color': const Color(0xFFE63E3E), 'count': '567'},
      {'name': 'Home & Living', 'icon': Icons.home_rounded, 'color': const Color(0xFFF59E0B), 'count': '1,890'},
      {'name': 'Beauty', 'icon': Icons.spa_rounded, 'color': const Color(0xFFEC4899), 'count': '234'},
      {'name': 'Books', 'icon': Icons.book_rounded, 'color': const Color(0xFF8B5CF6), 'count': '678'},
      {'name': 'Sports', 'icon': Icons.sports_rounded, 'color': const Color(0xFF14B8A6), 'count': '345'},
      {'name': 'Toys', 'icon': Icons.toys_rounded, 'color': const Color(0xFFF97316), 'count': '456'},
      {'name': 'Automotive', 'icon': Icons.car_repair_rounded, 'color': const Color(0xFF6366F1), 'count': '123'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeesoCategoryDetailScreen(
                    categoryName: cat['name'],
                    categoryColor: cat['color'],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cat['color'].withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      cat['icon'],
                      color: cat['color'],
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cat['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${cat['count']} items',
                    style: const TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============ CATEGORY DETAIL SCREEN ============
class MeesoCategoryDetailScreen extends StatelessWidget {
  final String categoryName;
  final Color categoryColor;

  const MeesoCategoryDetailScreen({
    super.key,
    required this.categoryName,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> products = [
      {
        'title': 'Premium Product 1',
        'imageUrl': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=400',
        'price': '\$29.99',
        'oldPrice': '\$49.99',
        'rating': 4.8,
        'badge': 'Hot',
      },
      {
        'title': 'Premium Product 2',
        'imageUrl': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?q=80&w=400',
        'price': '\$5.49',
        'oldPrice': '\$7.99',
        'rating': 4.9,
        'badge': 'Fresh',
      },
      {
        'title': 'Premium Product 3',
        'imageUrl': 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?q=80&w=400',
        'price': '\$34.00',
        'oldPrice': '\$45.00',
        'rating': 4.7,
        'badge': 'Trending',
      },
      {
        'title': 'Premium Product 4',
        'imageUrl': 'https://images.unsplash.com/photo-1546868871-704132a5d082?q=80&w=400',
        'price': '\$59.99',
        'oldPrice': '\$89.99',
        'rating': 4.6,
        'badge': 'Best',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          product['imageUrl'],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported_rounded, size: 40),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: categoryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            product['badge'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['title'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            product['rating'].toString(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            product['price'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE63E3E),
                            ),
                          ),
                          const SizedBox(width: 4),
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
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ============ WISHLIST SCREEN ============
class MeesoWishlistScreen extends StatelessWidget {
  const MeesoWishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> wishlistItems = [
      {
        'title': 'Premium Wireless Buds',
        'price': '\$29.99',
        'image': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=400',
        'color': const Color(0xFF2563EB),
      },
      {
        'title': 'Organic Avocado Pack',
        'price': '\$5.49',
        'image': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?q=80&w=400',
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Casual Hoodie',
        'price': '\$34.00',
        'image': 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?q=80&w=400',
        'color': const Color(0xFF7C3AED),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: wishlistItems.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border_rounded, size: 64, color: Color(0xFFCCCCCC)),
            SizedBox(height: 16),
            Text(
              'Your wishlist is empty',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Start adding items you love!',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: wishlistItems.length,
        itemBuilder: (context, index) {
          final item = wishlistItems[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item['image'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['price'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE63E3E),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite_rounded,
                    color: Color(0xFFE63E3E),
                    size: 24,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ============ PROFILE SCREEN ============
class MeesoProfileScreen extends StatelessWidget {
  const MeesoProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFFE63E3E),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE63E3E), Color(0xFFC62828)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person_rounded,
                          size: 50,
                          color: Color(0xFFE63E3E),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'John Doe',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'john.doe@email.com',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('Orders', '24'),
                      _buildStat('Wishlist', '18'),
                      _buildStat('Reviews', '12'),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.person_outline_rounded,
                        title: 'My Profile',
                        subtitle: 'Edit personal information',
                        color: const Color(0xFF2563EB),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.history_rounded,
                        title: 'Order History',
                        subtitle: 'View all your orders',
                        color: const Color(0xFF10B981),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.location_on_rounded,
                        title: 'Address Book',
                        subtitle: 'Manage delivery addresses',
                        color: const Color(0xFFF59E0B),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.payment_rounded,
                        title: 'Payment Methods',
                        subtitle: 'Manage cards & wallets',
                        color: const Color(0xFF7C3AED),
                      ),
                      _buildDivider(),
                      _buildMenuItem(
                        icon: Icons.help_rounded,
                        title: 'Help & Support',
                        subtitle: 'FAQ, contact & feedback',
                        color: const Color(0xFFEC4899),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        color: Color(0xFFE63E3E),
                        size: 24,
                      ),
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE63E3E),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF999999),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color(0xFF333333),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Color(0xFF999999),
          fontSize: 12,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: Color(0xFFCCCCCC),
      ),
      onTap: () {},
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 0,
      thickness: 0.5,
      color: Colors.grey[200],
      indent: 72,
    );
  }
}

// ============ PRODUCT DETAIL SCREEN ============
class MeesoProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const MeesoProductDetailScreen({super.key, required this.product});

  @override
  State<MeesoProductDetailScreen> createState() => _MeesoProductDetailScreenState();
}

class _MeesoProductDetailScreenState extends State<MeesoProductDetailScreen> {
  int _quantity = 1;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: Colors.white,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: _isFavorite ? const Color(0xFFE63E3E) : const Color(0xFF333333),
                  ),
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
                child: Image.network(
                  product['imageUrl'],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[100],
                    child: const Icon(
                      Icons.image_not_supported_rounded,
                      size: 80,
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE63E3E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product['badge'] ?? 'New',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            product['rating'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '(120 reviews)',
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product['title'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${product['shop']}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        product['price'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE63E3E),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product['oldPrice'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF999999),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE63E3E).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${((1 - double.parse(product['oldPrice'].replaceAll('\$', '')) / double.parse(product['price'].replaceAll('\$', ''))) * 100).toStringAsFixed(0)}% OFF',
                          style: const TextStyle(
                            color: Color(0xFFE63E3E),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This premium product is carefully selected and quality checked. Packed with high-grade materials to ensure best customer satisfaction and durability.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_quantity > 1) {
                          setState(() => _quantity--);
                        }
                      },
                      icon: const Icon(Icons.remove_rounded, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32),
                    ),
                    Text(
                      _quantity.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => _quantity++);
                      },
                      icon: const Icon(Icons.add_rounded, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added $_quantity item(s) to cart!'),
                        backgroundColor: const Color(0xFF10B981),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE63E3E),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFE63E3E).withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Color(0xFFE63E3E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}