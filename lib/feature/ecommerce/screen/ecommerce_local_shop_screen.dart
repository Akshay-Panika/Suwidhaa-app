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
        'price': '₹449',
        'oldPrice': '₹649',
        'badge': 'Fresh',
        'rating': 4.9,
        'reviews': 89,
        'color': const Color(0xFF10B981),
        'description': 'Fresh organic avocados sourced directly from farms.',
      },
      {
        'title': 'Fresh Strawberries Pack',
        'imageUrl': 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?q=80&w=400',
        'shop': 'Fresh Mart Grocery',
        'price': '₹349',
        'oldPrice': '₹499',
        'badge': 'Top Seller',
        'rating': 4.8,
        'reviews': 67,
        'color': const Color(0xFF10B981),
        'description': 'Fresh organic strawberries packed with vitamins.',
      },
      {
        'title': 'Organic Apples',
        'imageUrl': 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?q=80&w=400',
        'shop': 'Fresh Mart Grocery',
        'price': '₹299',
        'oldPrice': '₹499',
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
        'price': '₹199',
        'oldPrice': '₹299',
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
        'price': '₹2,499',
        'oldPrice': '₹3,999',
        'badge': 'Hot Deal',
        'rating': 4.8,
        'reviews': 120,
        'color': const Color(0xFF3B82F6),
        'description': 'Premium wireless earbuds with noise cancellation.',
      },
      {
        'title': 'Smart Vitality Watch',
        'imageUrl': 'https://images.unsplash.com/photo-1546868871-704132a5d082?q=80&w=400',
        'shop': 'TechHub Electronics',
        'price': '₹4,999',
        'oldPrice': '₹7,999',
        'badge': 'Best Seller',
        'rating': 4.7,
        'reviews': 95,
        'color': const Color(0xFF3B82F6),
        'description': 'Advanced smart watch with fitness tracking.',
      },
      {
        'title': 'USB-C Cable',
        'imageUrl': 'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?q=80&w=400',
        'shop': 'TechHub Electronics',
        'price': '₹499',
        'oldPrice': '₹799',
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
        'price': '₹2,899',
        'oldPrice': '₹3,799',
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
        'price': '₹3,299',
        'oldPrice': '₹4,299',
        'badge': 'Premium',
        'rating': 4.6,
        'reviews': 43,
        'color': const Color(0xFF7C3AED),
        'description': 'High-quality denim jeans with perfect fit.',
      },
      {
        'title': 'Summer Dress',
        'imageUrl': 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?q=80&w=400',
        'shop': 'Vogue Apparel',
        'price': '₹1,999',
        'oldPrice': '₹2,899',
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
        'price': '₹999',
        'oldPrice': '₹1,299',
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
        'price': '₹699',
        'oldPrice': '₹999',
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
        'price': '₹1,599',
        'oldPrice': '₹2,499',
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
        'price': '₹1,999',
        'oldPrice': '₹2,899',
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
        'price': '₹549',
        'oldPrice': '₹799',
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
        'price': '₹1,999',
        'oldPrice': '₹2,899',
        'badge': 'Kit',
        'rating': 4.7,
        'reviews': 34,
        'color': const Color(0xFF22C55E),
        'description': 'Complete garden tools set for all your gardening needs.',
      },
    ],
  };

  // Banner images for each store
  final Map<String, String> storeBanners = {
    'Fresh Mart Grocery': 'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=800',
    'TechHub Electronics': 'https://images.unsplash.com/photo-1498049794561-7780e7231661?q=80&w=800',
    'Vogue Apparel': 'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?q=80&w=800',
    'HealthPlus Pharmacy': 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?q=80&w=800',
    'HomeStyle Decor': 'https://images.unsplash.com/photo-1618220179428-22790b461013?q=80&w=800',
    'Green Garden Nursery': 'https://images.unsplash.com/photo-1466692476868-aef1dfb1e735?q=80&w=800',
  };

  // Gallery images for each store
  final Map<String, List<String>> storeGalleries = {
    'Fresh Mart Grocery': [
      'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=400',
      'https://images.unsplash.com/photo-1558618666-fcd25c85f1c6?q=80&w=400',
      'https://images.unsplash.com/photo-1509440159596-0249088772ff?q=80&w=400',
      'https://images.unsplash.com/photo-1556906781-9a412961c28c?q=80&w=400',
      'https://images.unsplash.com/photo-1556911220-bff31c812dba?q=80&w=400',
    ],
    'TechHub Electronics': [
      'https://images.unsplash.com/photo-1498049794561-7780e7231661?q=80&w=400',
      'https://images.unsplash.com/photo-1550009158-9ebf69173e03?q=80&w=400',
      'https://images.unsplash.com/photo-1550745165-9bc0b252726f?q=80&w=400',
      'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?q=80&w=400',
    ],
    'Vogue Apparel': [
      'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?q=80&w=400',
      'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?q=80&w=400',
      'https://images.unsplash.com/photo-1532453288672-3a27e9be9efd?q=80&w=400',
      'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=400',
    ],
    'HealthPlus Pharmacy': [
      'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?q=80&w=400',
      'https://images.unsplash.com/photo-1579165466741-7f35e4755660?q=80&w=400',
      'https://images.unsplash.com/photo-1631549916768-4119b2e5f926?q=80&w=400',
      'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=400',
    ],
    'HomeStyle Decor': [
      'https://images.unsplash.com/photo-1618220179428-22790b461013?q=80&w=400',
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=400',
      'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?q=80&w=400',
      'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?q=80&w=400',
    ],
    'Green Garden Nursery': [
      'https://images.unsplash.com/photo-1466692476868-aef1dfb1e735?q=80&w=400',
      'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?q=80&w=400',
      'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?q=80&w=400',
      'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=400',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final storeData = widget.store ?? {
      'name': 'Fresh Mart Grocery',
      'tags': 'Organic • Daily Essentials',
      'rating': '4.8',
      'deliveryTime': '15-25 min',
      'minOrder': '₹199',
      'deliveryFee': '₹39',
      'icon': Icons.storefront_rounded,
      'accent': const Color(0xFF10B981),
      'isOpen': true,
      'banner': storeBanners['Fresh Mart Grocery'],
    };

    final products = shopProducts[storeData['name']] ?? [];
    final galleryImages = storeGalleries[storeData['name']] ?? [];
    final bannerImage = storeBanners[storeData['name']] ?? storeData['banner'];

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            storeData['name'],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border_rounded, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Store Banner
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    // Banner Image
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(bannerImage ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.4),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Store Info Overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    storeData['icon'] ?? Icons.storefront_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        storeData['name'] ?? 'Store Name',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      if (storeData['tags'] != null)
                                        Text(
                                          storeData['tags'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white.withOpacity(0.8),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (storeData['isOpen'] ?? true)
                                        ? Colors.green.withOpacity(0.8)
                                        : Colors.red.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        (storeData['isOpen'] ?? true) ? 'Open' : 'Closed',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Store Info Card
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bio
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                storeData['bio'] ?? 'Your trusted local store for quality products.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Contact Info
                      Row(
                        children: [
                          _buildContactItem(
                            icon: Icons.phone_rounded,
                            text: storeData['phone'] ?? '+91 98765 43210',
                            accentColor: storeData['accent'] ?? const Color(0xFF10B981),
                          ),
                          const SizedBox(width: 8),
                          _buildContactItem(
                            icon:Icons.location_on_rounded,
                            text:storeData['address'] ?? '123 Main St',
                            accentColor: storeData['accent'] ?? const Color(0xFF10B981),
                          ),
                          const SizedBox(width: 8),
                          _buildContactItem(
                            icon: Icons.access_time_rounded,
                            text:storeData['timing'] ?? '9AM - 9PM',
                            accentColor: storeData['accent'] ?? const Color(0xFF10B981),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: storeData['accent'] ?? const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: const Text('Chat', style: TextStyle(fontSize: 13)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: storeData['accent'] ?? const Color(0xFF10B981),
                                side: BorderSide(
                                  color: (storeData['accent'] ?? const Color(0xFF10B981)).withOpacity(0.3),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Call', style: TextStyle(fontSize: 13)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: storeData['accent'] ?? const Color(0xFF10B981),
                                side: BorderSide(
                                  color: (storeData['accent'] ?? const Color(0xFF10B981)).withOpacity(0.3),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Direction', style: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 8),
              ),

              // TABS
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: storeData['accent'] ?? const Color(0xFF10B981),
                    unselectedLabelColor: Colors.grey[600],
                    indicatorColor: storeData['accent'] ?? const Color(0xFF10B981),
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
                      Tab(text: 'All Products'),
                      Tab(text: 'Popular'),
                      Tab(text: 'Offers'),
                      Tab(text: 'Gallery'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildProductGrid(context, products),
              _buildProductGrid(
                context,
                products.where((p) =>
                p['badge'] == 'Best Seller' ||
                    p['badge'] == 'Trending' ||
                    p['badge'] == 'Popular'
                ).toList(),
              ),
              _buildProductGrid(
                context,
                products.where((p) =>
                p['oldPrice'] != null && p['oldPrice'] != ''
                ).toList(),
              ),
              _buildGalleryGrid(context, galleryImages),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String text,
    required Color accentColor,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 14, color: accentColor),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Gallery Grid View
  Widget _buildGalleryGrid(BuildContext context, List<String> galleryImages) {
    if (galleryImages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              "No gallery images",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
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
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: galleryImages.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _showFullScreenImage(context, galleryImages, index);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                galleryImages[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // Full Screen Image Viewer
  void _showFullScreenImage(BuildContext context, List<String> images, int initialIndex) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Container(
              color: Colors.black.withOpacity(0.9),
              child: PageView.builder(
                controller: PageController(initialPage: initialIndex),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: InteractiveViewer(
                      panEnabled: true,
                      scaleEnabled: true,
                      minScale: 0.5,
                      maxScale: 3.0,
                      child: Image.network(
                        images[index],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.broken_image,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${initialIndex + 1} / ${images.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Product Grid Builder
  Widget _buildProductGrid(BuildContext context, List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              "No products found",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
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
        childAspectRatio: 0.9,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final product = items[index];
        return _buildProductCard(product);
      },
    );
  }

  // Product Card
  Widget _buildProductCard(Map<String, dynamic> product) {
    return InkWell(
      onTap: () {
        Navigator.push(
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
                'description': product['description'] ?? 'This premium item is carefully selected.',
              },
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
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
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
                  // Badge
                  if (product['badge'] != null && product['badge'].isNotEmpty)
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
                  // Favorite Button
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
            // Product Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
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
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        (product['rating'] ?? 4.8).toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product['price'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE63E3E),
                        ),
                      ),
                      if (product['oldPrice'] != null && product['oldPrice'].isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            product['oldPrice'],
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF999999),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'In Stock',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
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
      color: const Color(0xFFF5F6FA),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}