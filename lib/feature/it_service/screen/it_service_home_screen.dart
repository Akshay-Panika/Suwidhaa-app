// lib/screens/dashboard/it_service_home_screen.dart
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/app_color.dart';
import 'it_service_details_screen.dart';

final List<Map<String, dynamic>> serviceProviders = [
  {
    'id': 'provider_1',
    'name': 'CodeCraft Studios',
    'category': 'App Development',
    'image': 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?q=80&w=400',
    'logo': 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?q=80&w=200',
    'rating': 4.9,
    'reviews': 234,
    'distance': '0.5 km',
    'deliveryTime': '2-3 weeks',
    'minOrder': '₹50,000',
    'deliveryFee': '₹0',
    'isOpen': true,
    'tags': ['Flutter', 'React Native', 'iOS', 'Android'],
    'featuredProducts': [
      {'name': 'E-Commerce App', 'price': '₹1,50,000', 'unit': 'project'},
      {'name': 'Social Media App', 'price': '₹2,00,000', 'unit': 'project'},
      {'name': 'Custom App', 'price': '₹1,00,000', 'unit': 'project'},
    ],
    'address': '123 Tech Park, Mumbai',
    'phone': '+91 98765 43210',
  },
  {
    'id': 'provider_2',
    'name': 'WebWizards Inc',
    'category': 'Web Development',
    'image': 'https://images.unsplash.com/photo-1547658719-da2b51169166?q=80&w=400',
    'logo': 'https://images.unsplash.com/photo-1547658719-da2b51169166?q=80&w=200',
    'rating': 4.8,
    'reviews': 567,
    'distance': '1.2 km',
    'deliveryTime': '3-4 weeks',
    'minOrder': '₹40,000',
    'deliveryFee': '₹0',
    'isOpen': true,
    'tags': ['HTML', 'CSS', 'JavaScript', 'WordPress'],
    'featuredProducts': [
      {'name': 'Business Website', 'price': '₹80,000', 'unit': 'project'},
      {'name': 'E-Commerce Site', 'price': '₹1,50,000', 'unit': 'project'},
      {'name': 'Portfolio Website', 'price': '₹50,000', 'unit': 'project'},
    ],
    'address': '456 Web Avenue, Mumbai',
    'phone': '+91 98765 43211',
  },
  {
    'id': 'provider_3',
    'name': 'AppForge Solutions',
    'category': 'App Development',
    'image': 'https://images.unsplash.com/photo-1551650975-87deedd944c3?q=80&w=400',
    'logo': 'https://images.unsplash.com/photo-1551650975-87deedd944c3?q=80&w=200',
    'rating': 4.7,
    'reviews': 189,
    'distance': '2.0 km',
    'deliveryTime': '4-5 weeks',
    'minOrder': '₹60,000',
    'deliveryFee': '₹0',
    'isOpen': true,
    'tags': ['Kotlin', 'Swift', 'Flutter', 'Firebase'],
    'featuredProducts': [
      {'name': 'Gaming App', 'price': '₹2,50,000', 'unit': 'project'},
      {'name': 'Utility App', 'price': '₹1,20,000', 'unit': 'project'},
      {'name': 'Health App', 'price': '₹1,80,000', 'unit': 'project'},
    ],
    'address': '789 App Street, Mumbai',
    'phone': '+91 98765 43212',
  },
  {
    'id': 'provider_4',
    'name': 'RoboTech Innovations',
    'category': 'IoT & Robotics',
    'image': 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?q=80&w=400',
    'logo': 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?q=80&w=200',
    'rating': 4.9,
    'reviews': 345,
    'distance': '0.8 km',
    'deliveryTime': '6-8 weeks',
    'minOrder': '₹1,00,000',
    'deliveryFee': '₹0',
    'isOpen': true,
    'tags': ['Arduino', 'Raspberry Pi', 'Sensors', 'AI'],
    'featuredProducts': [
      {'name': 'Smart Home System', 'price': '₹2,00,000', 'unit': 'project'},
      {'name': 'Industrial Automation', 'price': '₹3,50,000', 'unit': 'project'},
      {'name': 'Robotics Kit', 'price': '₹1,50,000', 'unit': 'project'},
    ],
    'address': '321 Robotics Hub, Mumbai',
    'phone': '+91 98765 43213',
  },
  {
    'id': 'provider_5',
    'name': 'GameForge Studios',
    'category': 'Game Development',
    'image': 'https://images.unsplash.com/photo-1552820728-8b83bb6b773f?q=80&w=400',
    'logo': 'https://images.unsplash.com/photo-1552820728-8b83bb6b773f?q=80&w=200',
    'rating': 4.8,
    'reviews': 156,
    'distance': '3.5 km',
    'deliveryTime': '8-12 weeks',
    'minOrder': '₹1,50,000',
    'deliveryFee': '₹0',
    'isOpen': true,
    'tags': ['Unity', 'Unreal', '3D', '2D'],
    'featuredProducts': [
      {'name': 'Mobile Game', 'price': '₹2,50,000', 'unit': 'project'},
      {'name': 'PC Game', 'price': '₹4,00,000', 'unit': 'project'},
      {'name': 'AR/VR Game', 'price': '₹5,00,000', 'unit': 'project'},
    ],
    'address': '654 Game City, Mumbai',
    'phone': '+91 98765 43214',
  },
  {
    'id': 'provider_6',
    'name': 'WebApp Masters',
    'category': 'Web Application Development',
    'image': 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?q=80&w=400',
    'logo': 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?q=80&w=200',
    'rating': 4.6,
    'reviews': 98,
    'distance': '4.0 km',
    'deliveryTime': '4-6 weeks',
    'minOrder': '₹70,000',
    'deliveryFee': '₹0',
    'isOpen': true,
    'tags': ['React', 'Angular', 'Vue', 'Node.js'],
    'featuredProducts': [
      {'name': 'SaaS Platform', 'price': '₹2,00,000', 'unit': 'project'},
      {'name': 'Dashboard App', 'price': '₹1,20,000', 'unit': 'project'},
      {'name': 'API Development', 'price': '₹80,000', 'unit': 'project'},
    ],
    'address': '987 Web Park, Mumbai',
    'phone': '+91 98765 43215',
  },
];

class ItServiceHomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToCategory;
  final Function(String)? onNavigateToCategoryWithName;

  const ItServiceHomeScreen({
    super.key,
    this.onNavigateToCategory,
    this.onNavigateToCategoryWithName,
  });

  @override
  State<ItServiceHomeScreen> createState() => ItServiceHomeScreenState();
}

class ItServiceHomeScreenState extends State<ItServiceHomeScreen> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentBannerIndex = 0;
  String _selectedCategory = 'All';
  int _selectedServiceIndex = 0;

  List<String> get categoriesList {
    Set<String> categories = {'All'};
    for (var provider in serviceProviders) {
      categories.add(provider['category'] as String);
    }
    return categories.toList();
  }

  List<Map<String, dynamic>> get filteredProviders {
    if (_selectedCategory == 'All') {
      return serviceProviders;
    }
    return serviceProviders.where((provider) =>
    provider['category'] == _selectedCategory
    ).toList();
  }

  final List<Map<String, dynamic>> banners = [
    {
      'image': 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?q=80&w=600',
      'title': 'App Development',
      'subtitle': 'Build stunning mobile apps',
      'color': AppColors.itServices,
      'tag': '📱 Mobile Apps',
    },
    {
      'image': 'https://images.unsplash.com/photo-1547658719-da2b51169166?q=80&w=600',
      'title': 'Web Development',
      'subtitle': 'Create amazing websites',
      'color': AppColors.primary,
      'tag': '🌐 Web Solutions',
    },
    {
      'image': 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?q=80&w=600',
      'title': 'IoT & Robotics',
      'subtitle': 'Innovate with smart tech',
      'color': AppColors.accent,
      'tag': '🤖 Smart Technology',
    },
    {
      'image': 'https://images.unsplash.com/photo-1552820728-8b83bb6b773f?q=80&w=600',
      'title': 'Game Development',
      'subtitle': 'Create immersive games',
      'color': AppColors.school,
      'tag': '🎮 Gaming',
    },
  ];

  final List<Map<String, dynamic>> serviceCategories = [
    {'name': 'App Development', 'icon': Icons.mobile_friendly_rounded, 'color': AppColors.ecommerce},
    {'name': 'Web Development', 'icon': Icons.web_rounded, 'color': AppColors.primary},
    {'name': 'Web Application', 'icon': Icons.web_asset_rounded, 'color': AppColors.itServices},
    {'name': 'IoT & Robotics', 'icon': Icons.smart_toy_rounded, 'color': AppColors.ngo},
    {'name': 'Game Development', 'icon': Icons.sports_esports_rounded, 'color': AppColors.school},
    {'name': 'AI & ML', 'icon': Icons.psychology_rounded, 'color': AppColors.itServicesTint},
    {'name': 'Cloud Computing', 'icon': Icons.cloud_rounded, 'color': AppColors.primary},
    {'name': 'DevOps', 'icon': Icons.settings_rounded, 'color': AppColors.ecommerce},
    {'name': 'AR/VR', 'icon': Icons.view_in_ar_rounded, 'color': AppColors.ott},
    {'name': 'Blockchain', 'icon': Icons.link_rounded, 'color': AppColors.school},
    {'name': 'Cybersecurity', 'icon': Icons.security_rounded, 'color': AppColors.ngo},
    {'name': 'Data Science', 'icon': Icons.data_usage_rounded, 'color': AppColors.primary},
    {'name': 'All', 'icon': Icons.dashboard_rounded, 'color': AppColors.itServices},
  ];

  final List<Map<String, dynamic>> featuredProjects = [
    {
      'title': 'E-Commerce Mobile App',
      'imageUrl': 'https://images.unsplash.com/photo-1551650975-87deedd944c3?q=80&w=400',
      'provider': 'CodeCraft Studios',
      'price': '₹1,50,000',
      'oldPrice': '₹2,00,000',
      'rating': 4.9,
      'badge': 'Trending',
      'color': AppColors.ecommerce,
      'category': 'App Development',
    },
    {
      'title': 'Smart Home Automation',
      'imageUrl': 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?q=80&w=400',
      'provider': 'RoboTech Innovations',
      'price': '₹2,00,000',
      'oldPrice': '₹2,80,000',
      'rating': 4.8,
      'badge': 'IoT',
      'color': AppColors.ngo,
      'category': 'IoT & Robotics',
    },
    {
      'title': '3D Adventure Game',
      'imageUrl': 'https://images.unsplash.com/photo-1552820728-8b83bb6b773f?q=80&w=400',
      'provider': 'GameForge Studios',
      'price': '₹4,00,000',
      'oldPrice': '₹5,50,000',
      'rating': 4.7,
      'badge': 'Trending',
      'color': AppColors.school,
      'category': 'Game Development',
    },
    {
      'title': 'Corporate Website',
      'imageUrl': 'https://images.unsplash.com/photo-1547658719-da2b51169166?q=80&w=400',
      'provider': 'WebWizards Inc',
      'price': '₹80,000',
      'oldPrice': '₹1,20,000',
      'rating': 4.6,
      'badge': 'Popular',
      'color': AppColors.primary,
      'category': 'Web Development',
    },
    {
      'title': 'SaaS Dashboard',
      'imageUrl': 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?q=80&w=400',
      'provider': 'WebApp Masters',
      'price': '₹2,00,000',
      'oldPrice': '₹2,50,000',
      'rating': 4.8,
      'badge': 'New',
      'color': AppColors.itServices,
      'category': 'Web Application Development',
    },
    {
      'title': 'AR Shopping App',
      'imageUrl': 'https://images.unsplash.com/photo-1551650975-87deedd944c3?q=80&w=400',
      'provider': 'AppForge Solutions',
      'price': '₹2,50,000',
      'oldPrice': '₹3,20,000',
      'rating': 4.9,
      'badge': 'AR/VR',
      'color': AppColors.ott,
      'category': 'App Development',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ====== ENHANCED APP BAR ======
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.white,
            surfaceTintColor: AppColors.white,
            toolbarHeight: 70,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.itServices.withOpacity(0.1),
                        AppColors.itServices.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.itServices.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_rounded, color: AppColors.itServices, size: 18),
                      const SizedBox(width: 6),
                      const Text(
                        'Jabalpur, MP',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.itServices,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down_rounded, color: AppColors.itServices, size: 22),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary, size: 22),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                
              ],
            ),
            leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.dashboard, color: AppColors.itServices),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 22),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: 'Search IT services...',
                                  hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                                ),
                                style: TextStyle(fontSize: 14, color: AppColors.textMain),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(Icons.mic_rounded, color: AppColors.itServices, size: 22),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border_rounded, color: AppColors.textSecondary, size: 22),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ====== BANNER CAROUSEL ======
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CarouselSlider(
                      controller: _carouselController,
                      options: CarouselOptions(
                        height: 200,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 4),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
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
                            final category = banner['title'];
                            widget.onNavigateToCategoryWithName?.call(category);
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  banner['color'],
                                  banner['color'].withOpacity(0.7),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: 0.15,
                                    child: Image.network(
                                      banner['image'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: -20,
                                  top: -20,
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: AppColors.white.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -30,
                                  right: -10,
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: AppColors.white.withOpacity(0.08),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: AppColors.white.withOpacity(0.25),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          banner['tag'],
                                          style: const TextStyle(
                                            color: AppColors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        banner['title'],
                                        style: const TextStyle(
                                          color: AppColors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      Text(
                                        banner['subtitle'],
                                        style: const TextStyle(
                                          color: AppColors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(25),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.shadow,
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: const Text(
                                          'Explore →',
                                          style: TextStyle(
                                            color: AppColors.textMain,
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
                  ),
                  Positioned(
                    bottom: 14,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: banners.asMap().entries.map((entry) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _currentBannerIndex == entry.key ? 28 : 8,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: _currentBannerIndex == entry.key
                                ? AppColors.white
                                : AppColors.white.withOpacity(0.4),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),

          // ====== SERVICE CATEGORIES ======
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.grid_view_rounded, color: AppColors.itServices, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Services',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMain,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.itServices,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 0.8,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: serviceCategories.length,
                    itemBuilder: (context, index) {
                      final cat = serviceCategories[index];
                      final isAll = cat['name'] == 'All';
                      return InkWell(
                        onTap: () {
                          widget.onNavigateToCategoryWithName?.call(cat['name']);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.shadow,
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  cat['icon'],
                                  color: isAll ? AppColors.itServices : cat['color'],
                                  size: 26,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                cat['name'],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: isAll ? FontWeight.w700 : FontWeight.w500,
                                  color: isAll ? AppColors.itServices : AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),

          // ====== FEATURED PROJECTS ======
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.white,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            '🔥',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Featured Projects',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMain,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.itServices.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '6',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.itServices,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.itServices,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: featuredProjects.length,
                      itemBuilder: (context, index) {
                        final project = featuredProjects[index];
                        return _buildEnhancedProjectCard(project);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ====== TOP RATED PROVIDERS ======
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.verified_rounded, color: AppColors.itServices, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Top Rated Providers',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMain,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.itServices,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: serviceProviders.length,
                      itemBuilder: (context, index) {
                        final provider = serviceProviders[index];
                        return _buildProviderCard(provider);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedProjectCard(Map<String, dynamic> project) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItServiceDetailsScreen(
                project: project,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Stack(
                  children: [
                    Image.network(
                      project['imageUrl'],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.background,
                        child: const Center(
                          child: Icon(Icons.image_not_supported_rounded, size: 40, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [project['color'], project['color'].withOpacity(0.8)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          project['badge'],
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.textMain.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          project['category'],
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.textMain.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.school, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              project['rating'].toString(),
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project['title'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMain,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    project['provider'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        project['price'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.itServices,
                        ),
                      ),
                      Text(
                        project['oldPrice'],
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
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

  Widget _buildProviderCard(Map<String, dynamic> provider) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    provider['logo'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.background,
                      child: const Icon(Icons.business_rounded, size: 40, color: AppColors.textSecondary),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: provider['isOpen'] ? AppColors.success : AppColors.error,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      provider['isOpen'] ? 'Open' : 'Closed',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider['name'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMain,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.star_rounded, color: AppColors.school, size: 14),
                  const SizedBox(width: 2),
                  Text(
                    provider['rating'].toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${provider['reviews']})',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: (provider['tags'] as List).take(3).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 8,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          )
        ],
      ),
    );
  }
}