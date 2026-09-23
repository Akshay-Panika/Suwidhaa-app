// lib/feature/school/attendance/widget/teacher_checkin_checkout_button.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../attendance/controller/teacher_checkin_checkout_controller.dart';
import '../../attendance/screen/teacher_checkin_checkout_screen.dart';
import '../../profile/controller/teacher_controller.dart';

class TeacherCheckinCheckoutButton extends StatefulWidget {
  const TeacherCheckinCheckoutButton({super.key});

  @override
  State<TeacherCheckinCheckoutButton> createState() =>
      _TeacherCheckinCheckoutButtonState();
}

class _TeacherCheckinCheckoutButtonState
    extends State<TeacherCheckinCheckoutButton> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  final TeacherController teacherController = Get.find<TeacherController>();
  final TeacherCheckInOutController checkInOutController =
  Get.find<TeacherCheckInOutController>();

  @override
  void initState() {
    super.initState();

    // Live clock tick (updates every second)
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });

    // Fetch today's attendance once teacher id is available
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadToday());

    // Re-fetch whenever teacher data becomes available / changes
    ever(teacherController.teacherData, (_) => _loadToday());
  }

  void _loadToday() {
    final teacherId = teacherController.teacherIdCard;
    if (teacherId.isNotEmpty) {
      checkInOutController.fetchToday(teacherId: teacherId);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // ---------- Helpers ----------

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  String _formatClock(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TeacherCheckinCheckoutScreen(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- Date & Time Row ----------
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(_now),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time,
                      size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(
                    _formatClock(_now),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ---------- API-driven Check-in / Check-out ----------
              Obx(() {
                // Loading state
                if (checkInOutController.isLoading.value) {
                  return Row(
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Loading today\'s attendance...',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  );
                }

                final data = checkInOutController.todayData.value;

                return Row(
                  children: [
                    // -------- Check-in --------
                    Expanded(
                      child: _statusTile(
                        icon: Icons.login,
                        label: 'Check-in',
                        time: (data?.checkInTime?.isNotEmpty ?? false)
                            ? data!.checkInTime!
                            : '--:--',
                        active: data?.checkInTime?.isNotEmpty ?? false,
                        activeColor: Colors.green.shade700,
                      ),
                    ),
                    const SizedBox(width: 10),

                    // -------- Check-out --------
                    Expanded(
                      child: _statusTile(
                        icon: Icons.logout,
                        label: 'Check-out',
                        time: (data?.checkOutTime?.isNotEmpty ?? false)
                            ? data!.checkOutTime!
                            : '--:--',
                        active: data?.checkOutTime?.isNotEmpty ?? false,
                        activeColor: Colors.red.shade700,
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusTile({
    required IconData icon,
    required String label,
    required String time,
    required bool active,
    required Color activeColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: active
            ? activeColor.withOpacity(0.08)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: active
              ? activeColor.withOpacity(0.35)
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: active ? activeColor : Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: active ? activeColor : Colors.black54,
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