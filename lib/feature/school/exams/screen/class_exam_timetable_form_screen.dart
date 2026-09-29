// screen/class_exam_timetable_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../profile/controller/teacher_controller.dart';
import '../model/exams_table_model.dart';

class ClassExamTimetableFormScreen extends StatefulWidget {
  final ClassExamTimetable? existing;
  const ClassExamTimetableFormScreen({super.key, this.existing});

  bool get isEdit => existing != null;

  @override
  State<ClassExamTimetableFormScreen> createState() =>
      _ClassExamTimetableFormScreenState();
}

class _ClassExamTimetableFormScreenState
    extends State<ClassExamTimetableFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // 👇 Teacher controller — list + school type
  final TeacherController teacherController = Get.find<TeacherController>();

  // ---- NULL by default ----
  String? _className;
  ExamType? _examType;

  DateTime? _fromDate;
  DateTime? _toDate;

  final List<SubjectSchedule> _schedules = [];

  bool _isSubmitting = false;
  bool _dirty = false;
  bool _teachersLoaded = false;

  final List<String> _classes = const [
    '6th', '7th', '8th', '9th', '10th', '11th', '12th',
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _className = _classes.contains(e.className) ? e.className : null;
      _examType = e.examType;
      _fromDate = e.fromDate;
      _toDate = e.toDate;
      _schedules.addAll(e.schedules);
    }

    // 👇 Load teachers (use current school type from teacherController)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTeachers();
    });
  }

  // ==================== LOAD TEACHERS ====================
  Future<void> _loadTeachers() async {
    // If already loaded, skip
    if (teacherController.teacherList.isNotEmpty) {
      if (mounted) setState(() => _teachersLoaded = true);
      return;
    }

    // Load using current schoolType (may be null = all)
    await teacherController.loadTeacherList();

    if (mounted) setState(() => _teachersLoaded = true);
  }

  // ==================== HELPERS ====================
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

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';

  /// Get teacher full names as a list of strings
  List<String> get _teacherNames {
    return teacherController.teacherList
        .map((t) => t.fullName)
        .where((n) => n.isNotEmpty)
        .toList();
  }

  // ==================== DATE PICK ====================
  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom
          ? (_fromDate ?? DateTime.now())
          : (_toDate ?? DateTime.now().add(const Duration(days: 30))),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
        _dirty = true;
      });
      HapticFeedback.selectionClick();
    }
  }

  // ==================== SUBJECT SHEET ====================
  Future<void> _addOrEditSubject({SubjectSchedule? existing, int? index}) async {
    if (!_teachersLoaded) {
      _showSnack('Teachers loading... please wait', isError: true);
      return;
    }

    if (_teacherNames.isEmpty) {
      _showSnack('No teachers available', isError: true);
      return;
    }

    final result = await showModalBottomSheet<SubjectSchedule>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SubjectFormSheet(
        initial: existing,
        teacherNames: _teacherNames, // 👈 pass dynamic list
      ),
    );

    if (result != null) {
      setState(() {
        if (index != null) {
          _schedules[index] = result;
        } else {
          _schedules.add(result);
        }
        _dirty = true;
      });
      HapticFeedback.lightImpact();
    }
  }

  // ==================== SUBMIT ====================
  void _submit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      HapticFeedback.heavyImpact();
      return;
    }
    if (_className == null) {
      _showSnack('Please select a class', isError: true);
      return;
    }
    if (_examType == null) {
      _showSnack('Please select an exam type', isError: true);
      return;
    }
    if (_fromDate == null || _toDate == null) {
      _showSnack('Please select exam duration', isError: true);
      return;
    }
    if (_schedules.isEmpty) {
      _showSnack('Kam se kam ek subject add karein', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);
    HapticFeedback.mediumImpact();

    final timetable = ClassExamTimetable(
      id: widget.existing?.id,
      className: _className!,
      examType: _examType!,
      fromDate: _fromDate!,
      toDate: _toDate!,
      schedules: List.from(_schedules),
      createdById: widget.existing?.createdById,
      createdByName: widget.existing?.createdByName,
    );

    Navigator.pop(context, timetable);
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
        isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<bool> _confirmDiscard() async {
    if (!_dirty || _isSubmitting) return true;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text("Discard changes?"),
        content: const Text(
            "You have unsaved changes. Are you sure you want to leave?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Keep editing"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Discard"),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    final examColor =
    _examType != null ? _examColor(_examType!) : Colors.indigo;

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final ok = await _confirmDiscard();
        if (ok && mounted) Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: () async {
              final ok = await _confirmDiscard();
              if (ok && mounted) Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, size: 20),
          ),
          title: Text(
            widget.isEdit ? "Edit Timetable" : "Create Timetable",
            style:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summaryBanner(examColor),
                const SizedBox(height: 20),

                // ---------- Class ----------
                _sectionTitle("Class"),
                const SizedBox(height: 10),
                _buildDropdown<String>(
                  hint: "Select Class",
                  icon: Icons.class_rounded,
                  value: _className,
                  items: _classes,
                  color: Colors.indigo,
                  onChanged: (v) => setState(() {
                    _className = v;
                    _dirty = true;
                  }),
                ),

                const SizedBox(height: 20),

                // ---------- Exam Type ----------
                _sectionTitle("Exam Type"),
                const SizedBox(height: 10),
                _buildDropdown<ExamType>(
                  hint: "Select Exam Type",
                  icon: _examType != null
                      ? _examIcon(_examType!)
                      : Icons.assignment_outlined,
                  value: _examType,
                  items: ExamType.values,
                  color: examColor,
                  labelBuilder: (t) => t.label,
                  onChanged: (v) => setState(() {
                    _examType = v;
                    _dirty = true;
                  }),
                ),

                const SizedBox(height: 20),

                // ---------- Exam Duration ----------
                _sectionTitle("Exam Duration"),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _dateField(
                        label: "From",
                        value: _fromDate,
                        onTap: () => _pickDate(true),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _dateField(
                        label: "To",
                        value: _toDate,
                        onTap: () => _pickDate(false),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ---------- Subjects Header ----------
                Row(
                  children: [
                    _sectionTitle("Subjects"),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_schedules.length}',
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const Spacer(),

                    // 👇 Teachers loading state
                    if (!_teachersLoaded)
                      const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.indigo,
                          ),
                        ),
                      ),

                    TextButton.icon(
                      onPressed:
                      _teachersLoaded ? () => _addOrEditSubject() : null,
                      icon: Icon(
                        Icons.add_rounded,
                        size: 18,
                        color: _teachersLoaded
                            ? Colors.indigo
                            : Colors.grey.shade400,
                      ),
                      label: Text(
                        "Add",
                        style: TextStyle(
                          color: _teachersLoaded
                              ? Colors.indigo
                              : Colors.grey.shade400,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                _schedules.isEmpty ? _emptySubjectState() : _subjectTable(),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  // ==================== SUMMARY BANNER ====================
  Widget _summaryBanner(Color color) {
    final hasClass = _className != null;
    final hasExam = _examType != null;
    final hasDates = _fromDate != null && _toDate != null;

    final title = (!hasClass && !hasExam)
        ? 'Set up your exam'
        : '${hasClass ? "Class $_className" : "Class -"}'
        ' • ${hasExam ? _examType!.label : "Exam Type -"}';

    final subtitle = hasDates
        ? '${_fmt(_fromDate!)}  →  ${_fmt(_toDate!)}'
        : 'Select class, exam type & dates';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.12), color.withOpacity(0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              hasExam
                  ? _examIcon(_examType!)
                  : Icons.playlist_add_check_rounded,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF1A1F36),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== EMPTY STATE ====================
  Widget _emptySubjectState() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 30),
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
          child: const Icon(Icons.playlist_add_rounded,
              size: 28, color: Colors.indigo),
        ),
        const SizedBox(height: 12),
        const Text(
          'No subjects added yet',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: Color(0xFF1A1F36),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tap "Add" to create schedule',
          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
        ),
      ],
    ),
  );

  // ==================== SUBJECT TABLE ====================
  Widget _subjectTable() {
    const double wSr = 40;
    const double wSubject = 110;
    const double wDate = 100;
    const double wTime = 110;
    const double wInvigilator = 110;
    const double wRoom = 80;
    const double wAction = 92;
    const double rowH = 52;

    BorderSide bs = BorderSide(color: Colors.grey.shade300, width: 1);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.indigo.withOpacity(0.08),
                child: Row(
                  children: [
                    _headCell('Sr', wSr, bs),
                    _headCell('Subject', wSubject, bs),
                    _headCell('Date', wDate, bs),
                    _headCell('Time', wTime, bs),
                    _headCell('Invigilator', wInvigilator, bs),
                    _headCell('Room', wRoom, bs),
                    _headCell('Action', wAction, bs, isLast: true),
                  ],
                ),
              ),
              ...List.generate(_schedules.length, (i) {
                final s = _schedules[i];
                final isEven = i.isEven;

                return Container(
                  color: isEven
                      ? Colors.white
                      : Colors.indigo.withOpacity(0.02),
                  child: Row(
                    children: [
                      _dataCell(
                        width: wSr,
                        height: rowH,
                        bs: bs,
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                            color: Color(0xFF1A1F36),
                          ),
                        ),
                      ),
                      _dataCell(
                        width: wSubject,
                        height: rowH,
                        bs: bs,
                        child: Text(
                          s.subject,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.5,
                            color: Color(0xFF1A1F36),
                          ),
                        ),
                      ),
                      _dataCell(
                        width: wDate,
                        height: rowH,
                        bs: bs,
                        child: Text(
                          s.formattedDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1A1F36),
                          ),
                        ),
                      ),
                      _dataCell(
                        width: wTime,
                        height: rowH,
                        bs: bs,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              s.startTime,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1F36),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                size: 12,
                                color: Colors.indigo,
                              ),
                            ),
                            Text(
                              s.endTime,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1F36),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _dataCell(
                        width: wInvigilator,
                        height: rowH,
                        bs: bs,
                        child: Text(
                          s.invigilator,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1A1F36),
                          ),
                        ),
                      ),
                      _dataCell(
                        width: wRoom,
                        height: rowH,
                        bs: bs,
                        child: Text(
                          s.room,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1A1F36),
                          ),
                        ),
                      ),
                      _dataCell(
                        width: wAction,
                        height: rowH,
                        bs: bs,
                        isLast: true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _rowAction(
                              Icons.edit_outlined,
                              Colors.blue,
                                  () => _addOrEditSubject(existing: s, index: i),
                            ),
                            const SizedBox(width: 4),
                            _rowAction(
                              Icons.delete_outline,
                              const Color(0xFFEF4444),
                                  () => setState(() {
                                _schedules.removeAt(i);
                                _dirty = true;
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headCell(String text, double width, BorderSide bs,
      {bool isLast = false}) {
    return Container(
      width: width,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          right: isLast ? BorderSide.none : bs,
          bottom: bs,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 12,
          color: Colors.indigo,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _dataCell({
    required double width,
    required double height,
    required BorderSide bs,
    required Widget child,
    bool isLast = false,
    Alignment alignment = Alignment.centerLeft,
  }) {
    return Container(
      width: width,
      height: height,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        border: Border(
          right: isLast ? BorderSide.none : bs,
          bottom: bs,
        ),
      ),
      child: child,
    );
  }

  Widget _rowAction(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  // ==================== DATE FIELD ====================
  Widget _dateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    final hasValue = value != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 13,
            color: hasValue ? Colors.black54 : Colors.grey.shade500,
          ),
          prefixIcon: Icon(
            Icons.calendar_today_rounded,
            size: 18,
            color: hasValue ? Colors.indigo : Colors.grey.shade400,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.indigo, width: 1.4),
          ),
        ),
        child: Text(
          hasValue ? _fmt(value) : 'Select date',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color:
            hasValue ? const Color(0xFF1A1F36) : Colors.grey.shade400,
          ),
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

  // ==================== DROPDOWN ====================
  Widget _buildDropdown<T>({
    required String hint,
    required IconData icon,
    required T? value,
    required List<T> items,
    required Color color,
    required ValueChanged<T?> onChanged,
    String Function(T)? labelBuilder,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
              const SizedBox(width: 10),
              Text(
                hint,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          icon:
          const Icon(Icons.arrow_drop_down_rounded, color: Colors.indigo),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w500),
          onChanged: onChanged,
          items: items.map((it) {
            return DropdownMenuItem<T>(
              value: it,
              child: Row(
                children: [
                  Icon(icon, size: 16, color: color),
                  const SizedBox(width: 10),
                  Text(labelBuilder != null
                      ? labelBuilder(it)
                      : it.toString()),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ==================== BOTTOM BAR ====================
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isSubmitting
                    ? null
                    : () async {
                  final ok = await _confirmDiscard();
                  if (ok && mounted) Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isSubmitting
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Icon(
                  widget.isEdit
                      ? Icons.check_rounded
                      : Icons.add_rounded,
                  size: 18,
                ),
                label: Text(
                  _isSubmitting
                      ? "Saving..."
                      : (widget.isEdit
                      ? "Update Timetable"
                      : "Save Timetable"),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== SUBJECT BOTTOM SHEET ====================
class _SubjectFormSheet extends StatefulWidget {
  final SubjectSchedule? initial;
  final List<String> teacherNames; // 👈 dynamic teacher list

  const _SubjectFormSheet({
    this.initial,
    required this.teacherNames,
  });

  @override
  State<_SubjectFormSheet> createState() => _SubjectFormSheetState();
}

class _SubjectFormSheetState extends State<_SubjectFormSheet> {
  final _key = GlobalKey<FormState>();

  // Subjects list (static — you can make dynamic later)
  static const List<String> _subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'Hindi',
    'History',
    'Geography',
    'Computer',
    'General',
  ];

  String? _selectedSubject;
  String? _selectedInvigilator;

  late TextEditingController _roomCtrl;
  late TextEditingController _startCtrl;
  late TextEditingController _endCtrl;

  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    final s = widget.initial;
    _selectedSubject = (s != null && _subjects.contains(s.subject))
        ? s.subject
        : null;

    // Match invigilator against the dynamic list
    _selectedInvigilator =
    (s != null && widget.teacherNames.contains(s.invigilator))
        ? s.invigilator
        : null;

    _roomCtrl = TextEditingController(text: s?.room ?? '');
    _startCtrl = TextEditingController(text: s?.startTime ?? '10:00');
    _endCtrl = TextEditingController(text: s?.endTime ?? '13:00');
    if (s != null) _date = s.date;
  }

  // ---- Subject color / icon per name ----
  Color _subjectColor(String s) {
    switch (s) {
      case 'Mathematics':
        return Colors.indigo;
      case 'Physics':
        return Colors.blue;
      case 'Chemistry':
        return Colors.deepPurple;
      case 'Biology':
        return Colors.green;
      case 'English':
        return Colors.orange;
      case 'Hindi':
        return Colors.brown;
      case 'History':
        return Colors.teal;
      case 'Geography':
        return Colors.cyan;
      case 'Computer':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  IconData _subjectIcon(String s) {
    switch (s) {
      case 'Mathematics':
        return Icons.calculate_rounded;
      case 'Physics':
        return Icons.science_rounded;
      case 'Chemistry':
        return Icons.biotech_rounded;
      case 'Biology':
        return Icons.eco_rounded;
      case 'English':
        return Icons.translate_rounded;
      case 'Hindi':
        return Icons.text_fields_rounded;
      case 'History':
        return Icons.history_edu_rounded;
      case 'Geography':
        return Icons.public_rounded;
      case 'Computer':
        return Icons.computer_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }

  // ---- Invigilator avatar color (hash-based) ----
  Color _invigilatorColor(String name) {
    final palette = [
      Colors.indigo,
      Colors.blue,
      Colors.deepPurple,
      Colors.green,
      Colors.orange,
      Colors.teal,
      Colors.brown,
      Colors.cyan,
      Colors.pink,
      Colors.blueGrey,
    ];
    final idx = name.hashCode.abs() % palette.length;
    return palette[idx];
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (d != null) {
      setState(() => _date = d);
      HapticFeedback.selectionClick();
    }
  }

  Future<void> _pickTime(TextEditingController ctrl) async {
    final parts = ctrl.text.split(':');
    final init = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 10,
      minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
    );
    final t = await showTimePicker(context: context, initialTime: init);
    if (t != null) {
      ctrl.text =
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
      HapticFeedback.selectionClick();
    }
  }

  void _save() {
    if (!_key.currentState!.validate()) {
      HapticFeedback.heavyImpact();
      return;
    }
    if (_selectedSubject == null) {
      _errorSnack('Please select a subject');
      return;
    }
    if (_selectedInvigilator == null) {
      _errorSnack('Please select an invigilator');
      return;
    }
    Navigator.pop(
      context,
      SubjectSchedule(
        subject: _selectedSubject!,
        date: _date,
        startTime: _startCtrl.text.trim(),
        endTime: _endCtrl.text.trim(),
        invigilator: _selectedInvigilator!,
        room: _roomCtrl.text.trim(),
      ),
    );
  }

  void _errorSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Form(
          key: _key,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.initial == null
                          ? Icons.add_circle_outline_rounded
                          : Icons.edit_outlined,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.initial == null ? 'Add Subject' : 'Edit Subject',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1F36),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Subject
              _sectionTitle('Subject'),
              const SizedBox(height: 10),
              _subjectDropdown(),

              const SizedBox(height: 16),

              // Invigilator (dynamic)
              _sectionTitle('Invigilator'),
              const SizedBox(height: 10),
              _invigilatorDropdown(),

              const SizedBox(height: 16),

              // Exam Date
              _sectionTitle('Exam Date'),
              const SizedBox(height: 10),
              _sheetDateField(),
              const SizedBox(height: 16),

              // Times
              _sectionTitle('Exam Time'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _sheetField(
                      controller: _startCtrl,
                      label: 'Start Time',
                      hint: '10:00',
                      icon: Icons.access_time_rounded,
                      readOnly: true,
                      onTap: () => _pickTime(_startCtrl),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _sheetField(
                      controller: _endCtrl,
                      label: 'End Time',
                      hint: '13:00',
                      icon: Icons.timer_outlined,
                      readOnly: true,
                      onTap: () => _pickTime(_endCtrl),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Room
              _sectionTitle('Room / Hall (Optional)'),
              const SizedBox(height: 10),
              _sheetField(
                controller: _roomCtrl,
                label: 'Room / Hall',
                hint: 'e.g. Hall-1',
                icon: Icons.meeting_room_outlined,
                validator: (v) =>
                v == null || v.isEmpty ? 'Room required' : null,
              ),
              const SizedBox(height: 22),

              ElevatedButton.icon(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                label: Text(
                  widget.initial == null ? 'Add Subject' : 'Update Subject',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Subject Dropdown ----------
  Widget _subjectDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSubject,
          isExpanded: true,
          hint: Row(
            children: [
              Icon(Icons.menu_book_rounded,
                  size: 16, color: Colors.grey.shade400),
              const SizedBox(width: 10),
              Text(
                'Select Subject',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          icon:
          const Icon(Icons.arrow_drop_down_rounded, color: Colors.indigo),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (v) => setState(() => _selectedSubject = v),
          items: _subjects.map((it) {
            return DropdownMenuItem<String>(
              value: it,
              child: Row(
                children: [
                  Icon(_subjectIcon(it), size: 16, color: _subjectColor(it)),
                  const SizedBox(width: 10),
                  Text(it),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ---------- Invigilator Dropdown (dynamic teachers) ----------
  Widget _invigilatorDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedInvigilator,
          isExpanded: true,
          hint: Row(
            children: [
              Icon(Icons.person_outline_rounded,
                  size: 16, color: Colors.grey.shade400),
              const SizedBox(width: 10),
              Text(
                'Select Invigilator',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          icon:
          const Icon(Icons.arrow_drop_down_rounded, color: Colors.indigo),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (v) => setState(() => _selectedInvigilator = v),
          items: widget.teacherNames.map((name) {
            final initial = name.trim().isNotEmpty
                ? name.trim().split(' ').last[0].toUpperCase()
                : '?';
            final color = _invigilatorColor(name);

            return DropdownMenuItem<String>(
              value: name,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: color.withOpacity(0.15),
                    child: Text(
                      initial,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

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

  Widget _sheetDateField() {
    return InkWell(
      onTap: _pickDate,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date',
          labelStyle: const TextStyle(fontSize: 13),
          prefixIcon: const Icon(Icons.calendar_today_rounded,
              size: 18, color: Colors.indigo),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.indigo, width: 1.4),
          ),
        ),
        child: Text(
          '${_date.day}-${_date.month}-${_date.year}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Color(0xFF1A1F36),
          ),
        ),
      ),
    );
  }

  Widget _sheetField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      textCapitalization: textCapitalization,
      validator: validator,
      style: const TextStyle(fontSize: 13, color: Color(0xFF1A1F36)),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
        labelStyle: const TextStyle(fontSize: 13),
        prefixIcon: Icon(icon, size: 18, color: Colors.indigo),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.indigo, width: 1.4),
        ),
      ),
    );
  }
}