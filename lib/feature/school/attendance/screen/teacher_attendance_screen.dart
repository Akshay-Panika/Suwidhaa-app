// lib/feature/school/attendance/screen/teacher_attendance_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:untitled/feature/school/attendance/screen/teacher_leave_form_screen.dart';
import 'package:untitled/feature/school/attendance/screen/teacher_leave_list_screen.dart';

import '../../profile/controller/teacher_controller.dart';
import '../controller/teacher_attendance_controller.dart';
import '../model/teacher_attendance_model.dart';
import '../widget/teacher_attendance_shimmer.dart';
import '../widget/teacher_current_leave_request_card.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({super.key});

  @override
  State<TeacherAttendanceScreen> createState() => _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  late final TeacherController teacherController;
  late final TeacherAttendanceController attendanceController;

  // ================= PRIMARY COLOR =================
  static const Color _primary = Colors.indigo;
  static const Color _primaryDark = Color(0xFF283593);
  static const Color _primaryLight = Color(0xFFE8EAF6);

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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.calendar_month,
                size: 24,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 10),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "My Attendance",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "School Portal",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () {
                    // Notification screen
                  },
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ),

                Positioned(
                  right: 7,
                  top: 7,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (attendanceController.isLoading.value ||
            teacherController.isLoading.value) {
          return const TeacherAttendanceShimmer();
        }

        if (attendanceController.errorMessage.value.isNotEmpty) {
          return _buildErrorState();
        }

        if (!attendanceController.hasData) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            _buildSummaryCard(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 18),
                      _buildMonthHeader(),
                      const SizedBox(height: 10),
                      _buildCalendar(),
                      const SizedBox(height: 20),
                      _buildLegend(),
                      const SizedBox(height: 24),
                      TeacherCurrentLeaveRequestCard(),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryCard() {
    return Obx(() {
      final map = attendanceController.attendanceMap;
      final focused = attendanceController.focusedDay.value;

      int present = 0, absent = 0, leave = 0, halfDay = 0;
      map.forEach((date, record) {
        if (date.year == focused.year && date.month == focused.month) {
          switch (record.statusType) {
            case AttendanceStatusType.present:
            case AttendanceStatusType.running:
              present++;
              break;
            case AttendanceStatusType.absent:
              absent++;
              break;
            case AttendanceStatusType.leave:
              leave++;
              break;
            case AttendanceStatusType.halfDay:
              halfDay++;
              break;
            case AttendanceStatusType.weekOff:
              break;
          }
        }
      });

      return Container(
        width: double.infinity,
        padding:  EdgeInsets.only(left: 10,right: 10,bottom: 10),
        color: Colors.indigo,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _miniStat("Present", present, Colors.green.shade300),
                _miniDivider(),
                _miniStat("Absent", absent, Colors.red.shade300),
                _miniDivider(),
                _miniStat("Leave", leave, Colors.blue.shade300),
                _miniDivider(),
                _miniStat("Half Day", halfDay, Colors.orange.shade300),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _miniStat(String label, int value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text("$value",
              style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _miniDivider() => Container(
    width: 1,
    height: 30,
    color: Colors.white.withOpacity(0.2),
  );

  // ─────────────────────────────────────────────
  // Error / Empty
  // ─────────────────────────────────────────────
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
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.event_busy_rounded,
                size: 50, color: _primary),
          ),
          const SizedBox(height: 16),
          const Text(
            "No Attendance Records",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text("Data will appear here once available",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Month Header
  // ─────────────────────────────────────────────
  Widget _buildMonthHeader() {
    return Obx(() {
      final focused = attendanceController.focusedDay.value;
      final canPrev = attendanceController.canGoPrev;
      final canNext = attendanceController.canGoNext;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: canPrev
                  ? () => attendanceController.goToPreviousMonth()
                  : null,
              icon: Icon(
                Icons.chevron_left_rounded,
                size: 28,
                color: canPrev ? _primary : Colors.grey.shade300,
              ),
            ),
            Column(
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(focused),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: canNext
                  ? () => attendanceController.goToNextMonth()
                  : null,
              icon: Icon(
                Icons.chevron_right_rounded,
                size: 28,
                color: canNext ? _primary : Colors.grey.shade300,
              ),
            ),
          ],
        ),
      );
    });
  }

  // ─────────────────────────────────────────────
  // Calendar
  // ─────────────────────────────────────────────
  Widget _buildCalendar() {
    return Obx(() {
      final focused = attendanceController.focusedDay.value;
      final map = attendanceController.attendanceMap;

      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TableCalendar(
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
              attendanceController.focusedDay.value = focused;
            }
          },
          calendarStyle: CalendarStyle(
            defaultDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            weekendDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            outsideDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            todayDecoration: BoxDecoration(
              color: _primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            todayTextStyle: const TextStyle(
              color: _primary,
              fontWeight: FontWeight.bold,
            ),
            markerDecoration:
            const BoxDecoration(color: Colors.transparent),
            markersMaxCount: 0,
            cellPadding: const EdgeInsets.all(3),
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
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Colors.black87,
            ),
            weekendStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: _primary.withOpacity(0.7),
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
                  color: _primaryLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _primary, width: 1.2),
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: _primary,
                    ),
                  ),
                ),
              );
            },
          ),
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
      backgroundColor = _primaryLight;
      textColor = _primary;
    }

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
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
        return _primary.withOpacity(0.7);
    }
  }

  // ─────────────────────────────────────────────
  // Legend
  // ─────────────────────────────────────────────
  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: _primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.info_outline_rounded,
                    size: 12, color: _primary),
              ),
              const SizedBox(width: 8),
              const Text("Legend",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 10,
            children: [
              _legendItem(color: Colors.grey.shade300, title: "Week Off"),
              _legendItem(color: Colors.red.shade300, title: "Absent"),
              _legendItem(color: Colors.green.shade400, title: "Present"),
              _legendItem(color: Colors.green.shade300, title: "Running"),
              _legendItem(color: Colors.orange.shade300, title: "Half Day"),
              _legendItem(color: _primary.withOpacity(0.7), title: "Leave"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem({required Color color, required String title}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}