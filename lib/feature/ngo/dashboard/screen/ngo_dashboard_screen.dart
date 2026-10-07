import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../../../router/app_routes.dart';
import '../../category/screen/ngo_category_screen.dart';
import '../../screen/donation_dialog.dart';
import '../../home/screen/ngo_home_screen.dart';
import '../../account/screen/ngo_profile_screen.dart';

class NgoDashboardScreen extends StatefulWidget {
  const NgoDashboardScreen({super.key});

  @override
  State<NgoDashboardScreen> createState() => _NgoDashboardScreenState();
}

class _NgoDashboardScreenState extends State<NgoDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  String? _selectedCategoryFromHome;

  // ✅ 3 tabs only
  static const List<Map<String, dynamic>> _navItems = [
    {"icon": Icons.home_rounded, "label": "Home"},
    {"icon": Icons.grid_view_rounded, "label": "Category"},
    {"icon": Icons.person_rounded, "label": "Account"},
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    HapticFeedback.selectionClick();
    setState(() => _selectedIndex = index);
  }

  void _onNavigateFromHome(int index, {String? category}) {
    setState(() {
      _selectedIndex = index;
      _selectedCategoryFromHome = category;
    });
  }

  void _showDonationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const DonationDialogContent(),
    );
  }

  Future<void> _handleBack() async {
    if (_selectedIndex != 0) {
      setState(() => _selectedIndex = 0);
      return;
    }
    _showExitBottomSheet();
  }

  void _showExitBottomSheet() {
    _scaffoldKey.currentState?.showBottomSheet(
          (context) => Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.symmetric(
            horizontal: BorderSide(color: Colors.teal),
            vertical: BorderSide(color: Colors.teal),
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
                      backgroundColor: Colors.teal,
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
    final List<Widget> _screens = [
      NgoHomeScreen(onNavigate: _onNavigateFromHome),
      NGOCategoryScreen(
        key: ValueKey(_selectedCategoryFromHome),
        initialCategory: _selectedCategoryFromHome,
      ),
      const NgoProfileScreen(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBack();
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.teal,
          titleSpacing: 10,
          leadingWidth: 70,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "NGO",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              Text(
                "Provided by Suwidhaa",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 0.3),
            ),
            child: const Icon(
              Icons.volunteer_activism,
              color: Colors.white,
              size: 25,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.paid, color: Colors.white),
              onPressed: () => _showDonationDialog(context),
            ),
          ],
        ),

        // ✅ Page transition animation between tabs
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey(_selectedIndex),
            child: _screens[_selectedIndex],
          ),
        ),

          bottomNavigationBar: _FloatingPillNav(
            selectedIndex: _selectedIndex,
            items: _navItems,
            onTap: _onItemTapped,
          ),
      ),
    );
  }
}

class _FloatingPillNav extends StatelessWidget {
  final int selectedIndex;
  final List<Map<String, dynamic>> items;
  final ValueChanged<int> onTap;

  const _FloatingPillNav({
    required this.selectedIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.18),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: List.generate(items.length, (index) {
              final selected = index == selectedIndex;
              final item = items[index];

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: selected
                          ? LinearGradient(
                        colors: [
                          Colors.teal.shade400,
                          Colors.teal.shade700,
                        ],
                      )
                          : null,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item["icon"] as IconData,
                          color: selected ? Colors.white : Colors.teal,
                          size: 24,
                        ),
                        // Expand label only when selected
                        AnimatedSize(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutCubic,
                          child: selected
                              ? Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              item["label"] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
