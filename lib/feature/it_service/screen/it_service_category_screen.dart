// lib/screens/dashboard/it_service_category_screen.dart
import 'package:flutter/material.dart';
import '../../../core/utils/app_color.dart';
import 'it_service_details_screen.dart';

class ItServiceCategoryScreen extends StatefulWidget {
  final String? initialCategory;

  const ItServiceCategoryScreen({super.key, this.initialCategory});

  @override
  State<ItServiceCategoryScreen> createState() => _ItServiceCategoryScreenState();
}

class _ItServiceCategoryScreenState extends State<ItServiceCategoryScreen> {
  late String _selectedCategory;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'All';
  }

  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.dashboard, 'color': AppColors.itServices},
    {'name': 'App Development', 'icon': Icons.mobile_friendly_rounded, 'color': AppColors.ecommerce},
    {'name': 'Web Development', 'icon': Icons.web_rounded, 'color': AppColors.primary},
    {'name': 'Web Application', 'icon': Icons.web_asset_rounded, 'color': AppColors.itServices},
    {'name': 'IoT & Robotics', 'icon': Icons.smart_toy_rounded, 'color': AppColors.ngo},
    {'name': 'Game Development', 'icon': Icons.sports_esports_rounded, 'color': AppColors.school},
    {'name': 'AI & ML', 'icon': Icons.psychology_rounded, 'color': AppColors.itServicesTint},
    {'name': 'Cloud Computing', 'icon': Icons.cloud_rounded, 'color': AppColors.primary},
    {'name': 'DevOps', 'icon': Icons.settings_rounded, 'color': AppColors.ecommerce},
    {'name': 'AR/VR', 'icon': Icons.circle, 'color': AppColors.ott},
    {'name': 'Blockchain', 'icon': Icons.link_rounded, 'color': AppColors.school},
    {'name': 'Cybersecurity', 'icon': Icons.security_rounded, 'color': AppColors.ngo},
    {'name': 'Data Science', 'icon': Icons.data_usage_rounded, 'color': AppColors.primary},
  ];

  final List<Map<String, dynamic>> allProjects = [
    // App Development Projects
    {
      'title': 'E-Commerce Mobile App',
      'price': '₹1,50,000',
      'oldPrice': '₹2,00,000',
      'imageUrl': 'https://images.unsplash.com/photo-1551650975-87deedd944c3?q=80&w=200',
      'category': 'App Development',
      'rating': 4.9,
      'reviews': 89,
      'badge': 'Trending',
      'color': AppColors.ecommerce,
      'provider': 'CodeCraft Studios',
      'description': 'Full-featured e-commerce mobile app with payment integration, user authentication, and real-time inventory management.',
    },
    {
      'title': 'Social Media App',
      'price': '₹2,00,000',
      'oldPrice': '₹2,80,000',
      'imageUrl': 'https://images.unsplash.com/photo-1611162616475-46b635cb6868?q=80&w=200',
      'category': 'App Development',
      'rating': 4.8,
      'reviews': 67,
      'badge': 'Popular',
      'color': AppColors.ecommerce,
      'provider': 'AppForge Solutions',
      'description': 'Social media platform with real-time chat, post sharing, and user profile management.',
    },
    {
      'title': 'Health & Fitness App',
      'price': '₹1,80,000',
      'oldPrice': '₹2,50,000',
      'imageUrl': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80&w=200',
      'category': 'App Development',
      'rating': 4.7,
      'reviews': 45,
      'badge': 'New',
      'color': AppColors.ecommerce,
      'provider': 'CodeCraft Studios',
      'description': 'Health tracking app with workout plans, nutrition tracking, and progress monitoring.',
    },
    // Web Development Projects
    {
      'title': 'Corporate Website',
      'price': '₹80,000',
      'oldPrice': '₹1,20,000',
      'imageUrl': 'https://images.unsplash.com/photo-1547658719-da2b51169166?q=80&w=200',
      'category': 'Web Development',
      'rating': 4.6,
      'reviews': 56,
      'badge': 'Popular',
      'color': AppColors.primary,
      'provider': 'WebWizards Inc',
      'description': 'Professional corporate website with custom design, SEO optimization, and responsive layout.',
    },
    {
      'title': 'Portfolio Website',
      'price': '₹50,000',
      'oldPrice': '₹75,000',
      'imageUrl': 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?q=80&w=200',
      'category': 'Web Development',
      'rating': 4.5,
      'reviews': 34,
      'badge': 'Trending',
      'color': AppColors.primary,
      'provider': 'WebWizards Inc',
      'description': 'Creative portfolio website for showcasing work, with animated elements and contact forms.',
    },
    {
      'title': 'Blog Platform',
      'price': '₹60,000',
      'oldPrice': '₹90,000',
      'imageUrl': 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?q=80&w=200',
      'category': 'Web Development',
      'rating': 4.4,
      'reviews': 28,
      'badge': 'Best',
      'color': AppColors.primary,
      'provider': 'WebWizards Inc',
      'description': 'Full-featured blog platform with content management, user comments, and social sharing.',
    },
    // Web Application Development
    {
      'title': 'SaaS Dashboard',
      'price': '₹2,00,000',
      'oldPrice': '₹2,50,000',
      'imageUrl': 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?q=80&w=200',
      'category': 'Web Application',
      'rating': 4.8,
      'reviews': 78,
      'badge': 'New',
      'color': AppColors.itServices,
      'provider': 'WebApp Masters',
      'description': 'Comprehensive SaaS dashboard with analytics, user management, and real-time data visualization.',
    },
    {
      'title': 'API Development',
      'price': '₹80,000',
      'oldPrice': '₹1,20,000',
      'imageUrl': 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?q=80&w=200',
      'category': 'Web Application',
      'rating': 4.7,
      'reviews': 56,
      'badge': 'Popular',
      'color': AppColors.itServices,
      'provider': 'WebApp Masters',
      'description': 'Custom REST API development with authentication, rate limiting, and comprehensive documentation.',
    },
    {
      'title': 'E-Learning Platform',
      'price': '₹2,50,000',
      'oldPrice': '₹3,50,000',
      'imageUrl': 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?q=80&w=200',
      'category': 'Web Application',
      'rating': 4.9,
      'reviews': 89,
      'badge': 'Trending',
      'color': AppColors.itServices,
      'provider': 'WebApp Masters',
      'description': 'Complete e-learning platform with video streaming, quizzes, and student progress tracking.',
    },
    // IoT & Robotics
    {
      'title': 'Smart Home System',
      'price': '₹2,00,000',
      'oldPrice': '₹2,80,000',
      'imageUrl': 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?q=80&w=200',
      'category': 'IoT & Robotics',
      'rating': 4.9,
      'reviews': 45,
      'badge': 'IoT',
      'color': AppColors.ngo,
      'provider': 'RoboTech Innovations',
      'description': 'Complete smart home automation system with voice control, sensors, and mobile app integration.',
    },
    {
      'title': 'Industrial Automation',
      'price': '₹3,50,000',
      'oldPrice': '₹4,50,000',
      'imageUrl': 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?q=80&w=200',
      'category': 'IoT & Robotics',
      'rating': 4.8,
      'reviews': 34,
      'badge': 'Industrial',
      'color': AppColors.ngo,
      'provider': 'RoboTech Innovations',
      'description': 'Industrial automation system with PLC integration, remote monitoring, and predictive maintenance.',
    },
    {
      'title': 'Robotics Kit',
      'price': '₹1,50,000',
      'oldPrice': '₹2,00,000',
      'imageUrl': 'https://images.unsplash.com/photo-1535378917042-10a22c95931a?q=80&w=200',
      'category': 'IoT & Robotics',
      'rating': 4.7,
      'reviews': 28,
      'badge': 'New',
      'color': AppColors.ngo,
      'provider': 'RoboTech Innovations',
      'description': 'Educational robotics kit with sensors, actuators, and programming interface.',
    },
    // Game Development
    {
      'title': '3D Adventure Game',
      'price': '₹4,00,000',
      'oldPrice': '₹5,50,000',
      'imageUrl': 'https://images.unsplash.com/photo-1552820728-8b83bb6b773f?q=80&w=200',
      'category': 'Game Development',
      'rating': 4.8,
      'reviews': 67,
      'badge': 'Trending',
      'color': AppColors.school,
      'provider': 'GameForge Studios',
      'description': 'Immersive 3D adventure game with realistic graphics, story-driven gameplay, and multiplayer support.',
    },
    {
      'title': 'Mobile Game',
      'price': '₹2,50,000',
      'oldPrice': '₹3,50,000',
      'imageUrl': 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?q=80&w=200',
      'category': 'Game Development',
      'rating': 4.6,
      'reviews': 45,
      'badge': 'Popular',
      'color': AppColors.school,
      'provider': 'GameForge Studios',
      'description': 'Casual mobile game with addictive gameplay, leaderboards, and in-app purchases.',
    },
    {
      'title': 'AR/VR Game',
      'price': '₹5,00,000',
      'oldPrice': '₹7,00,000',
      'imageUrl': 'https://images.unsplash.com/photo-1622979135225-d2ba269cf1ac?q=80&w=200',
      'category': 'Game Development',
      'rating': 4.9,
      'reviews': 34,
      'badge': 'AR/VR',
      'color': AppColors.ott,
      'provider': 'GameForge Studios',
      'description': 'Cutting-edge AR/VR game with immersive experiences, gesture controls, and 3D environments.',
    },
  ];

  List<Map<String, dynamic>> get filteredProjects {
    if (_selectedCategory == 'All') {
      return allProjects;
    }
    return allProjects.where((project) =>
    project['category'] == _selectedCategory
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.white,
        title: const Text(
          'IT Services',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textMain,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppColors.border,
          ),
        ),
      ),
      body: Row(
        children: [
          // ====== CATEGORY LIST ======
          Container(
            width: 100,
            color: AppColors.white,
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
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.itServices.withOpacity(0.08)
                          : Colors.transparent,
                      border: Border(
                        left: BorderSide(
                          color: isSelected
                              ? AppColors.itServices
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Removed AnimatedContainer - using normal Container
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                              colors: [AppColors.itServices, AppColors.itServices.withOpacity(0.6)],
                            )
                                : null,
                            color: isSelected
                                ? null
                                : category['color'].withOpacity(0.12),
                            shape: BoxShape.circle,
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: AppColors.itServices.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                                : null,
                          ),
                          child: Icon(
                            category['icon'],
                            color: isSelected
                                ? AppColors.white
                                : category['color'],
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColors.itServices
                                : AppColors.textSecondary,
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

          // ====== PROJECT GRID ======
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedCategory,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${filteredProjects.length} projects',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: filteredProjects.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_rounded,
                            size: 64,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No projects in this category',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                        : GridView.builder(
                      padding: const EdgeInsets.all(4),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 1.3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: filteredProjects.length,
                      itemBuilder: (context, index) {
                        final project = filteredProjects[index];
                        return _buildEnhancedProjectCard(project);
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

  Widget _buildEnhancedProjectCard(Map<String, dynamic> project) {
    return InkWell(
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
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    Image.network(
                      project['imageUrl'] ?? '',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.background,
                        child: const Icon(
                          Icons.image_not_supported_rounded,
                          size: 40,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [project['color'], project['color'].withOpacity(0.8)],
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          project['category'] ?? '',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (project['badge'] != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.textMain,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            project['badge'],
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.textMain.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.school,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              (project['rating'] ?? 4.5).toString(),
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
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMain,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    project['provider'] ?? '',
                    style: const TextStyle(
                      fontSize: 10,
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
                        project['price'] ?? '',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.itServices,
                        ),
                      ),
                      if (project['oldPrice'] != null && project['oldPrice'] != '')
                        Text(
                          project['oldPrice'],
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  if (project['reviews'] != null)
                    Text(
                      '${project['reviews']} reviews',
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppColors.textSecondary,
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