import 'package:flutter/material.dart';
import '../../account/screen/ott_account_screen.dart';
import '../../home/screen/ott_home_screen.dart';
import '../../movie/screen/ott_movie_screen.dart';
import '../../reels/screen/ott_reel_screen.dart';
import '../../school/screen/ott_school_screen.dart';


class OttDashboardScreen extends StatefulWidget {
  final int? currentIndex;
  const OttDashboardScreen({super.key,  this.currentIndex});

  @override
  State<OttDashboardScreen> createState() => _OttDashboardScreenState();
}

class _OttDashboardScreenState extends State<OttDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const OttHomeScreen(),
    const OttReelScreen(),
    const OttMovieScreen(),
    const OttSchoolScreen(),
    const OttAccountScreen(),
  ];

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.currentIndex ?? 0;

    if (_currentIndex < 0 || _currentIndex >= _screens.length) {
      _currentIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
            color: Colors.grey[800]!,
            width: 0.5,
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'YouTube',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Student',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}