// screen/class_exam_timetable_view_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/exams_controller.dart';
import '../model/exams_table_model.dart';
import 'class_exam_timetable_form_screen.dart';

class ClassExamTimetableViewScreen extends StatefulWidget {
  final ClassExamTimetable timetable;

  const ClassExamTimetableViewScreen({super.key, required this.timetable});

  @override
  State<ClassExamTimetableViewScreen> createState() =>
      _ClassExamTimetableViewScreenState();
}

class _ClassExamTimetableViewScreenState
    extends State<ClassExamTimetableViewScreen> {
  final ExamsController controller = Get.find<ExamsController>();
  late ClassExamTimetable _timetable;

  @override
  void initState() {
    super.initState();
    _timetable = widget.timetable;
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

  // ==================== EDIT (UPDATE API) ====================
  Future<void> _editTimetable() async {
    final result = await Navigator.push<ClassExamTimetable>(
      context,
      MaterialPageRoute(
        builder: (_) => ClassExamTimetableFormScreen(existing: _timetable),
      ),
    );

    if (result == null || !mounted) return;

    // Push update to backend
    final updated = await controller.updateTimetable(
      id: _timetable.id!,
      timetable: result,
    );

    if (updated != null && mounted) {
      setState(() => _timetable = updated);
      HapticFeedback.lightImpact();
      // Controller shows the toast — no need for extra snackbar
    }
  }

  // ==================== DELETE (DELETE API) ====================
  Future<void> _confirmDeleteTimetable() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text("Delete Timetable?"),
        content: Text(
            "This will permanently delete the timetable for Class ${_timetable.className}. This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;

    // Delete on backend
    final deleted = await controller.deleteTimetable(_timetable.id!);

    if (deleted && mounted) {
      HapticFeedback.heavyImpact();
      Navigator.pop(context, 'deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [..._timetable.schedules]
      ..sort((a, b) => a.date.compareTo(b.date));
    final examColor = _examColor(_timetable.examType);
    final examIcon = _examIcon(_timetable.examType);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Class ${_timetable.className}',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
        actions: [
          InkWell(
            onTap: _editTimetable,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 0.3),
              ),
              child: const Icon(Icons.edit_outlined,
                  color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width:10),
          InkWell(
            onTap: _confirmDeleteTimetable,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 0.3),
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerCard(examColor, examIcon),
            const SizedBox(height: 20),
            _sectionTitle('Exam Schedule', count: _timetable.schedules.length),
            const SizedBox(height: 10),
            if (sorted.isEmpty) _emptyScheduleState() else _scheduleTable(sorted),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ==================== EMPTY STATE ====================
  Widget _emptyScheduleState() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
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
          child: const Icon(Icons.event_busy_rounded,
              size: 28, color: Colors.indigo),
        ),
        const SizedBox(height: 12),
        const Text(
          'No subjects in this timetable',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: Color(0xFF1A1F36),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tap the edit icon to add subjects',
          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
        ),
      ],
    ),
  );

  // ==================== HEADER ====================
  Widget _headerCard(Color examColor, IconData examIcon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.indigo, Color(0xFF5C6BC0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(examIcon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _timetable.examType.label.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'EXAM TIME TABLE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _infoRow('Class', _timetable.className),
          const SizedBox(height: 5),
          _infoRow('Duration', _timetable.formattedRange),
          const SizedBox(height: 5),
          _infoRow('Total Subjects', '${_timetable.schedules.length}'),
          if (_timetable.createdByName != null &&
              _timetable.createdByName!.isNotEmpty) ...[
            const SizedBox(height: 5),
            _infoRow('Created By', _timetable.createdByName!),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            '$label:',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== SECTION TITLE ====================
  Widget _sectionTitle(String title, {int? count}) {
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
        if (count != null) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ==================== SCHEDULE TABLE ====================
  Widget _scheduleTable(List<SubjectSchedule> sorted) {
    const double wSr = 40;
    const double wSubject = 110;
    const double wDate = 100;
    const double wTime = 110;
    const double wInvigilator = 110;
    const double wRoom = 80;
    const double rowH = 52;

    final bs = BorderSide(color: Colors.grey.shade300, width: 1);

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
                    _headCell('Room', wRoom, bs, isLast: true),
                  ],
                ),
              ),
              ...List.generate(sorted.length, (i) {
                final s = sorted[i];
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
                        isLast: true,
                        child: Text(
                          s.room,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1A1F36),
                          ),
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
}