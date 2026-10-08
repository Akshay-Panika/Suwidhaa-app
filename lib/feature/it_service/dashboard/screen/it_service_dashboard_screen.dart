import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_color.dart';
import '../../../../router/app_routes.dart';
import '../../category/screen/it_service_category_screen.dart';
import '../../home/screen/it_service_home_screen.dart';
import '../../account/screen/it_service_profile_screen.dart';

class ItServiceDashboardScreen extends StatefulWidget {
  const ItServiceDashboardScreen({super.key});

  @override
  State<ItServiceDashboardScreen> createState() =>
      _ItServiceDashboardScreenState();
}

class _ItServiceDashboardScreenState extends State<ItServiceDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  String _selectedCategoryName = 'All';

  final GlobalKey<ItServiceHomeScreenState> _homeScreenKey =
  GlobalKey<ItServiceHomeScreenState>();

  // ---------- Navigation between tabs ----------
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

  void _onNavTap(int index) {
    if (_selectedIndex == index) return;
    HapticFeedback.lightImpact();
    setState(() {
      _selectedIndex = index;
      if (index != 1) {
        _selectedCategoryName = 'All';
      }
    });
  }

  // ---------- Back handling ----------
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

  // ---------- Exit confirmation bottom sheet ----------
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
            const Row(
              children: [
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

  // ---------- Build ----------
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBack();
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,
        extendBody: true,
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
            const ItServiceProfileScreen(),
          ],
        ),
        bottomNavigationBar: _ItServiceNavBar(
          selectedIndex: _selectedIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }
}

// ============================================================
// NAV BAR  —  floating rounded bar with sliding pill
// ============================================================
class _ItServiceNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _ItServiceNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  static const int _itemCount = 3;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double itemWidth = constraints.maxWidth / _itemCount;
            const double pillPadding = 8.0;
            const double pillHeight = 52.0;

            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                // ---------- Sliding pill indicator ----------
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  left: (selectedIndex * itemWidth) + pillPadding,
                  top: (68 - pillHeight) / 2,
                  child: Container(
                    width: itemWidth - (pillPadding * 2),
                    height: pillHeight,
                    decoration: BoxDecoration(
                      color: AppColors.itServices,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.itServices.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),

                // ---------- Items ----------
                Row(
                  children: [
                    _NavItem(
                      icon: Icons.home_rounded,
                      label: 'Home',
                      isSelected: selectedIndex == 0,
                      onTap: () => onTap(0),
                    ),
                    _NavItem(
                      icon: Icons.grid_view_rounded,
                      label: 'Services',
                      isSelected: selectedIndex == 1,
                      onTap: () => onTap(1),
                    ),
                    _NavItem(
                      icon: Icons.person_rounded,
                      label: 'Profile',
                      isSelected: selectedIndex == 2,
                      onTap: () => onTap(2),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// NAV ITEM
// ============================================================
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color =
    isSelected ? Colors.white : AppColors.textSecondary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        splashColor: AppColors.itServices.withOpacity(0.08),
        highlightColor: Colors.transparent,
        child: SizedBox(
          height: 68,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: color,
                  fontWeight:
                  isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 11,
                ),
                child: Row(
                  spacing: 4,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: isSelected ? 22 : 22,
                      color: color,
                    ),
                    const SizedBox(height: 2),
                    Text(label, style: TextStyle(fontSize: 14),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}