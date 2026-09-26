import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:untitled/core/widget/flutter_toast.dart';

import '../../profile/controller/teacher_controller.dart';
import '../../student/controller/student_list_controller.dart';
import '../../student/model/student_list_model.dart';
import '../controller/report_card_controller.dart';
import '../model/report_card_model.dart';

// ==================== FILTER OPTIONS ====================
class ReportFilters {
  static const List<String> exams = [
    'Unit Test 1', 'Unit Test 2', 'Unit Test 3', 'Unit Test 4',
    'Half Yearly', 'Final Term', 'Mid Term', 'Quarterly', 'Other Test',
  ];
}

const List<String> kSubjects = [
  "Mathematics", "Science", "English", "Social Studies", "Computer",
];

Color gradeColor(String grade) {
  switch (grade) {
    case "A+":
    case "A":
      return Colors.green;
    case "B+":
    case "B":
      return Colors.blue;
    case "C":
    case "D":
      return Colors.orange;
    case "F":
      return Colors.red;
    default:
      return Colors.grey;
  }
}

String? _readString(dynamic v) {
  if (v == null) return null;
  if (v is String) return v;
  try {
    final inner = (v as dynamic).value;
    if (inner is String) return inner;
    if (inner != null) return inner.toString();
  } catch (_) {}
  try {
    return v.toString();
  } catch (_) {
    return null;
  }
}

// ============================================================
//                    LIST SCREEN
// ============================================================
class TeacherAssignReportScreen extends StatefulWidget {
  const TeacherAssignReportScreen({super.key});

  @override
  State<TeacherAssignReportScreen> createState() =>
      _TeacherAssignReportScreenState();
}

class _TeacherAssignReportScreenState extends State<TeacherAssignReportScreen> {
  final teacherController = Get.find<TeacherController>();
  final studentController = Get.find<StudentListController>();
  final reportController = Get.find<ReportCardController>();

  String _selectedClass = 'All Classes';
  String _selectedExam = 'All Exams';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadIfReady());
  }

  String? _resolveAdminId() {
    try {
      final fromCard = _readString(teacherController.teacherIdCard);
      if (fromCard != null && fromCard.trim().isNotEmpty) {
        return fromCard.trim();
      }
      final dynamic t = teacherController;
      final candidates = <dynamic>[
        (() { try { return (t as dynamic).adminId; } catch (_) { return null; } })(),
        (() { try { return (t as dynamic).idCard; } catch (_) { return null; } })(),
        (() { try { return (t as dynamic).userId; } catch (_) { return null; } })(),
      ];
      for (final c in candidates) {
        final s = _readString(c);
        if (s != null && s.trim().isNotEmpty) return s.trim();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  void _loadIfReady() {
    final adminId = _resolveAdminId();
    if (adminId != null && adminId.isNotEmpty) {
      reportController.loadReportCards(adminId);
    } else {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        final retry = _resolveAdminId();
        if (retry != null && retry.isNotEmpty) {
          reportController.loadReportCards(retry);
        }
      });
    }
  }

  List<ReportCardData> get _filteredReports {
    return reportController.reportCards.where((r) {
      final classOk = _selectedClass == 'All Classes' || r.className == _selectedClass;
      final examOk = _selectedExam == 'All Exams' || r.examName == _selectedExam;
      final dateOk = _selectedDate == null || _matchesDate(r.createdAt, _selectedDate!);
      return classOk && examOk && dateOk;
    }).toList();
  }

  bool _matchesDate(String iso, DateTime d) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return dt.year == d.year && dt.month == d.month && dt.day == d.day;
    } catch (_) {
      return false;
    }
  }

  bool get _hasFilter =>
      _selectedClass != 'All Classes' ||
          _selectedExam != 'All Exams' ||
          _selectedDate != null;

  void _resetFilters() {
    setState(() {
      _selectedClass = 'All Classes';
      _selectedExam = 'All Exams';
      _selectedDate = null;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    DateTime tempPicked = _selectedDate ?? now;

    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // drag handle
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // header
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded,
                            color: Colors.indigo, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Select Date',
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
                    // calendar
                    SizedBox(
                      height: 320,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Colors.indigo,
                            onPrimary: Colors.white,
                            onSurface: Colors.black87,
                          ),
                        ),
                        child: CalendarDatePicker(
                          initialDate: tempPicked,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          onDateChanged: (date) {
                            setModalState(() => tempPicked = date);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // actions
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              setState(() => _selectedDate = null);
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
                            onPressed: () =>
                                Navigator.pop(ctx, tempPicked),
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
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  String _fmtDate(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";

  Future<void> _openForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TeacherAssignReportFormScreen(),
      ),
    );
    final adminId = _resolveAdminId();
    if (adminId != null && adminId.isNotEmpty) {
      reportController.loadReportCards(adminId);
    }
    if (mounted) setState(() {});
  }

  String _resolveStudentName(ReportCardData r) {
    final match = studentController.studentList.firstWhereOrNull(
          (s) => s.studentIdCard == r.studentId,
    );
    if (match != null && match.fullName.trim().isNotEmpty) {
      return match.fullName;
    }
    return r.studentId;
  }

  int _resolveRoll(ReportCardData r) {
    final match = studentController.studentList.firstWhereOrNull(
          (s) => s.studentIdCard == r.studentId,
    );
    if (match != null) {
      return int.tryParse(match.rollNumber) ?? 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Assign Report Card",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _openForm),
        ],
      ),
      body: Obx(() {
        if (reportController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final classes = _uniqueClasses();

        return reportController.reportCards.isEmpty
            ? _emptyState()
            : Column(
          children: [
            _buildFilterBar(classes),
            Expanded(
              child: _filteredReports.isEmpty
                  ? _noResults()
                  : _buildList(),
            ),
          ],
        );
      }),
    );
  }

  List<String> _uniqueClasses() {
    final set = <String>{};
    for (final r in reportController.reportCards) {
      if (r.className.trim().isNotEmpty) set.add(r.className.trim());
    }
    if (set.isEmpty) {
      for (final s in studentController.studentList) {
        if (s.studentClass.trim().isNotEmpty) {
          set.add(s.studentClass.trim());
        }
      }
    }
    final list = set.toList();
    list.sort((a, b) {
      final na = int.tryParse(a);
      final nb = int.tryParse(b);
      if (na != null && nb != null) return na.compareTo(nb);
      return a.compareTo(b);
    });
    return list;
  }

  Widget _buildFilterBar(List<String> classes) {
    final classItems = ['All Classes', ...classes];
    final safeClass = classItems.contains(_selectedClass)
        ? _selectedClass
        : classItems.first;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _filterDropdown(
                  'Class',
                  Icons.class_rounded,
                  classItems,
                  safeClass,
                  Colors.indigo,
                      (v) => setState(() => _selectedClass = v!),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _filterDropdown(
                  'Exam',
                  Icons.event_note_rounded,
                  ['All Exams', ...ReportFilters.exams],
                  _selectedExam,
                  Colors.teal,
                      (v) => setState(() => _selectedExam = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: _selectedDate != null
                          ? Colors.orange.withOpacity(0.08)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedDate != null
                            ? Colors.orange.withOpacity(0.4)
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month_rounded,
                            size: 18,
                            color: _selectedDate != null
                                ? Colors.orange
                                : Colors.grey[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? 'Filter by Date'
                                : _fmtDate(_selectedDate!),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _selectedDate != null
                                  ? Colors.orange[800]
                                  : Colors.grey[700],
                            ),
                          ),
                        ),
                        if (_selectedDate != null)
                          GestureDetector(
                            onTap: () =>
                                setState(() => _selectedDate = null),
                            child: Icon(Icons.close_rounded,
                                size: 16, color: Colors.orange[700]),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_hasFilter) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _resetFilters,
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.refresh_rounded,
                            size: 16, color: Colors.red[600]),
                        const SizedBox(width: 4),
                        Text('Reset',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.red[600],
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.filter_alt_outlined,
                  size: 15, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                "${_filteredReports.length} report${_filteredReports.length == 1 ? '' : 's'} found",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterDropdown(
      String hint,
      IconData icon,
      List<String> items,
      String value,
      Color color,
      Function(String?) onChanged,
      ) {
    final safe = items.contains(value) ? value : items.first;
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: safe,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down_rounded,
                    size: 18, color: color),
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color),
                items: items
                    .map((e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color)),
                ))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: _filteredReports.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _reportTile(_filteredReports[i]),
    );
  }

  Widget _reportTile(ReportCardData r) {
    final c = gradeColor(r.grade);
    final name = _resolveStudentName(r);
    final StudentListData? student = studentController.studentList
        .firstWhereOrNull((s) => s.studentIdCard == r.studentId);
    final String profileUrl = (student?.studentProfile ?? '').trim();
    final bool hasProfile = profileUrl.isNotEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ReportCardDetailScreen(report: r),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                image: hasProfile
                    ? DecorationImage(
                  image: NetworkImage(profileUrl),
                  fit: BoxFit.cover,
                  onError: (_, __) {},
                )
                    : null,
              ),
              child: hasProfile
                  ? null
                  : Center(
                child: Icon(Icons.image)
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text("${r.subjectName} • ${r.examName}",
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[600])),
                  const SizedBox(height: 3),
                  Text("${r.className} • ${r.studentId}",
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[500])),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: c.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(r.grade,
                      style: TextStyle(
                          color: c,
                          fontWeight: FontWeight.w700,
                          fontSize: 12)),
                ),
                const SizedBox(height: 4),
                Text("${r.studentMarks}/${r.subjectMaxMarks}",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
            Icon(Icons.chevron_right_rounded,
                color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
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
            child: const Icon(Icons.assignment_outlined,
                size: 48, color: Colors.indigo),
          ),
          const SizedBox(height: 16),
          const Text("No Report Cards Yet",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text("Tap + to assign a new report card.",
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _openForm,
            icon: const Icon(Icons.add, color: Colors.white, size: 18),
            label: const Text("Assign Report Card",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _noResults() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded,
              size: 56, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text("No Matching Reports",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text("Try different filters.",
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          if (_hasFilter) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _resetFilters,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text("Reset Filters"),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================
//                    DETAIL SCREEN (with edit + delete)
// ============================================================
class ReportCardDetailScreen extends StatelessWidget {
  final ReportCardData report;
  const ReportCardDetailScreen({super.key, required this.report});

  Future<void> _confirmDelete(BuildContext context) async {
    final controller = Get.find<ReportCardController>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Report Card?"),
        content: Text(
          "This will permanently delete ${report.subjectName} "
              "(${report.examName}) for ${report.studentId}. "
              "This action cannot be undone.",
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (ok != true) return;
    final success = await controller.deleteReportCard(report.id);
    if (success && context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _openEdit(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TeacherAssignReportFormScreen(existing: report),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gColor = gradeColor(report.grade);
    final controller = Get.find<ReportCardController>();
    final StudentListData? student = Get.find<StudentListController>()
        .studentList
        .firstWhereOrNull((s) => s.studentIdCard == report.studentId);

    final String profileUrl = (student?.studentProfile ?? '').trim();
    final bool hasProfile = profileUrl.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Report Card",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.indigo.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      image: hasProfile
                          ? DecorationImage(
                        image: NetworkImage(profileUrl),
                        fit: BoxFit.cover,
                        onError: (_, __) {},
                      )
                          : null,
                    ),
                    child: hasProfile
                        ? null
                        : const Center(
                      child: Icon(Icons.person_rounded,
                          color: Colors.white, size: 30),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(report.studentId,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                        Text("${report.className} • ${report.schoolType}",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(report.grade,
                        style: TextStyle(
                            color: gColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 14)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _section("Exam Details", [
              _kv("Exam", report.examName),
              _kv("Subject", report.subjectName),
              _kv("Class", report.className),
              _kv("Submitted On", _formatDate(report.createdAt)),
            ]),
            const SizedBox(height: 12),
            _section("Marks & Grade", [
              _kv("Marks Obtained", "${report.studentMarks}"),
              _kv("Max Marks", "${report.subjectMaxMarks}"),
              _kv("Pass Marks", "${report.passingMaxMarks}"),
              _kv(
                  "Percentage",
                  report.subjectMaxMarks > 0
                      ? "${(report.studentMarks / report.subjectMaxMarks * 100).toStringAsFixed(1)}%"
                      : "-"),
              _kv("Grade", report.grade),
              _kv("Result", report.isPass ? "PASS" : "FAIL"),
            ]),
            if (report.remark.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.comment_rounded,
                            color: Colors.amber, size: 18),
                        SizedBox(width: 8),
                        Text("Teacher's Remark",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(report.remark,
                        style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openEdit(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: const BorderSide(color: Colors.indigo),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.edit,
                        color: Colors.indigo, size: 18),
                    label: const Text("Edit Report Card",
                        style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() {
                    final deleting = controller.isDeleting.value;
                    return OutlinedButton.icon(
                      onPressed: deleting
                          ? null
                          : () => _confirmDelete(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: BorderSide(color: Colors.red.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: deleting
                          ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.red,
                        ),
                      )
                          : Icon(Icons.delete_outline_rounded,
                          color: Colors.red[600], size: 18),
                      label: Text(
                        deleting ? "Deleting…" : "Delete",
                        style: TextStyle(
                            color: Colors.red[600],
                            fontWeight: FontWeight.w600),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          Text(v,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final d = DateTime.parse(iso).toLocal();
      return "${d.day}/${d.month}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return iso;
    }
  }
}

// ============================================================
//   FORM SCREEN — supports CREATE and EDIT (via `existing`)
// ============================================================
class TeacherAssignReportFormScreen extends StatefulWidget {
  /// If non-null → EDIT mode (pre-fills fields, calls update API)
  final ReportCardData? existing;

  const TeacherAssignReportFormScreen({super.key, this.existing});

  bool get isEditMode => existing != null;

  @override
  State<TeacherAssignReportFormScreen> createState() =>
      _TeacherAssignReportFormScreenState();
}

class _TeacherAssignReportFormScreenState
    extends State<TeacherAssignReportFormScreen> {
  int _step = 0;

  final List<String> _subjects = kSubjects;

  final studentController = Get.find<StudentListController>();
  final teacherController = Get.find<TeacherController>();
  final reportController = Get.find<ReportCardController>();

  String? _selectedClass;
  String? _selectedExam;
  String? _selectedSubject;

  final TextEditingController _maxMarksController = TextEditingController();
  final TextEditingController _passMarksController = TextEditingController();

  int get _maxMarks => int.tryParse(_maxMarksController.text.trim()) ?? 0;
  int get _passMarks => int.tryParse(_passMarksController.text.trim()) ?? 0;

  final Map<int, bool> _selectedStudentIds = {};
  final Map<int, TextEditingController> _marksControllers = {};
  final Map<int, TextEditingController> _remarkControllers = {};
  final Map<int, String> _grades = {};

  /// In EDIT mode we only handle this one student
  StudentListData? _editStudent;
  int _editStudentIndex = -1;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      _hydrateFromExisting(widget.existing!);
    }
  }

  void _hydrateFromExisting(ReportCardData r) {
    _selectedClass = r.className;
    _selectedExam = r.examName;
    // Only preselect if it exists in our dropdown, else add
    _selectedSubject = _subjects.contains(r.subjectName)
        ? r.subjectName
        : r.subjectName; // still set; dropdown allows null fallback
    _maxMarksController.text = r.subjectMaxMarks.toString();
    _passMarksController.text = r.passingMaxMarks.toString();

    // Find the student to attach the existing marks to
    final idx = studentController.studentList
        .indexWhere((s) => s.studentIdCard == r.studentId);
    if (idx >= 0) {
      _editStudent = studentController.studentList[idx];
      _editStudentIndex = idx;
    } else {
      // Student not in loaded list — create a synthetic one so we can still edit
      _editStudent = null;
    }

    if (_editStudent != null) {
      _selectedStudentIds[_editStudent!.id] = true;
      _ensureControllers(_editStudent!.id);
      _marksControllers[_editStudent!.id]!.text = r.studentMarks.toString();
      _remarkControllers[_editStudent!.id]!.text = r.remark;
      _grades[_editStudent!.id] = _calcGrade(r.studentMarks);

      // Start at Marks step in edit mode (skip picker)
      _step = 2;
    } else {
      // Fallback: still start at step 0 so user can pick a class/student
      _step = 0;
    }
  }

  @override
  void dispose() {
    for (final c in _marksControllers.values) {
      c.dispose();
    }
    for (final c in _remarkControllers.values) {
      c.dispose();
    }
    _maxMarksController.dispose();
    _passMarksController.dispose();
    super.dispose();
  }

  String? _resolveAdminId() {
    try {
      final fromCard = _readString(teacherController.teacherIdCard);
      if (fromCard != null && fromCard.trim().isNotEmpty) {
        return fromCard.trim();
      }
      final dynamic t = teacherController;
      final candidates = <dynamic>[
        (() { try { return (t as dynamic).adminId; } catch (_) { return null; } })(),
        (() { try { return (t as dynamic).idCard; } catch (_) { return null; } })(),
        (() { try { return (t as dynamic).userId; } catch (_) { return null; } })(),
      ];
      for (final c in candidates) {
        final s = _readString(c);
        if (s != null && s.trim().isNotEmpty) return s.trim();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  List<String> _uniqueClasses() {
    final set = <String>{};
    for (final s in studentController.studentList) {
      if (s.studentClass.trim().isNotEmpty) {
        set.add(s.studentClass.trim());
      }
    }
    final list = set.toList();
    list.sort((a, b) {
      final na = int.tryParse(a);
      final nb = int.tryParse(b);
      if (na != null && nb != null) return na.compareTo(nb);
      return a.compareTo(b);
    });
    return list;
  }

  List<StudentListData> get _classStudents {
    if (_selectedClass == null) return [];
    return studentController.studentList
        .where((s) => s.studentClass.trim() == _selectedClass!.trim())
        .toList();
  }

  List<StudentListData> get _selectedStudents =>
      _classStudents.where((s) => _selectedStudentIds[s.id] == true).toList();

  String _calcGrade(num marks) {
    if (_maxMarks <= 0) return "-";
    final pct = (marks / _maxMarks) * 100;
    if (pct >= 90) return "A+";
    if (pct >= 80) return "A";
    if (pct >= 70) return "B+";
    if (pct >= 60) return "B";
    if (pct >= 50) return "C";
    if (pct >= 33) return "D";
    return "F";
  }

  Color _gradeColor(String grade) {
    switch (grade) {
      case "A+":
      case "A":
        return Colors.green;
      case "B+":
      case "B":
        return Colors.blue;
      case "C":
      case "D":
        return Colors.orange;
      case "F":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _ensureControllers(int id) {
    _marksControllers.putIfAbsent(id, () => TextEditingController());
    _remarkControllers.putIfAbsent(id, () => TextEditingController());
    _grades.putIfAbsent(id, () => "-");
  }

  void _onMarksChanged(int id) {
    final text = _marksControllers[id]?.text ?? '';
    setState(() {
      _grades[id] = text.isEmpty ? "-" : _calcGrade(int.tryParse(text) ?? 0);
    });
  }

  void _selectAll(bool value) {
    setState(() {
      for (final s in _classStudents) {
        _selectedStudentIds[s.id] = value;
        if (value) _ensureControllers(s.id);
      }
    });
  }

  void _next() {
    if (_step == 0) {
      if (_selectedClass == null ||
          _selectedExam == null ||
          _selectedSubject == null) {
        FlutterToast.error("Please select Class, Exam and Subject");
        return;
      }
      final maxText = _maxMarksController.text.trim();
      final passText = _passMarksController.text.trim();
      if (maxText.isEmpty) {
        FlutterToast.error("Please enter Max Marks");
        return;
      }
      final maxVal = int.tryParse(maxText);
      if (maxVal == null || maxVal <= 0) {
        FlutterToast.error("Max Marks must be a positive number");
        return;
      }
      if (passText.isEmpty) {
        FlutterToast.error("Please enter Pass Marks");
        return;
      }
      final passVal = int.tryParse(passText);
      if (passVal == null || passVal < 0) {
        FlutterToast.error("Pass Marks must be a valid number");
        return;
      }
      if (passVal > maxVal) {
        FlutterToast.error("Pass Marks cannot be greater than Max Marks");
        return;
      }
      if (_classStudents.isEmpty) {
        FlutterToast.error("No students found for class $_selectedClass");
        return;
      }
      setState(() => _step = 1);
    } else if (_step == 1) {
      if (_selectedStudents.isEmpty) {
        FlutterToast.error("Please select at least one student");
        return;
      }
      setState(() => _step = 2);
    } else {
      _submit();
    }
  }

  void _prev() {
    if (_step > 0) setState(() => _step--);
  }

  void _submit() {
    // EDIT MODE — one student, direct submit
    if (widget.isEditMode && _editStudent != null) {
      final id = _editStudent!.id;
      _ensureControllers(id);
      final text = _marksControllers[id]!.text.trim();
      if (text.isEmpty) {
        FlutterToast.error("Please enter marks");
        return;
      }
      final m = int.tryParse(text);
      if (m == null || m < 0 || m > _maxMarks) {
        FlutterToast.error("Marks must be between 0 and $_maxMarks");
        return;
      }
      _showConfirm(isEdit: true, count: 1);
      return;
    }

    // CREATE MODE — many students
    int missing = 0;
    int invalid = 0;
    for (final s in _selectedStudents) {
      _ensureControllers(s.id);
      final text = _marksControllers[s.id]!.text.trim();
      if (text.isEmpty) {
        missing++;
      } else {
        final m = int.tryParse(text);
        if (m == null || m < 0 || m > _maxMarks) invalid++;
      }
    }
    if (missing > 0) {
      FlutterToast.error("Please enter marks for all students");
      return;
    }
    if (invalid > 0) {
      FlutterToast.error("Marks must be between 0 and $_maxMarks");
      return;
    }
    _showConfirm(isEdit: false, count: _selectedStudents.length);
  }

  void _showConfirm({required bool isEdit, required int count}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isEdit ? "Update Report Card?" : "Submit Report Cards?"),
        content: Text(
          isEdit
              ? "Save changes to $_selectedSubject ($_selectedExam)?"
              : "Submit for $count students in $_selectedSubject ($_selectedExam).",
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            onPressed: () {
              Navigator.pop(context);
              if (isEdit) {
                _saveAndUpdate();
              } else {
                _saveAndSubmit();
              }
            },
            child: Text(isEdit ? "Update" : "Submit",
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ================== CREATE ==================
  Future<void> _saveAndSubmit() async {
    final adminId = _resolveAdminId();
    if (adminId == null || adminId.isEmpty) {
      FlutterToast.error("Admin ID missing — cannot submit");
      return;
    }
    final schoolType = teacherController.schoolType;

    final requests = <CreateReportCardRequest>[];
    for (final s in _selectedStudents) {
      _ensureControllers(s.id);
      final marks = int.tryParse(_marksControllers[s.id]!.text) ?? 0;
      final sid = s.studentIdCard.isNotEmpty
          ? s.studentIdCard
          : 'STU${s.id.toString().padLeft(3, '0')}';
      final result = marks >= _passMarks ? 'pass' : 'fail';

      requests.add(
        CreateReportCardRequest(
          adminId: adminId,
          studentId: sid,
          schoolType: schoolType,
          className: _selectedClass!,
          subjectName: _selectedSubject!,
          examName: _selectedExam!,
          subjectMaxMarks: _maxMarks,
          passingMaxMarks: _passMarks,
          studentMarks: marks,
          result: result,
          description: _remarkControllers[s.id]!.text.trim().isEmpty
              ? ''
              : _remarkControllers[s.id]!.text.trim(),
        ),
      );
    }

    final bulk = await reportController.createReportCards(requests);
    if (!mounted) return;

    if (bulk.hasFailures) {
      _showResult(
        successCount: bulk.created.length,
        failures: bulk.failures,
      );
    } else {
      _showSuccess(bulk.created.length);
    }
  }

  // ================== UPDATE ==================
  Future<void> _saveAndUpdate() async {
    final adminId = _resolveAdminId();
    if (adminId == null || adminId.isEmpty) {
      FlutterToast.error("Admin ID missing — cannot update");
      return;
    }
    final s = _editStudent!;
    _ensureControllers(s.id);
    final marks = int.tryParse(_marksControllers[s.id]!.text) ?? 0;
    final sid = s.studentIdCard.isNotEmpty
        ? s.studentIdCard
        : 'STU${s.id.toString().padLeft(3, '0')}';
    final result = marks >= _passMarks ? 'pass' : 'fail';

    final req = CreateReportCardRequest(
      adminId: adminId,
      studentId: sid,
      schoolType: teacherController.schoolType,
      className: _selectedClass ?? widget.existing!.className,
      subjectName: _selectedSubject ?? widget.existing!.subjectName,
      examName: _selectedExam ?? widget.existing!.examName,
      subjectMaxMarks: _maxMarks,
      passingMaxMarks: _passMarks,
      studentMarks: marks,
      result: result,
      description: _remarkControllers[s.id]!.text.trim().isEmpty
          ? ''
          : _remarkControllers[s.id]!.text.trim(),
    );

    final ok = await reportController.updateReportCard(
      widget.existing!.id,
      req,
    );

    if (!mounted) return;

    if (ok) {
      Navigator.pop(context); // close bottom sheet
      Navigator.pop(context); // close form
    }
  }

  void _showSuccess(int count) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: Colors.green, size: 44),
            ),
            const SizedBox(height: 16),
            const Text("Report Cards Submitted!",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(
              "$count report card${count == 1 ? '' : 's'} submitted for $_selectedExam.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("Done",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResult({
    required int successCount,
    required List<String> failures,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.warning_amber_rounded,
                      color: Colors.orange, size: 30),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text("Partially Submitted",
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              "$successCount submitted, ${failures.length} failed.",
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            ...failures.take(5).map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text("• $f",
                  style: const TextStyle(
                      fontSize: 11, color: Colors.red)),
            )),
            if (failures.length > 5)
              Text("…and ${failures.length - 5} more",
                  style: const TextStyle(fontSize: 11)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("Close",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => _step > 0 && !widget.isEditMode
              ? _prev()
              : Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          widget.isEditMode ? "Edit Report Card" : "Assign Report Card",
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 17),
        ),
      ),
      body: Column(
        children: [
          if (!widget.isEditMode) _buildStepper(),
          Expanded(child: _buildStepContent()),
          Obx(() => _buildBottomBar()),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    final steps = ["Class", "Students", "Marks"];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final done = _step > i ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                color: done ? Colors.indigo : Colors.grey.shade300,
              ),
            );
          }
          final idx = i ~/ 2;
          final active = idx <= _step;
          final done = idx < _step;
          return Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: active ? Colors.indigo : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: done
                      ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 16)
                      : Text("${idx + 1}",
                      style: TextStyle(
                        color: active ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      )),
                ),
              ),
              const SizedBox(height: 4),
              Text(steps[idx],
                  style: TextStyle(
                    fontSize: 11,
                    color: active ? Colors.indigo : Colors.grey,
                    fontWeight:
                    active ? FontWeight.w600 : FontWeight.normal,
                  )),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStepContent() {
    if (widget.isEditMode) {
      return _step1()..toString(); // still allow editing top fields
    }
    switch (_step) {
      case 0:
        return _step1();
      case 1:
        return _step2();
      default:
        return _step3();
    }
  }

  Widget _step1() {
    final classes = _uniqueClasses();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoCard(widget.isEditMode
              ? "Update details of this report card."
              : "Select class, exam and subject. Enter Max Marks and Pass Marks for this exam."),
          const SizedBox(height: 18),
          _label("Class"),
          const SizedBox(height: 8),
          if (classes.isEmpty && !widget.isEditMode)
            _emptyHint("No classes found in student list")
          else
            _dropdown<String>(
              value: _selectedClass,
              hint: 'Select Class',
              icon: Icons.class_rounded,
              items: classes.isEmpty ? [_selectedClass ?? ''] : classes,
              onChanged: (v) => setState(() {
                _selectedClass = v;
                _selectedStudentIds.clear();
              }),
            ),
          const SizedBox(height: 16),
          _label("Exam / Term"),
          const SizedBox(height: 8),
          _dropdown<String>(
            value: _selectedExam,
            hint: 'Select Exam',
            icon: Icons.event_note_rounded,
            items: ReportFilters.exams,
            onChanged: (v) => setState(() => _selectedExam = v),
          ),
          const SizedBox(height: 16),
          _label("Subject"),
          const SizedBox(height: 8),
          _dropdown<String>(
            value: _selectedSubject,
            hint: 'Select Subject',
            icon: Icons.menu_book_rounded,
            items: _subjects,
            onChanged: (v) => setState(() => _selectedSubject = v),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Max Marks"),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _maxMarksController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {
                        for (final id in _marksControllers.keys) {
                          final t = _marksControllers[id]!.text;
                          _grades[id] = t.isEmpty
                              ? "-"
                              : _calcGrade(int.tryParse(t) ?? 0);
                        }
                      }),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      decoration: _inputDeco(
                          "Max Marks", "e.g. 100", Icons.grade_rounded),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Pass Marks"),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passMarksController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      decoration: _inputDeco(
                          "Pass Marks", "e.g. 33", Icons.verified_rounded),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_selectedClass != null && !widget.isEditMode) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.indigo.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.people_alt_rounded,
                      size: 16, color: Colors.indigo),
                  const SizedBox(width: 8),
                  Text(
                    "${_classStudents.length} student${_classStudents.length == 1 ? '' : 's'} in class $_selectedClass",
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.indigo,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
          // In EDIT mode, show the mark card for the single student right here
          if (widget.isEditMode && _editStudent != null) ...[
            const SizedBox(height: 20),
            _label("Marks"),
            const SizedBox(height: 8),
            _markCard(_editStudent!),
          ],
        ],
      ),
    );
  }

  Widget _emptyHint(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Colors.orange, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 12, color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _step2() {
    final students = _classStudents;
    final allSelected = students.isNotEmpty &&
        students.every((s) => _selectedStudentIds[s.id] == true);

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "${_selectedStudents.length} of ${students.length} selected",
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              TextButton.icon(
                onPressed: () => _selectAll(!allSelected),
                icon: Icon(
                  allSelected
                      ? Icons.remove_done_rounded
                      : Icons.done_all_rounded,
                  size: 18,
                  color: Colors.indigo,
                ),
                label: Text(
                  allSelected ? "Unselect All" : "Select All",
                  style: const TextStyle(
                      color: Colors.indigo, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: students.isEmpty
              ? Center(
            child: Text("No students in class $_selectedClass",
                style: TextStyle(color: Colors.grey[600])),
          )
              : ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: students.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final s = students[i];
              final sel = _selectedStudentIds[s.id] == true;
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() {
                  _selectedStudentIds[s.id] = !sel;
                  if (!sel) _ensureControllers(s.id);
                }),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                    sel ? Colors.indigo.withOpacity(0.06) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: sel
                          ? Colors.indigo.withOpacity(0.4)
                          : Colors.grey.shade200,
                      width: sel ? 1.4 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: sel ? Colors.indigo : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(image: NetworkImage(s.studentProfile!))
                        ),
                        child: s.studentProfile!.isNotEmpty ?null :Center(
                          child: Text(
                            s.rollNumber.isNotEmpty ? s.rollNumber : '${i + 1}',
                            style: TextStyle(
                              color: sel
                                  ? Colors.white
                                  : Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.fullName,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                            Text(
                              '${'ID: ${s.studentIdCard}'}',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700),
                            ),
                            Text(
                              '${'Class: ${s.studentClass}th'}',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                      Checkbox(
                        value: sel,
                        activeColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        onChanged: (v) => setState(() {
                          _selectedStudentIds[s.id] = v ?? false;
                          if (v == true) _ensureControllers(s.id);
                        }),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _step3() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_selectedSubject ?? '-',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                    Text("$_selectedExam • $_selectedClass",
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("Max $_maxMarks",
                    style: const TextStyle(
                        fontSize: 11,
                        color: Colors.indigo,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: _selectedStudents.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _markCard(_selectedStudents[i]),
          ),
        ),
      ],
    );
  }

  Widget _markCard(StudentListData s) {
    _ensureControllers(s.id);
    final grade = _grades[s.id] ?? "-";

    final rollText = s.rollNumber.isNotEmpty
        ? s.rollNumber
        : '${_classStudents.indexOf(s) + 1}';

    return Container(
      padding: const EdgeInsets.all(12),
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
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color:  Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(image: NetworkImage(s.studentProfile!))
                ),
                child: s.studentProfile!.isNotEmpty ?null :Center(
                  child: Text(
                    rollText,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.fullName,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    Text(
                      '${'ID: ${s.studentIdCard}'}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700),
                    ),
                    Text(
                      '${'Class: ${s.studentClass}th'}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _gradeColor(grade).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(grade,
                    style: TextStyle(
                        color: _gradeColor(grade),
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height:20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _marksControllers[s.id],
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _onMarksChanged(s.id),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: _inputDeco("Marks", "0 - $_maxMarks",
                      Icons.grade_rounded),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _remarkControllers[s.id],
                  style: const TextStyle(fontSize: 13),
                  decoration: _inputDeco("Remark (optional)",
                      "e.g. Excellent work", Icons.comment_rounded),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDeco(String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(fontSize: 12),
      prefixIcon: Icon(icon, color: Colors.indigo, size: 18),
      filled: true,
      fillColor: Colors.grey.shade50,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.indigo, width: 1.4),
      ),
    );
  }

  Widget _buildBottomBar() {
    final isLast = _step == 2 || widget.isEditMode;
    final submitting = reportController.isSubmitting.value;
    final updating = reportController.isUpdating.value;
    final busy = submitting || updating;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_step > 0 && !widget.isEditMode)
              Expanded(
                child: OutlinedButton(
                  onPressed: busy ? null : _prev,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    side: const BorderSide(color: Colors.indigo),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Back",
                      style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            if (_step > 0 && !widget.isEditMode) const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: busy ? null : _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: busy
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Icon(
                  isLast
                      ? (widget.isEditMode
                      ? Icons.save_rounded
                      : Icons.check_circle_rounded)
                      : Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                label: Text(
                  busy
                      ? (widget.isEditMode ? "Updating…" : "Submitting…")
                      : (isLast
                      ? (widget.isEditMode
                      ? "Update Report Card"
                      : "Submit Report Cards")
                      : "Continue"),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Text(t,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700));

  Widget _dropdown<T>({
    required T? value,
    required String hint,
    required IconData icon,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    final T? safeValue =
    (value != null && items.contains(value)) ? value : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: safeValue == null
              ? Colors.grey.shade300
              : Colors.indigo.withOpacity(0.4),
          width: safeValue == null ? 1 : 1.4,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: safeValue,
          hint: Row(
            children: [
              Icon(icon, color: Colors.grey.shade500, size: 18),
              const SizedBox(width: 10),
              Text(hint,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.indigo),
          style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 14),
          items: items
              .map((e) => DropdownMenuItem<T>(
            value: e,
            child: Row(
              children: [
                Icon(icon, color: Colors.indigo, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(e.toString(),
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _infoCard(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline_rounded,
              color: Colors.blue, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style:
                const TextStyle(fontSize: 12, color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}