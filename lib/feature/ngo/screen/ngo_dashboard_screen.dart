import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'donation_dialog.dart';
import 'ngo_history_screen.dart';
import 'ngo_home_screen.dart';
import 'ngo_notifications_screen.dart';
import 'ngo_profile_screen.dart';

class NgoDashboardScreen extends StatefulWidget {
  const NgoDashboardScreen({super.key});

  @override
  State<NgoDashboardScreen> createState() => _NgoDashboardScreenState();
}

class _NgoDashboardScreenState extends State<NgoDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const NgoHomeScreen(),
    NgoHistoryScreen(),
    NgoProfileScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.history),
      label: 'History',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      label: 'Profile',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Screen open hote hi dialog open karne ke liye
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDonationDialog(context);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Donation Screen ko Dialog mein convert kiya gaya function
  void _showDonationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const DonationDialogContent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("NGO"),
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.dashboard, color: Colors.white)),
        actions: [
          // Agar aap chahe toh AppBar se bhi donation dialog dubara khol sakte hain
          IconButton(
            icon: const Icon(Icons.volunteer_activism, color: Colors.white),
            onPressed: () => _showDonationDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NgoNotificationsScreen()));
            },
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
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        showUnselectedLabels: true,
        iconSize: 24,
      ),
    );
  }
}

