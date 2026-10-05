import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:untitled/core/utils/app_color.dart';
import 'package:untitled/router/app_routes.dart'; // 👈 adjust path if different
import 'package:untitled/feature/ecommerce/screen/ecommerce_category_screen.dart';

import 'eccomerce_product_order_screen.dart';
import 'ecommerce_home_screen.dart';
import 'ecommerce_profile_screen.dart';

class EcommerceDashboardScreen extends StatefulWidget {
  const EcommerceDashboardScreen({super.key});

  @override
  State<EcommerceDashboardScreen> createState() =>
      _EcommerceDashboardScreenState();
}

class _EcommerceDashboardScreenState extends State<EcommerceDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  String _selectedCategoryName = 'All';

  // Theme color for ecommerce
  static const Color _ecommerceColor = Color(0xFFE63E3E);

  // Key for HomeScreen to access its state
  final GlobalKey<EcommerceHomeScreenState> _homeScreenKey =
  GlobalKey<EcommerceHomeScreenState>();

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

  // ✅ Back handling
  Future<void> _handleBack() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
        _selectedCategoryName = 'All';
      });
      return;
    }
    _showExitBottomSheet();
  }

  // ✅ Exit confirmation bottom sheet
  void _showExitBottomSheet() {
    _scaffoldKey.currentState?.showBottomSheet(
          (context) => Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.symmetric(
            horizontal: BorderSide(color: _ecommerceColor),
            vertical: BorderSide(color: _ecommerceColor),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.exit_to_app, color: Colors.red, size: 20),
                SizedBox(width: 6),
                Text(
                  'Exit App?',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Do you really want to close the app?',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _ecommerceColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      Get.offAllNamed(AppRoutes.dashboard);
                    },
                    child: const Text(
                      'Exit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBack();
      },
      child: Scaffold(
        key: _scaffoldKey, // 👈 required for showBottomSheet
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
            selectedItemColor: _ecommerceColor,
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
      ),
    );
  }
}