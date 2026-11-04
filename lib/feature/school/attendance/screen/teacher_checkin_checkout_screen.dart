// lib/feature/school/attendance/screen/teacher_checkin_checkout_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/widget/flutter_toast.dart';

import '../../profile/controller/teacher_controller.dart';
import '../controller/teacher_attendance_controller.dart';
import '../controller/teacher_checkin_checkout_controller.dart';

class TeacherCheckinCheckoutScreen extends StatefulWidget {
  const TeacherCheckinCheckoutScreen({super.key});

  @override
  State<TeacherCheckinCheckoutScreen> createState() =>
      _TeacherCheckinCheckoutScreenState();
}

class _TeacherCheckinCheckoutScreenState
    extends State<TeacherCheckinCheckoutScreen> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  final TeacherController teacherController = Get.find<TeacherController>();
  final TeacherCheckInOutController checkInOutController =
  Get.find<TeacherCheckInOutController>();
  final TeacherAttendanceController attendanceController =
  Get.find<TeacherAttendanceController>();

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadToday());
    ever(teacherController.teacherData, (_) => _loadToday());
  }

  /// ✅ No teacherId param — controller resolves from SharedPrefs
  void _loadToday() {
    checkInOutController.fetchToday();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // ── Formatters ──
  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m:$s $ampm';
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  // ── Handlers ──
  Future<void> _handleCheckIn() async {
    final ok = await checkInOutController.checkIn();
    if (ok) {
      FlutterToast.success("Checked in successfully");
      // Refresh history so calendar updates
      await attendanceController.fetchAttendance();
    } else {
      FlutterToast.error(
        checkInOutController.errorMessage.value.isNotEmpty
            ? checkInOutController.errorMessage.value
            : "Check-in failed",
      );
    }
  }

  Future<void> _handleCheckOut() async {
    final ok = await checkInOutController.checkOut();
    if (ok) {
      FlutterToast.success("Checked out successfully");
      await attendanceController.fetchAttendance();
    } else {
      FlutterToast.error(
        checkInOutController.errorMessage.value.isNotEmpty
            ? checkInOutController.errorMessage.value
            : "Check-out failed",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Self Attendance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Teacher card ──
            Obx(() {
              if (teacherController.isLoading.value) {
                return const SizedBox(
                  height: 80,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (teacherController.hasData) {
                final teacher = teacherController.teacherData.value!;
                return Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.indigo.shade200, width: 2),
                        image: teacher.teacherProfile != null &&
                            teacher.teacherProfile!.isNotEmpty
                            ? DecorationImage(
                          image:
                          NetworkImage(teacher.teacherProfile!),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: teacher.teacherProfile == null ||
                          teacher.teacherProfile!.isEmpty
                          ? CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.indigo.shade100,
                        child: Text(
                          teacherController.fullName.isNotEmpty
                              ? teacherController.fullName[0]
                              .toUpperCase()
                              : 'T',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade700,
                          ),
                        ),
                      )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            teacherController.teacherIdCard.isNotEmpty
                                ? teacherController.teacherIdCard
                                : "--",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54),
                          ),
                          Text(
                            teacherController.fullName.isNotEmpty
                                ? teacherController.fullName
                                : "Teacher Name",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            teacherController.qualification.isNotEmpty
                                ? teacherController.qualification
                                : "Teacher",
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFFE3F2FD),
                    child: Icon(Icons.person,
                        color: Colors.indigo.shade300, size: 30),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("--",
                          style: TextStyle(
                              fontSize: 12, color: Colors.black54)),
                      Text("Teacher Name",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              );
            }),

            const SizedBox(height: 20),

            // ── Live clock ──
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    _formatTime(_now),
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(_now),
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Check-in / out times (from API) ──
            Obx(() {
              final data = checkInOutController.todayData.value;
              return Row(
                children: [
                  Expanded(
                    child: _timeBox(
                      label: 'Check-in',
                      time: data?.checkInTime ?? '--:--',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _timeBox(
                      label: 'Check-out',
                      time: data?.checkOutTime ?? '--:--',
                    ),
                  ),
                ],
              );
            }),

            const Expanded(child: SizedBox(height: 24)),

            // ── Action buttons ──
            Obx(() {
              final isCheckingIn = checkInOutController.isCheckingIn.value;
              final isCheckingOut =
                  checkInOutController.isCheckingOut.value;
              final hasIn = checkInOutController.hasCheckedIn;
              final hasOut = checkInOutController.hasCheckedOut;

              final canCheckIn = !hasIn && !isCheckingIn && !isCheckingOut;
              final canCheckOut =
                  hasIn && !hasOut && !isCheckingIn && !isCheckingOut;

              return Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: canCheckIn ? _handleCheckIn : null,
                      icon: isCheckingIn
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                          : const Icon(Icons.login),
                      label: Text(
                          isCheckingIn ? 'Checking in...' : 'Check In'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.grey.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: canCheckOut ? _handleCheckOut : null,
                      icon: isCheckingOut
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                          : const Icon(Icons.logout),
                      label: Text(
                          isCheckingOut ? 'Checking out...' : 'Check Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade700,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.grey.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _timeBox({required String label, required String time}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 6),
          Text(time,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}