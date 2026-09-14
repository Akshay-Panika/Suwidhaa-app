import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClassAttendanceScreen extends StatefulWidget {
  const ClassAttendanceScreen({super.key});

  @override
  State<ClassAttendanceScreen> createState() => _ClassAttendanceScreenState();
}

class _ClassAttendanceScreenState extends State<ClassAttendanceScreen>
    with SingleTickerProviderStateMixin {
  // ==================== STATE ====================
  late TabController _tabController;

  DateTime selectedDate = DateTime.now();
  String className = '10th Grade';
  String section = 'A';

  bool isLoading = true;
  bool isSubmitting = false;
  String errorMessage = '';
  String searchQuery = '';

  List<StudentAttendance> students = [];
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

  String _dateKey(DateTime d) => '${d.day}-${d.month}-${d.year}';

  // ==================== MOCK HISTORY ====================
  void _loadMockHistory() {
    final now = DateTime.now();
    for (int i = 0; i < 20; i++) {
      final date = now.subtract(Duration(days: i));
      final key = _dateKey(date);
      attendanceHistory[key] = [
        StudentAttendance(id: '1', name: 'Ahmed Khan', rollNumber: '01', className: '10th A', status: i % 3 == 0 ? 'Present' : (i % 3 == 1 ? 'Absent' : 'Leave')),
        StudentAttendance(id: '2', name: 'Sara Ahmed', rollNumber: '02', className: '10th A', status: i % 2 == 0 ? 'Present' : 'Absent'),
        StudentAttendance(id: '3', name: 'Muhammad Ali', rollNumber: '03', className: '10th A', status: 'Leave'),
        StudentAttendance(id: '4', name: 'Fatima Noor', rollNumber: '04', className: '10th A', status: 'Present'),
        StudentAttendance(id: '5', name: 'Usman Malik', rollNumber: '05', className: '10th A', status: i % 2 == 0 ? 'Absent' : 'Present'),
        StudentAttendance(id: '6', name: 'Ayesha Bibi', rollNumber: '06', className: '10th A', status: 'Present'),
        StudentAttendance(id: '7', name: 'Hassan Raza', rollNumber: '07', className: '10th A', status: 'Absent'),
      ];
    }
  }

  // ==================== FETCH ====================
  Future<void> _fetchStudents() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final mock = [
      StudentAttendance(id: '1', name: 'Ahmed Khan', rollNumber: '01', className: '10th A', status: 'Present'),
      StudentAttendance(id: '2', name: 'Sara Ahmed', rollNumber: '02', className: '10th A', status: 'Absent'),
      StudentAttendance(id: '3', name: 'Muhammad Ali', rollNumber: '03', className: '10th A', status: 'Leave'),
      StudentAttendance(id: '4', name: 'Fatima Noor', rollNumber: '04', className: '10th A', status: 'Present'),
      StudentAttendance(id: '5', name: 'Usman Malik', rollNumber: '05', className: '10th A', status: 'Present'),
      StudentAttendance(id: '6', name: 'Ayesha Bibi', rollNumber: '06', className: '10th A', status: 'Absent'),
      StudentAttendance(id: '7', name: 'Hassan Raza', rollNumber: '07', className: '10th A', status: 'Present'),
      StudentAttendance(id: '8', name: 'Zainab Ali', rollNumber: '08', className: '10th A', status: 'Leave'),
      StudentAttendance(id: '9', name: 'Bilal Ahmed', rollNumber: '09', className: '10th A', status: 'Present'),
      StudentAttendance(id: '10', name: 'Hira Noor', rollNumber: '10', className: '10th A', status: 'Absent'),
    ];

    if (!mounted) return;
    setState(() {
      students = mock;
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
          colorScheme: const ColorScheme.light(primary: Colors.blue),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        final key = _dateKey(picked);
        if (attendanceHistory.containsKey(key)) {
          students = attendanceHistory[key]!.map((s) => s.copyWith()).toList();
        }
        _updateCounts();
      });
    }
  }

  Future<void> _submitAttendance() async {
    setState(() => isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));

    final key = _dateKey(selectedDate);
    attendanceHistory[key] = students.map((s) => s.copyWith()).toList();

    if (!mounted) return;
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: const [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Text('Attendance saved successfully!'),
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
      backgroundColor: Colors.blue,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
      ),
      title: const Text('Class Attendance',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
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
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
        _buildHeaderCard(),
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

  // ==================== HEADER CARD ====================
  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.blue.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.school_rounded, color: Colors.white70, size: 16),
                    const SizedBox(width: 6),
                    Text('$className • Sec $section',
                        style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _formatDate(selectedDate),
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: _pickDate,
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.calendar_month_rounded, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    final today = DateTime.now();
    final isToday = d.day == today.day && d.month == today.month && d.year == today.year;
    final prefix = isToday ? 'Today • ' : '';
    return '$prefix${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}';
  }

  // ==================== STATS ====================
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _statChip('Present', presentCount, Colors.green, Icons.check_circle_rounded),
          _statChip('Absent', absentCount, Colors.red, Icons.cancel_rounded),
          _statChip('Leave', leaveCount, Colors.orange, Icons.beach_access_rounded),
          _statChip('Total', totalStudents, Colors.blue, Icons.people_rounded),
        ],
      ),
    );
  }

  Widget _statChip(String label, int count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text('$count',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  // ==================== SEARCH + BULK ====================
  Widget _buildSearchAndBulk() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Column(
        children: [
          Row(
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
                      hintText: 'Search student or roll no...',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey[500]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 11),
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
        ],
      ),
    );
  }

  Widget _bulkBtn(String label, Color color, VoidCallback onTap) {
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
            style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
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
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                student.name[0].toUpperCase(),
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student.name,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text('Roll: ${student.rollNumber}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                ],
              ),
            ),
            Row(
              children: [
                _statusBtn(student, 'Present', Icons.check_rounded, Colors.green),
                _statusBtn(student, 'Absent', Icons.close_rounded, Colors.red),
                _statusBtn(student, 'Leave', Icons.beach_access_rounded, Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBtn(StudentAttendance s, String status, IconData icon, Color color) {
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
            size: 16, color: isSelected ? Colors.white : color.withOpacity(0.7)),
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
              style: TextStyle(color: Colors.grey[500], fontSize: 14)),
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
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Text(
                '$presentCount/$totalStudents marked',
                style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton.icon(
              onPressed: isSubmitting ? null : _submitAttendance,
              icon: isSubmitting
                  ? const SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save_rounded, size: 18),
              label: Text(isSubmitting ? 'Saving...' : 'Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== TAB 2 : HISTORY ====================
  Widget _buildHistoryTab() {
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final firstWeekday = DateTime(currentMonth.year, currentMonth.month, 1).weekday;

    return Column(
      children: [
        _buildMonthSelector(),
        _buildLegend(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWeekLabels(),
                const SizedBox(height: 4),
                _buildCalendarGrid(daysInMonth, firstWeekday),
                const SizedBox(height: 16),
                _buildRecentHistoryList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthSelector() {
    const months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => setState(() =>
            currentMonth = DateTime(currentMonth.year, currentMonth.month - 1)),
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Expanded(
            child: Center(
              child: Text(
                '${months[currentMonth.month - 1]} ${currentMonth.year}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              final next = DateTime(currentMonth.year, currentMonth.month + 1);
              if (next.isBefore(DateTime.now().add(const Duration(days: 1)))) {
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
          _legendDot(Colors.grey.shade300, 'No data'),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
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
                  fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[600])),
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
      final key = _dateKey(date);
      final records = attendanceHistory[key];
      final isFuture = date.isAfter(DateTime.now());
      final isToday = _isSameDay(date, DateTime.now());

      Color? dotColor;
      if (records != null && records.isNotEmpty) {
        final p = records.where((r) => r.status == 'Present').length;
        final a = records.where((r) => r.status == 'Absent').length;
        final l = records.where((r) => r.status == 'Leave').length;
        if (p >= a && p >= l) dotColor = Colors.green;
        else if (a >= l) dotColor = Colors.red;
        else dotColor = Colors.orange;
      }

      cells.add(GestureDetector(
        onTap: isFuture || records == null
            ? null
            : () => _showHistoryDialog(key, records),
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: isToday ? Colors.blue.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isToday ? Colors.blue : Colors.grey.shade200,
              width: isToday ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$day',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                    color: isFuture ? Colors.grey[350] : Colors.black87,
                  )),
              const SizedBox(height: 3),
              if (dotColor != null)
                Container(width: 6, height: 6, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle))
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

  void _showHistoryDialog(String dateKey, List<StudentAttendance> records) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
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
            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (_, i) {
                  final s = records[i];
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
                          backgroundColor: Colors.blue.shade50,
                          child: Text(s.name[0],
                              style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
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
      ),
    );
  }

  // ==================== RECENT HISTORY LIST ====================
  Widget _buildRecentHistoryList() {
    final keys = attendanceHistory.keys.toList().reversed.take(10).toList();
    if (keys.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('No previous records',
              style: TextStyle(color: Colors.grey[500], fontSize: 13)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text('Recent Records',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
        ...keys.map((k) {
          final records = attendanceHistory[k]!;
          final p = records.where((r) => r.status == 'Present').length;
          final a = records.where((r) => r.status == 'Absent').length;
          final l = records.where((r) => r.status == 'Leave').length;
          return GestureDetector(
            onTap: () => _showHistoryDialog(k, records),
            child: Container(
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
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.event_note_rounded, color: Colors.blue, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(k, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        const SizedBox(height: 2),
                        Text('${records.length} students marked',
                            style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  _miniPill('$p P', Colors.green),
                  const SizedBox(width: 4),
                  _miniPill('$a A', Colors.red),
                  const SizedBox(width: 4),
                  _miniPill('$l L', Colors.orange),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _miniPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text,
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }

  // ==================== SKELETON ====================
  Widget _buildSkeleton() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: List.generate(6, (_) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 66,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 120, height: 12, color: Colors.grey.shade200),
                  const SizedBox(height: 6),
                  Container(width: 60, height: 10, color: Colors.grey.shade100),
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
          Icon(Icons.error_outline, size: 56, color: Colors.red[300]),
          const SizedBox(height: 10),
          Text(errorMessage, style: TextStyle(color: Colors.grey[700])),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _fetchStudents, child: const Text('Retry')),
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