// lib/screens/ott/ott_dashboard_screen.dart
import 'package:flutter/material.dart';
import '../../../core/utils/app_color.dart';
import 'ott_platform_home_screen.dart';
import 'ott_platform_profile_screen.dart';
import 'ott_platform_reel_screen.dart';
import 'ott_platform_search_screen.dart';

class OttDashboardScreen extends StatefulWidget {
  const OttDashboardScreen({super.key});

  @override
  State<OttDashboardScreen> createState() => _OttDashboardScreenState();
}

class _OttDashboardScreenState extends State<OttDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children:  [
          OttPlatformHomeScreen(),
          OttPlatformSearchScreen(),
          OttPlatformReelScreen(),
          OttProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey[500],
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
              icon: Icon(Icons.home_rounded, size: 24),
              activeIcon: Icon(Icons.home_rounded, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 24),
              activeIcon: Icon(Icons.search, size: 24),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_collection_outlined, size: 24),
              activeIcon: Icon(Icons.video_collection, size: 24),
              label: 'Reel',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded, size: 24),
              activeIcon: Icon(Icons.person_rounded, size: 24),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}