import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:untitled/core/utils/app_color.dart';
import 'package:untitled/feature/ecommerce/screen/ecommerce_category_screen.dart';

import 'eccomerce_product_order_screen.dart';
import 'ecommerce_home_screen.dart';
import 'ecommerce_profile_screen.dart';

class EcommerceDashboardScreen extends StatefulWidget {
  const EcommerceDashboardScreen({super.key});

  @override
  State<EcommerceDashboardScreen> createState() => _EcommerceDashboardScreenState();
}

class _EcommerceDashboardScreenState extends State<EcommerceDashboardScreen> {
  int _selectedIndex = 0;
  String _selectedCategoryName = 'All';

  // Key for HomeScreen to access its state
  final GlobalKey<EcommerceHomeScreenState> _homeScreenKey = GlobalKey<EcommerceHomeScreenState>();

  void _navigateToCategoryScreen() {
    setState(() {
      _selectedIndex = 1; // Categories tab index
      _selectedCategoryName = 'All';
    });
  }

  void _navigateToCategoryScreenWithName(String categoryName) {
    setState(() {
      _selectedIndex = 1; // Categories tab index
      _selectedCategoryName = categoryName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          EcommerceHomeScreen(
            key: _homeScreenKey,
            onNavigateToCategory: _navigateToCategoryScreen,
            onNavigateToCategoryWithName: _navigateToCategoryScreenWithName,
          ),
          EcommerceCategoryScreen(
            initialCategory: _selectedCategoryName,
          ),
          const EcommerceProductOrderScreen(),
          const EcommerceProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFE63E3E),
          unselectedItemColor: const Color(0xFF888888),
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
              // Reset category name when switching tabs manually
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
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Order',
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