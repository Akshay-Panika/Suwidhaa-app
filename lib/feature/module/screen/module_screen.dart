// lib/feature/module/screen/module_screen.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_color.dart';
import '../../collage/screen/collage_dashboard_screen.dart';
import '../../ecommerce/screen/ecommerce_dashboard_screen.dart';
import '../../it_service/screen/it_services_dashboard_screen.dart';
import '../../ngo/screen/ngo_dashboard_screen.dart';
import '../../ott_platform/screen/ott_platform_dashboard_screen.dart';
import '../../school/auth/screen/school_auth_screen.dart';
import '../../school/dashboard/screen/school_student_dashboard_screen.dart';
import '../../school/dashboard/screen/school_teacher_dashboard_screen.dart';
import '../../school/auth/controller/school_auth_controller.dart';

class ModuleScreen extends StatefulWidget {
  const ModuleScreen({super.key});

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen>
    with SingleTickerProviderStateMixin {
  int _currentBannerIndex = 0;
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, String>> bannerItems = [
    {
      'tag': '⚡ MULTI-SERVICE HUB',
      'title': 'All Local Services & Needs\nRight Inside One App',
      'action': 'Explore Now',
      'icon': '🏪',
      'bgColor': '#EEF2FF',
    },
    {
      'tag': '🛍️ FESTIVE DELIGHTS',
      'title': 'Get Amazing Discounts Across\nAll Our Verified Digital Channels',
      'action': 'Check Offers',
      'icon': '🎉',
      'bgColor': '#FFF7ED',
    },
    {
      'tag': '🚀 PREMIUM SERVICES',
      'title': 'Unlock Exclusive Benefits\nWith Suwidhaa Premium',
      'action': 'Upgrade Now',
      'icon': '⭐',
      'bgColor': '#F3E8FF',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Function to handle School Portal navigation
  void _navigateToSchool() {
    // Get the controller instance
    final authController = Get.find<SchoolAuthController>();

    // Check if user is logged in
    if (authController.isLoggedIn.value) {
      // If logged in, navigate to dashboard based on user type
      if (authController.userType.value == 'student') {
        Get.to(() => const SchoolStudentDashboardScreen());
      } else {
        Get.to(() => const SchoolTeacherDashboardScreen());
      }
    } else {
      // If not logged in, navigate to login screen
      Get.to(() => const SchoolAuthScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> primaryServices = [
      {
        'title': 'E-Commerce',
        'subtitle': 'Shopping',
        'icon': Icons.shopping_bag_rounded,
        'color': AppColors.ecommerce,
        'targetScreen': const EcommerceDashboardScreen(),
        'gradient': [AppColors.ecommerce, AppColors.ecommerce.withOpacity(0.3)],
      },
      {
        'title': 'IT Services',
        'subtitle': 'Tech Support',
        'icon': Icons.build_circle_rounded,
        'color': AppColors.itServices,
        'targetScreen': const ItServicesDashboardScreen(),
        'gradient': [AppColors.itServices, AppColors.itServices.withOpacity(0.3)],
      },
      {
        'title': 'School Portal',
        'subtitle': 'Education',
        'icon': Icons.school_rounded,
        'color': AppColors.school,
        'targetScreen': null, // We'll handle navigation manually
        'gradient': [AppColors.school, AppColors.school.withOpacity(0.3)],
        'isSchool': true, // Flag to identify school portal
      },
      {
        'title': 'Video Player',
        'subtitle': 'Entertainment',
        'icon': Icons.play_circle_fill_rounded,
        'color': AppColors.ott,
        'targetScreen': const OttDashboardScreen(),
        'gradient': [AppColors.ott, AppColors.ott.withOpacity(0.3)],
      },
      {
        'title': 'NGO Connect',
        'subtitle': 'Community Help',
        'icon': Icons.volunteer_activism_rounded,
        'color': AppColors.ngo,
        'targetScreen': const NgoDashboardScreen(),
        'gradient': [AppColors.ngo, AppColors.ngo.withOpacity(0.3)],
      },
      {
        'title': 'Collage',
        'subtitle': 'Community Help',
        'icon': Icons.school,
        'color': AppColors.ngo,
        'targetScreen': const CollageDashboardScreen(),
        'gradient': [AppColors.ngo, AppColors.ngo.withOpacity(0.3)],
      },
    ];

    final List<Map<String, dynamic>> promotionalCards = [
      {
        'headline': '🛒 SUPER GROCERY SALE',
        'desc': 'Flat 20% Off on daily essentials',
        'actionLabel': 'Shop Now →',
        'icon': Icons.local_mall_rounded,
        'gradient': const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'targetScreen': const EcommerceDashboardScreen(),
      },
      {
        'headline': '💻 ON-DEMAND TECHS',
        'desc': 'Verified IT experts at home instantly',
        'actionLabel': 'Hire Experts →',
        'icon': Icons.gavel_rounded,
        'gradient': const LinearGradient(
          colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'targetScreen': const ItServicesDashboardScreen(),
      },
      {
        'headline': '🎓 ADMISSION OPEN 2026',
        'desc': 'Apply online to tier-1 local institutions',
        'actionLabel': 'Explore Now →',
        'icon': Icons.auto_stories_rounded,
        'gradient': const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF10B981)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'targetScreen': null, // School portal
        'isSchool': true,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSectionTitle('Explore Categories', 'View All →'),
                    const SizedBox(height: 14),
                    _buildCategoryGrid(primaryServices),
                    const SizedBox(height: 24),
                    _buildDivider(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('✨ Promotions & Highlights', 'See All →'),
                    const SizedBox(height: 14),
                    _buildPromotionalCards(promotionalCards),
                    const SizedBox(height: 24),
                    _buildDivider(),
                    const SizedBox(height: 24),
                    _buildQuickActions(),
                    const SizedBox(height: 24),
                    _buildDivider(),
                    const SizedBox(height: 24),
                    _buildAboutSection(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          splashRadius: 20,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_active, color: Colors.white),
            onPressed: () {},
            splashRadius: 20,
          ),
        ),
      ],
      centerTitle: true,
      title: Column(
        children: [
          Text(
            "Welcome Back!",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Text(
            "Akshay Panika",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.primary,
      toolbarHeight: 0,
      expandedHeight: 220,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(color: AppColors.primary),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 180,
                    child: CarouselSlider(
                      items: bannerItems.map((item) {
                        return _buildBannerItem(item);
                      }).toList(),
                      options: CarouselOptions(
                        height: 180,
                        viewportFraction: 0.92,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayCurve: Curves.easeInOut,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentBannerIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildBannerIndicators(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerItem(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(int.parse(item['bgColor']!.replaceFirst('#', '0xFF'))),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['tag']!,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['title']!,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    item['action']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  item['icon']!,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        bannerItems.length,
            (index) {
          bool isActive = _currentBannerIndex == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isActive ? 24 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(3),
              boxShadow: isActive
                  ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 6,
                ),
              ]
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary.withOpacity(0.5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              action,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(List<Map<String, dynamic>> services) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildCategoryCard(services[2])), // School
                const SizedBox(width: 8),
                Expanded(child: _buildCategoryCard(services[5])), // Collage
                const SizedBox(width: 8),
                Expanded(child: _buildCategoryCard(services[4])), // NGO
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildCategoryCard(services[0])), // E-Commerce
                const SizedBox(width: 8),
                Expanded(child: _buildCategoryCard(services[1])), // IT
                const SizedBox(width: 8),
                Expanded(child: _buildCategoryCard(services[3])), // Video
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> module) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Check if it's the school portal
          if (module['isSchool'] == true) {
            _navigateToSchool();
          } else {
            // Normal navigation
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => module['targetScreen']),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (module['color'] as Color).withOpacity(0.1),
                      (module['color'] as Color).withOpacity(0.05),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  module['icon'],
                  color: module['color'],
                  size: 26,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                module['title'],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: AppColors.textMain,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                module['subtitle'],
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionalCards(List<Map<String, dynamic>> cards) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return GestureDetector(
            onTap: () {
              if (card['isSchool'] == true) {
                _navigateToSchool();
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => card['targetScreen']),
                );
              }
            },
            child: Container(
              width: 280,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: card['gradient'],
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: (card['gradient'] as LinearGradient)
                        .colors
                        .first
                        .withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            card['headline'],
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          card['desc'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Text(
                            card['actionLabel'],
                            style: TextStyle(
                              fontSize: 10,
                              color: (card['gradient'] as LinearGradient)
                                  .colors
                                  .first,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    card['icon'],
                    color: Colors.white.withOpacity(0.15),
                    size: 56,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickActionItem(Icons.support_agent_rounded, 'Support', () {}),
          _buildQuickActionItem(Icons.history_rounded, 'History', () {}),
          _buildQuickActionItem(Icons.favorite_rounded, 'Favorites', () {}),
          _buildQuickActionItem(Icons.settings_rounded, 'Settings', () {}),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.background,
            AppColors.background.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primary.withOpacity(0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'About Suwidhaa Hub',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Suwidhaa Hub ek multi-service digital ecosystem platform hai jo aapki daily life ki sabhi basic aur premium requirements ko ek single app me safe aur seamless tarike se integrate karta hai.',
            style: TextStyle(
              fontSize: 13,
              color: const Color(0xFF475569),
              height: 1.7,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          _buildFeatureRow(Icons.check_circle_rounded, 'Unified Access: All systems inside a single login frame.'),
          const SizedBox(height: 8),
          _buildFeatureRow(Icons.shield_rounded, 'Verified Partners: Safe transactions across trusted verticals.'),
          const SizedBox(height: 8),
          _buildFeatureRow(Icons.headset_mic_rounded, '24/7 Support: Dedicated assistance for all your needs.'),
          const SizedBox(height: 4),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Learn More →',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.primary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            const Color(0xFFF1F5F9),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}