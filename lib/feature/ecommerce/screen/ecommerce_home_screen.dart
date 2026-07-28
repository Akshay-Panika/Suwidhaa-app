import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:untitled/feature/ecommerce/screen/ecommerce_local_shop_screen.dart';
import 'package:untitled/feature/ecommerce/screen/ecommerce_details_screen.dart';
import 'package:untitled/feature/ecommerce/screen/ecommerce_category_screen.dart';

class EcommerceHomeScreen extends StatefulWidget {
  const EcommerceHomeScreen({super.key});

  @override
  State<EcommerceHomeScreen> createState() => _EcommerceHomeScreenState();
}

class _EcommerceHomeScreenState extends State<EcommerceHomeScreen> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  bool _isCollapsed = false;
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Banner carousel controller
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      bool collapsed = _scrollController.offset > 100;
      if (collapsed != _isCollapsed) {
        setState(() {
          _isCollapsed = collapsed;
        });
      }
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Realistic Mock Categories
    final List<Map<String, dynamic>> categories = [
      {'name': 'Groceries', 'icon': Icons.local_grocery_store_outlined, 'color': const Color(0xFF10B981)},
      {'name': 'Fashion', 'icon': Icons.checkroom_rounded, 'color': const Color(0xFF6366F1)},
      {'name': 'Electronics', 'icon': Icons.devices_other_rounded, 'color': const Color(0xFF0EA5E9)},
      {'name': 'Pharmacy', 'icon': Icons.medical_services_outlined, 'color': const Color(0xFFF43F5E)},
    ];

    // Realistic Mock Top Rated Local Stores
    final List<Map<String, dynamic>> premiumStores = [
      {
        'name': 'Fresh Mart Groceries',
        'tags': 'Organic • Daily Essentials',
        'rating': '4.8',
        'delivery': '15-25 min',
        'discount': 'FREE Delivery',
        'icon': Icons.storefront_rounded,
        'accent': const Color(0xFF10B981),
      },
      {
        'name': 'Apex Digital Hub',
        'tags': 'Gadgets • Accessories',
        'rating': '4.9',
        'delivery': '30-45 min',
        'discount': '10% OFF tech',
        'icon': Icons.electric_car_outlined,
        'accent': const Color(0xFF0EA5E9),
      },
    ];

    // Realistic Trending Products Data
    final List<Map<String, dynamic>> trendingProducts = [
      {
        'title': 'Premium Wireless Buds',
        'imageUrl': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=400',
        'shop': 'Apex Digital Hub',
        'price': '\$29.99',
        'oldPrice': '\$49.99',
        'badge': 'Hot Deal',
        'color': const Color(0xFFF59E0B),
        'icon': Icons.headphones_rounded,
      },
      {
        'title': 'Organic Avocado Pack',
        'imageUrl': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?q=80&w=400',
        'shop': 'Fresh Mart Groceries',
        'price': '\$5.49',
        'oldPrice': '\$7.99',
        'badge': 'Fresh',
        'color': const Color(0xFF10B981),
        'icon': Icons.agriculture_rounded,
      },
      {
        'title': 'Casual Comfort Hoodie',
        'shop': 'Vogue Apparel',
        'imageUrl': 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?q=80&w=400',
        'price': '\$34.00',
        'oldPrice': '\$45.00',
        'badge': 'Trending',
        'color': const Color(0xFF6366F1),
        'icon': Icons.checkroom_rounded,
      },
      {
        'title': 'Smart Vitality Watch',
        'shop': 'Apex Digital Hub',
        'imageUrl': 'https://images.unsplash.com/photo-1546868871-704132a5d082?q=80&w=400',
        'price': '\$59.99',
        'oldPrice': '\$89.99',
        'badge': 'Best Seller',
        'color': const Color(0xFF0EA5E9),
        'icon': Icons.watch_rounded,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildBody(categories, premiumStores, trendingProducts),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF6366F1),
          unselectedItemColor: const Color(0xFF64748B),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
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
              icon: Icon(Icons.favorite_rounded),
              activeIcon: Icon(Icons.favorite_rounded),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
      List<Map<String, dynamic>> categories,
      List<Map<String, dynamic>> premiumStores,
      List<Map<String, dynamic>> trendingProducts,
      ) {
    switch (_selectedIndex) {
      case 1:
        return _buildCategoriesTab(categories);
      case 2:
        return _buildWishlistTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildHomeTab(categories, premiumStores, trendingProducts);
    }
  }

  // ==================== BANNER CAROUSEL METHOD ====================
  Widget _buildBannerCarousel() {
    final List<Map<String, dynamic>> banners = [
      {
        'image': 'https://images.unsplash.com/photo-1607082350899-7e105aa886ae?q=80&w=400',
        'title': 'Fresh Groceries',
        'subtitle': 'Up to 40% off on organic items',
        'color': const Color(0xFF10B981),
        'tag': '⚡ Special Offer',
      },
      {
        'image': 'https://images.unsplash.com/photo-1607083206968-1366d8b9f4a1?q=80&w=400',
        'title': 'Electronics Sale',
        'subtitle': 'Best deals on gadgets & accessories',
        'color': const Color(0xFF0EA5E9),
        'tag': '🔥 Hot Deals',
      },
      {
        'image': 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=400',
        'title': 'Fashion Week',
        'subtitle': 'New arrivals at amazing prices',
        'color': const Color(0xFF6366F1),
        'tag': '👗 New Collection',
      },
      {
        'image': 'https://images.unsplash.com/photo-1607082350899-7e105aa886ae?q=80&w=400',
        'title': 'Pharmacy Care',
        'subtitle': 'Essential medicines at your doorstep',
        'color': const Color(0xFFF43F5E),
        'tag': '💊 Health First',
      },
    ];

    return Stack(
      children: [
        CarouselSlider(
          controller: _carouselController,
          options: CarouselOptions(
            height: 330,
            viewportFraction: 1.0,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOut,
            pauseAutoPlayOnTouch: true,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
          ),
          items: banners.map((banner) {
            return GestureDetector(
              onTap: () {
                // Handle banner tap
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Banner tapped: ${banner['title']}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (banner['color'] as Color).withOpacity(0.9),
                      (banner['color'] as Color).withOpacity(0.7),
                    ],
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image with error handling
                    Image.network(
                      banner['image'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: (banner['color'] as Color).withOpacity(0.3),
                          child: Icon(
                            Icons.image_not_supported_rounded,
                            color: (banner['color'] as Color),
                            size: 60,
                          ),
                        );
                      },
                    ),
                    // Dark overlay for text readability
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              banner['tag'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            banner['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            banner['subtitle'] as String,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                const Shadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Text(
                              'Shop Now →',
                              style: TextStyle(
                                color: Color(0xFF1E293B),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
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
        // Custom indicator dots
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: banners.asMap().entries.map((entry) {
                  return Container(
                    width: _currentBannerIndex == entry.key ? 20 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _currentBannerIndex == entry.key
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        // Navigation arrows (optional)
        Positioned(
          left: 8,
          top: 0,
          bottom: 0,
          child: Center(
            child: GestureDetector(
              onTap: () {
                _carouselController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 8,
          top: 0,
          bottom: 0,
          child: Center(
            child: GestureDetector(
              onTap: () {
                _carouselController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==================== HOME TAB ====================
  Widget _buildHomeTab(
      List<Map<String, dynamic>> categories,
      List<Map<String, dynamic>> premiumStores,
      List<Map<String, dynamic>> trendingProducts,
      ) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 330,
          toolbarHeight: 70,
          backgroundColor: _isCollapsed ? Colors.white : Colors.white.withOpacity(0.0),
          leading: Center(
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: _isCollapsed ? Colors.black : Colors.white,
                  size: 18,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          title: Text(
            'Suwidhaa Marketplace',
            style: TextStyle(
              color: _isCollapsed ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: _isCollapsed ? Colors.black : Colors.white,
                ),
                onPressed: () {},
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search_rounded, color: Color(0xFF6366F1)),
                    hintText: 'Search items, stores or brands...',
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: _buildBannerCarousel(),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Browse Categories',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6366F1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EcommerceCategoryScreen(initialIndex: index),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            width: 85,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        cat['color'].withOpacity(0.1),
                                        cat['color'].withOpacity(0.2),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(cat['icon'], color: cat['color'], size: 26),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  cat['name'],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF475569),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Rated Local Shops',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6366F1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: premiumStores.length,
                  itemBuilder: (context, index) {
                    final store = premiumStores[index];
                    return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(30 * (1 - value), 0),
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocalShopScreen(store: store),
                          ),
                        ),
                        child: Container(
                          width: 260,
                          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: (store['accent'] as Color).withOpacity(0.15),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: (store['accent'] as Color).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  store['icon'] as IconData,
                                  color: store['accent'] as Color,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      store['name'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Color(0xFF1E293B),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      store['tags'] as String,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star_rounded,
                                          color: Colors.amber,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          store['rating'] as String,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: (store['accent'] as Color)
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            store['delivery'] as String,
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: store['accent'] as Color,
                                              fontWeight: FontWeight.w600,
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trending Near You',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6366F1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.76,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final product = trendingProducts[index];
                return TweenAnimationBuilder(
                  duration: Duration(milliseconds: 300 + (index * 50)),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EcommerceDetailsScreen(
                          product: product,
                        ),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.grey.withOpacity(0.06)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.04),
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
                                  color: (product['color'] as Color).withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        product['imageUrl'] as String,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Center(
                                            child: Icon(
                                              product['icon'] as IconData,
                                              size: 40,
                                              color: product['color'] as Color,
                                            ),
                                          );
                                        },
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
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.04),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          product['badge'] as String,
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: product['color'] as Color,
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
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              product['title'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF1E293B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              product['shop'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['price'] as String,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    Text(
                                      product['oldPrice'] as String,
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
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF6366F1), Color(0xFF4338CA)],
                                    ),
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
                  ),
                );
              },
              childCount: trendingProducts.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  // Categories Tab
  Widget _buildCategoriesTab(List<Map<String, dynamic>> categories) {
    final allCategories = [
      ...categories,
      {'name': 'Books', 'icon': Icons.book_rounded, 'color': const Color(0xFF8B5CF6)},
      {'name': 'Home', 'icon': Icons.home_rounded, 'color': const Color(0xFFF59E0B)},
      {'name': 'Beauty', 'icon': Icons.spa_rounded, 'color': const Color(0xFFEC4899)},
      {'name': 'Sports', 'icon': Icons.sports_rounded, 'color': const Color(0xFF14B8A6)},
      {'name': 'Toys', 'icon': Icons.toys_rounded, 'color': const Color(0xFFF97316)},
      {'name': 'Automotive', 'icon': Icons.car_repair_rounded, 'color': const Color(0xFF8B5CF6)},
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'All Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${allCategories.length} categories',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6366F1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: allCategories.length,
                itemBuilder: (context, index) {
                  final category = allCategories[index];
                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EcommerceCategoryScreen(
                              initialIndex: index % categories.length,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: (category['color'] as Color).withOpacity(0.1),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (category['color'] as Color).withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    (category['color'] as Color).withOpacity(0.1),
                                    (category['color'] as Color).withOpacity(0.2),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                category['icon'] as IconData,
                                color: category['color'] as Color,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              category['name'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Wishlist Tab
  Widget _buildWishlistTab() {
    final wishlistItems = [
      {'name': 'Premium Wireless Buds', 'price': '\$29.99', 'image': Icons.headphones_rounded, 'color': const Color(0xFFF59E0B)},
      {'name': 'Smart Vitality Watch', 'price': '\$59.99', 'image': Icons.watch_rounded, 'color': const Color(0xFF0EA5E9)},
      {'name': 'Organic Avocado Pack', 'price': '\$5.49', 'image': Icons.agriculture_rounded, 'color': const Color(0xFF10B981)},
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Wishlist',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Items you have saved for later',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: wishlistItems.length,
                itemBuilder: (context, index) {
                  final item = wishlistItems[index];
                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(20 * (1 - value), 0),
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: (item['color'] as Color).withOpacity(0.1),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: (item['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              item['image'] as IconData,
                              color: item['color'] as Color,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                Text(
                                  item['price'] as String,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6366F1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.favorite_rounded,
                              color: Colors.red.shade400,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Profile Tab
  Widget _buildProfileTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF4338CA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person_rounded,
                          size: 50,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
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
                  const SizedBox(height: 4),
                  Text(
                    'john.doe@email.com',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildProfileStat('Orders', '24'),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      _buildProfileStat('Wishlist', '18'),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      _buildProfileStat('Reviews', '12'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileMenuItem(
              icon: Icons.person_outline_rounded,
              title: 'My Profile',
              subtitle: 'Edit personal information',
              color: const Color(0xFF6366F1),
            ),
            _buildProfileMenuItem(
              icon: Icons.history_rounded,
              title: 'Order History',
              subtitle: 'View all your orders',
              color: const Color(0xFF0EA5E9),
            ),
            _buildProfileMenuItem(
              icon: Icons.location_on_rounded,
              title: 'Address Book',
              subtitle: 'Manage delivery addresses',
              color: const Color(0xFF10B981),
            ),
            _buildProfileMenuItem(
              icon: Icons.payment_rounded,
              title: 'Payment Methods',
              subtitle: 'Manage cards & wallets',
              color: const Color(0xFF8B5CF6),
            ),
            _buildProfileMenuItem(
              icon: Icons.help_rounded,
              title: 'Help & Support',
              subtitle: 'FAQ, contact & feedback',
              color: const Color(0xFFF59E0B),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red.shade300, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      color: Colors.red.shade400,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.2)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Color(0xFF1E293B),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: Color(0xFF64748B),
          ),
        ),
        onTap: () {},
      ),
    );
  }
}