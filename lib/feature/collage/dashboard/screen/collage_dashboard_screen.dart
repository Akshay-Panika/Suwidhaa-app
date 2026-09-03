import 'package:flutter/material.dart';

import '../../../../core/utils/app_color.dart';
import '../../home/screen/collage_home_screen.dart';
import '../../screen/add_tiffin_senter_screen.dart';


class CollageDashboardScreen extends StatefulWidget {
  const CollageDashboardScreen({super.key});

  @override
  State<CollageDashboardScreen> createState() => _CollageDashboardScreenState();
}

class _CollageDashboardScreenState extends State<CollageDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const CollageHomeScreen(),
    const CollageFavoritesScreen(),
    const CollageBookingsScreen(),
    const CollageProfileScreen(),
  ];

  final List<String> _titles = [
    "Colleges",
    "Favorites",
    "Bookings",
    "Profile"
  ];

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.book_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.dashboard, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(child: CollageHomeScreen()),
      // body: _screens[_selectedIndex],
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.05),
      //         blurRadius: 10,
      //         offset: const Offset(0, -2),
      //       ),
      //     ],
      //   ),
      //   child: BottomNavigationBar(
      //     currentIndex: _selectedIndex,
      //     onTap: (index) {
      //       setState(() {
      //         _selectedIndex = index;
      //       });
      //     },
      //     type: BottomNavigationBarType.fixed,
      //     backgroundColor: Colors.white,
      //     selectedItemColor: AppColors.primary,
      //     unselectedItemColor: Colors.grey.shade600,
      //     selectedLabelStyle: const TextStyle(
      //       fontSize: 12,
      //       fontWeight: FontWeight.w600,
      //     ),
      //     unselectedLabelStyle: const TextStyle(
      //       fontSize: 12,
      //       fontWeight: FontWeight.w500,
      //     ),
      //     elevation: 0,
      //     items: [
      //       BottomNavigationBarItem(
      //         icon: Icon(_icons[0]),
      //         label: "Home",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(_icons[1]),
      //         label: "Favorites",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(_icons[2]),
      //         label: "Bookings",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(_icons[3]),
      //         label: "Profile",
      //       ),
      //     ],
      //   ),
      // ),
      //
      // floatingActionButton: FloatingActionButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddTiffinCenterScreen(),),),child:
      //   Icon(Icons.add),),
    );
  }
}

// Favorites Screen
class CollageFavoritesScreen extends StatelessWidget {
  const CollageFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              "No Favorites Yet",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Start saving your favorite colleges",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Bookings Screen
class CollageBookingsScreen extends StatelessWidget {
  const CollageBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_rounded,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              "No Bookings",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Your bookings will appear here",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Profile Screen
class CollageProfileScreen extends StatelessWidget {
  const CollageProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Student Name",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "student@email.com",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Profile Options
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildProfileTile(
                    Icons.person_outline_rounded,
                    "Edit Profile",
                        () {},
                  ),
                  _buildProfileTile(
                    Icons.bookmark_border_rounded,
                    "Saved Colleges",
                        () {},
                  ),
                  _buildProfileTile(
                    Icons.history_rounded,
                    "Booking History",
                        () {},
                  ),
                  _buildProfileTile(
                    Icons.notifications_outlined,
                    "Notifications",
                        () {},
                  ),
                  _buildProfileTile(
                    Icons.settings_outlined,
                    "Settings",
                        () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Logout Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red.shade700,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 20,
                      color: Colors.red.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}