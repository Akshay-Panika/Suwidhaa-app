import 'package:flutter/material.dart';
import 'package:untitled/feature/school/class/screen/class_screen.dart';
import 'package:untitled/feature/school/live/screen/live_class_screen.dart';
import '../../../core/utils/app_color.dart';
import '../../notificatinal/screen/notification_screen.dart';
import '../class/screen/event_screen.dart';
import '../school_login/school_login.dart';
import '../school_profile/screen/school_profile_screen.dart';
import '../tranport/screen/transport_screen.dart';

class SchoolScreen extends StatefulWidget {
  SchoolScreen({super.key});

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  double _currentSheetSize = 0.65;
  int _selectedIndex = 0;
  bool _isLoggedIn = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onLoginSuccess(bool status) {
    setState(() {
      _isLoggedIn = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double dynamicRadius = _currentSheetSize >= 0.98 ? 0.0 : 32.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _selectedIndex != 0
          ? null
          : AppBar(
        title: Text(
          "School Portal",
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.dashboard, color: Colors.white, size: 20),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.notifications_outlined, color: AppColors.white),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(dynamicRadius),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_rounded),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv_rounded),
            label: 'Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(double dynamicRadius) {
    switch (_selectedIndex) {
      case 1:
        return ClassScreen();
      case 2:
        return LiveClassScreen();
      case 3:
        return SchoolProfileScreen();
      default:
        return NotificationListener<DraggableScrollableNotification>(
          onNotification: (DraggableScrollableNotification notification) {
            setState(() {
              _currentSheetSize = notification.extent;
            });
            return true;
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double remainingHeight = constraints.maxHeight;
              final double backgroundBannerHeight = remainingHeight * (1.0 - 0.65);

              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: backgroundBannerHeight + 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.school_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                               "Welcome to School Portal",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("Your learning journey starts here",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.65,
                    minChildSize: 0.65,
                    maxChildSize: 1.0,
                    builder: (BuildContext context, ScrollController scrollController) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(dynamicRadius),
                            topRight: Radius.circular(dynamicRadius),
                          ),
                          boxShadow: [
                            if (_currentSheetSize < 0.98)
                              const BoxShadow(
                                color: Color(0x12000000),
                                blurRadius: 16,
                                offset: Offset(0, -4),
                              )
                          ],
                        ),
                        child: ListView(
                          controller: scrollController,
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          children: [
                            if (_currentSheetSize < 0.98)
                              Center(
                                child: Container(
                                  width: 44,
                                  height: 5,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFCBD5E1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),

                            /// If not logged in show login form, else show dashboard
                            if (!_isLoggedIn)
                              SchoolLogin(onLoginSuccess: _onLoginSuccess)
                            else
                              Column(
                                children: [


                                  GridView.count(
                                    shrinkWrap: true,
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 1,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: [
                                      _buildQuickActionCard(
                                        icon: Icons.class_rounded,
                                        label: "Classes",
                                        color: AppColors.school,
                                        tint: AppColors.schoolTint,
                                        onTap: () {
                                          setState(() {
                                            _selectedIndex = 1;
                                          });
                                        },
                                      ),
                                      _buildQuickActionCard(
                                        icon: Icons.live_tv_rounded,
                                        label: "Live",
                                        color: AppColors.accent,
                                        tint: Colors.cyan[50]!,
                                        onTap: () {
                                          setState(() {
                                            _selectedIndex = 2;
                                          });
                                        },
                                      ),
                                      _buildQuickActionCard(
                                        icon: Icons.event_rounded,
                                        label: "Events",
                                        color: AppColors.primary,
                                        tint: Colors.blue[50]!,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EventScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                      _buildQuickActionCard(
                                        icon: Icons.directions_bus_rounded,
                                        label: "Transport",
                                        color: AppColors.itServices,
                                        tint: AppColors.itServicesTint,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TransportScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Card(
                                    elevation: 0.1,
                                    color: Colors.grey.shade50,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: _buildStatCard(
                                              title: "Teachers",
                                              value: "48",
                                              icon: Icons.person_rounded,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _buildStatCard(
                                              title: "Students",
                                              value: "1.2K",
                                              icon: Icons.people_rounded,
                                              color: AppColors.accent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildSectionHeader("📅 Upcoming Events", "View All"),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        height: 110,
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: 4,
                                          separatorBuilder: (context, index) =>
                                          const SizedBox(width: 12),
                                          itemBuilder: (context, index) {
                                            final events = [
                                              {
                                                "title": "Parent Meeting",
                                                "time": "10:00 AM",
                                                "date": "Today"
                                              },
                                              {
                                                "title": "Sports Day",
                                                "time": "2:30 PM",
                                                "date": "Tomorrow"
                                              },
                                              {
                                                "title": "Exam Results",
                                                "time": "11:00 AM",
                                                "date": "Wed"
                                              },
                                              {
                                                "title": "Workshop",
                                                "time": "9:00 AM",
                                                "date": "Thu"
                                              },
                                            ];
                                            final event = events[index];
                                            final colors = [
                                              AppColors.school,
                                              AppColors.accent,
                                              AppColors.primary,
                                              AppColors.itServices
                                            ];
                                            return _buildEventCard(
                                              title: event["title"]!,
                                              time: event["time"]!,
                                              date: event["date"]!,
                                              color: colors[index],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildSectionHeader("📢 Notice Board", "More"),
                                      const SizedBox(height: 12),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.06),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            _buildNoticeItem(
                                              title: "School Holiday",
                                              subtitle: "School will remain closed on Friday",
                                              icon: Icons.calendar_today_rounded,
                                              color: AppColors.school,
                                              time: "2 hours ago",
                                            ),
                                            const Divider(height: 1, indent: 16, endIndent: 16),
                                            _buildNoticeItem(
                                              title: "Exam Schedule Released",
                                              subtitle: "Final exams start from next week",
                                              icon: Icons.assignment_rounded,
                                              color: AppColors.primary,
                                              time: "5 hours ago",
                                            ),
                                            const Divider(height: 1, indent: 16, endIndent: 16),
                                            _buildNoticeItem(
                                              title: "New Timetable",
                                              subtitle: "Check your new class schedule",
                                              icon: Icons.schedule_rounded,
                                              color: AppColors.accent,
                                              time: "1 day ago",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
    }
  }

  // All your existing widget methods remain the same...
  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required Color tint,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              color: color,
              size: 26,
            ),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textMain,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMain,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.textMain,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
          ),
          child: Row(
            children: [
              Text(
                action,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primary,
                size: 12,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard({
    required String title,
    required String time,
    required String date,
    required Color color,
  }) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  date,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.access_time_rounded,
                  color: color,
                  size: 12,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                time,
                style: TextStyle(
                  color: color,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textMain,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textMain,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}