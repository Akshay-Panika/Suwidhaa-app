// lib/feature/student_attendance/screen/student_attendance_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart'; // ✅ Shimmer Import
import 'package:untitled/core/widget/flutter_toast.dart';

import '../controller/student_attendance_controller.dart';
import '../model/student_attendance_model.dart';

class StudentAttendanceDetailScreen extends StatefulWidget {
  final int studentId;
  final String studentCardId;
  final String studentName;
  final String studentClass;

  const StudentAttendanceDetailScreen({
    super.key,
    required this.studentId,
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

  // ✅ Controller for Remarks
  final TextEditingController remarksController = TextEditingController();

  int? selectedYear;
  String? selectedMonthName;

  List<int> availableYears = [];
  Map<int, List<String>> yearMonthsMap = {};

  // ✅ Map to store full AttendanceRecord so we get remarks
  Map<String, AttendanceRecord> attendanceMap = {};

  bool isLoading = true;
  bool isSaving = false;
  String errorMessage = '';

  DateTime? selectedDateForMarking;
  String? currentSelectedStatus; // ✅ Track selected status in bottom sheet

  static const Color _primary = Colors.indigo;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await controller.fetchStudentAttendance(studentId: widget.studentId);
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
              // ✅ Store full record
              attendanceMap[r.date] = r;
            }
          });
        });
      }

      // Ensure Current Year & Month exist
      final now = DateTime.now();
      final currentYear = now.year;
      final currentMonthName = DateFormat('MMMM').format(now);

      if (!yearMonthsMap.containsKey(currentYear)) {
        yearMonthsMap[currentYear] = [];
      }
      if (!yearMonthsMap[currentYear]!.contains(currentMonthName)) {
        yearMonthsMap[currentYear]!.add(currentMonthName);
        yearMonthsMap[currentYear]!
            .sort((a, b) => _monthNumber(a).compareTo(_monthNumber(b)));
      }

      availableYears = yearMonthsMap.keys.toList()..sort((a, b) => b.compareTo(a));

      if (availableYears.isNotEmpty) {
        selectedYear =
        availableYears.contains(currentYear) ? currentYear : availableYears.first;
        final months = yearMonthsMap[selectedYear] ?? [];
        if (months.isNotEmpty) {
          selectedMonthName =
          months.contains(currentMonthName) ? currentMonthName : months.last;
        }
      }

      if (!mounted) return;
      setState(() => isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  // ==================== SAVE ATTENDANCE ====================
  Future<void> _saveAttendance(String status) async {
    if (selectedDateForMarking == null) return;

    setState(() => isSaving = true);

    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDateForMarking!);
    final remarks = remarksController.text.trim(); // ✅ Get remarks text

    try {
      final item = StudentAttendanceItem(
        studentId: widget.studentId,
        date: dateStr,
        attendanceStatus: status,
        remarks: remarks, // ✅ Pass remarks to API
      );

      final success = await controller.submitBulkAttendance([item]);

      if (success) {
        FlutterToast.success('Attendance saved for $dateStr');
        Get.back(); // Close Bottom Sheet
        selectedDateForMarking = null;
        currentSelectedStatus = null;
        remarksController.clear();

        await _fetchData(); // Reload to show updated data
      }
    } catch (e) {
      FlutterToast.error('Error: ${e.toString()}');
    } finally {
      setState(() => isSaving = false);
    }
  }

  // ==================== SHOW MARK ATTENDANCE SHEET (UPDATED DESIGN) ====================
  void _showMarkAttendanceSheet(DateTime date) {
    if (date.isAfter(DateTime.now())) {
      FlutterToast.warning('Cannot mark attendance for future dates');
      return;
    }

    setState(() => selectedDateForMarking = date);

    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final existingRecord = attendanceMap[dateStr];

    // Set current state from existing record
    currentSelectedStatus = existingRecord?.attendanceStatus.toLowerCase();
    remarksController.text = existingRecord?.remarks ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // ✅ Transparent for rounded shape
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Drag Handle
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Title & Date Info
                  const Text(
                    'Mark Attendance',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        widget.studentName,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        dateStr,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ✅ Status Buttons
                  Row(
                    children: [
                      _buildStatusOption('Present', Colors.green, Icons.check_circle_rounded, setModalState),
                      const SizedBox(width: 10),
                      _buildStatusOption('Absent', Colors.red, Icons.cancel_rounded, setModalState),
                      const SizedBox(width: 10),
                      _buildStatusOption('Leave', Colors.orange, Icons.beach_access_rounded, setModalState),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ✅ Remarks Input Field
                  const Text(
                    'Remarks (Optional)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: remarksController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Write something about this attendance...',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      prefixIcon: const Icon(Icons.edit_note, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _primary, width: 1.5),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ✅ Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: (currentSelectedStatus == null || isSaving)
                          ? null
                          : () => _saveAttendance(currentSelectedStatus!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: isSaving
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                          : const Text(
                        'Save Attendance',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ✅ Status Option Widget (Improved Design)
  Widget _buildStatusOption(String status, Color color, IconData icon, StateSetter setModalState) {
    final isSelected = currentSelectedStatus == status.toLowerCase();

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setModalState(() {
            currentSelectedStatus = status.toLowerCase();
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : color.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: isSelected
                ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                : [],
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : color, size: 28),
              const SizedBox(height: 8),
              Text(
                status,
                style: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== HELPERS ====================
  int _monthNumber(String monthName) {
    const map = {
      'January': 1, 'February': 2, 'March': 3, 'April': 4,
      'May': 5, 'June': 6, 'July': 7, 'August': 8,
      'September': 9, 'October': 10, 'November': 11, 'December': 12,
    };
    return map[monthName] ?? 1;
  }

  int get _selectedMonthNumber => selectedMonthName == null ? 1 : _monthNumber(selectedMonthName!);

  String _dateKey(int day) {
    final y = (selectedYear ?? 0).toString().padLeft(4, '0');
    final m = _selectedMonthNumber.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  AttendanceRecord? _recordForDay(int day) => attendanceMap[_dateKey(day)];
  String? _statusForDay(int day) => _recordForDay(day)?.attendanceStatus.toLowerCase();

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
      case 'present': return const Color(0xFF43A047);
      case 'absent': return const Color(0xFFEF5350);
      case 'leave': return const Color(0xFF5C6BC0);
      case 'half_day':
      case 'halfday':
      case 'half-day': return const Color(0xFFFFB74D);
      case 'running': return const Color(0xFF66BB6A);
      case 'week_off':
      case 'weekoff':
      case 'week-off':
      case 'holiday': return const Color(0xFFE0E0E0);
      default: return Colors.transparent;
    }
  }

  bool _hasStatus(String? status) => status != null && status.isNotEmpty;

  List<DropdownMenuItem<int>> get _yearItems {
    return availableYears.map((y) => DropdownMenuItem<int>(
        value: y,
        child: Text('$y', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87))
    )).toList();
  }

  List<DropdownMenuItem<String>> get _monthItems {
    if (selectedYear == null) return [];
    final months = yearMonthsMap[selectedYear] ?? [];
    return months.map((m) => DropdownMenuItem<String>(
        value: m,
        child: Text(m, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87))
    )).toList();
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        ),
        title: const Text('Attendance Detail', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: false,
      ),
      body: isLoading
          ? _buildShimmerLoading() // ✅ Shimmer Effect Added
          : errorMessage.isNotEmpty
          ? _buildError()
          : _buildBody(),
    );
  }

  // ✅ Shimmer Loading Widget
  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Info Card Skeleton
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Container(width: 54, height: 54, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 150, height: 16, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(width: 100, height: 12, color: Colors.white),
                      const SizedBox(height: 6),
                      Container(width: 80, height: 12, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 2. Calendar Card Skeleton
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(child: Container(height: 40, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)))),
                      const SizedBox(width: 8),
                      Expanded(flex: 2, child: Container(height: 40, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // 7x5 Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 35,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 4, childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 3. Legend Card Skeleton
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 80, height: 16, color: Colors.white),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 10,
                    children: List.generate(4, (index) => Container(width: 70, height: 20, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
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

  Widget _buildStudentInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.indigo, width: 0.1)),
      child: Row(
        children: [
          Container(
            width: 54, height: 54,
            decoration: BoxDecoration(color: _primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: Text(widget.studentName.isNotEmpty ? widget.studentName[0].toUpperCase() : '?', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.studentName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text('ID: ${widget.studentCardId}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 1),
                Text('Class: ${widget.studentClass}th', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.indigo, width: 0.1)),
      child: Column(
        children: [
          _buildCalendarHeader(),
          const Divider(height: 1, thickness: 1),
          Padding(padding: const EdgeInsets.all(12), child: _buildDaysGrid()),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: _primary.withOpacity(0.06), borderRadius: BorderRadius.circular(10), border: Border.all(color: _primary.withOpacity(0.2))),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: selectedYear,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: _primary),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
                  items: _yearItems,
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() {
                      selectedYear = val;
                      final months = yearMonthsMap[val] ?? [];
                      selectedMonthName = months.isNotEmpty ? months.last : null;
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
              decoration: BoxDecoration(color: _primary.withOpacity(0.06), borderRadius: BorderRadius.circular(10), border: Border.all(color: _primary.withOpacity(0.2))),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedMonthName,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: _primary),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
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

  Widget _buildDaysGrid() {
    final daysInMonth = _daysInMonth;
    final offset = _firstWeekdayOffset;
    final today = DateTime.now();
    const weekHeaders = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Column(
      children: [
        Row(
          children: List.generate(7, (i) {
            final isWeekend = i == 0 || i == 6;
            return Expanded(
              child: Center(
                child: Text(weekHeaders[i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isWeekend ? const Color(0xFF5C6BC0) : Colors.grey[700])),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: offset + daysInMonth,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 4, childAspectRatio: 1),
          itemBuilder: (context, index) {
            if (index < offset) return const SizedBox.shrink();

            final day = index - offset + 1;
            final record = _recordForDay(day);
            final status = record?.attendanceStatus.toLowerCase();
            final date = DateTime(selectedYear!, _selectedMonthNumber, day);

            final isToday = today.year == selectedYear && today.month == _selectedMonthNumber && today.day == day;

            return _dayCell(date, day, status, record?.remarks, isToday);
          },
        ),
      ],
    );
  }

  Widget _dayCell(DateTime date, int day, String? status, String? remarks, bool isToday) {
    final hasStatus = _hasStatus(status);
    final cellColor = _colorForStatus(status);

    // ✅ Show a tiny dot if remarks exist
    final hasRemarks = remarks != null && remarks.isNotEmpty;

    return GestureDetector(
      onTap: () => _showMarkAttendanceSheet(date),
      child: Container(
        decoration: BoxDecoration(
          color: hasStatus ? cellColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isToday && !hasStatus ? Border.all(color: _primary, width: 1.5) : null,
        ),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
                '$day',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: hasStatus ? Colors.white : Colors.black87
                )
            ),
            if (hasRemarks)
              Positioned(
                bottom: 4,
                child: Container(
                  width: 4, height: 4,
                  decoration: BoxDecoration(
                    color: hasStatus ? Colors.white : Colors.black54,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.indigo, width: 0.1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Legend', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 10,
            children: [
              _legendItem(color: Colors.grey.shade400, title: "Week Off"),
              _legendItem(color: const Color(0xFFEF5350), title: "Absent"),
              _legendItem(color: const Color(0xFF43A047), title: "Present"),
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
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 6),
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
      ],
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 56, color: Colors.red[300]),
          const SizedBox(height: 10),
          Text(errorMessage, style: TextStyle(color: Colors.grey[700], fontSize: 12), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _fetchData, child: const Text('Retry')),
        ],
      ),
    );
  }
}