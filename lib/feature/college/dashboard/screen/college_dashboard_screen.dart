import 'package:flutter/material.dart';
import '../../../../core/utils/app_color.dart';
import '../../account/screen/college_account_screen.dart';
import '../../booking/screen/college_booking_screen.dart';
import '../../home/screen/collage_home_screen.dart';
import '../../screen/add_tiffin_senter_screen.dart';

class CollegeDashboardScreen extends StatefulWidget {
  const CollegeDashboardScreen({super.key});

  @override
  State<CollegeDashboardScreen> createState() => _CollegeDashboardScreenState();
}

class _CollegeDashboardScreenState extends State<CollegeDashboardScreen> {
  int _selectedIndex = 0;

  final List<dynamic> _screens = [
    {
      "screen":CollageHomeScreen(),
      "title":'Home',
       "icon":Icons.home_rounded,
    },
    {
      "screen":CollegeBookingScreen(),
      "title":'Booking',
      "icon":Icons.book_rounded,
    },
    {
      "screen":CollegeAccountScreen(),
      "title":'Account',
      "icon":Icons.person_rounded,
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_selectedIndex]['title']=='Home'?'Colleges':_screens[_selectedIndex]['title']),
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
      body: _screens[_selectedIndex]['screen'],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Navigation Items
                ...List.generate(_screens.length, (index) {
                  final screen = _screens[index];
                  final isSelected = _selectedIndex == index;
                  return Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              screen['icon'],
                              color: isSelected ? AppColors.primary : Colors.grey.shade400,
                              size: 26,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              screen['title'],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                color: isSelected ? AppColors.primary : Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                // Floating Add Button
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddTiffinCenterScreen(),
                      ),
                    ),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


