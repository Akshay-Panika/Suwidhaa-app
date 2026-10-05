import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../../core/utils/app_color.dart';
import '../../../router/app_routes.dart'; // 👈 adjust path if different
import 'it_service_category_screen.dart';
import 'it_service_home_screen.dart';
import 'it_service_order_screen.dart';
import 'it_service_profile_screen.dart';

class ItServicesDashboardScreen extends StatefulWidget {
  const ItServicesDashboardScreen({super.key});

  @override
  State<ItServicesDashboardScreen> createState() =>
      _ItServicesDashboardScreenState();
}

class _ItServicesDashboardScreenState extends State<ItServicesDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  String _selectedCategoryName = 'All';

  final GlobalKey<ItServiceHomeScreenState> _homeScreenKey =
  GlobalKey<ItServiceHomeScreenState>();

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
            horizontal: BorderSide(color: AppColors.itServices),
            vertical: BorderSide(color: AppColors.itServices),
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
                      backgroundColor: AppColors.itServices,
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
      ),
    );
  }
}