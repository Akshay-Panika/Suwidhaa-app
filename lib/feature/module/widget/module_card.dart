import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../core/utils/app_color.dart';
import '../../collage/dashboard/screen/collage_dashboard_screen.dart';
import '../../ecommerce/screen/ecommerce_dashboard_screen.dart';
import '../../it_service/screen/it_services_dashboard_screen.dart';
import '../../ngo/screen/ngo_dashboard_screen.dart';
import '../../ott_platform/auth/screen/ott_splash_screen.dart';
import '../../school/auth/controller/school_auth_controller.dart';
import '../../school/auth/screen/school_auth_screen.dart';
import '../../school/dashboard/screen/school_student_dashboard_screen.dart';
import '../../school/dashboard/screen/school_teacher_dashboard_screen.dart';

class ModuleCard extends StatefulWidget {
  const ModuleCard({super.key});

  @override
  State<ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<ModuleCard> {

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
      'targetScreen': const OttSplashScreen(),
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

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 320,
      child: Column(
        spacing: 6,
        children: [
          // Top row - Same as your original
          Expanded(
            flex: 2,
            child: Row(
              spacing: 6,
              children: [
                // Left side - 2 stacked boxes
                Expanded(
                  child: Column(
                    spacing: 6,
                    children: [
                      Expanded(
                        child: _buildModuleBox(primaryServices[2]),
                      ),
                      Expanded(
                        child: _buildModuleBox(primaryServices[5]),
                      ),
                    ],
                  ),
                ),
                // Right side - Large box
                Expanded(
                  flex: 2,
                  child: _buildModuleBox(primaryServices[3]),
                ),
              ],
            ),
          ),
          // Bottom row - Same as your original
          Expanded(
            flex: 1,
            child: Row(
              spacing: 6,
              children: [
                // Left box
                Expanded(
                  child: _buildModuleBox(primaryServices[0]),
                ),
                // Right side - 2 stacked boxes
                Expanded(
                  child: Row(
                    spacing: 6,
                    children: [
                      Expanded(
                        child: _buildModuleBox(primaryServices[1]),
                      ),
                      Expanded(
                        child: _buildModuleBox(primaryServices[4]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleBox(Map<String, dynamic> module) {
    return InkWell(
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
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.01), width: 1.5),
          gradient: RadialGradient(
            colors: [
              (module['color'] as Color).withOpacity(0.1),
              (module['color'] as Color).withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          spacing: 4,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              module['icon'],
              color: module['color'],
              size: 26,
            ),
            Text(
              module['title'],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}