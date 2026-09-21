import 'package:flutter/material.dart';

class TeacherAssignReportScreen extends StatefulWidget {
  const TeacherAssignReportScreen({super.key});

  @override
  State<TeacherAssignReportScreen> createState() =>
      _TeacherAssignReportScreenState();
}

class _TeacherAssignReportScreenState extends State<TeacherAssignReportScreen> {
  // ==================== STEP CONTROL ====================
  int _currentStep = 0; // 0: Select Class/Exam, 1: Select Students, 2: Enter Marks

  // ==================== CLASS & EXAM ====================
  final List<String> _classes = [
    "Class 10 - A",
    "Class 10 - B",
    "Class 9 - A",
    "Class 9 - B",
    "Class 8 - A",
  ];
  final List<String> _exams = [
    "Mid Term 2025",
    "Final Term 2025",
    "Unit Test 1",
    "Unit Test 2",
    "Half Yearly",
  ];
  final List<String> _subjects = [
    "Mathematics",
    "Science",
    "English",
    "Social Studies",
    "Computer",
  ];

  String _selectedClass = "Class 10 - A";
  String _selectedExam = "Mid Term 2025";
  String _selectedSubject = "Mathematics";

  // ==================== STUDENTS DATA ====================
  final List<Map<String, dynamic>> _students = [
    {"id": "STU001", "roll": 1, "name": "Aarav Sharma", "selected": false},
    {"id": "STU002", "roll": 2, "name": "Priya Verma", "selected": false},
    {"id": "STU003", "roll": 3, "name": "Rohan Gupta", "selected": false},
    {"id": "STU004", "roll": 4, "name": "Sneha Patel", "selected": false},
    {"id": "STU005", "roll": 5, "name": "Karan Singh", "selected": false},
    {"id": "STU006", "roll": 6, "name": "Ananya Iyer", "selected": false},
    {"id": "STU007", "roll": 7, "name": "Vikram Reddy", "selected": false},
    {"id": "STU008", "roll": 8, "name": "Meera Joshi", "selected": false},
    {"id": "STU009", "roll": 9, "name": "Aditya Nair", "selected": false},
    {"id": "STU010", "roll": 10, "name": "Riya Kapoor", "selected": false},
  ];

  // ==================== MARKS DATA ====================
  // Each student's marks per subject
  final Map<String, Map<String, TextEditingController>> _marksControllers = {};
  final Map<String, String> _grades = {};
  final Map<String, TextEditingController> _remarkControllers = {};

  // ==================== MAX MARKS ====================
  final int _maxMarks = 100;
  final int _passMarks = 33;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    for (final s in _students) {
      final id = s['id'] as String;
      _marksControllers[id] = {
        _selectedSubject: TextEditingController(),
      };
      _grades[id] = "-";
      _remarkControllers[id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final m in _marksControllers.values) {
      for (final c in m.values) {
        c.dispose();
      }
    }
    for (final c in _remarkControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ==================== HELPERS ====================
  List<Map<String, dynamic>> get _selectedStudents =>
      _students.where((s) => s['selected'] == true).toList();

  String _calcGrade(num marks) {
    if (marks >= 90) return "A+";
    if (marks >= 80) return "A";
    if (marks >= 70) return "B+";
    if (marks >= 60) return "B";
    if (marks >= 50) return "C";
    if (marks >= 33) return "D";
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

  void _selectAll(bool value) {
    setState(() {
      for (final s in _students) {
        s['selected'] = value;
      }
    });
  }

  void _onMarksChanged(String id) {
    final text = _marksControllers[id]?[_selectedSubject]?.text ?? "";
    if (text.isEmpty) {
      setState(() => _grades[id] = "-");
      return;
    }
    final marks = int.tryParse(text) ?? 0;
    setState(() {
      _grades[id] = _calcGrade(marks);
    });
  }

  // ==================== STEP NAVIGATION ====================
  void _nextStep() {
    if (_currentStep == 0) {
      if (_selectedClass.isEmpty ||
          _selectedExam.isEmpty ||
          _selectedSubject.isEmpty) {
        _snack("Please select Class, Exam and Subject");
        return;
      }
      setState(() => _currentStep = 1);
    } else if (_currentStep == 1) {
      if (_selectedStudents.isEmpty) {
        _snack("Please select at least one student");
        return;
      }
      setState(() => _currentStep = 2);
    } else {
      _submitReports();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  void _submitReports() {
    int missing = 0;
    for (final s in _selectedStudents) {
      final id = s['id'] as String;
      final txt = _marksControllers[id]?[_selectedSubject]?.text ?? "";
      if (txt.isEmpty || int.tryParse(txt) == null) missing++;
    }
    if (missing > 0) {
      _snack("Please enter marks for all $missing selected students");
      return;
    }
    _showConfirmDialog();
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Submit Report Cards?"),
        content: Text(
          "You are submitting report cards for ${_selectedStudents.length} students "
              "in $_selectedSubject ($_selectedExam).",
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
              _showSuccessSheet();
            },
            child: const Text("Submit",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSuccessSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
              "${_selectedStudents.length} report cards successfully submitted for $_selectedExam.",
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
                  setState(() {
                    _currentStep = 0;
                    for (final s in _students) {
                      s['selected'] = false;
                    }
                  });
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

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade400,
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
          onPressed: () {
            if (_currentStep > 0) {
              _prevStep();
            } else {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          "Assign Report Card",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
      ),
      body: Column(
        children: [
          _buildStepper(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildStepContent(),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  // ==================== STEPPER ====================
  Widget _buildStepper() {
    final steps = ["Class", "Students", "Marks"];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final done = _currentStep > i ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                color: done ? Colors.indigo : Colors.grey.shade300,
              ),
            );
          }
          final idx = i ~/ 2;
          final active = idx <= _currentStep;
          final done = idx < _currentStep;
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
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      default:
        return const SizedBox();
    }
  }

  // ==================== STEP 1: CLASS / EXAM / SUBJECT ====================
  Widget _buildStep1() {
    return SingleChildScrollView(
      key: const ValueKey(1),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoCard(
            "Select the class, exam and subject for which you want to prepare report cards.",
          ),
          const SizedBox(height: 18),

          _sectionTitle("Class"),
          const SizedBox(height: 8),
          _dropdown<String>(
            value: _selectedClass,
            items: _classes,
            icon: Icons.class_rounded,
            onChanged: (v) => setState(() => _selectedClass = v!),
          ),

          const SizedBox(height: 18),
          _sectionTitle("Exam / Term"),
          const SizedBox(height: 8),
          _dropdown<String>(
            value: _selectedExam,
            items: _exams,
            icon: Icons.event_note_rounded,
            onChanged: (v) => setState(() => _selectedExam = v!),
          ),

          const SizedBox(height: 18),
          _sectionTitle("Subject"),
          const SizedBox(height: 8),
          _dropdown<String>(
            value: _selectedSubject,
            items: _subjects,
            icon: Icons.menu_book_rounded,
            onChanged: (v) => setState(() => _selectedSubject = v!),
          ),

          const SizedBox(height: 24),

          // Summary
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.indigo.withOpacity(0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.info_outline_rounded,
                        color: Colors.indigo, size: 18),
                    SizedBox(width: 8),
                    Text("Report Summary",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 10),
                _kv("Class", _selectedClass),
                _kv("Exam", _selectedExam),
                _kv("Subject", _selectedSubject),
                _kv("Max Marks", "$_maxMarks"),
                _kv("Pass Marks", "$_passMarks"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== STEP 2: SELECT STUDENTS ====================
  Widget _buildStep2() {
    final selectedCount = _selectedStudents.length;
    final allSelected = _students.every((s) => s['selected'] == true);

    return Column(
      key: const ValueKey(2),
      children: [
        // Header bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "$selectedCount of ${_students.length} selected",
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
          child: ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: _students.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final s = _students[index];
              final sel = s['selected'] as bool;
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() => s['selected'] = !sel),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: sel
                        ? Colors.indigo.withOpacity(0.06)
                        : Colors.white,
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
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: sel
                              ? Colors.indigo
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text("${s['roll']}",
                              style: TextStyle(
                                color: sel
                                    ? Colors.white
                                    : Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              )),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s['name'] as String,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text(s['id'] as String,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      Checkbox(
                        value: sel,
                        activeColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        onChanged: (v) =>
                            setState(() => s['selected'] = v ?? false),
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

  // ==================== STEP 3: ENTER MARKS ====================
  Widget _buildStep3() {
    return Column(
      key: const ValueKey(3),
      children: [
        // Header bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_selectedSubject,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text("$_selectedExam • $_selectedClass",
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
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
            itemBuilder: (context, index) {
              final s = _selectedStudents[index];
              return _buildMarkEntryCard(s);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMarkEntryCard(Map<String, dynamic> s) {
    final id = s['id'] as String;
    final grade = _grades[id] ?? "-";
    final controller = _marksControllers[id]![_selectedSubject]!;

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
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text("${s['roll']}",
                      style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(s['name'] as String,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ),
              // Grade badge
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _gradeColor(grade).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  grade,
                  style: TextStyle(
                    color: _gradeColor(grade),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Marks input
              Expanded(
                flex: 2,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _onMarksChanged(id),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: "Marks",
                    hintText: "0 - $_maxMarks",
                    labelStyle: const TextStyle(fontSize: 12),
                    prefixIcon: const Icon(Icons.grade_rounded,
                        color: Colors.indigo, size: 18),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
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
                      borderSide:
                      const BorderSide(color: Colors.indigo, width: 1.4),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Remarks
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _remarkControllers[id],
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: "Remark (optional)",
                    hintText: "e.g. Excellent work",
                    labelStyle: const TextStyle(fontSize: 12),
                    prefixIcon: const Icon(Icons.comment_rounded,
                        color: Colors.indigo, size: 18),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
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
                      borderSide:
                      const BorderSide(color: Colors.indigo, width: 1.4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== BOTTOM BAR ====================
  Widget _buildBottomBar() {
    final isLast = _currentStep == 2;
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
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevStep,
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
            if (_currentStep > 0) const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(
                  isLast
                      ? Icons.check_circle_rounded
                      : Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                label: Text(
                  isLast ? "Submit Report Cards" : "Continue",
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

  // ==================== SMALL WIDGETS ====================
  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700));
  }

  Widget _dropdown<T>({
    required T value,
    required List<T> items,
    required IconData icon,
    required ValueChanged<T?> onChanged,
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
                Text(e.toString()),
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
                style: const TextStyle(fontSize: 12, color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
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
}