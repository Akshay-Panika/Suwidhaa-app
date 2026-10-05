import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../../../router/app_routes.dart'; // 👈 adjust path if needed
import '../../category/screen/ngo_category_screen.dart';
import '../../screen/donation_dialog.dart';
import '../../history/screen/ngo_history_screen.dart';
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

  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Category'),
    BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
    BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _showDonationDialog(context);
    // });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

  // ✅ Back handling
  Future<void> _handleBack() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
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
                      // ✅ Exit app or navigate to login/dashboard route
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
      const NgoHistoryScreen(),
      const NgoProfileScreen(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBack();
      },
      child: Scaffold(
        key: _scaffoldKey, // 👈 important for bottom sheet
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text("NGO"),
          titleTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20),
          leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.dashboard, color: Colors.white)),
          actions: [
            IconButton(
              icon: const Icon(Icons.volunteer_activism, color: Colors.white),
              onPressed: () => _showDonationDialog(context),
            ),
          ],
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: _bottomNavItems,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey.shade600,
          backgroundColor: Colors.white,
          elevation: 8,
          selectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
          showUnselectedLabels: true,
          iconSize: 24,
        ),
      ),
    );
  }
}