// screen/class_exam_timetable_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/controller/school_auth_controller.dart';
import '../../profile/controller/teacher_controller.dart';
import '../controller/exams_controller.dart';
import '../model/exams_table_model.dart';
import 'class_exam_timetable_form_screen.dart';
import 'class_exam_timetable_view_screen.dart';

// ==================== FILTER STATUS ====================
enum TimetableStatus { all, upcoming, running, completed }

extension TimetableStatusLabel on TimetableStatus {
  String get label {
    switch (this) {
      case TimetableStatus.all:
        return 'All';
      case TimetableStatus.upcoming:
        return 'Upcoming';
      case TimetableStatus.running:
        return 'Running';
      case TimetableStatus.completed:
        return 'Completed';
    }
  }

  IconData get icon {
    switch (this) {
      case TimetableStatus.all:
        return Icons.apps_rounded;
      case TimetableStatus.upcoming:
        return Icons.schedule_rounded;
      case TimetableStatus.running:
        return Icons.play_circle_outline_rounded;
      case TimetableStatus.completed:
        return Icons.check_circle_outline_rounded;
    }
  }

  Color get color {
    switch (this) {
      case TimetableStatus.all:
        return Colors.indigo;
      case TimetableStatus.upcoming:
        return Colors.blue;
      case TimetableStatus.running:
        return Colors.orange;
      case TimetableStatus.completed:
        return const Color(0xFF10B981);
    }
  }
}

class ClassExamTimetableListScreen extends StatefulWidget {
  const ClassExamTimetableListScreen({super.key});

  @override
  State<ClassExamTimetableListScreen> createState() => _ClassExamTimetableListScreenState();
}

class _ClassExamTimetableListScreenState extends State<ClassExamTimetableListScreen> {

  final authController = Get.find<SchoolAuthController>();
  // if(authController.userType!='student')
  // ==================== CONTROLLER ====================
  final ExamsController controller = Get.put(ExamsController());
  final TeacherController teacherController = Get.find<TeacherController>();


  // ==================== FILTER STATE ====================
  String? _selectedClass;
  int? _selectedMonth;
  int? _selectedYear;
  TimetableStatus _selectedStatus = TimetableStatus.all;

  static const List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  // ==================== INIT ====================
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchTimetables();
    });
  }

  // ==================== HELPERS ====================
  /// Shortcut to controller's observable list
  List<ClassExamTimetable> get _all => controller.timetables;

  List<String> get _availableClasses {
    final set = _all.map((t) => t.className).toSet().toList();
    set.sort();
    return set;
  }

  List<int> get _availableYears {
    final set = _all.map((t) => t.fromDate.year).toSet().toList();
    set.sort((a, b) => b.compareTo(a));
    return set;
  }

  List<int> get _availableMonths {
    final set = _all
        .where((t) =>
    _selectedYear == null || t.fromDate.year == _selectedYear)
        .map((t) => t.fromDate.month)
        .toSet()
        .toList();
    set.sort();
    return set;
  }

  List<ClassExamTimetable> get _filtered {
    final now = DateTime.now();
    return _all.where((t) {
      if (_selectedClass != null && t.className != _selectedClass) return false;
      if (_selectedYear != null && t.fromDate.year != _selectedYear) return false;
      if (_selectedMonth != null && t.fromDate.month != _selectedMonth) {
        return false;
      }
      if (_selectedStatus != TimetableStatus.all) {
        if (_computeStatus(t, now) != _selectedStatus) return false;
      }
      return true;
    }).toList();
  }

  TimetableStatus _computeStatus(ClassExamTimetable t, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final from = DateTime(t.fromDate.year, t.fromDate.month, t.fromDate.day);
    final to = DateTime(t.toDate.year, t.toDate.month, t.toDate.day);

    if (today.isBefore(from)) return TimetableStatus.upcoming;
    if (today.isAfter(to)) return TimetableStatus.completed;
    return TimetableStatus.running;
  }

  bool get _hasActiveFilter =>
      _selectedClass != null ||
          _selectedMonth != null ||
          _selectedYear != null ||
          _selectedStatus != TimetableStatus.all;

  void _clearFilters() {
    setState(() {
      _selectedClass = null;
      _selectedMonth = null;
      _selectedYear = null;
      _selectedStatus = TimetableStatus.all;
    });
  }

  Color _examColor(ExamType t) {
    switch (t) {
      case ExamType.board:
        return Colors.indigo;
      case ExamType.halfYearly:
        return Colors.blue;
      case ExamType.annual:
        return Colors.deepPurple;
      case ExamType.preBoard:
        return Colors.orange;
      case ExamType.unitTest:
        return Colors.teal;
    }
  }

  IconData _examIcon(ExamType t) {
    switch (t) {
      case ExamType.board:
        return Icons.workspace_premium_rounded;
      case ExamType.halfYearly:
        return Icons.calendar_view_month_rounded;
      case ExamType.annual:
        return Icons.event_available_rounded;
      case ExamType.preBoard:
        return Icons.assignment_turned_in_rounded;
      case ExamType.unitTest:
        return Icons.quiz_rounded;
    }
  }

  // ==================== CREATE ====================
  Future<void> _onCreateTapped() async {
    final result = await Navigator.push<ClassExamTimetable>(
      context,
      MaterialPageRoute(
        builder: (_) => const ClassExamTimetableFormScreen(),
      ),
    );

    if (result != null) {
      // Send to backend
      await controller.createTimetable(
        timetable: result,
        createdById: teacherController.teacherIdCard,
        createdByName: teacherController.fullName,
      );
    }
  }

  // ==================== VIEW ====================
  Future<void> _openTimetable(ClassExamTimetable t) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClassExamTimetableViewScreen(timetable: t),
      ),
    );

    if (result == 'deleted') {
      // Controller's timetables already updated by view screen
      setState(() {});
    }
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Exam Timetables',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
        actions: [
          if(authController.userType!='student')
          InkWell(
            onTap: _onCreateTapped,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 0.3),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Obx(() {
        // Loading state (first load only)
        if (controller.isLoading.value && controller.timetables.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.indigo),
          );
        }

        // Error state
        if (controller.errorMessage.isNotEmpty &&
            controller.timetables.isEmpty) {
          return _errorState(controller.errorMessage.value);
        }

        final filtered = _filtered;

        return RefreshIndicator(
          onRefresh: controller.refreshTimetables,
          color: Colors.indigo,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- FILTERS ----------
                _sectionTitle('Filters'),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _filterDropdown<String>(
                        hint: 'Class',
                        icon: Icons.class_rounded,
                        value: _selectedClass,
                        items: _availableClasses,
                        onChanged: (v) => setState(() => _selectedClass = v),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _filterDropdown<int>(
                        hint: 'Year',
                        icon: Icons.calendar_today_rounded,
                        value: _selectedYear,
                        items: _availableYears,
                        labelBuilder: (v) => '$v',
                        onChanged: (v) => setState(() {
                          _selectedYear = v;
                          if (_selectedMonth != null &&
                              !_availableMonths.contains(_selectedMonth)) {
                            _selectedMonth = null;
                          }
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                _filterDropdown<int>(
                  hint: 'Month',
                  icon: Icons.calendar_month_rounded,
                  value: _selectedMonth,
                  items: _availableMonths,
                  labelBuilder: (m) => _monthNames[m - 1],
                  onChanged: (v) => setState(() => _selectedMonth = v),
                ),
                const SizedBox(height: 12),

                _statusChips(),

                if (_hasActiveFilter) ...[
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.close_rounded,
                          size: 14, color: Colors.indigo),
                      label: const Text(
                        'Clear Filters',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // ---------- LIST HEADER ----------
                Row(
                  children: [
                    _sectionTitle('Timetables'),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${filtered.length}',
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ---------- LIST ----------
                if (filtered.isEmpty)
                  _noResults()
                else
                  ...filtered.map(
                        (t) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _timetableCard(t),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ==================== ERROR STATE ====================
  Widget _errorState(String error) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline_rounded,
                size: 40, color: Colors.red.shade400),
          ),
          const SizedBox(height: 14),
          Text(
            'Failed to load timetables',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red.shade700,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () => controller.fetchTimetables(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Retry',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    ),
  );

  // ==================== STATUS CHIPS ====================
  Widget _statusChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TimetableStatus.values.map((s) {
          final selected = _selectedStatus == s;
          final color = s.color;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedStatus = s),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? color : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? color : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(s.icon,
                        size: 14,
                        color: selected ? Colors.white : color),
                    const SizedBox(width: 6),
                    Text(
                      s.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==================== FILTER DROPDOWN ====================
  Widget _filterDropdown<T>({
    required String hint,
    required IconData icon,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    String Function(T)? labelBuilder,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey.shade400),
              const SizedBox(width: 8),
              Text(
                'All $hint',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.indigo),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w500),
          onChanged: onChanged,
          items: [
            DropdownMenuItem<T>(
              value: null,
              child: Row(
                children: [
                  Icon(icon, size: 16, color: Colors.grey.shade500),
                  const SizedBox(width: 8),
                  Text('All $hint',
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            ...items.map((it) {
              return DropdownMenuItem<T>(
                value: it,
                child: Row(
                  children: [
                    Icon(icon, size: 16, color: Colors.indigo),
                    const SizedBox(width: 8),
                    Text(labelBuilder != null
                        ? labelBuilder(it)
                        : it.toString()),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ==================== SECTION TITLE ====================
  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.black54,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  // ==================== TIMETABLE CARD ====================
  Widget _timetableCard(ClassExamTimetable t) {
    final examColor = _examColor(t.examType);
    final examIcon = _examIcon(t.examType);
    final status = _computeStatus(t, DateTime.now());
    final statusColor = status.color;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _openTimetable(t),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          examColor.withOpacity(0.15),
                          examColor.withOpacity(0.06),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      t.className,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: examColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Class ${t.className}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                            color: Color(0xFF1A1F36),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(examIcon, size: 13, color: examColor),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                t.examType.label,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: examColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        _statusPill(status, statusColor),
                      ],
                    ),
                  ),
                  _subjectBadge(t.schedules.length),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.date_range_rounded,
                        size: 15, color: Colors.indigo),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        t.formattedRange,
                        style: const TextStyle(
                          color: Color(0xFF1A1F36),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        size: 11, color: Colors.indigo),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusPill(TimetableStatus s, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(s.icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            s.label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 9.5,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _subjectBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.menu_book_rounded,
              size: 11, color: Color(0xFF10B981)),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: const TextStyle(
              color: Color(0xFF10B981),
              fontWeight: FontWeight.w800,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== NO RESULTS ====================
  Widget _noResults() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
    decoration: BoxDecoration(
      color: const Color(0xFFF9FAFC),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.10),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.filter_alt_off_rounded,
              size: 28, color: Colors.indigo),
        ),
        const SizedBox(height: 12),
        const Text(
          'No matching timetables',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: Color(0xFF1A1F36),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Try changing filters',
          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
        ),
      ],
    ),
  );
}