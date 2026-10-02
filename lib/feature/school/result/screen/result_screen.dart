import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  /// Optional: preloaded data. If null, we use the demo data below.
  final Map<String, dynamic>? studentData;

  const ResultScreen({
    super.key,
    this.studentData,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // ---------- Indigo Theme ----------
  static const _accentDark = Color(0xFF4338CA);   // Indigo 700
  static const _accentSoft = Color(0xFFE0E7FF);   // Indigo 100
  static const _ink = Color(0xFF1F2937);
  static const _inkSoft = Color(0xFF6B7280);
  static const _bg = Color(0xFFF7F8FA);

  // Currently viewed class (from 1 to 12)
  int _selectedClass = 10;

  // ---- DEMO DATA: single student, results from Class 1 to 12 ----
  final Map<String, dynamic> _demoStudent = {
    'name': 'Aarav Sharma',
    'id': 'STU-2024-001',
    'roll': '10A-01',
    'currentClass': 10,
    'session': '2024-25',
    'results': <int, Map<String, dynamic>>{
      1: {
        'exam': 'Annual Exam',
        'obtained': 445,
        'total': 500,
        'percentage': 89.0,
        'grade': 'A',
        'remark': 'Great start!',
        'subjects': [
          {'name': 'Math', 'max': 100, 'obtained': 92, 'grade': 'A+'},
          {'name': 'English', 'max': 100, 'obtained': 88, 'grade': 'A'},
          {'name': 'EVS', 'max': 100, 'obtained': 90, 'grade': 'A+'},
          {'name': 'Hindi', 'max': 100, 'obtained': 85, 'grade': 'A'},
          {'name': 'Drawing', 'max': 100, 'obtained': 90, 'grade': 'A+'},
        ],
      },
      2: {
        'exam': 'Annual Exam',
        'obtained': 452,
        'total': 500,
        'percentage': 90.4,
        'grade': 'A+',
        'remark': 'Excellent.',
        'subjects': [
          {'name': 'Math', 'max': 100, 'obtained': 94, 'grade': 'A+'},
          {'name': 'English', 'max': 100, 'obtained': 90, 'grade': 'A+'},
          {'name': 'EVS', 'max': 100, 'obtained': 88, 'grade': 'A'},
          {'name': 'Hindi', 'max': 100, 'obtained': 90, 'grade': 'A+'},
          {'name': 'Drawing', 'max': 100, 'obtained': 90, 'grade': 'A+'},
        ],
      },
      3: {
        'exam': 'Annual Exam',
        'obtained': 430,
        'total': 500,
        'percentage': 86.0,
        'grade': 'A',
        'remark': 'Good.',
        'subjects': [
          {'name': 'Math', 'max': 100, 'obtained': 88, 'grade': 'A'},
          {'name': 'English', 'max': 100, 'obtained': 86, 'grade': 'A'},
          {'name': 'Science', 'max': 100, 'obtained': 84, 'grade': 'A'},
          {'name': 'Hindi', 'max': 100, 'obtained': 86, 'grade': 'A'},
          {'name': 'Social', 'max': 100, 'obtained': 86, 'grade': 'A'},
        ],
      },
      4: {
        'exam': 'Annual Exam',
        'obtained': 441,
        'total': 500,
        'percentage': 88.2,
        'grade': 'A',
        'remark': 'Keep it up.',
        'subjects': [
          {'name': 'Math', 'max': 100, 'obtained': 90, 'grade': 'A+'},
          {'name': 'English', 'max': 100, 'obtained': 88, 'grade': 'A'},
          {'name': 'Science', 'max': 100, 'obtained': 86, 'grade': 'A'},
          {'name': 'Hindi', 'max': 100, 'obtained': 88, 'grade': 'A'},
          {'name': 'Social', 'max': 100, 'obtained': 89, 'grade': 'A'},
        ],
      },
      5: {
        'exam': 'Annual Exam',
        'obtained': 448,
        'total': 500,
        'percentage': 89.6,
        'grade': 'A',
        'remark': 'Very good.',
        'subjects': [
          {'name': 'Math', 'max': 100, 'obtained': 92, 'grade': 'A+'},
          {'name': 'English', 'max': 100, 'obtained': 90, 'grade': 'A+'},
          {'name': 'Science', 'max': 100, 'obtained': 88, 'grade': 'A'},
          {'name': 'Hindi', 'max': 100, 'obtained': 89, 'grade': 'A'},
          {'name': 'Social', 'max': 100, 'obtained': 89, 'grade': 'A'},
        ],
      },
      6: {
        'exam': 'Annual Exam',
        'obtained': 455,
        'total': 500,
        'percentage': 91.0,
        'grade': 'A+',
        'remark': 'Outstanding.',
        'subjects': [
          {'name': 'Math', 'max': 100, 'obtained': 95, 'grade': 'A+'},
          {'name': 'English', 'max': 100, 'obtained': 92, 'grade': 'A+'},
          {'name': 'Science', 'max': 100, 'obtained': 90, 'grade': 'A+'},
          {'name': 'Hindi', 'max': 100, 'obtained': 89, 'grade': 'A'},
          {'name': 'Social', 'max': 100, 'obtained': 89, 'grade': 'A'},
        ],
      },
      7: {
        'exam': 'Annual Exam',
        'obtained': 442,
        'total': 500,
        'percentage': 88.4,
        'grade': 'A',
        'remark': 'Good performance.',
        'subjects': [
          {'name': 'Math', 'max': 100, 'obtained': 90, 'grade': 'A+'},
          {'name': 'English', 'max': 100, 'obtained': 88, 'grade': 'A'},
          {'name': 'Science', 'max': 100, 'obtained': 88, 'grade': 'A'},
          {'name': 'Hindi', 'max': 100, 'obtained': 88, 'grade': 'A'},
          {'name': 'Social', 'max': 100, 'obtained': 88, 'grade': 'A'},
        ],
      },
      8: {
        'exam': 'Annual Exam',
        'obtained': 460,
        'total': 500,
        'percentage': 92.0,
        'grade': 'A+',
        'remark': 'Excellent.',
        'subjects': [
          {'name': 'Math', 'max': 100, 'obtained': 96, 'grade': 'A+'},
          {'name': 'English', 'max': 100, 'obtained': 92, 'grade': 'A+'},
          {'name': 'Science', 'max': 100, 'obtained': 92, 'grade': 'A+'},
          {'name': 'Hindi', 'max': 100, 'obtained': 90, 'grade': 'A+'},
          {'name': 'Social', 'max': 100, 'obtained': 90, 'grade': 'A+'},
        ],
      },
      9: {
        'exam': 'Annual Exam',
        'obtained': 435,
        'total': 500,
        'percentage': 87.0,
        'grade': 'A',
        'remark': 'Well done.',
        'subjects': [
          {'name': 'Math', 'max': 100, 'obtained': 88, 'grade': 'A'},
          {'name': 'English', 'max': 100, 'obtained': 86, 'grade': 'A'},
          {'name': 'Science', 'max': 100, 'obtained': 88, 'grade': 'A'},
          {'name': 'Hindi', 'max': 100, 'obtained': 87, 'grade': 'A'},
          {'name': 'Social', 'max': 100, 'obtained': 86, 'grade': 'A'},
        ],
      },
      10: {
        'exam': 'Final Term',
        'obtained': 438,
        'total': 500,
        'percentage': 87.6,
        'grade': 'A',
        'remark': 'Excellent performance. Keep it up!',
        'subjects': [
          {'name': 'Mathematics', 'max': 100, 'obtained': 92, 'grade': 'A+'},
          {'name': 'Science', 'max': 100, 'obtained': 88, 'grade': 'A'},
          {'name': 'English', 'max': 100, 'obtained': 85, 'grade': 'A'},
          {'name': 'Social Studies', 'max': 100, 'obtained': 90, 'grade': 'A+'},
          {'name': 'Hindi', 'max': 100, 'obtained': 83, 'grade': 'A'},
        ],
      },
    },
  };

  Map<String, dynamic> get _student =>
      widget.studentData ?? _demoStudent;

  int get _currentClass =>
      (_student['currentClass'] as int?) ?? 10;

  List<int> get _availableClasses {
    final results = (_student['results'] as Map).keys.cast<int>().toList();
    results.sort();
    return results;
  }

  Map<String, dynamic>? get _classResult {
    final results = _student['results'] as Map;
    return results[_selectedClass] as Map<String, dynamic>?;
  }

  Color _gradeColor(String g) {
    if (g.startsWith('A')) return const Color(0xFF059669);
    if (g.startsWith('B')) return const Color(0xFF2563EB);
    if (g.startsWith('C')) return const Color(0xFFD97706);
    return const Color(0xFFDC2626);
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.indigo,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
  }

  void _downloadCurrent() {
    final r = _classResult;
    if (r == null) return;
    _toast(
      'Downloading Class $_selectedClass result of ${_student['name']}…',
    );
  }

  @override
  Widget build(BuildContext context) {
    final classes = _availableClasses;
    if (!classes.contains(_selectedClass) && classes.isNotEmpty) {
      _selectedClass = classes.last;
    }

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: const Text(
          'Student Result',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios)),
        actions: [
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // ---- Student header ----
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _accentSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      (_student['name'] as String)
                          .substring(0, 1)
                          .toUpperCase(),
                      style: const TextStyle(
                        color: _accentDark,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _student['name'] as String,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: _ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ID: ${_student['id']}  •  Roll: ${_student['roll']}',
                        style: const TextStyle(
                            fontSize: 11.5, color: _inkSoft),
                      ),
                      Text(
                        'Current Class: $_currentClass  •  Session: ${_student['session']}',
                        style: const TextStyle(
                            fontSize: 11.5, color: _inkSoft),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 1),

          // ---- Class chips ----
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'View Result By Class',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _inkSoft,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: classes.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final c = classes[i];
                      final selected = c == _selectedClass;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedClass = c),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? Colors.indigo
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected
                                  ? Colors.indigo
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Class $c',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color:
                                selected ? Colors.white : _ink,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 1),

          // ---- Result content ----
          Expanded(
            child: _classResult == null
                ? _emptyState()
                : SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: _resultCard(_classResult!),
            ),
          ),

        ],
      ),
    );
  }

  // ============================
  //       RESULT CARD
  // ============================
  Widget _resultCard(Map<String, dynamic> r) {
    final subjects = List<Map<String, dynamic>>.from(
      (r['subjects'] as List)
          .map((e) => Map<String, dynamic>.from(e as Map)),
    );
    final gColor = _gradeColor(r['grade'] as String);
    final isPass = (r['percentage'] as num) >= 33;

    return Container(
      margin: EdgeInsets.only(bottom: 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, _accentDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(14)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.school_rounded,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'School Management',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Student Progress Report',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Download',
                      onPressed: _classResult == null ? null : _downloadCurrent,
                      icon: const Icon(Icons.download_rounded, color: Colors.white,),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _pill('Class $_selectedClass'),
                    const SizedBox(width: 8),
                    _pill(r['exam'] as String),
                  ],
                ),
              ],
            ),
          ),

          // Grade + total summary
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: gColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border:
                    Border.all(color: gColor.withOpacity(0.4)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'GRADE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: gColor,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        r['grade'] as String,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: gColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _kvLine('Obtained',
                          '${r['obtained']} / ${r['total']}'),
                      const SizedBox(height: 4),
                      _kvLine('Percentage',
                          '${r['percentage']}%'),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            'Result: ',
                            style: TextStyle(
                                fontSize: 12, color: _inkSoft),
                          ),
                          Text(
                            isPass ? 'PASS' : 'FAIL',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: isPass
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Table header
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'SUBJECT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: _inkSoft,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'MARKS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: _inkSoft,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'MAX',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: _inkSoft,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'GRADE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: _inkSoft,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Table rows
          ...subjects.map((s) {
            final c = _gradeColor(s['grade'] as String);
            return Container(
              margin:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 11),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      s['name'] as String,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: _ink,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${s['obtained']}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${s['max']}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 12, color: _inkSoft),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: c.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          s['grade'] as String,
                          style: TextStyle(
                            color: c,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 14),

          // Totals
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _accentSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _totalRow(
                  'Total Marks',
                  '${r['obtained']} / ${r['total']}',
                ),
                const SizedBox(height: 6),
                _totalRow('Percentage', '${r['percentage']}%'),
                const SizedBox(height: 6),
                _totalRow('Overall Grade', r['grade'] as String),
                const SizedBox(height: 6),
                _totalRow(
                  'Result',
                  isPass ? 'PASS' : 'FAIL',
                  color: isPass ? Colors.green : Colors.red,
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Remark
          if ((r['remark'] as String).trim().isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.amber.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.comment_rounded,
                          color: Colors.amber, size: 15),
                      SizedBox(width: 6),
                      Text(
                        "Teacher's Remark",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: _ink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    r['remark'] as String,
                    style: const TextStyle(
                        fontSize: 12, color: _ink),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 22),

          // Signatures
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _signature('Class Teacher'),
                _signature('Principal'),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Text(
            'Generated on ${_today()}',
            style: const TextStyle(fontSize: 10, color: _inkSoft),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _kvLine(String k, String v) {
    return Row(
      children: [
        Text('$k: ',
            style:
            const TextStyle(fontSize: 12, color: _inkSoft)),
        Text(
          v,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _ink,
          ),
        ),
      ],
    );
  }

  Widget _totalRow(String label, String value, {Color? color}) {
    return Row(
      children: [
        Text(
          label,
          style:
          const TextStyle(fontSize: 12, color: _inkSoft),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: color ?? _ink,
          ),
        ),
      ],
    );
  }

  Widget _signature(String label) {
    return Column(
      children: [
        Container(width: 110, height: 1, color: Colors.grey.shade400),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: _inkSoft),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.assignment_outlined,
                  size: 42, color: Colors.indigo),
            ),
            const SizedBox(height: 14),
            const Text(
              'No Result Found',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'No result available for Class $_selectedClass.',
              textAlign: TextAlign.center,
              style:
              const TextStyle(fontSize: 12, color: _inkSoft),
            ),
          ],
        ),
      ),
    );
  }

  String _today() {
    final d = DateTime.now();
    return '${d.day}/${d.month}/${d.year}';
  }
}