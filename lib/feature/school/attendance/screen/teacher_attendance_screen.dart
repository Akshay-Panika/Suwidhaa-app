// lib/feature/school/attendance/screen/teacher_attendance_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:untitled/feature/school/attendance/screen/leave_form_screen.dart';

import '../../profile/controller/teacher_controller.dart';
import '../controller/teacher_attendance_controller.dart';
import '../model/teacher_attendance_model.dart';
import '../widget/teacher_attendance_shimmer.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({super.key});

  @override
  State<TeacherAttendanceScreen> createState() =>
      _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  late final TeacherController teacherController;
  late final TeacherAttendanceController attendanceController;

  @override
  void initState() {
    super.initState();
    teacherController = Get.find<TeacherController>();
    attendanceController = Get.find<TeacherAttendanceController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAttendance();
    });

    ever(teacherController.teacherData, (_) => _loadAttendance());
  }

  void _loadAttendance() {
    final teacherId = teacherController.teacherIdCard;
    if (teacherId.isNotEmpty &&
        !attendanceController.isLoading.value &&
        !attendanceController.hasData) {
      attendanceController.fetchAttendance(teacherId: teacherId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          // Loading
          if (attendanceController.isLoading.value ||
              teacherController.isLoading.value) {
            return const TeacherAttendanceShimmer();
          }

          // Error
          if (attendanceController.errorMessage.value.isNotEmpty) {
            return _buildErrorState();
          }

          // No data
          if (!attendanceController.hasData) {
            return _buildEmptyState();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildMonthHeader(),
                  const SizedBox(height: 8),
                  _buildCalendar(),
                  const SizedBox(height: 24),
                  _buildLegend(),
                  const SizedBox(height: 28),
                  _buildLeaveSection(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              attendanceController.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                attendanceController.fetchAttendance(
                  teacherId: teacherController.teacherIdCard,
                );
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        "No Attendance Records",
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ✅ Month Header — arrows disable when no data in that direction
  // ─────────────────────────────────────────────
  Widget _buildMonthHeader() {
    return Obx(() {
      final focused = attendanceController.focusedDay.value;
      final canPrev = attendanceController.canGoPrev;
      final canNext = attendanceController.canGoNext;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Prev Button ──
          IconButton(
            onPressed: canPrev
                ? () => attendanceController.goToPreviousMonth()
                : null,
            icon: Icon(
              Icons.chevron_left,
              size: 32,
              color: canPrev ? Colors.black87 : Colors.grey.shade300,
            ),
          ),

          // ── Month + Year Text ──
          Text(
            DateFormat('MMMM yyyy').format(focused),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),

          // ── Next Button ──
          IconButton(
            onPressed: canNext
                ? () => attendanceController.goToNextMonth()
                : null,
            icon: Icon(
              Icons.chevron_right,
              size: 32,
              color: canNext ? Colors.black87 : Colors.grey.shade300,
            ),
          ),
        ],
      );
    });
  }

  // ─────────────────────────────────────────────
  // ✅ Calendar — swipe disabled to prevent going to empty months
  // ─────────────────────────────────────────────
  Widget _buildCalendar() {
    return Obx(() {
      final focused = attendanceController.focusedDay.value;
      final map = attendanceController.attendanceMap;

      return TableCalendar(
        firstDay: DateTime.utc(2026, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focused,
        calendarFormat: CalendarFormat.month,
        availableCalendarFormats: const {CalendarFormat.month: 'Month'},
        startingDayOfWeek: StartingDayOfWeek.sunday,
        selectedDayPredicate: (_) => false,
        onDaySelected: null,
        availableGestures: AvailableGestures.none,
        onPageChanged: (newFocused) {
          final target = DateTime(newFocused.year, newFocused.month, 1);
          final index = attendanceController.availableMonths
              .indexWhere((m) => isSameDay(m, target));
          if (index != -1) {
            attendanceController.currentMonthIndex.value = index;
            attendanceController.focusedDay.value = target;
          } else {
            // Snap back to current focused month
            attendanceController.focusedDay.value = focused;
          }
        },

        calendarStyle: CalendarStyle(
          defaultDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          weekendDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          outsideDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          todayDecoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          todayTextStyle: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
          markerDecoration: const BoxDecoration(color: Colors.transparent),
          markersMaxCount: 0,
          cellPadding: const EdgeInsets.all(4),
          cellMargin: const EdgeInsets.all(2),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontSize: 0),
          leftChevronVisible: false,
          rightChevronVisible: false,
          headerPadding: EdgeInsets.zero,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
          weekendStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
          decoration: const BoxDecoration(color: Colors.transparent),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, date, _) {
            return _buildDayCell(date, map);
          },
          outsideBuilder: (context, date, _) {
            return _buildDayCell(date, map, isOutside: true);
          },
          todayBuilder: (context, date, _) {
            final record = _findRecord(map, date);
            if (record != null) {
              return _buildDayCell(date, map);
            }
            return Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  AttendanceRecord? _findRecord(
      Map<DateTime, AttendanceRecord> map,
      DateTime date,
      ) {
    for (final entry in map.entries) {
      if (isSameDay(entry.key, date)) {
        return entry.value;
      }
    }
    return null;
  }

  Widget _buildDayCell(
      DateTime date,
      Map<DateTime, AttendanceRecord> map, {
        bool isOutside = false,
      }) {
    final record = _findRecord(map, date);
    final isToday = isSameDay(date, DateTime.now());

    Color? backgroundColor;
    Color textColor = isOutside ? Colors.black26 : Colors.black87;

    if (record != null) {
      backgroundColor = _getStatusColor(record.statusType);
      textColor = Colors.white;
    } else if (isToday) {
      backgroundColor = Colors.blue.shade100;
      textColor = Colors.blue.shade700;
    }

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(AttendanceStatusType status) {
    switch (status) {
      case AttendanceStatusType.weekOff:
        return Colors.grey.shade300;
      case AttendanceStatusType.absent:
        return Colors.red.shade300;
      case AttendanceStatusType.present:
        return Colors.green.shade400;
      case AttendanceStatusType.running:
        return Colors.green.shade300;
      case AttendanceStatusType.halfDay:
        return Colors.orange.shade300;
      case AttendanceStatusType.leave:
        return Colors.blue.shade300;
    }
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 24,
      runSpacing: 10,
      children: [
        _legendItem(color: Colors.grey.shade300, title: "Week Off"),
        _legendItem(color: Colors.red.shade300, title: "Absent"),
        _legendItem(color: Colors.green.shade400, title: "Present"),
        _legendItem(color: Colors.green.shade300, title: "Running"),
        _legendItem(color: Colors.orange.shade300, title: "Half Day"),
        _legendItem(color: Colors.blue.shade300, title: "Leave"),
      ],
    );
  }

  Widget _legendItem({required Color color, required String title}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Apply For Leave",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 90,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "No leave requests this month.",
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LeaveFormScreen(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text(
                  "Apply",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}