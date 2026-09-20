// lib/feature/school/attendance/widget/teacher_attendance_dashboard_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../attendance/controller/teacher_attendance_controller.dart';
import '../../attendance/model/teacher_attendance_model.dart';
import '../../profile/controller/teacher_controller.dart';

class TeacherAttendanceDashboardCard extends StatefulWidget {
  const TeacherAttendanceDashboardCard({super.key});

  @override
  State<TeacherAttendanceDashboardCard> createState() =>
      _TeacherAttendanceDashboardCardState();
}

class _TeacherAttendanceDashboardCardState
    extends State<TeacherAttendanceDashboardCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final TeacherController teacherController = Get.find<TeacherController>();
  final TeacherAttendanceController attendanceController =
  Get.find<TeacherAttendanceController>();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Animate 0 → 1. Actual value multiplied by real `ratio` in build.
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();

    // Fetch attendance once teacher id is available
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAttendance());
    ever(teacherController.teacherData, (_) => _loadAttendance());
  }

  void _loadAttendance() {
    final teacherId = teacherController.teacherIdCard;
    if (teacherId.isNotEmpty && !attendanceController.hasData) {
      attendanceController.fetchAttendance(teacherId: teacherId);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int _countByStatus(
      List<AttendanceRecord> records,
      AttendanceStatusType type,
      ) {
    return records.where((r) => r.statusType == type).length;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = attendanceController.isLoading.value;
      final hasData = attendanceController.hasData;

      // ── Loading State ──
      if (isLoading && !hasData) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }

      // ── Compute stats from API ──
      final records =
          attendanceController.attendanceData.value?.allRecords ??
              <AttendanceRecord>[];

      // Use ALL records (no month filter) — graph shows lifetime stats
      // Week-off & running excluded (not attendable)
      final attendableRecords = records.where((r) {
        return r.statusType != AttendanceStatusType.weekOff &&
            r.statusType != AttendanceStatusType.running;
      }).toList();

      final presentDays = _countByStatus(
        attendableRecords,
        AttendanceStatusType.present,
      );
      final absentDays = _countByStatus(
        attendableRecords,
        AttendanceStatusType.absent,
      );
      final halfDays = _countByStatus(
        attendableRecords,
        AttendanceStatusType.halfDay,
      );
      final leaveDays = _countByStatus(
        attendableRecords,
        AttendanceStatusType.leave,
      );

      final totalAttendable = presentDays + absentDays + halfDays + leaveDays;

      // ✅ Percentage logic:
      //   PRESENT    → 1.0 weight
      //   HALF_DAY   → 0.5 weight
      //   LEAVE      → 0.0 weight
      //   ABSENT     → 0.0 weight
      final attended = presentDays + (halfDays * 0.5);

      final double ratio = totalAttendable > 0
          ? (attended / totalAttendable).clamp(0.0, 1.0)
          : 0.0;

      // Debug (remove in production)
      debugPrint('📊 Attendance → present=$presentDays, absent=$absentDays, '
          'half=$halfDays, leave=$leaveDays, total=$totalAttendable, '
          'attended=$attended, ratio=$ratio');

      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          // Animate 0 → ratio smoothly
          final double animatedValue = _progressAnimation.value * ratio;
          final int animatedPercent = (animatedValue * 100).round();

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
                // ── Title ──
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
                    child: const Text(
                      "Attendance",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // ── Circular Progress ──
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: CircularProgressIndicator(
                                value: animatedValue,
                                strokeWidth: 10,
                                backgroundColor: Colors.grey.shade300,
                                valueColor:
                                const AlwaysStoppedAnimation<Color>(
                                  Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.8, end: 1).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: const Interval(0.2, 0.7,
                                    curve: Curves.easeOut),
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "$animatedPercent%",
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Present / Absent ──
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: _buildAnimatedAttendanceItem(
                        icon: Icons.check_circle_outline,
                        title: "Present",
                        value: "$presentDays Days",
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
                        value: "$absentDays Days",
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
    });
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