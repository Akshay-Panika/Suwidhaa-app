import 'package:flutter/material.dart';

class TeacherAttendanceDashboardCard extends StatefulWidget {
  const TeacherAttendanceDashboardCard({super.key});

  @override
  State<TeacherAttendanceDashboardCard> createState() => _TeacherAttendanceDashboardCardState();
}

class _TeacherAttendanceDashboardCardState
    extends State<TeacherAttendanceDashboardCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Progress animation (0 to 0.917)
    _progressAnimation = Tween<double>(begin: 0, end: 0.917).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Fade animation for text
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );

    // Scale animation for the circular indicator
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Start animation when widget is built
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with slide animation
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-0.2, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0, 0.3, curve: Curves.easeOut),
                  ),
                ),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0, 0.2, curve: Curves.easeIn),
                    ),
                  ),
                  child: Text(
                    "Attendance",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // Circular Progress with animation
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Animated Circular Progress
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(
                              value: _progressAnimation.value,
                              strokeWidth: 10,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Animated Percentage Text
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.8, end: 1).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve:  Interval(0.2, 0.7, curve: Curves.easeOut),
                            ),
                          ),
                          child: AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) {
                              final percentage =
                              (_progressAnimation.value * 100).round();
                              return FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "$percentage%",
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Attendance items with staggered animation
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: _buildAnimatedAttendanceItem(
                      icon: Icons.check_circle_outline,
                      title: "Present",
                      value: "22 Days",
                      color: Colors.green,
                      delay: 0.4,
                    ),
                  ),
                  Container(
                    height: 35,
                    width: 1,
                    color: Colors.grey.shade200,
                  ),
                  Expanded(
                    child: _buildAnimatedAttendanceItem(
                      icon: Icons.cancel_outlined,
                      title: "Absent",
                      value: "2 Days",
                      color: Colors.red,
                      delay: 0.6,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedAttendanceItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required double delay,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.2, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(delay, delay + 0.3, curve: Curves.easeOut),
        ),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(delay, delay + 0.2, curve: Curves.easeIn),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 8, color: color),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 8, color: Colors.grey.shade700),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
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