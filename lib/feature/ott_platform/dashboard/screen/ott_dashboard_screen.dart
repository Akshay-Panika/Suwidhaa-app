import 'package:flutter/material.dart';
import '../../home/screen/ott_home_screen.dart';
import '../../ott_account/screen/ott_account_screen.dart';
import '../../ott_movie/screen/ott_movie_screen.dart';
import '../../ott_school/screen/ott_school_screen.dart';
import '../../tv_show/screen/ott_tv_show_screen.dart';


class OttDashboardScreen extends StatefulWidget {
  const OttDashboardScreen({super.key});

  @override
  State<OttDashboardScreen> createState() => _OttDashboardScreenState();
}

class _OttDashboardScreenState extends State<OttDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const OttHomeScreen(),
    const OttTvShowScreen(),
    const OttMovieScreen(),
    const OttSchoolScreen(),
    const OttAccountScreen(),
  ];

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
            label: 'TV Shows',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
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