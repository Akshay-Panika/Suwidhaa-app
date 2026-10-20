import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../../../core/utils/app_color.dart';
import '../../category/widget/ecommerce_category_widget.dart';
import '../../product/screen/ecommerce_product_details_screen.dart';
import '../../product/screen/ecommerce_product_favorite_screen.dart';
import '../../product/screen/ecommerce_product_screen.dart';
import '../../search/screen/ecommerce_search_screen.dart';
import '../../store/screen/ecommerce_local_shop_screen.dart';
import '../widget/all_picks_widget.dart';
import '../widget/ecommerce_banner_widget.dart';
import '../widget/flash_deals_widget.dart';
import '../widget/top_picks_widget.dart';

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
                        child: Row(
                          children: [
                            Icon(Icons.search_rounded, color: Color(0xFF999999), size: 20),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                readOnly: true,
                                onTap: () {
                                  Get.to(() => EcommerceSearchScreen(
                                  ));
                                },
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
                      child: IconButton(onPressed: (){
                        Get.to(() => EcommerceProductFavoriteScreen(
                        ));
                      }, icon: Icon(Icons.favorite)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ====== BANNER CAROUSEL ======
          SliverToBoxAdapter(
            child: EcommerceBannerWidget(),
          ),

          // ====== CATEGORIES GRID ======
          SliverToBoxAdapter(
            child: EcommerceCategoryWidget(onNavigateToCategoryWithName: widget.onNavigateToCategoryWithName,),
          ),

          // ====== FLASH DEALS ======
          SliverToBoxAdapter(
            child: FlashDealsWidget(),
          ),

          // ====== TOP PICKS ======
          SliverToBoxAdapter(
            child: TopPicksWidget(),
          ),
          SliverToBoxAdapter(
            child: AllPicksWidget(),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 50,),)

        ],
      ),
    );
  }
}