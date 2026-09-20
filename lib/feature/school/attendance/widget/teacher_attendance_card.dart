// lib/feature/school/attendance/widget/teacher_attendance_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../attendance/controller/teacher_attendance_controller.dart';
import '../../attendance/model/teacher_attendance_model.dart';
import '../../profile/controller/teacher_controller.dart';

class TeacherAttendanceCard extends StatefulWidget {
  const TeacherAttendanceCard({super.key});

  @override
  State<TeacherAttendanceCard> createState() => _TeacherAttendanceCardState();
}

class _TeacherAttendanceCardState extends State<TeacherAttendanceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  final TeacherController teacherController = Get.find<TeacherController>();
  final TeacherAttendanceController attendanceController =
  Get.find<TeacherAttendanceController>();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
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
          height: 78,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        );
      }

      // ── Compute stats ──
      final records =
          attendanceController.attendanceData.value?.allRecords ??
              <AttendanceRecord>[];

      // Exclude week-off & running
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

      // Half-day = 0.5 weight
      final attended = presentDays + (halfDays * 0.5);

      final double ratio = totalAttendable > 0
          ? (attended / totalAttendable).clamp(0.0, 1.0)
          : 0.0;

      final double percent = ratio * 100;

      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final double animatedValue = _progressAnimation.value * ratio;
          final int animatedPercent = (animatedValue * 100).round();

          return Container(
            height: 78,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              spacing: 10,
              children: [
                // ================= PRESENT & ABSENT =================
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildAttendanceItem(
                            icon: Icons.check_circle_outline,
                            title: "Present",
                            value: "$presentDays Days",
                            color: Colors.green,
                          ),
                        ),

                        Container(
                          height: 38,
                          width: 1,
                          color: Colors.grey.shade200,
                        ),

                        Expanded(
                          child: _buildAttendanceItem(
                            icon: Icons.cancel_outlined,
                            title: "Absent",
                            value: "$absentDays Days",
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ================= ATTENDANCE PERCENTAGE =================
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: animatedValue,
                                strokeWidth: 4,
                                backgroundColor: Colors.blue.shade100,
                                valueColor:
                                const AlwaysStoppedAnimation<Color>(
                                  Colors.blue,
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "$animatedPercent%",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 7),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Attendance",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 3),

                              Text(
                                "${percent.toStringAsFixed(1)}%",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildAttendanceItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}