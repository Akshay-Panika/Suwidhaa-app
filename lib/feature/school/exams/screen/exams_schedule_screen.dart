import 'package:flutter/material.dart';

class ExamsScheduleScreen extends StatefulWidget {
  const ExamsScheduleScreen({super.key});

  @override
  State<ExamsScheduleScreen> createState() => _ExamsScheduleScreenState();
}

class _ExamsScheduleScreenState extends State<ExamsScheduleScreen>
    with SingleTickerProviderStateMixin {
  // ==================== TAB ====================
  late TabController _tabController;

  // ==================== FILTER ====================
  String _selectedClass = "All Classes";
  String _statusFilter = "All"; // All | Upcoming | Ongoing | Completed

  // ==================== DATA ====================
  final List<String> _classes = [
    "All Classes",
    "Class 10 - A",
    "Class 10 - B",
    "Class 9 - A",
    "Class 9 - B",
  ];

  final List<Map<String, dynamic>> _exams = [
    {
      "id": "EX001",
      "title": "Mid Term Examination",
      "class": "Class 10 - A",
      "status": "Upcoming",
      "startDate": "10 Oct 2025",
      "endDate": "18 Oct 2025",
      "color": Colors.indigo,
      "published": true,
      "subjects": [
        {"name": "Mathematics", "date": "10 Oct 2025", "time": "9:00 AM", "duration": "3 hrs", "maxMarks": 100, "room": "Hall A"},
        {"name": "Science", "date": "12 Oct 2025", "time": "9:00 AM", "duration": "3 hrs", "maxMarks": 100, "room": "Hall A"},
        {"name": "English", "date": "14 Oct 2025", "time": "9:00 AM", "duration": "3 hrs", "maxMarks": 100, "room": "Hall A"},
        {"name": "Social Studies", "date": "16 Oct 2025", "time": "9:00 AM", "duration": "3 hrs", "maxMarks": 100, "room": "Hall A"},
        {"name": "Computer", "date": "18 Oct 2025", "time": "9:00 AM", "duration": "2 hrs", "maxMarks": 100, "room": "Lab 1"},
      ],
      "totalStudents": 42,
      "invigilator": "Mr. Ahmed Khan",
    },
    {
      "id": "EX002",
      "title": "Unit Test - 2",
      "class": "Class 10 - B",
      "status": "Ongoing",
      "startDate": "22 Sep 2025",
      "endDate": "26 Sep 2025",
      "color": Colors.orange,
      "published": true,
      "subjects": [
        {"name": "Mathematics", "date": "22 Sep 2025", "time": "10:00 AM", "duration": "1.5 hrs", "maxMarks": 50, "room": "Hall B"},
        {"name": "Science", "date": "24 Sep 2025", "time": "10:00 AM", "duration": "1.5 hrs", "maxMarks": 50, "room": "Hall B"},
        {"name": "English", "date": "26 Sep 2025", "time": "10:00 AM", "duration": "1.5 hrs", "maxMarks": 50, "room": "Hall B"},
      ],
      "totalStudents": 40,
      "invigilator": "Ms. Priya Sharma",
    },
    {
      "id": "EX003",
      "title": "Final Examination",
      "class": "Class 9 - A",
      "status": "Upcoming",
      "startDate": "15 Nov 2025",
      "endDate": "28 Nov 2025",
      "color": Colors.teal,
      "published": false,
      "subjects": [
        {"name": "Mathematics", "date": "15 Nov 2025", "time": "9:00 AM", "duration": "3 hrs", "maxMarks": 100, "room": "Hall C"},
        {"name": "Science", "date": "18 Nov 2025", "time": "9:00 AM", "duration": "3 hrs", "maxMarks": 100, "room": "Hall C"},
        {"name": "English", "date": "21 Nov 2025", "time": "9:00 AM", "duration": "3 hrs", "maxMarks": 100, "room": "Hall C"},
      ],
      "totalStudents": 38,
      "invigilator": "Mr. Ravi Kumar",
    },
    {
      "id": "EX004",
      "title": "Unit Test - 1",
      "class": "Class 9 - B",
      "status": "Completed",
      "startDate": "05 Sep 2025",
      "endDate": "08 Sep 2025",
      "color": Colors.grey,
      "published": true,
      "subjects": [
        {"name": "Mathematics", "date": "05 Sep 2025", "time": "10:00 AM", "duration": "1.5 hrs", "maxMarks": 50, "room": "Hall D"},
        {"name": "Science", "date": "07 Sep 2025", "time": "10:00 AM", "duration": "1.5 hrs", "maxMarks": 50, "room": "Hall D"},
      ],
      "totalStudents": 36,
      "invigilator": "Ms. Neha Verma",
    },
  ];

  // ==================== UPCOMING SNAPSHOT ====================
  final List<Map<String, dynamic>> _todayExams = [
    {"subject": "Mathematics", "class": "Class 10 - B", "time": "10:00 AM", "room": "Hall B", "students": 40},
  ];
  final List<Map<String, dynamic>> _tomorrowExams = [
    {"subject": "Science", "class": "Class 10 - B", "time": "10:00 AM", "room": "Hall B", "students": 40},
    {"subject": "English", "class": "Class 10 - A", "time": "9:00 AM", "room": "Hall A", "students": 42},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ==================== HELPERS ====================
  List<Map<String, dynamic>> get _filteredExams {
    var list = List<Map<String, dynamic>>.from(_exams);
    if (_selectedClass != "All Classes") {
      list = list.where((e) => e['class'] == _selectedClass).toList();
    }
    if (_statusFilter != "All") {
      list = list.where((e) => e['status'] == _statusFilter).toList();
    }
    return list;
  }

  Color _statusColor(String s) {
    switch (s) {
      case "Upcoming":
        return Colors.blue;
      case "Ongoing":
        return Colors.orange;
      case "Completed":
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String s) {
    switch (s) {
      case "Upcoming":
        return Icons.schedule_rounded;
      case "Ongoing":
        return Icons.play_circle_rounded;
      case "Completed":
        return Icons.check_circle_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  int get _totalStudents =>
      _exams.fold(0, (s, e) => s + (e['totalStudents'] as int));

  void _snack(String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color ?? Colors.green,
      ),
    );
  }

  // ==================== PUBLISH EXAM ====================
  void _publishExam(Map<String, dynamic> e) {
    setState(() => e['published'] = true);
    _snack("Exam published! Students notified.");
  }

  // ==================== DELETE ====================
  void _deleteExam(int index) {
    final e = _exams[index];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Exam?"),
        content: Text("Delete \"${e['title']}\"? This cannot be undone.",
            style: const TextStyle(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              setState(() => _exams.removeAt(index));
              _snack("Exam deleted", color: Colors.orange);
            },
            child: const Text("Delete",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ==================== DETAIL SHEET ====================
  void _showExamDetail(Map<String, dynamic> e) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (e['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.event_note_rounded,
                              color: e['color'] as Color, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e['title'] as String,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(e['class'] as String,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700])),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _statusColor(
                                          e['status'] as String)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(e['status'] as String,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: _statusColor(
                                              e['status'] as String),
                                          fontWeight: FontWeight.w700,
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Info grid
                    _infoTile(Icons.calendar_today_rounded, "Start Date",
                        e['startDate'] as String),
                    _infoTile(Icons.event_rounded, "End Date",
                        e['endDate'] as String),
                    _infoTile(Icons.person_rounded, "Invigilator",
                        e['invigilator'] as String),
                    _infoTile(Icons.people_alt_rounded, "Students",
                        "${e['totalStudents']} enrolled"),

                    const SizedBox(height: 18),

                    // Subjects timetable
                    const Text("Subject Timetable",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    ...(e['subjects'] as List).asMap().entries.map((entry) {
                      final idx = entry.key;
                      final s = entry.value as Map<String, dynamic>;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: (e['color'] as Color)
                                    .withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text("${idx + 1}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: e['color'] as Color,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s['name'] as String,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today_rounded,
                                          size: 10,
                                          color: Colors.grey[600]),
                                      const SizedBox(width: 3),
                                      Text(s['date'] as String,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey[600])),
                                      const SizedBox(width: 8),
                                      Icon(Icons.access_time_rounded,
                                          size: 10,
                                          color: Colors.grey[600]),
                                      const SizedBox(width: 3),
                                      Text(s['time'] as String,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey[600])),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("${s['maxMarks']} marks",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text("${s['duration']}",
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600])),
                                const SizedBox(height: 2),
                                Text("Room ${s['room']}",
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600])),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 18),

                    // Publish status
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (e['published'] as bool)
                            ? Colors.green.withOpacity(0.08)
                            : Colors.orange.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: (e['published'] as bool)
                              ? Colors.green.withOpacity(0.3)
                              : Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            (e['published'] as bool)
                                ? Icons.check_circle_rounded
                                : Icons.info_outline_rounded,
                            color: (e['published'] as bool)
                                ? Colors.green
                                : Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              (e['published'] as bool)
                                  ? "Published - Students can view schedule"
                                  : "Draft - Not visible to students yet",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: (e['published'] as bool)
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Actions
                    if (!(e['published'] as bool))
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _publishExam(e);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.send_rounded,
                              color: Colors.white, size: 18),
                          label: const Text("Publish Exam",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    if (!(e['published'] as bool)) const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showMarksEntrySheet(e);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              side: const BorderSide(color: Colors.indigo),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.grade_rounded,
                                color: Colors.indigo, size: 18),
                            label: const Text("Enter Marks",
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showEditSheet(e);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              side: const BorderSide(color: Colors.indigo),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.edit_rounded,
                                color: Colors.indigo, size: 18),
                            label: const Text("Edit",
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.indigo, size: 14),
          ),
          const SizedBox(width: 10),
          Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const Spacer(),
          Flexible(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  // ==================== MARKS ENTRY SHEET ====================
  void _showMarksEntrySheet(Map<String, dynamic> e) {
    final subjects = e['subjects'] as List;
    final selectedSubject = ValueNotifier<String>(
        (subjects.first as Map)['name'] as String);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        constraints:
        BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Icon(Icons.grade_rounded, color: Colors.indigo),
                SizedBox(width: 8),
                Text("Enter Marks",
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            // Subject selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSubject.value,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Colors.indigo),
                  style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                  items: subjects
                      .map((s) => DropdownMenuItem<String>(
                    value: (s as Map)['name'] as String,
                    child: Text(s['name'] as String),
                  ))
                      .toList(),
                  onChanged: (v) => selectedSubject.value = v!,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.separated(
                itemCount: 10,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.indigo.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text("${index + 1}",
                                style: const TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text("Student ${index + 1}",
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              hintText: "0-100",
                              hintStyle: const TextStyle(fontSize: 12),
                              isDense: true,
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.indigo, width: 1.4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _snack("Marks saved successfully!");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.save_rounded,
                    color: Colors.white, size: 18),
                label: const Text("Save Marks",
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

  // ==================== CREATE / EDIT SHEET ====================
  void _showCreateSheet({Map<String, dynamic>? existing, int? index}) {
    final isEdit = existing != null;
    final titleCtrl =
    TextEditingController(text: isEdit ? existing['title'] as String : "");
    final classCtrl = isEdit ? existing['class'] as String : "Class 10 - A";
    final invigCtrl = TextEditingController(
        text: isEdit ? existing['invigilator'] as String : "");
    DateTime startDate = DateTime.now().add(const Duration(days: 7));
    DateTime endDate = DateTime.now().add(const Duration(days: 14));

    // Subject rows
    final List<Map<String, TextEditingController>> subjCtrls = [];
    if (isEdit) {
      for (final s in (existing['subjects'] as List)) {
        subjCtrls.add({
          "name": TextEditingController(text: (s as Map)['name'] as String),
          "date": TextEditingController(text: s['date'] as String),
          "time": TextEditingController(text: s['time'] as String),
          "duration": TextEditingController(text: s['duration'] as String),
          "maxMarks":
          TextEditingController(text: (s['maxMarks'] as int).toString()),
          "room": TextEditingController(text: s['room'] as String),
        });
      }
    } else {
      subjCtrls.add({
        "name": TextEditingController(),
        "date": TextEditingController(),
        "time": TextEditingController(),
        "duration": TextEditingController(text: "3 hrs"),
        "maxMarks": TextEditingController(text: "100"),
        "room": TextEditingController(),
      });
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(ctx).size.height * 0.9),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                        isEdit
                            ? Icons.edit_calendar_rounded
                            : Icons.event_available_rounded,
                        color: Colors.indigo),
                    const SizedBox(width: 8),
                    Text(isEdit ? "Edit Exam" : "Create Exam Schedule",
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _inputField(
                            controller: titleCtrl,
                            label: "Exam Title",
                            hint: "e.g. Mid Term Examination",
                            icon: Icons.title_rounded),
                        const SizedBox(height: 12),

                        // Class
                        const Text("Class",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: classCtrl,
                              isExpanded: true,
                              icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.indigo),
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13),
                              items: _classes
                                  .where((c) => c != "All Classes")
                                  .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c),
                              ))
                                  .toList(),
                              onChanged: (v) {},
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                        _inputField(
                            controller: invigCtrl,
                            label: "Invigilator",
                            hint: "e.g. Mr. Ahmed Khan",
                            icon: Icons.person_rounded),

                        const SizedBox(height: 12),

                        // Dates
                        Row(
                          children: [
                            Expanded(
                              child: _dateField("Start Date", startDate,
                                      (d) => setModal(() => startDate = d)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _dateField("End Date", endDate,
                                      (d) => setModal(() => endDate = d)),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),
                        Row(
                          children: [
                            const Text("Subject Timetable",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: () {
                                setModal(() {
                                  subjCtrls.add({
                                    "name": TextEditingController(),
                                    "date": TextEditingController(),
                                    "time": TextEditingController(),
                                    "duration":
                                    TextEditingController(text: "3 hrs"),
                                    "maxMarks":
                                    TextEditingController(text: "100"),
                                    "room": TextEditingController(),
                                  });
                                });
                              },
                              icon: const Icon(Icons.add_rounded,
                                  size: 16, color: Colors.indigo),
                              label: const Text("Add",
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Subject rows
                        ...subjCtrls.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final ctrls = entry.value;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: Colors.indigo.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text("${idx + 1}",
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.indigo,
                                                fontWeight:
                                                FontWeight.w700)),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text("Subject",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700)),
                                    const Spacer(),
                                    if (subjCtrls.length > 1)
                                      InkWell(
                                        onTap: () => setModal(
                                                () => subjCtrls.removeAt(idx)),
                                        child: const Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.red,
                                            size: 18),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _smallField(
                                    ctrls["name"]!, "Subject Name", "Maths"),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                        child: _smallField(ctrls["date"]!,
                                            "Date", "10 Oct 2025")),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: _smallField(ctrls["time"]!,
                                            "Time", "9:00 AM")),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                        child: _smallField(ctrls["duration"]!,
                                            "Duration", "3 hrs")),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: _smallField(ctrls["maxMarks"]!,
                                            "Max Marks", "100",
                                            keyboard: TextInputType.number)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: _smallField(ctrls["room"]!,
                                            "Room", "Hall A")),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (titleCtrl.text.isEmpty) {
                        _snack("Please enter exam title",
                            color: Colors.red);
                        return;
                      }
                      final subjects = subjCtrls
                          .where((c) => c["name"]!.text.isNotEmpty)
                          .map((c) => {
                        "name": c["name"]!.text,
                        "date": c["date"]!.text.isEmpty
                            ? "TBD"
                            : c["date"]!.text,
                        "time": c["time"]!.text.isEmpty
                            ? "TBD"
                            : c["time"]!.text,
                        "duration": c["duration"]!.text,
                        "maxMarks":
                        int.tryParse(c["maxMarks"]!.text) ?? 100,
                        "room": c["room"]!.text.isEmpty
                            ? "TBD"
                            : c["room"]!.text,
                      })
                          .toList();

                      if (subjects.isEmpty) {
                        _snack("Add at least one subject",
                            color: Colors.red);
                        return;
                      }

                      const months = [
                        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
                      ];
                      final sd =
                          "${startDate.day} ${months[startDate.month - 1]} ${startDate.year}";
                      final ed =
                          "${endDate.day} ${months[endDate.month - 1]} ${endDate.year}";

                      setState(() {
                        if (isEdit) {
                          _exams[index!] = {
                            ...existing!,
                            "title": titleCtrl.text,
                            "class": classCtrl,
                            "invigilator": invigCtrl.text.isEmpty
                                ? "TBD"
                                : invigCtrl.text,
                            "startDate": sd,
                            "endDate": ed,
                            "subjects": subjects,
                          };
                        } else {
                          _exams.insert(0, {
                            "id": "EX${DateTime.now().millisecondsSinceEpoch}",
                            "title": titleCtrl.text,
                            "class": classCtrl,
                            "status": "Upcoming",
                            "startDate": sd,
                            "endDate": ed,
                            "color": Colors.indigo,
                            "published": false,
                            "subjects": subjects,
                            "totalStudents": 40,
                            "invigilator": invigCtrl.text.isEmpty
                                ? "TBD"
                                : invigCtrl.text,
                          });
                        }
                      });
                      Navigator.pop(ctx);
                      _snack(isEdit
                          ? "Exam updated!"
                          : "Exam schedule created!");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(
                        isEdit ? Icons.save_rounded : Icons.check_rounded,
                        color: Colors.white,
                        size: 18),
                    label: Text(
                        isEdit ? "Save Changes" : "Create Schedule",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditSheet(Map<String, dynamic> e) {
    final idx = _exams.indexOf(e);
    _showCreateSheet(existing: e, index: idx);
  }

  Widget _dateField(String label, DateTime date,
      ValueChanged<DateTime> onPick) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (c, child) => Theme(
            data: Theme.of(c).copyWith(
              colorScheme:
              const ColorScheme.light(primary: Colors.indigo),
            ),
            child: child!,
          ),
        );
        if (picked != null) onPick(picked);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                color: Colors.indigo, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 10, color: Colors.grey[600])),
                  const SizedBox(height: 2),
                  Text("${date.day}/${date.month}/${date.year}",
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13),
        labelStyle: const TextStyle(fontSize: 12),
        prefixIcon: Icon(icon, color: Colors.indigo, size: 18),
        filled: true,
        fillColor: Colors.grey.shade50,
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

  Widget _smallField(TextEditingController ctrl, String label, String hint,
      {TextInputType keyboard = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 11),
        labelStyle: const TextStyle(fontSize: 11),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.indigo, width: 1.4),
        ),
      ),
    );
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Exam Schedule",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        actions: [
          IconButton(
            tooltip: "Create Exam",
            onPressed: () => _showCreateSheet(),
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle:
          const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: const [
            Tab(text: "All Exams"),
            Tab(text: "Snapshot"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllExamsTab(),
          _buildSnapshotTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateSheet(),
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text("Create",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  // ==================== TAB 1: ALL EXAMS ====================
  Widget _buildAllExamsTab() {
    return Column(
      children: [
        // Filters
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          child: Column(
            children: [
              Row(
                children: [
                  // Class dropdown
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedClass,
                          isExpanded: true,
                          icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.indigo),
                          style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 13),
                          items: _classes
                              .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c),
                          ))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedClass = v!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Status chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                  ["All", "Upcoming", "Ongoing", "Completed"].map((s) {
                    final sel = _statusFilter == s;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(s),
                        selected: sel,
                        onSelected: (_) =>
                            setState(() => _statusFilter = s),
                        selectedColor: Colors.indigo,
                        labelStyle: TextStyle(
                          color: sel ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _filteredExams.isEmpty
              ? _emptyState("No exams found")
              : ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: _filteredExams.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) =>
                _buildExamTile(_filteredExams[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildExamTile(Map<String, dynamic> e) {
    final status = e['status'] as String;
    final sc = _statusColor(status);
    final color = e['color'] as Color;
    final subjects = e['subjects'] as List;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _showExamDetail(e),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(14)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.event_note_rounded,
                            color: color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(e['title'] as String,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                if (!(e['published'] as bool)) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text("Draft",
                                        style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.class_rounded,
                                    size: 11, color: Colors.grey[600]),
                                const SizedBox(width: 3),
                                Text(e['class'] as String,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600])),
                                const SizedBox(width: 8),
                                Icon(Icons.date_range_rounded,
                                    size: 11, color: Colors.grey[600]),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                      "${e['startDate']} - ${e['endDate']}",
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600]),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: sc.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_statusIcon(status),
                                size: 10, color: sc),
                            const SizedBox(width: 3),
                            Text(status,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: sc,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.menu_book_rounded,
                          size: 12, color: Colors.grey[600]),
                      const SizedBox(width: 3),
                      Text("${subjects.length} subjects",
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[600])),
                      const SizedBox(width: 12),
                      Icon(Icons.people_alt_rounded,
                          size: 12, color: Colors.grey[600]),
                      const SizedBox(width: 3),
                      Text("${e['totalStudents']} students",
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[600])),
                      const Spacer(),
                      Icon(Icons.person_rounded,
                          size: 12, color: Colors.grey[600]),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(e['invigilator'] as String,
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== TAB 2: SNAPSHOT ====================
  Widget _buildSnapshotTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Big stat
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.indigo, Color(0xFF3F51B5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.28),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.event_note_rounded,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Total Exams",
                          style: TextStyle(
                              color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 3),
                      Text("${_exams.length}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 3),
                      Text("$_totalStudents students enrolled",
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Today's exams
          Row(
            children: const [
              Icon(Icons.today_rounded, color: Colors.red, size: 20),
              SizedBox(width: 6),
              Text("Today's Exams",
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          if (_todayExams.isEmpty)
            _emptyCard("No exams today 🎉")
          else
            ..._todayExams.map((e) => _buildSnapshotTile(e, Colors.red)),

          const SizedBox(height: 20),

          // Tomorrow's exams
          Row(
            children: const [
              Icon(Icons.event_rounded, color: Colors.orange, size: 20),
              SizedBox(width: 6),
              Text("Tomorrow's Exams",
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          if (_tomorrowExams.isEmpty)
            _emptyCard("No exams tomorrow")
          else
            ..._tomorrowExams
                .map((e) => _buildSnapshotTile(e, Colors.orange)),

          const SizedBox(height: 20),

          // Breakdown
          const Text("By Status",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: _statTile(
                      "Upcoming",
                      _exams
                          .where((e) => e['status'] == "Upcoming")
                          .length,
                      Colors.blue,
                      Icons.schedule_rounded)),
              const SizedBox(width: 8),
              Expanded(
                  child: _statTile(
                      "Ongoing",
                      _exams
                          .where((e) => e['status'] == "Ongoing")
                          .length,
                      Colors.orange,
                      Icons.play_circle_rounded)),
              const SizedBox(width: 8),
              Expanded(
                  child: _statTile(
                      "Completed",
                      _exams
                          .where((e) => e['status'] == "Completed")
                          .length,
                      Colors.grey,
                      Icons.check_circle_rounded)),
            ],
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSnapshotTile(Map<String, dynamic> e, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.menu_book_rounded, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e['subject'] as String,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text("${e['class']} • Room ${e['room']}",
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey[600])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(e['time'] as String,
                  style: TextStyle(
                      fontSize: 13,
                      color: color,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text("${e['students']} students",
                  style:
                  TextStyle(fontSize: 10, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statTile(String label, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text("$count",
              style: TextStyle(
                  fontSize: 20,
                  color: color,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _emptyCard(String msg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline_rounded,
              size: 36, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(msg,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _emptyState(String msg) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy_rounded,
              size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text(msg,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}