import 'package:flutter/material.dart';

import '../../attendance/screen/school_teacher_attendance_screen.dart';
import '../../home/screen/school_teacher_home_screen.dart';
import '../../profile/screen/school_teacher_profile_screen.dart';
import '../../transport/screen/school_student_transport_screen.dart';

class SchoolTeacherDashboardScreen extends StatefulWidget {
  const SchoolTeacherDashboardScreen({super.key});

  @override
  State<SchoolTeacherDashboardScreen> createState() => _SchoolTeacherDashboardScreenState();
}

class _SchoolTeacherDashboardScreenState extends State<SchoolTeacherDashboardScreen> {

  int _currentIndex = 0;

  final List<Widget> _screens = const [
    SchoolTeacherHomeScreen(),
    SchoolTeacherAttendanceScreen(),
    SchoolStudentTransportScreen(),
    SchoolTeacherProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,

        titleSpacing: 16,

        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.school_outlined,
                size: 24,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 10),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Suwidhaa School",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Student Portal",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () {
                    // Notification screen
                  },
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ),

                Positioned(
                  right: 7,
                  top: 7,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,

            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },

            backgroundColor: Colors.white,

            elevation: 0,

            type: BottomNavigationBarType.fixed,

            selectedItemColor: Colors.blue,

            unselectedItemColor: Colors.grey.shade500,

            selectedFontSize: 11,

            unselectedFontSize: 11,

            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),

            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
            ),

            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  size: 23,
                ),
                activeIcon: Icon(
                  Icons.home_rounded,
                  size: 23,
                ),
                label: 'Home',
              ),

              BottomNavigationBarItem(
                icon: Icon(
                  Icons.fact_check_outlined,
                  size: 23,
                ),
                activeIcon: Icon(
                  Icons.fact_check_rounded,
                  size: 23,
                ),
                label: 'Attendance',
              ),

              BottomNavigationBarItem(
                icon: Icon(
                  Icons.directions_bus_outlined,
                  size: 23,
                ),
                activeIcon: Icon(
                  Icons.directions_bus_rounded,
                  size: 23,
                ),
                label: 'Transport',
              ),

              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline_rounded,
                  size: 23,
                ),
                activeIcon: Icon(
                  Icons.person_rounded,
                  size: 23,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
