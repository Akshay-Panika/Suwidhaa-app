import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/utils/app_color.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();


  final Map<DateTime, String> _attendanceStatus = {
    DateTime.utc(2026, 7, 1): 'present',
    DateTime.utc(2026, 7, 2): 'absent',
    DateTime.utc(2026, 7, 4): 'present',
    DateTime.utc(2026, 7, 5): 'present',
    DateTime.utc(2026, 7, 6): 'absent',
    DateTime.utc(2026, 7, 7): 'holiday',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
           elevation: 0.2,
          color: Colors.white,
          child: TableCalendar(
            firstDay: DateTime.utc(2026, 1, 1),
            lastDay: DateTime.utc(2026, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (f) => setState(() => _calendarFormat = f),
            onPageChanged: (focusedDay) => setState(() => _focusedDay = focusedDay),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(color: Colors.white),
              selectedDecoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                String? status = _attendanceStatus[day];
                if (status == null) return null;
                return Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _getColor(status),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "${day.day}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 30),
        _buildLegend(),
        const SizedBox(height: 20),
        _buildAttendanceSummary(),
      ],
    );
  }


  Color _getColor(String status) {
    switch (status) {
      case 'present':
        return AppColors.ngo;
      case 'absent':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Widget _buildLegend() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _legendItem(AppColors.ngo, "✅ Present"),
      _legendItem(Colors.red, "❌ Absent"),
      _legendItem(Colors.orange, "🎉 Holiday"),
    ],
  );

  Widget _legendItem(Color color, String label) => Row(
    children: [
      Icon(Icons.circle, size: 12, color: color),
      const SizedBox(width: 5),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
    ],
  );

  Widget _buildAttendanceSummary() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _summaryItem("📚 Total Classes", "20"),
        _summaryItem("✅ Present", "16"),
        _summaryItem("❌ Absent", "4"),
      ],
    ),
  );

  Widget _summaryItem(String label, String value) => Column(
    children: [
      Text(
        value,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textMain,
        ),
      ),
      Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: AppColors.textSecondary,
        ),
      ),
    ],
  );
}