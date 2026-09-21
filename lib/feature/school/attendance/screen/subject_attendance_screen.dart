import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SubjectAttendanceScreen extends StatefulWidget {
  const SubjectAttendanceScreen({super.key});

  @override
  State<SubjectAttendanceScreen> createState() =>
      _SubjectAttendanceScreenState();
}

class _SubjectAttendanceScreenState extends State<SubjectAttendanceScreen>
    with SingleTickerProviderStateMixin {
  // ==================== CONFIG DATA ====================
  final List<String> classes = ['9th', '10th', '11th', '12th'];
  final List<String> sections = ['A', 'B', 'C'];

  // Subjects per class
  final Map<String, List<String>> classSubjects = {
    '9th': ['Math', 'Physics', 'Chemistry', 'English', 'Biology'],
    '10th': ['Math', 'Physics', 'Chemistry', 'English', 'Computer'],
    '11th': ['Physics', 'Chemistry', 'Math', 'Biology', 'English'],
    '12th': ['Physics', 'Chemistry', 'Math', 'Biology', 'English'],
  };

  // ==================== STATE ====================
  late TabController _tabController;

  String selectedClass = '10th';
  String selectedSection = 'A';
  String selectedSubject = 'Math';
  DateTime selectedDate = DateTime.now();

  bool isLoading = true;
  bool isSubmitting = false;
  String errorMessage = '';
  String searchQuery = '';

  List<StudentAttendance> students = [];

  // Key: "class|section|subject|date"
  Map<String, List<StudentAttendance>> attendanceHistory = {};

  int presentCount = 0;
  int absentCount = 0;
  int leaveCount = 0;
  int totalStudents = 0;

  DateTime currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMockHistory();
    _fetchStudents();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ==================== HELPERS ====================
  String _dateKey(DateTime d) => '${d.day}-${d.month}-${d.year}';

  String _historyKey(String cls, String sec, String sub, DateTime d) =>
      '$cls|$sec|$sub|${_dateKey(d)}';

  String get _currentKey => _historyKey(
    selectedClass,
    selectedSection,
    selectedSubject,
    selectedDate,
  );

  // ==================== MOCK HISTORY ====================
  void _loadMockHistory() {
    final now = DateTime.now();
    final subjects = ['Math', 'Physics', 'Chemistry', 'English'];
    final classesList = ['10th', '9th'];

    for (int i = 0; i < 15; i++) {
      final date = now.subtract(Duration(days: i));
      for (final cls in classesList) {
        for (final sub in subjects) {
          final key = _historyKey(cls, 'A', sub, date);
          attendanceHistory[key] = _generateMockStudents(cls, sub, i);
        }
      }
    }
  }

  List<StudentAttendance> _generateMockStudents(
      String cls, String sub, int seed) {
    final baseNames = [
      'Ahmed Khan', 'Sara Ahmed', 'Muhammad Ali', 'Fatima Noor',
      'Usman Malik', 'Ayesha Bibi', 'Hassan Raza', 'Zainab Ali',
      'Bilal Ahmed', 'Hira Noor', 'Ali Raza', 'Sana Khan',
    ];

    return baseNames.asMap().entries.map((e) {
      final i = e.key;
      final statuses = ['Present', 'Present', 'Present', 'Absent', 'Leave'];
      final status = statuses[(i + seed + sub.length) % statuses.length];
      return StudentAttendance(
        id: '$cls-$sub-$i',
        name: e.value,
        rollNumber: '${(i + 1).toString().padLeft(2, '0')}',
        className: '$cls ${selectedSection}',
        status: status,
      );
    }).toList();
  }

  // ==================== FETCH ====================
  Future<void> _fetchStudents() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (attendanceHistory.containsKey(_currentKey)) {
      setState(() {
        students = attendanceHistory[_currentKey]!
            .map((s) => s.copyWith())
            .toList();
        _updateCounts();
        isLoading = false;
      });
      return;
    }

    final fresh = _generateMockStudents(selectedClass, selectedSubject, 0);
    setState(() {
      students = fresh;
      _updateCounts();
      isLoading = false;
    });
  }

  void _updateCounts() {
    presentCount = students.where((s) => s.status == 'Present').length;
    absentCount = students.where((s) => s.status == 'Absent').length;
    leaveCount = students.where((s) => s.status == 'Leave').length;
    totalStudents = students.length;
  }

  void _updateStudentStatus(String id, String status) {
    HapticFeedback.selectionClick();
    setState(() {
      final i = students.indexWhere((s) => s.id == id);
      if (i != -1) {
        students[i] = students[i].copyWith(status: status);
        _updateCounts();
      }
    });
  }

  void _markAll(String status) {
    HapticFeedback.mediumImpact();
    setState(() {
      students = students.map((s) => s.copyWith(status: status)).toList();
      _updateCounts();
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.indigo),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        final key = _historyKey(
            selectedClass, selectedSection, selectedSubject, picked);
        if (attendanceHistory.containsKey(key)) {
          students = attendanceHistory[key]!.map((s) => s.copyWith()).toList();
        } else {
          students =
              _generateMockStudents(selectedClass, selectedSubject, 0);
        }
        _updateCounts();
      });
    }
  }

  Future<void> _submitAttendance() async {
    setState(() => isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));

    attendanceHistory[_currentKey] =
        students.map((s) => s.copyWith()).toList();

    if (!mounted) return;
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$selectedSubject attendance saved!',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    setState(() => isSubmitting = false);
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: _buildAppBar(),
      body: isLoading
          ? _buildSkeleton()
          : errorMessage.isNotEmpty
          ? _buildErrorState()
          : TabBarView(
        controller: _tabController,
        children: [
          _buildMarkAttendanceTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.indigo,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new,
            color: Colors.white, size: 20),
      ),
      title: const Text('Subject Attendance',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18)),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: _fetchStudents,
          icon: const Icon(Icons.refresh, color: Colors.white),
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelStyle:
        const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        tabs: const [
          Tab(text: 'Mark Attendance'),
          Tab(text: 'History'),
        ],
      ),
    );
  }

  // ==================== TAB 1 ====================
  Widget _buildMarkAttendanceTab() {
    final filtered = students.where((s) {
      if (searchQuery.isEmpty) return true;
      return s.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          s.rollNumber.contains(searchQuery);
    }).toList();

    return Column(
      children: [
        _buildSelectionCard(),
        _buildStatsRow(),
        _buildSearchAndBulk(),
        Expanded(
          child: filtered.isEmpty
              ? _buildEmptySearch()
              : ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 100),
            itemCount: filtered.length,
            itemBuilder: (_, i) => _buildStudentCard(filtered[i]),
          ),
        ),
        _buildBottomSubmitBar(),
      ],
    );
  }

  // ==================== SELECTION CARD ====================
  Widget _buildSelectionCard() {
    final subjects = classSubjects[selectedClass] ?? [];

    if (!subjects.contains(selectedSubject) && subjects.isNotEmpty) {
      selectedSubject = subjects.first;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3F51B5), Color(0xFF303F9F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.indigo.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          // Row 1: Class + Section + Date
          Row(
            children: [
              Expanded(
                child: _selectionChip(
                  icon: Icons.class_rounded,
                  label: 'Class',
                  value: selectedClass,
                  onTap: () => _showPicker('Class', classes, (v) {
                    setState(() => selectedClass = v);
                    _fetchStudents();
                  }),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _selectionChip(
                  icon: Icons.groups_rounded,
                  label: 'Section',
                  value: selectedSection,
                  onTap: () => _showPicker('Section', sections, (v) {
                    setState(() => selectedSection = v);
                    _fetchStudents();
                  }),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: _pickDate,
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.calendar_month_rounded,
                        color: Colors.white, size: 22),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Row 2: Subject (full width)
          _selectionChip(
            icon: Icons.menu_book_rounded,
            label: 'Subject',
            value: selectedSubject,
            onTap: () => _showPicker('Subject', subjects, (v) {
              setState(() => selectedSubject = v);
              _fetchStudents();
            }),
            fullWidth: true,
          ),
          const SizedBox(height: 10),
          // Date display
          Row(
            children: [
              const Icon(Icons.event, size: 14, color: Colors.white70),
              const SizedBox(width: 6),
              Text(
                _formatDate(selectedDate),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _selectionChip({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    return Material(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: Colors.white70, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 10)),
                    Text(value,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.white70, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  void _showPicker(
      String title, List<String> options, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(height: 12),
            Text('Select $title',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (_, i) {
                  final opt = options[i];
                  final isSelected =
                      (title == 'Class' && opt == selectedClass) ||
                          (title == 'Section' && opt == selectedSection) ||
                          (title == 'Subject' && opt == selectedSubject);
                  return ListTile(
                    title: Text(opt),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.indigo)
                        : null,
                    onTap: () {
                      Navigator.pop(context);
                      onSelect(opt);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    final today = DateTime.now();
    final isToday =
        d.day == today.day && d.month == today.month && d.year == today.year;
    final prefix = isToday ? 'Today • ' : '';
    return '$prefix${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}';
  }

  // ==================== STATS ====================
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _statChip('Present', presentCount, Colors.green,
              Icons.check_circle_rounded),
          _statChip('Absent', absentCount, Colors.red,
              Icons.cancel_rounded),
          _statChip('Leave', leaveCount, Colors.orange,
              Icons.beach_access_rounded),
          _statChip('Total', totalStudents, Colors.indigo,
              Icons.people_rounded),
        ],
      ),
    );
  }

  Widget _statChip(
      String label, int count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text('$count',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(label,
                style:
                TextStyle(fontSize: 10, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  // ==================== SEARCH + BULK ====================
  Widget _buildSearchAndBulk() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                onChanged: (v) => setState(() => searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search student...',
                  hintStyle:
                  TextStyle(fontSize: 13, color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search,
                      size: 20, color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 11),
                ),
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _bulkBtn('All P', Colors.green, () => _markAll('Present')),
          const SizedBox(width: 6),
          _bulkBtn('All A', Colors.red, () => _markAll('Absent')),
        ],
      ),
    );
  }

  Widget _bulkBtn(
      String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12)),
      ),
    );
  }

  // ==================== STUDENT CARD ====================
  Widget _buildStudentCard(StudentAttendance student) {
    final color = _getStatusColor(student.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                student.name[0].toUpperCase(),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade700),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student.name,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text('Roll: ${student.rollNumber}',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey[600])),
                ],
              ),
            ),
            Row(
              children: [
                _statusBtn(student, 'Present', Icons.check_rounded,
                    Colors.green),
                _statusBtn(student, 'Absent', Icons.close_rounded,
                    Colors.red),
                _statusBtn(student, 'Leave',
                    Icons.beach_access_rounded, Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBtn(StudentAttendance s, String status,
      IconData icon, Color color) {
    final isSelected = s.status == status;
    return GestureDetector(
      onTap: () => _updateStudentStatus(s.id, status),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(left: 5),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.08),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.25),
            width: 1.4,
          ),
        ),
        child: Icon(icon,
            size: 16,
            color: isSelected
                ? Colors.white
                : color.withOpacity(0.7)),
      ),
    );
  }

  Widget _buildEmptySearch() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 56, color: Colors.grey[300]),
          const SizedBox(height: 8),
          Text('No student found',
              style:
              TextStyle(color: Colors.grey[500], fontSize: 14)),
        ],
      ),
    );
  }

  // ==================== BOTTOM SUBMIT ====================
  Widget _buildBottomSubmitBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$presentCount/$totalStudents marked',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600)),
                  Text('$selectedSubject • $selectedClass-$selectedSection',
                      style: TextStyle(
                          fontSize: 10, color: Colors.grey[500])),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: isSubmitting ? null : _submitAttendance,
              icon: isSubmitting
                  ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save_rounded, size: 18),
              label: Text(isSubmitting ? 'Saving...' : 'Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== TAB 2 : HISTORY ====================
  Widget _buildHistoryTab() {
    final daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final firstWeekday =
        DateTime(currentMonth.year, currentMonth.month, 1).weekday;

    return Column(
      children: [
        _buildMonthSelector(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWeekLabels(),
              const SizedBox(height: 4),
              _buildCalendarGrid(daysInMonth, firstWeekday),
              const SizedBox(height: 16),
            ],
          ),
        ),
        _buildLegend(),
      ],
    );
  }

  Widget _buildMonthSelector() {
    const months = [
      'January','February','March','April','May','June',
      'July','August','September','October','November','December'
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => setState(() => currentMonth = DateTime(
                currentMonth.year, currentMonth.month - 1)),
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Expanded(
            child: Center(
              child: Text(
                '${months[currentMonth.month - 1]} ${currentMonth.year}',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              final next = DateTime(
                  currentMonth.year, currentMonth.month + 1);
              if (next.isBefore(
                  DateTime.now().add(const Duration(days: 1)))) {
                setState(() => currentMonth = next);
              }
            },
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _legendDot(Colors.green, 'Present'),
          _legendDot(Colors.red, 'Absent'),
          _legendDot(Colors.orange, 'Leave'),
          _legendDot(Colors.grey.shade300, 'No class'),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildWeekLabels() {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Row(
      children: labels
          .map((l) => Expanded(
        child: Center(
          child: Text(l,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600])),
        ),
      ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid(int daysInMonth, int firstWeekday) {
    final cells = <Widget>[];
    for (int i = 1; i < firstWeekday; i++) {
      cells.add(const SizedBox());
    }
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      final isFuture = date.isAfter(DateTime.now());
      final isToday = _isSameDay(date, DateTime.now());

      // Collect all records for this date
      final dateK = _dateKey(date);
      final dayRecords = <StudentAttendance>[];
      attendanceHistory.forEach((key, records) {
        if (key.endsWith(dateK)) {
          dayRecords.addAll(records);
        }
      });

      int p = dayRecords.where((r) => r.status == 'Present').length;
      int a = dayRecords.where((r) => r.status == 'Absent').length;
      int l = dayRecords.where((r) => r.status == 'Leave').length;

      Color? dotColor;
      if (p + a + l > 0) {
        if (p >= a && p >= l) dotColor = Colors.green;
        else if (a >= l) dotColor = Colors.red;
        else dotColor = Colors.orange;
      }

      cells.add(GestureDetector(
        onTap: isFuture || dayRecords.isEmpty
            ? null
            : () => _showHistoryDialog(dateK, dayRecords),
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: isToday
                ? Colors.indigo.withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isToday ? Colors.indigo : Colors.grey.shade200,
              width: isToday ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$day',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                    isToday ? FontWeight.bold : FontWeight.w500,
                    color: isFuture
                        ? Colors.grey[350]
                        : Colors.black87,
                  )),
              const SizedBox(height: 3),
              if (dotColor != null)
                Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                        color: dotColor, shape: BoxShape.circle))
              else
                const SizedBox(height: 6),
            ],
          ),
        ),
      ));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.0,
      children: cells,
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.day == b.day && a.month == b.month && a.year == b.year;

  // ==================== HISTORY DIALOG WITH FILTER ====================
  void _showHistoryDialog(String dateKey, List<StudentAttendance> records) {
    const filterList = ["All", "Present", "Absent", "Leave"];
    String selectedFilter = "All";

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) {
          final filteredRecords = selectedFilter == "All"
              ? records
              : records.where((r) => r.status == selectedFilter).toList();

          return Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Attendance • $dateKey',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filterList.length,
                    itemBuilder: (_, index) {
                      final filter = filterList[index];
                      final isSelected = selectedFilter == filter;
                      final color = filter == "All"
                          ? Colors.indigo
                          : _getStatusColor(filter);
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedFilter = filter),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? color : color.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? color : color.withOpacity(0.25),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            filter,
                            style: TextStyle(
                              color: isSelected ? Colors.white : color,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: filteredRecords.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.filter_alt_off, size: 48, color: Colors.grey[300]),
                        const SizedBox(height: 8),
                        Text('No records found',
                            style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                      ],
                    ),
                  )
                      : ListView.builder(
                    itemCount: filteredRecords.length,
                    itemBuilder: (_, i) {
                      final s = filteredRecords[i];
                      final c = _getStatusColor(s.status);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: c.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: c.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.indigo.shade50,
                              child: Text(s.name[0],
                                  style: TextStyle(color: Colors.indigo.shade700, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  Text('Roll: ${s.rollNumber}',
                                      style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: c.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(s.status,
                                  style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ==================== SKELETON ====================
  Widget _buildSkeleton() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: List.generate(
          6,
              (_) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 66,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 120,
                          height: 12,
                          color: Colors.grey.shade200),
                      const SizedBox(height: 6),
                      Container(
                          width: 60,
                          height: 10,
                          color: Colors.grey.shade100),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  // ==================== ERROR ====================
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline,
              size: 56, color: Colors.red[300]),
          const SizedBox(height: 10),
          Text(errorMessage,
              style: TextStyle(color: Colors.grey[700])),
          const SizedBox(height: 12),
          ElevatedButton(
              onPressed: _fetchStudents,
              child: const Text('Retry')),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Present':
        return Colors.green;
      case 'Absent':
        return Colors.red;
      case 'Leave':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

// ==================== MODEL ====================
class StudentAttendance {
  final String id;
  final String name;
  final String rollNumber;
  final String className;
  final String status;

  StudentAttendance({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.className,
    required this.status,
  });

  StudentAttendance copyWith({
    String? id,
    String? name,
    String? rollNumber,
    String? className,
    String? status,
  }) {
    return StudentAttendance(
      id: id ?? this.id,
      name: name ?? this.name,
      rollNumber: rollNumber ?? this.rollNumber,
      className: className ?? this.className,
      status: status ?? this.status,
    );
  }
}