import 'package:flutter/material.dart';
import 'package:untitled/feature/ecommerce/screen/ecommerce_details_screen.dart';

class LocalShopScreen extends StatefulWidget {
  final Map<String, dynamic>? store;

  const LocalShopScreen({super.key, this.store});

  @override
  State<LocalShopScreen> createState() => _LocalShopScreenState();
}

class _LocalShopScreenState extends State<LocalShopScreen> {
  // Store items mock data mapped by store name
  final Map<String, List<Map<String, dynamic>>> shopProducts = {
    'Fresh Mart Groceries': [
      {
        'title': 'Organic Avocado Pack',
        'imageUrl': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?q=80&w=400',
        'shop': 'Fresh Mart Groceries',
        'price': '\$5.49',
        'oldPrice': '\$7.99',
        'badge': 'Fresh',
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Fresh Strawberries Pack',
        'imageUrl': 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?q=80&w=400',
        'shop': 'Fresh Mart Groceries',
        'price': '\$3.99',
        'oldPrice': '\$5.49',
        'badge': 'Top Seller',
        'color': const Color(0xFF10B981),
      }
    ],
    'Apex Digital Hub': [
      {
        'title': 'Premium Wireless Buds',
        'imageUrl': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=400',
        'shop': 'Apex Digital Hub',
        'price': '\$29.99',
        'oldPrice': '\$49.99',
        'badge': 'Hot Deal',
        'color': const Color(0xFF0EA5E9),
      },
      {
        'title': 'Smart Vitality Watch',
        'imageUrl': 'https://images.unsplash.com/photo-1546868871-704132a5d082?q=80&w=400',
        'shop': 'Apex Digital Hub',
        'price': '\$59.99',
        'oldPrice': '\$89.99',
        'badge': 'Best Seller',
        'color': const Color(0xFF0EA5E9),
      }
    ]
  };

  @override
  Widget build(BuildContext context) {
    // Navigated store fallback default data
    final storeData = widget.store ?? {
      'name': 'Fresh Mart Groceries',
      'tags': 'Organic • Daily Essentials',
      'rating': '4.8',
      'delivery': '15-25 min',
      'discount': 'FREE Delivery',
      'icon': Icons.storefront_rounded,
      'accent': const Color(0xFF10B981),
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
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                      onPressed: () {},
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [storeData['accent'], storeData['accent'].withOpacity(0.75)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -30,
                          bottom: -10,
                          child: Icon(storeData['icon'], size: 180, color: Colors.white.withOpacity(0.12)),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  storeData['discount'],
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                storeData['name'],
                                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                storeData['tags'],
                                style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13, fontWeight: FontWeight.w500),
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
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(storeData['rating'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text("Rating", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                        ],
                      ),
                      Container(height: 24, width: 1, color: const Color(0xFFE2E8F0)),
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time_filled_rounded, color: Color(0xFF64748B), size: 18),
                              const SizedBox(width: 4),
                              Text(storeData['delivery'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text("Delivery Time", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                        ],
                      ),
                      Container(height: 24, width: 1, color: const Color(0xFFE2E8F0)),
                      Column(
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.verified_user_rounded, color: Color(0xFF10B981), size: 18),
                              const SizedBox(width: 4),
                              Text("100%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text("Verified Shop", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
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
                    labelColor: const Color(0xFF1E293B),
                    unselectedLabelColor: const Color(0xFF94A3B8),
                    indicatorColor: storeData['accent'],
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 3,
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
              _buildProductGrid(context, products),
              _buildProductGrid(context, products.reversed.toList()),
            ],
          ),
        ),
      ),
    );
  }

  // Common Product Grid Builder
  Widget _buildProductGrid(BuildContext context, List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return const Center(child: Text("No products listed by this merchant yet"));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.76,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final product = items[index];
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EcommerceDetailsScreen(product: product)),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.grey.withOpacity(0.06)),
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
                                  Center(child: Icon(Icons.image_not_supported_outlined, size: 30, color: product['color'])),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                product['badge'],
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: product['color']),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product['shop'],
                    style: TextStyle(fontSize: 10, color: Colors.grey[400], fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product['price'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                          Text(
                            product['oldPrice'],
                            style: TextStyle(fontSize: 10, color: Colors.grey[400], decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Color(0xFF1E293B), shape: BoxShape.circle),
                        child: const Icon(Icons.add_rounded, color: Colors.white, size: 16),
                      )
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