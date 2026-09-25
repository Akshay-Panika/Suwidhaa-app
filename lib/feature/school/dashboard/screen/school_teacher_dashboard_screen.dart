import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../../router/app_routes.dart';
import '../../attendance/screen/teacher_attendance_screen.dart';
import '../../teacher/screen/school_teacher_home_screen.dart';
import '../../profile/screen/school_teacher_profile_screen.dart';
import '../../transport/screen/school_student_transport_screen.dart';

class SchoolTeacherDashboardScreen extends StatefulWidget {
  const SchoolTeacherDashboardScreen({super.key});

  @override
  State<SchoolTeacherDashboardScreen> createState() => _SchoolTeacherDashboardScreenState();
}

class _SchoolTeacherDashboardScreenState extends State<SchoolTeacherDashboardScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 0;

  late final List<Widget> _screens = [
    SchoolTeacherHomeScreen(
      onNavigate: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    ),
    const TeacherAttendanceScreen(),
    const SchoolStudentTransportScreen(),
    const SchoolTeacherProfileScreen(),
  ];

  final  _bottomNav = [
    {
      "Icon":Icons.home,
      "label":"Home"
    },
    {
      "Icon":Icons.calendar_month,
      "label":"Attendance"
    },
    {
      "Icon":Icons.directions_bus,
      "label":"Transport"
    },
    {
      "Icon":Icons.person,
      "label":"Account"
    },
  ];

  /// Handle back navigation logic
  Future<void> _handleBack() async {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return;
    }

    _showExitBottomSheet();
  }

  void _showExitBottomSheet() {
    _scaffoldKey.currentState?.showBottomSheet(
          (context) => Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          border: Border.symmetric(
            horizontal: BorderSide(color: Colors.green),
            vertical: BorderSide(color: Colors.green),
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
                      backgroundColor: Colors.blue,
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBack();
      },
      child: Scaffold(
        extendBody: true,
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),


        bottomNavigationBar: SizedBox(
          height: 110,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / _bottomNav.length;
              final targetCenter = (itemWidth * _currentIndex) + itemWidth / 2;

              return TweenAnimationBuilder<double>(
                tween: Tween(begin: targetCenter, end: targetCenter),
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                builder: (context, centerX, child) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // ---- Bar with animated notch shape ----
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _NotchedBarPainter(
                            centerX: centerX,
                            barTop: 32,
                            notchRadius: 30,
                          ),
                        ),
                      ),

                      // ---- Labels (default state) ----
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 10,
                        bottom: 0,
                        child: Row(
                          children: List.generate(_bottomNav.length, (index) {
                            final isSelected = _currentIndex == index;
                            return Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _currentIndex = index),
                                child: Center(
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 250),
                                    opacity: isSelected ? 0 : 1,
                                    child: Text(
                                      _bottomNav[index]['label'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      // ---- Floating circle with icon (selected state) ----
                      Positioned(
                        left: centerX - 26,
                        top: 4,
                        child: TweenAnimationBuilder<double>(
                          key: ValueKey(_currentIndex),
                          tween: Tween(begin: 0.6, end: 1),
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutBack,
                          builder: (context, scale, _) => Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.indigo.withValues(alpha: 0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _bottomNav[_currentIndex]['Icon'] as IconData,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
class _NotchedBarPainter extends CustomPainter {
  final double centerX;
  final double barTop;
  final double notchRadius;

  _NotchedBarPainter({
    required this.centerX,
    required this.barTop,
    required this.notchRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final r = notchRadius;
    final depth = r * 0.95;

    path.moveTo(0, barTop);
    path.lineTo(centerX - r - 22, barTop);

    // left shoulder -> notch bottom
    path.cubicTo(
      centerX - r - 2, barTop,
      centerX - r + 4, barTop + depth,
      centerX, barTop + depth,
    );

    // notch bottom -> right shoulder
    path.cubicTo(
      centerX + r - 4, barTop + depth,
      centerX + r + 2, barTop,
      centerX + r + 22, barTop,
    );

    path.lineTo(size.width, barTop);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // shadow
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.35), 6, false);

    canvas.drawPath(path, Paint()..color = Colors.indigo);

    // top border line (aapke original design jaisa)
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.indigo.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
  }

  @override
  bool shouldRepaint(_NotchedBarPainter old) =>
      old.centerX != centerX ||
          old.barTop != barTop ||
          old.notchRadius != notchRadius;
}