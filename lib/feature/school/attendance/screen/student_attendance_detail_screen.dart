// lib/feature/student_attendance/screen/student_attendance_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../controller/student_attendance_controller.dart';

class StudentAttendanceDetailScreen extends StatefulWidget {
  final String studentCardId;
  final String studentName;
  final String studentClass;

  const StudentAttendanceDetailScreen({
    super.key,
    required this.studentCardId,
    required this.studentName,
    required this.studentClass,
  });

  @override
  State<StudentAttendanceDetailScreen> createState() =>
      _StudentAttendanceDetailScreenState();
}

class _StudentAttendanceDetailScreenState
    extends State<StudentAttendanceDetailScreen> {
  final controller = Get.find<StudentAttendanceController>();

  int? selectedYear;
  String? selectedMonthName; // "September"

  List<int> availableYears = [];
  Map<int, List<String>> yearMonthsMap = {};

  Map<String, String> attendanceMap = {};

  bool isLoading = true;
  String errorMessage = '';

  static const Color _primary = Colors.indigo;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await controller.fetchStudentAttendance(widget.studentCardId);

      final data = controller.attendanceData.value;
      attendanceMap = {};
      yearMonthsMap = {};
      availableYears = [];

      if (data != null && data.history.isNotEmpty) {
        data.history.forEach((yearStr, months) {
          final year = int.tryParse(yearStr) ?? 0;
          if (year == 0) return;

          yearMonthsMap[year] = months.keys.toList();

          months.forEach((monthName, records) {
            for (final r in records) {
              attendanceMap[r.date] = r.attendanceStatus.toLowerCase();
            }
          });
        });

        availableYears = yearMonthsMap.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        if (availableYears.isNotEmpty) {
          selectedYear = availableYears.first;

          final months = yearMonthsMap[selectedYear] ?? [];
          if (months.isNotEmpty) {
            selectedMonthName = months.last; // last = latest
          }
        }
      }

      if (!mounted) return;
      setState(() => isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  // ==================== HELPERS ====================
  int _monthNumber(String monthName) {
    const map = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };
    return map[monthName] ?? 1;
  }

  int get _selectedMonthNumber =>
      selectedMonthName == null ? 1 : _monthNumber(selectedMonthName!);

  String _dateKey(int day) {
    final y = (selectedYear ?? 0).toString().padLeft(4, '0');
    final m = _selectedMonthNumber.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String? _statusForDay(int day) => attendanceMap[_dateKey(day)];

  int get _daysInMonth {
    if (selectedYear == null) return 30;
    return DateTime(selectedYear!, _selectedMonthNumber + 1, 0).day;
  }

  int get _firstWeekdayOffset {
    if (selectedYear == null) return 0;
    return DateTime(selectedYear!, _selectedMonthNumber, 1).weekday % 7;
  }

  Color _colorForStatus(String? status) {
    switch (status) {
      case 'present':
        return const Color(0xFF43A047);
      case 'absent':
        return const Color(0xFFEF5350);
      case 'leave':
        return const Color(0xFF5C6BC0);
      case 'half_day':
      case 'halfday':
      case 'half-day':
        return const Color(0xFFFFB74D);
      case 'running':
        return const Color(0xFF66BB6A);
      case 'week_off':
      case 'weekoff':
      case 'week-off':
      case 'holiday':
        return const Color(0xFFE0E0E0);
      default:
        return const Color(0xFFEF5350);
    }
  }

  bool _hasStatus(String? status) => status != null && status.isNotEmpty;

  /// 🔹 Year dropdown options
  List<DropdownMenuItem<int>> get _yearItems {
    return availableYears
        .map((y) => DropdownMenuItem<int>(
      value: y,
      child: Text(
        '$y',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    ))
        .toList();
  }

  /// 🔹 Month dropdown options (selectedYear के हिसाब से)
  List<DropdownMenuItem<String>> get _monthItems {
    if (selectedYear == null) return [];
    final months = yearMonthsMap[selectedYear] ?? [];
    return months
        .map((m) => DropdownMenuItem<String>(
      value: m,
      child: Text(
        m,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    ))
        .toList();
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
        ),
        title: const Text(
          'Attendance Detail',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? _buildError()
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    // ❌ अगर API में कोई data नहीं है
    if (availableYears.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              'No attendance records found',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStudentInfoCard(),
          const SizedBox(height: 12),
          _buildCalendarCard(),
          const SizedBox(height: 14),
          _buildLegendCard(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ==================== STUDENT INFO ====================
  Widget _buildStudentInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.indigo,width: 0.1)
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.studentName.isNotEmpty
                  ? widget.studentName[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.studentName,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  'ID: ${widget.studentCardId}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 1),
                Text(
                  'Class: ${widget.studentClass}th',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== CALENDAR CARD ====================
  Widget _buildCalendarCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo,width: 0.1)
      ),
      child: Column(
        children: [
          _buildCalendarHeader(),
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: _buildDaysGrid(),
          ),
        ],
      ),
    );
  }

  // ==================== HEADER — API based Year + Month dropdowns ====================
  Widget _buildCalendarHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      child: Row(
        children: [
          // Year dropdown
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: _primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _primary.withOpacity(0.2)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: selectedYear,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down,
                      color: _primary),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  items: _yearItems,
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() {
                      selectedYear = val;
                      final months = yearMonthsMap[val] ?? [];
                      if (months.isNotEmpty) {
                        selectedMonthName = months.last;
                      } else {
                        selectedMonthName = null;
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: _primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _primary.withOpacity(0.2)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedMonthName,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down,
                      color: _primary),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  items: _monthItems,
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => selectedMonthName = val);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== DAYS GRID ====================
  Widget _buildDaysGrid() {
    final daysInMonth = _daysInMonth;
    final offset = _firstWeekdayOffset;
    final today = DateTime.now();
    const weekHeaders = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Column(
      children: [
        // Weekday headers
        Row(
          children: List.generate(7, (i) {
            final isWeekend = i == 0 || i == 6;
            return Expanded(
              child: Center(
                child: Text(
                  weekHeaders[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isWeekend
                        ? const Color(0xFF5C6BC0)
                        : Colors.grey[700],
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),

        // Day cells
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: offset + daysInMonth,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 4,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            if (index < offset) return const SizedBox.shrink();

            final day = index - offset + 1;
            final status = _statusForDay(day);

            final isToday = selectedYear != null &&
                today.year == selectedYear &&
                today.month == _selectedMonthNumber &&
                today.day == day;

            return _dayCell(day, status, isToday);
          },
        ),
      ],
    );
  }

  Widget _dayCell(int day, String? status, bool isToday) {
    final hasStatus = _hasStatus(status);
    final cellColor = _colorForStatus(status);

    return Container(
      decoration: BoxDecoration(
        color: hasStatus ? cellColor : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: isToday && !hasStatus
            ? Border.all(color: _primary, width: 1.5)
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        '$day',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: hasStatus ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  // ==================== LEGEND CARD ====================
  Widget _buildLegendCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.indigo,width: 0.1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Legend',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 10,
            children: [
              _legendItem(color: Colors.grey.shade400, title: "Week Off"),
              _legendItem(color: const Color(0xFFEF5350), title: "Absent"),
              _legendItem(color: const Color(0xFF43A047), title: "Present"),
              _legendItem(color: const Color(0xFF66BB6A), title: "Running"),
              _legendItem(color: const Color(0xFFFFB74D), title: "Half Day"),
              _legendItem(color: const Color(0xFF5C6BC0), title: "Leave"),
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
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // ==================== ERROR ====================
  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 56, color: Colors.red[300]),
          const SizedBox(height: 10),
          Text(errorMessage,
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _fetchData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}