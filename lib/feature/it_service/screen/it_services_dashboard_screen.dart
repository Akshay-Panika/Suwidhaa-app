import 'package:flutter/material.dart';
import '../../../core/utils/app_color.dart';
import 'it_service_category_screen.dart';
import 'it_service_home_screen.dart';
import 'it_service_order_screen.dart';
import 'it_service_profile_screen.dart';

class ItServicesDashboardScreen extends StatefulWidget {
  const ItServicesDashboardScreen({super.key});

  @override
  State<ItServicesDashboardScreen> createState() => _ItServicesDashboardScreenState();
}

class _ItServicesDashboardScreenState extends State<ItServicesDashboardScreen> {
  int _selectedIndex = 0;
  String _selectedCategoryName = 'All';

  final GlobalKey<ItServiceHomeScreenState> _homeScreenKey = GlobalKey<ItServiceHomeScreenState>();

  void _navigateToCategoryScreen() {
    setState(() {
      _selectedIndex = 1;
      _selectedCategoryName = 'All';
    });
  }

  void _navigateToCategoryScreenWithName(String categoryName) {
    setState(() {
      _selectedIndex = 1;
      _selectedCategoryName = categoryName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ItServiceHomeScreen(
            key: _homeScreenKey,
            onNavigateToCategory: _navigateToCategoryScreen,
            onNavigateToCategoryWithName: _navigateToCategoryScreenWithName,
          ),
          ItServiceCategoryScreen(
            initialCategory: _selectedCategoryName,
          ),
          const ItServiceOrderScreen(),
          const ItServiceProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.itServices,
          unselectedItemColor: AppColors.textSecondary,
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
              if (index != 1) {
                _selectedCategoryName = 'All';
              }
            });
          },
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
              label: 'Services',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Projects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}