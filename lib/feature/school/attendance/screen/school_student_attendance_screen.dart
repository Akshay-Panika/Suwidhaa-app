import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:untitled/feature/school/attendance/screen/student_leave_form_screen.dart';

class SchoolStudentAttendanceScreen extends StatefulWidget {
  const SchoolStudentAttendanceScreen({super.key});

  @override
  State<SchoolStudentAttendanceScreen> createState() =>
      _SchoolStudentAttendanceScreenState();
}

class _SchoolStudentAttendanceScreenState extends State<SchoolStudentAttendanceScreen> {
  DateTime _focusedDay = DateTime(2026, 8);

  // Sample attendance data
  final Map<DateTime, AttendanceStatus> _attendance = {
    DateTime(2026, 8, 1): AttendanceStatus.absent,
    DateTime(2026, 8, 2): AttendanceStatus.weekOff,
    DateTime(2026, 8, 3): AttendanceStatus.absent,
    DateTime(2026, 8, 4): AttendanceStatus.absent,
    DateTime(2026, 8, 5): AttendanceStatus.absent,
    DateTime(2026, 8, 6): AttendanceStatus.absent,
    DateTime(2026, 8, 7): AttendanceStatus.absent,
    DateTime(2026, 8, 8): AttendanceStatus.absent,
    DateTime(2026, 8, 9): AttendanceStatus.weekOff,
    DateTime(2026, 8, 10): AttendanceStatus.absent,
    DateTime(2026, 8, 11): AttendanceStatus.absent,
    DateTime(2026, 8, 12): AttendanceStatus.absent,
    DateTime(2026, 8, 13): AttendanceStatus.absent,
    DateTime(2026, 8, 14): AttendanceStatus.absent,
    DateTime(2026, 8, 15): AttendanceStatus.absent,
    DateTime(2026, 8, 16): AttendanceStatus.weekOff,
    DateTime(2026, 8, 17): AttendanceStatus.absent,
    DateTime(2026, 8, 18): AttendanceStatus.absent,
    DateTime(2026, 8, 19): AttendanceStatus.absent,
    DateTime(2026, 8, 20): AttendanceStatus.absent,
    DateTime(2026, 8, 21): AttendanceStatus.absent,
    DateTime(2026, 8, 22): AttendanceStatus.absent,
    DateTime(2026, 8, 23): AttendanceStatus.weekOff,
    DateTime(2026, 8, 24): AttendanceStatus.absent,
    DateTime(2026, 8, 25): AttendanceStatus.absent,
    DateTime(2026, 8, 26): AttendanceStatus.absent,
    DateTime(2026, 8, 27): AttendanceStatus.absent,
    DateTime(2026, 8, 28): AttendanceStatus.absent,
    DateTime(2026, 8, 29): AttendanceStatus.absent,
    DateTime(2026, 8, 30): AttendanceStatus.weekOff,
  };

  AttendanceStatus? _getAttendanceStatus(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return _attendance[normalizedDate];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // Month Header
                _buildMonthHeader(),

                const SizedBox(height: 8),

                // Calendar
                _buildCalendar(),

                const SizedBox(height: 24),

                // Legend
                _buildLegend(),

                const SizedBox(height: 28),

                // Apply For Leave
                _buildLeaveSection(),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _focusedDay = DateTime(
                _focusedDay.year,
                _focusedDay.month - 1,
              );
            });
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 32,
            color: Colors.black87,
          ),
        ),
        Text(
          '${DateFormat('MMMM yyyy').format(_focusedDay)}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _focusedDay = DateTime(
                _focusedDay.year,
                _focusedDay.month + 1,
              );
            });
          },
          icon: const Icon(
            Icons.chevron_right,
            size: 32,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.month,
      selectedDayPredicate: (day) => false,
      onDaySelected: null,
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarStyle: CalendarStyle(
        // Simple colors - just background color for each status
        defaultDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        weekendDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        todayDecoration: BoxDecoration(
          color: Colors.blue.shade100,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4),
        ),
        todayTextStyle: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
        markerDecoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        cellPadding: const EdgeInsets.all(4),
        cellMargin: const EdgeInsets.all(2),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontSize: 0,
        ),
        leftChevronVisible: false,
        rightChevronVisible: false,
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
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        // Removed markerBuilder - no circles on dates
        defaultBuilder: (context, date, _) {
          final status = _getAttendanceStatus(date);
          final isToday = isSameDay(date, DateTime.now());

          Color? backgroundColor;
          Color textColor = Colors.black87;

          if (isToday) {
            backgroundColor = Colors.blue.shade100;
            textColor = Colors.blue.shade700;
          } else if (status != null) {
            // Simple background color based on status
            backgroundColor = _getStatusColor(status);
            textColor = Colors.white;
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
        },
      ),
    );
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.weekOff:
        return Colors.grey.shade300;
      case AttendanceStatus.absent:
        return Colors.red.shade300;
      case AttendanceStatus.present:
        return Colors.green.shade400;
      case AttendanceStatus.running:
        return Colors.green.shade300;
      case AttendanceStatus.halfDay:
        return Colors.orange.shade300;
      case AttendanceStatus.leave:
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

  Widget _legendItem({
    required Color color,
    required String title,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
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
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "No leave requests this month.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  StudentLeaveFormScreen(),
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

enum AttendanceStatus {
  weekOff,
  absent,
  present,
  running,
  halfDay,
  leave,
}