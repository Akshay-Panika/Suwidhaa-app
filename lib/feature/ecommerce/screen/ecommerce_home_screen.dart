import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/app_color.dart';
import 'ecommerce_details_screen.dart';
import 'ecommerce_local_shop_screen.dart';

final List<Map<String, dynamic>> localStores = [
  {
    'id': 'store_1',
    'name': 'Fresh Mart Grocery',
    'category': 'Grocery',
    'image': 'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?q=80&w=400',
    'logo': 'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?q=80&w=200',
    'rating': 4.8,
    'reviews': 234,
    'distance': '0.5 km',
    'deliveryTime': '15-20 min',
    'minOrder': '₹5.00',
    'deliveryFee': '₹1.99',
    'isOpen': true,
    'tags': ['Fresh Produce', 'Organic', 'Local'],
    'featuredProducts': [
      {'name': 'Organic Apples', 'price': '₹3.99', 'unit': 'kg'},
      {'name': 'Fresh Milk', 'price': '₹2.49', 'unit': 'L'},
      {'name': 'Bread', 'price': '₹1.99', 'unit': 'loaf'},
    ],
    'address': '123 Main St, Mumbai',
    'phone': '+91 98765 43210',
  },
  {
    'id': 'store_2',
    'name': 'TechHub Electronics',
    'category': 'Electronics',
    'image': 'https://images.unsplash.com/photo-1498049794561-7780e1234567?q=80&w=400',
    'logo': 'https://images.unsplash.com/photo-1498049794561-7780e1234567?q=80&w=200',
    'rating': 4.9,
    'reviews': 567,
    'distance': '1.2 km',
    'deliveryTime': '30-45 min',
    'minOrder': '₹10.00',
    'deliveryFee': '₹2.99',
    'isOpen': true,
    'tags': ['Gadgets', 'Repair', 'Accessories'],
    'featuredProducts': [
      {'name': 'USB Cable', 'price': '₹5.99', 'unit': 'pc'},
      {'name': 'Phone Case', 'price': '₹12.99', 'unit': 'pc'},
      {'name': 'Screen Protector', 'price': '₹3.99', 'unit': 'pc'},
    ],
    'address': '456 Tech Park, Mumbai',
    'phone': '+91 98765 43211',
  },
  {
    'id': 'store_3',
    'name': 'Vogue Apparel',
    'category': 'Fashion',
    'image': 'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?q=80&w=400',
    'logo': 'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?q=80&w=200',
    'rating': 4.7,
    'reviews': 189,
    'distance': '2.0 km',
    'deliveryTime': '45-60 min',
    'minOrder': '₹15.00',
    'deliveryFee': '₹3.99',
    'isOpen': true,
    'tags': ['Trendy', 'Ethnic', 'Western'],
    'featuredProducts': [
      {'name': 'T-Shirt', 'price': '₹14.99', 'unit': 'pc'},
      {'name': 'Jeans', 'price': '₹29.99', 'unit': 'pc'},
      {'name': 'Dress', 'price': '₹24.99', 'unit': 'pc'},
    ],
    'address': '789 Fashion St, Mumbai',
    'phone': '+91 98765 43212',
  },
  {
    'id': 'store_4',
    'name': 'HealthPlus Pharmacy',
    'category': 'Pharmacy',
    'image': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=400',
    'logo': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=200',
    'rating': 4.9,
    'reviews': 345,
    'distance': '0.8 km',
    'deliveryTime': '20-30 min',
    'minOrder': '₹2.00',
    'deliveryFee': '₹0.99',
    'isOpen': true,
    'tags': ['Medicine', 'Health', 'Wellness'],
    'featuredProducts': [
      {'name': 'Vitamin C', 'price': '₹4.99', 'unit': 'bottle'},
      {'name': 'Pain Relief', 'price': '₹2.99', 'unit': 'strip'},
      {'name': 'Hand Sanitizer', 'price': '₹1.99', 'unit': 'bottle'},
    ],
    'address': '321 Health Ave, Mumbai',
    'phone': '+91 98765 43213',
  },
  {
    'id': 'store_5',
    'name': 'HomeStyle Decor',
    'category': 'Home',
    'image': 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=400',
    'logo': 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=200',
    'rating': 4.6,
    'reviews': 156,
    'distance': '3.5 km',
    'deliveryTime': '60-90 min',
    'minOrder': '₹20.00',
    'deliveryFee': '₹4.99',
    'isOpen': false,
    'tags': ['Furniture', 'Decor', 'Kitchen'],
    'featuredProducts': [
      {'name': 'Table Lamp', 'price': '₹19.99', 'unit': 'pc'},
      {'name': 'Wall Art', 'price': '₹24.99', 'unit': 'pc'},
      {'name': 'Cushion Set', 'price': '₹15.99', 'unit': 'set'},
    ],
    'address': '654 Home St, Mumbai',
    'phone': '+91 98765 43214',
  },
  {
    'id': 'store_6',
    'name': 'Green Garden Nursery',
    'category': 'Garden',
    'image': 'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?q=80&w=400',
    'logo': 'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?q=80&w=200',
    'rating': 4.8,
    'reviews': 98,
    'distance': '4.0 km',
    'deliveryTime': '60-90 min',
    'minOrder': '₹5.00',
    'deliveryFee': '₹2.99',
    'isOpen': true,
    'tags': ['Plants', 'Seeds', 'Tools'],
    'featuredProducts': [
      {'name': 'Rose Plant', 'price': '₹6.99', 'unit': 'pot'},
      {'name': 'Garden Soil', 'price': '₹4.99', 'unit': 'kg'},
      {'name': 'Watering Can', 'price': '₹8.99', 'unit': 'pc'},
    ],
    'address': '987 Garden Rd, Mumbai',
    'phone': '+91 98765 43215',
  },
];

class EcommerceHomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToCategory;
  final Function(String)? onNavigateToCategoryWithName;

  const EcommerceHomeScreen({
    super.key,
    this.onNavigateToCategory,
    this.onNavigateToCategoryWithName,
  });

  @override
  State<EcommerceHomeScreen> createState() => EcommerceHomeScreenState();
}

class EcommerceHomeScreenState extends State<EcommerceHomeScreen> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentBannerIndex = 0;

  // Store filter state
  String _selectedCategory = 'All';

  // Get unique categories for filter
  List<String> get categoriesList {
    Set<String> categories = {'All'};
    for (var store in localStores) {
      categories.add(store['category'] as String);
    }
    return categories.toList();
  }

  // Filter stores based on selected category
  List<Map<String, dynamic>> get filteredStores {
    if (_selectedCategory == 'All') {
      return localStores;
    }
    return localStores.where((store) =>
    store['category'] == _selectedCategory
    ).toList();
  }

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
    {'name': 'Books', 'icon': Icons.menu_book_rounded, 'color': const Color(0xFF8B5CF6)},
    {'name': 'Sports', 'icon': Icons.sports_soccer_rounded, 'color': const Color(0xFFEF4444)},
    {'name': 'Toys', 'icon': Icons.toys_rounded, 'color': const Color(0xFFF472B6)},
    {'name': 'Automotive', 'icon': Icons.car_repair_rounded, 'color': const Color(0xFF3B82F6)},
    {'name': 'Furniture', 'icon': Icons.chair_rounded, 'color': const Color(0xFFD97706)},
    {'name': 'All', 'icon': Icons.dashboard, 'color': const Color(0xFF34D399)},
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
      'price': '₹2,499',
      'oldPrice': '₹4,199',
      'rating': 4.8,
      'badge': 'Hot',
      'color': const Color(0xFF2563EB),
    },
    {
      'title': 'Organic Avocado Pack',
      'imageUrl': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?q=80&w=400',
      'shop': 'Fresh Mart',
      'price': '₹459',
      'oldPrice': '₹669',
      'rating': 4.9,
      'badge': 'Fresh',
      'color': const Color(0xFF10B981),
    },
    {
      'title': 'Casual Hoodie',
      'shop': 'Vogue Apparel',
      'imageUrl': 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?q=80&w=400',
      'price': '₹2,850',
      'oldPrice': '₹3,799',
      'rating': 4.7,
      'badge': 'Trending',
      'color': const Color(0xFF7C3AED),
    },
    {
      'title': 'Smart Watch',
      'shop': 'TechHub',
      'imageUrl': 'https://images.unsplash.com/photo-1546868871-704132a5d082?q=80&w=400',
      'price': '₹4,999',
      'oldPrice': '₹7,499',
      'rating': 4.6,
      'badge': 'Best',
      'color': const Color(0xFFE63E3E),
    },
    {
      'title': 'Italian Leather Bag',
      'imageUrl': 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?q=80&w=400',
      'shop': 'Luxury Lane',
      'price': '₹7,499',
      'oldPrice': '₹9,999',
      'rating': 4.9,
      'badge': 'Luxury',
      'color': const Color(0xFFD97706),
    },
    {
      'title': 'Stainless Steel Bottle',
      'imageUrl': 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?q=80&w=400',
      'shop': 'EcoLife',
      'price': '₹1,599',
      'oldPrice': '₹2,199',
      'rating': 4.5,
      'badge': 'Eco',
      'color': const Color(0xFF059669),
    },
    {
      'title': 'Gaming Mouse Pro',
      'imageUrl': 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?q=80&w=400',
      'shop': 'GameZone',
      'price': '₹3,799',
      'oldPrice': '₹5,499',
      'rating': 4.7,
      'badge': 'Gamer',
      'color': const Color(0xFFDC2626),
    },
    {
      'title': 'Scented Candle Set',
      'imageUrl': 'https://images.unsplash.com/photo-1602874801007-bd458bb1b8b6?q=80&w=400',
      'shop': 'Aroma Bliss',
      'price': '₹1,099',
      'oldPrice': '₹1,599',
      'rating': 4.4,
      'badge': 'Cozy',
      'color': const Color(0xFFF59E0B),
    },
    {
      'title': 'Fitness Tracker Band',
      'imageUrl': 'https://images.unsplash.com/photo-1575311373937-040b8e1fd6b6?q=80&w=400',
      'shop': 'FitLife',
      'price': '₹3,299',
      'oldPrice': '₹4,599',
      'rating': 4.3,
      'badge': 'Sport',
      'color': const Color(0xFFEF4444),
    },
    {
      'title': 'Wooden Phone Stand',
      'imageUrl': 'https://images.unsplash.com/photo-1586953208448-b95a79798f07?q=80&w=400',
      'shop': 'CraftWorks',
      'price': '₹1,349',
      'oldPrice': '₹1,899',
      'rating': 4.2,
      'badge': 'Handmade',
      'color': const Color(0xFFB45309),
    },
    {
      'title': 'Silk Pillowcase Pair',
      'imageUrl': 'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?q=80&w=400',
      'shop': 'SleepWell',
      'price': '₹2,299',
      'oldPrice': '₹3,349',
      'rating': 4.6,
      'badge': 'Luxury',
      'color': const Color(0xFF8B5CF6),
    },
    {
      'title': 'Mini Desktop Fan',
      'imageUrl': 'https://images.unsplash.com/photo-1589195318702-a65b2a36721c?q=80&w=400',
      'shop': 'CoolBreeze',
      'price': '₹1,849',
      'oldPrice': '₹2,499',
      'rating': 4.1,
      'badge': 'Summer',
      'color': const Color(0xFF06B6D4),
    },
    {
      'title': 'Vegan Leather Wallet',
      'imageUrl': 'https://images.unsplash.com/photo-1627123424574-724758594e93?q=80&w=400',
      'shop': 'EthicalWear',
      'price': '₹1,699',
      'oldPrice': '₹2,349',
      'rating': 4.5,
      'badge': 'Vegan',
      'color': const Color(0xFF16A34A),
    },
    {
      'title': 'Bluetooth Speaker Mini',
      'imageUrl': 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?q=80&w=400',
      'shop': 'AudioWave',
      'price': '₹2,999',
      'oldPrice': '₹4,199',
      'rating': 4.8,
      'badge': 'Sound',
      'color': const Color(0xFF7C3AED),
    },
    {
      'title': 'Plant Pot Set (3 pcs)',
      'imageUrl': 'https://images.unsplash.com/photo-1485955900006-10f4d324d411?q=80&w=400',
      'shop': 'GreenThumb',
      'price': '₹2,099',
      'oldPrice': '₹2,899',
      'rating': 4.3,
      'badge': 'Garden',
      'color': const Color(0xFF22C55E),
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
            foregroundColor: Colors.white,
            surfaceTintColor: Colors.white,
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
                        'Jabalpur MP',
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
              ],
            ),
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.dashboard,color: AppColors.primary,),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  spacing: 10,
                  children: [
                    Expanded(
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
                                readOnly: true,
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(onPressed: () => null, icon: Icon(Icons.favorite)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ====== BANNER CAROUSEL ======
          SliverToBoxAdapter(
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
                        width: double.infinity,
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

          // ====== CATEGORIES GRID ======
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                color: Colors.white,
                elevation: 0.3,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    childAspectRatio: 0.8,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: categories.length > 12 ? 12: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return InkWell(
                      onTap: () {
                        // Call the callback with the category name
                        widget.onNavigateToCategoryWithName?.call(cat['name']);
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
          ),

          // ====== FLASH DEALS ======
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                elevation: 0.3,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                                            child: Center(child: const Icon(Icons.image_not_supported_rounded)),
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
            ),
          ),

          // ====== TOP PICKS ======
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Column(
                children: [
                  Row(
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
                  SizedBox(height: 10,),
                  SizedBox(
                    height: 420,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.4,
                        ),
                        itemCount: topPicks.length,
                        itemBuilder: (context, index) {
                          final product = topPicks[index];
                          return _buildProductCard(product);
                        },),
                  )
                ],
              ),
            ),
          ),

          // ====== STICKY STORE CATEGORY FILTER ======
          SliverPersistentHeader(
            pinned: true,
            delegate: _StoreFilterDelegate(
              categories: categoriesList,
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              storeCount: filteredStores.length,
            ),
          ),

          // ====== STORE LIST SECTION ======
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
            sliver: SliverList.builder(
              itemCount: filteredStores.length,
              itemBuilder: (context, index) {
                final store = filteredStores[index];
                return _buildStoreListItem(store);
              },
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
                'title': product['title'],
                'imageUrl': product['imageUrl'],
                'shop': product['shop'],
                'price': product['price'],
                'oldPrice': product['oldPrice'],
                'badge': product['badge'],
                'rating': product['rating'],
                'reviews': product['reviews'] ?? 120,
                'color': product['color'],
                'description': product['description'] ?? 'This premium item is carefully selected and quality checked. Packed with high-grade materials to ensure best customer satisfaction and durability.',
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
                        child: Center(child: const Icon(Icons.image_not_supported_rounded, size: 40)),
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

  Widget _buildStoreListItem(Map<String, dynamic> store) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocalShopScreen(
              store: {
                'name': store['name'],
                'tags': store['tags']?.join(' • ') ?? 'Quality Products',
                'rating': store['rating'].toString(),
                'deliveryTime': store['deliveryTime'],
                'minOrder': store['minOrder'],
                'deliveryFee': store['deliveryFee'],
                'icon': Icons.storefront_rounded,
                'accent': const Color(0xFF10B981),
                'isOpen': store['isOpen'],
              },
            ),
          ),
        );
      },
      child: Container(
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
                store['image'],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.storefront_rounded, size: 40, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          store['name'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: store['isOpen'] ? const Color(0xFF10B981).withOpacity(0.1) : const Color(0xFFEF4444).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          store['isOpen'] ? 'Open' : 'Closed',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: store['isOpen'] ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        store['rating'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${store['reviews']} reviews)',
                        style: const TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        store['distance'],
                        style: const TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.timer_rounded, color: Color(0xFF999999), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        store['deliveryTime'],
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.local_shipping_rounded, color: Color(0xFF999999), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        store['deliveryFee'],
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Min: ${store['minOrder']}',
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 2,
                    children: (store['tags'] as List<String>).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE63E3E).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFFE63E3E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Color(0xFFCCCCCC),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreFilterDelegate extends SliverPersistentHeaderDelegate {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final int storeCount;

  _StoreFilterDelegate({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.storeCount,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12,12, 12, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.storefront_rounded, color: Color(0xFFE63E3E), size: 22),
                    SizedBox(width: 6),
                    Text(
                      'Local Stores',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                Text(
                  '$storeCount stores',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.white : const Color(0xFF333333),
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => onCategorySelected(category),
                    backgroundColor: const Color(0xFFF5F5F5),
                    selectedColor: const Color(0xFFE63E3E),
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFFE63E3E) : Colors.transparent,
                        width: 0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 90;

  @override
  double get minExtent => 90;

  @override
  bool shouldRebuild(_StoreFilterDelegate oldDelegate) {
    return selectedCategory != oldDelegate.selectedCategory ||
        categories != oldDelegate.categories ||
        storeCount != oldDelegate.storeCount;
  }
}