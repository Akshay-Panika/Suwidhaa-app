// lib/feature/school/homework/screen/student_homework_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../student/controller/student_list_controller.dart';
import '../../student/model/student_list_model.dart';
import '../../profile/controller/student_controller.dart';
import '../controller/homework_controller.dart';
import '../model/homework_model.dart';

class StudentHomeworkScreen extends StatefulWidget {
  const StudentHomeworkScreen({super.key});

  @override
  State<StudentHomeworkScreen> createState() => _StudentHomeworkScreenState();
}

class _StudentHomeworkScreenState extends State<StudentHomeworkScreen> {
  final studentController = Get.find<StudentController>();
  final hwController = Get.find<HomeworkController>();
  final studentListController = Get.find<StudentListController>();

  late final String studentId;
  late final String studentName;
  late final String studentSchool;
  late final String studentClass;

  final RxBool _localLoading = true.obs;

  // ── Filter state ──
  String _statusFilter = 'All';
  DateTime? _dateFilter;

  final List<HomeworkModel> _allHomework = [];

  @override
  void initState() {
    super.initState();

    studentId = studentController.studentIdCard;
    studentName = studentController.fullName;
    studentSchool = studentController.schoolType;
    studentClass = studentController.studentClass;

    hwController.homeworkList.clear();
    // ✅ Set initial loading
    _localLoading.value = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  Future<void> _load() async {
    // ✅ Start loading
    _localLoading.value = true;

    try {
      // 1. Load homework for my class
      await hwController.fetchHomeworkByClass(
        schoolType: studentSchool,
        className: studentClass,
      );

      // 2. Load students for name/photo lookup
      if (studentSchool.isNotEmpty) {
        await studentListController.loadStudentListBySchoolType(studentSchool);
      }

      // 3. Filter my homework
      _allHomework
        ..clear()
        ..addAll(
          hwController.homeworkList.where(
                (hw) => hw.studentIdsList.any(
                  (e) => e.studentIdcard == studentId,
            ),
          ),
        );

      // 4. Apply filters
      _applyFilters();
    } finally {
      // ✅ Stop loading (always)
      _localLoading.value = false;
    }
  }

  // ── Match a homework entry's studentIdCard with loaded students ──
  StudentListData? _findStudent(String idCard) {
    for (final s in studentListController.studentList) {
      if (s.studentIdCard == idCard) return s;
    }
    return null;
  }

  void _applyFilters() {
    List<HomeworkModel> filtered = List.from(_allHomework);

    if (_statusFilter == 'Complete') {
      filtered = filtered.where((hw) => _myStatus(hw) == true).toList();
    } else if (_statusFilter == 'Incomplete') {
      filtered = filtered.where((hw) => _myStatus(hw) == false).toList();
    }

    if (_dateFilter != null) {
      filtered = filtered.where((hw) {
        final d = DateTime.tryParse(hw.endDate ?? '');
        if (d == null) return false;
        return d.year == _dateFilter!.year &&
            d.month == _dateFilter!.month &&
            d.day == _dateFilter!.day;
      }).toList();
    }

    hwController.homeworkList.assignAll(filtered);
  }

  bool? _myStatus(HomeworkModel hw) {
    for (final e in hw.studentIdsList) {
      if (e.studentIdcard == studentId) return e.status;
    }
    return null;
  }

  bool get _hasActiveFilters =>
      _statusFilter != 'All' || _dateFilter != null;

  void _clearFilters() {
    setState(() {
      _statusFilter = 'All';
      _dateFilter = null;
    });
    _applyFilters();
  }

  Future<void> _pickDateFilter() async {
    final now = DateTime.now();
    DateTime temp = _dateFilter ?? now;

    await showModalBottomSheet<DateTime?>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded,
                        color: Colors.indigo, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Filter by Due Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close_rounded, size: 20),
                    ),
                  ],
                ),
                const Divider(height: 1),
                const SizedBox(height: 8),
                SizedBox(
                  height: 320,
                  child: CalendarDatePicker(
                    initialDate: temp,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    onDateChanged: (d) => setModal(() => temp = d),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _dateFilter = null);
                          _applyFilters();
                          Navigator.pop(ctx);
                        },
                        style: OutlinedButton.styleFrom(
                          padding:
                          const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _dateFilter = temp);
                          _applyFilters();
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding:
                          const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Apply',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _subjectColor(String? s) {
    if (s == null) return Colors.indigo;
    const colors = [
      Colors.indigo,
      Colors.teal,
      Colors.deepOrange,
      Colors.purple,
      Colors.blue,
      Colors.green,
    ];
    return colors[s.hashCode.abs() % colors.length];
  }

  String _fmtDate(String? raw) {
    if (raw == null || raw.isEmpty) return '-';
    final d = DateTime.tryParse(raw);
    if (d == null) return raw;
    return DateFormat('dd MMM yyyy').format(d);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          'My Homework',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildFilterBar(),
            Expanded(
              child: Obx(() {
                if (_localLoading.value || hwController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (hwController.errorMessage.value.isNotEmpty) {
                  return _buildErrorState(hwController.errorMessage.value);
                }

                final list = hwController.homeworkList;
                if (list.isEmpty) {
                  return _allHomework.isEmpty
                      ? _buildEmptyState()
                      : _buildNoMatchState();
                }

                return RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                    itemCount: list.length,
                    itemBuilder: (_, i) =>
                        _buildHomeworkCard(context, list[i]),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  // Filter Bar
  // ══════════════════════════════════════════════════════
  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune_rounded, size: 16, color: Colors.indigo),
              const SizedBox(width: 6),
              const Text(
                'Filters',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                  letterSpacing: 0.3,
                ),
              ),
              const Spacer(),
              if (_hasActiveFilters)
                GestureDetector(
                  onTap: _clearFilters,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close_rounded,
                            size: 12, color: Colors.red),
                        SizedBox(width: 3),
                        Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip(
                  label: 'All',
                  icon: Icons.list_alt_rounded,
                  selected: _statusFilter == 'All',
                  color: Colors.indigo,
                  onTap: () {
                    setState(() => _statusFilter = 'All');
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 8),
                _filterChip(
                  label: 'Pending',
                  icon: Icons.hourglass_bottom_rounded,
                  selected: _statusFilter == 'Incomplete',
                  color: Colors.orange,
                  onTap: () {
                    setState(() => _statusFilter = 'Incomplete');
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 8),
                _filterChip(
                  label: 'Completed',
                  icon: Icons.check_circle_rounded,
                  selected: _statusFilter == 'Complete',
                  color: Colors.green,
                  onTap: () {
                    setState(() => _statusFilter = 'Complete');
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 8),
                _filterChip(
                  label: _dateFilter == null
                      ? 'Date'
                      : DateFormat('dd MMM').format(_dateFilter!),
                  icon: Icons.calendar_today_rounded,
                  selected: _dateFilter != null,
                  color: Colors.deepPurple,
                  onTap: _pickDateFilter,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required IconData icon,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? color : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: selected ? Colors.white : color,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: selected ? Colors.white : Colors.grey.shade800,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  // Homework Card
  // ══════════════════════════════════════════════════════
  Widget _buildHomeworkCard(BuildContext context, HomeworkModel hw) {
    final subjectColor = _subjectColor(hw.subjectName);
    final hasImage = hw.image != null && hw.image!.isNotEmpty;
    final completed = _myStatus(hw) == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: completed ? Colors.green : Colors.grey,width: 0.3
        ),

      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _showHomeworkDetails(hw),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 84,
                        height: 84,
                        child: hasImage
                            ? Image.network(
                          hw.image!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: subjectColor.withOpacity(0.1),
                              child: Center(
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: subjectColor,
                                  ),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => Container(
                            color: subjectColor.withOpacity(0.12),
                            child: Icon(
                              Icons.menu_book_sharp,
                              color: subjectColor,
                              size: 28,
                            ),
                          ),
                        )
                            : Container(
                          color: subjectColor.withOpacity(0.12),
                          child: Icon(
                            Icons.menu_book_sharp,
                            color: subjectColor,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  hw.subjectName ?? '-',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              _statusChip(completed: completed),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            hw.subjectTopic ?? '-',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.event_rounded,
                                  size: 12, color: Colors.grey[500]),
                              const SizedBox(width: 3),
                              Text(
                                'Due: ${_fmtDate(hw.endDate)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(height: 1, color: Colors.grey.shade200),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person_rounded,
                        size: 13, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        hw.teacherName ?? 'Teacher',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _statusChip({
    required bool completed,
  }) {
    final Color color = completed ? Colors.green : Colors.orange;
    final String text = completed ? 'Completed' : 'Pending';
    final IconData icon = completed
        ? Icons.check_circle_rounded
        : Icons.pending_actions_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  // ══════════════════════════════════════════════════════
  // Details Bottom Sheet
  // ══════════════════════════════════════════════════════
  void _showHomeworkDetails(HomeworkModel hw) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: ListView(
            controller: scrollCtrl,
            padding: const EdgeInsets.all(18),
            children: [
              Center(
                child: Container(
                  width: 45,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                      _subjectColor(hw.subjectName).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.menu_book_sharp,
                      color: _subjectColor(hw.subjectName),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hw.subjectName ?? '-',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          hw.subjectTopic ?? '-',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _detailTile(
                icon: Icons.event_available_rounded,
                label: 'Issue Date',
                value: _fmtDate(hw.issueDate),
              ),
              _detailTile(
                icon: Icons.event_busy_rounded,
                label: 'Due Date',
                value: _fmtDate(hw.endDate),
              ),
              _detailTile(
                icon: Icons.class_rounded,
                label: 'Class',
                value: hw.className ?? '-',
              ),
              _detailTile(
                icon: Icons.person_rounded,
                label: 'Teacher',
                value: hw.teacherName ?? '-',
              ),
              _detailTile(
                icon: Icons.school_rounded,
                label: 'School Type',
                value: hw.schoolType ?? '-',
              ),

              const SizedBox(height: 16),
              const Text(
                'Students',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),

              if (hw.studentIdsList.isEmpty)
                const Text(
                  'No students assigned',
                  style: TextStyle(color: Colors.grey),
                )
              else
                ...hw.studentIdsList.map((entry) {
                  // ✅ Match against loaded students
                  final student = _findStudent(entry.studentIdcard);
                  final isMe = entry.studentIdcard == studentId;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.indigo.withOpacity(0.06)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isMe
                            ? Colors.indigo.withOpacity(0.3)
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        // ── Avatar ──
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: isMe
                              ? Colors.indigo.withOpacity(0.15)
                              : Colors.grey.shade200,
                          backgroundImage: (student?.studentProfile != null &&
                              student!.studentProfile!.isNotEmpty)
                              ? NetworkImage(student.studentProfile!)
                              : null,
                          child: (student?.studentProfile == null ||
                              student!.studentProfile!.isEmpty)
                              ? Text(
                            student != null &&
                                student.fullName.isNotEmpty
                                ? student.fullName
                                .substring(0, 1)
                                .toUpperCase()
                                : '?',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isMe
                                  ? Colors.indigo
                                  : Colors.grey.shade600,
                            ),
                          )
                              : null,
                        ),
                        const SizedBox(width: 10),

                        // ── Name + ID + class ──
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      student?.fullName ??
                                          entry.studentIdcard,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isMe
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        color: isMe
                                            ? Colors.indigo
                                            : Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isMe) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius:
                                        BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'YOU',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  // ID chip
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo
                                          .withOpacity(0.1),
                                      borderRadius:
                                      BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.badge_rounded,
                                          size: 9,
                                          color: Colors.indigo,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          entry.studentIdcard,
                                          style: const TextStyle(
                                            fontSize: 9,
                                            color: Colors.indigo,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Class chip
                                  if (student != null &&
                                      student.studentClass.isNotEmpty) ...[
                                    const SizedBox(width: 5),
                                    Container(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: Colors.orange
                                            .withOpacity(0.12),
                                        borderRadius:
                                        BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        "Class ${student.studentClass.replaceAll('Class ', '')}",
                                        style: TextStyle(
                                          fontSize: 9,
                                          color:
                                          Colors.orange.shade800,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),

                        // ── Status chip ──
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: (entry.status
                                ? Colors.green
                                : Colors.orange)
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            entry.status ? 'Done' : 'Pending',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: entry.status
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

              const SizedBox(height: 16),

              if ((hw.image ?? '').isNotEmpty) ...[
                const Text(
                  'Attachment',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _showFullImage(hw.image!),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      hw.image!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, p) => p == null
                          ? child
                          : Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(
                            child: CircularProgressIndicator()),
                      ),
                      errorBuilder: (_, __, ___) => Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.error_outline,
                              color: Colors.grey, size: 36),
                        ),
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.indigo),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullImage(String url) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Image.network(url, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 22),
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: true,
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
              color: Colors.indigo.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.inbox_rounded,
                size: 56, color: Colors.indigo),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Homework Assigned',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Check back later for new homework',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Refresh'),
            style: OutlinedButton.styleFrom(
              padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoMatchState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.filter_alt_off_rounded,
                size: 56, color: Colors.orange),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Results',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No homework matches your filters',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.close_rounded, size: 18),
            label: const Text('Clear Filters'),
            style: OutlinedButton.styleFrom(
              padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 56, color: Colors.red),
            const SizedBox(height: 12),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}