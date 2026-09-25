// lib/feature/student_attendance/screen/class_attendance_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:untitled/feature/school/attendance/screen/student_attendance_detail_screen.dart';
import 'package:untitled/feature/school/leave/screen/student_leave_request_screen.dart';

import '../../student/controller/student_list_controller.dart';
import '../controller/student_attendance_controller.dart';
import '../model/student_attendance_model.dart';

class ClassAttendanceScreen extends StatefulWidget {
  const ClassAttendanceScreen({super.key});

  @override
  State<ClassAttendanceScreen> createState() => _ClassAttendanceScreenState();
}

class _ClassAttendanceScreenState extends State<ClassAttendanceScreen> {
  // ==================== CONTROLLER ====================
  final studentListController = Get.find<StudentListController>();
  final studentAttendanceController = Get.find<StudentAttendanceController>();

  // ==================== STATE ====================
  String section = 'A';

  // 🔹 Class filter state
  String selectedClass = 'All';

  // 🔹 Selected date (default = today)
  DateTime selectedDate = DateTime.now();

  bool isLoading = true;
  String errorMessage = '';
  String searchQuery = '';

  List<StudentAttendance> students = [];

  int presentCount = 0;
  int absentCount = 0;
  int leaveCount = 0;
  int totalStudents = 0;

  /// 🔹 Format date → "YYYY-MM-DD"
  String get selectedDateStr {
    final d = selectedDate;
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  // ==================== FETCH FROM API ====================
  Future<void> _fetchStudents() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      if (studentListController.studentList.isEmpty) {
        await studentListController.loadStudentList();
      }

      if (studentListController.errorMessage.value.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
          errorMessage = studentListController.errorMessage.value;
        });
        return;
      }

      final dateForFetch = selectedDateStr;

      // 🔹 हर student का attendance parallel में fetch
      final results = await Future.wait(
        studentListController.studentList.map((s) async {
          final studentCardId = s.studentIdCard;

          debugPrint('🔍 Processing: $studentCardId (${s.fullName})');

          final status = await _fetchStatusForDate(
            studentCardId,
            dateForFetch,
          );

          return StudentAttendance(
            id: s.id.toString(),
            name: s.fullName,
            rollNumber: studentCardId,
            className: '${s.studentClass} $section',
            status: status,
            sClass: s.studentClass,
          );
        }),
      );

      if (!mounted) return;
      setState(() {
        students = results;
        _updateCounts();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load students: $e';
      });
    }
  }

  void _updateCounts() {
    presentCount = students.where((s) => s.status == 'Present').length;
    absentCount = students.where((s) => s.status == 'Absent').length;
    leaveCount = students.where((s) => s.status == 'Leave').length;
    totalStudents = students.length;
  }


  Future<String> _fetchStatusForDate(
      String studentCardId,
      String dateStr,
      ) async {
    try {
      await studentAttendanceController.fetchStudentAttendance(studentCardId);

      final data = studentAttendanceController.attendanceData.value;

      if (data == null || data.status == false) {
        debugPrint('   ❌ $studentCardId → status false → Absent');
        return 'Absent';
      }

      if (data.history.isEmpty) {
        debugPrint('   ❌ $studentCardId → history empty → Absent');
        return 'Absent';
      }

      for (final yearEntry in data.history.entries) {
        for (final monthEntry in yearEntry.value.entries) {
          for (final record in monthEntry.value) {
            if (record.date == dateStr) {
              final status = record.attendanceStatus.toLowerCase();
              debugPrint('   ✅ $studentCardId → $dateStr → $status');

              if (status == 'present') return 'Present';
              if (status == 'absent') return 'Absent';
              if (status == 'leave') return 'Leave';
              return 'Absent';
            }
          }
        }
      }

      debugPrint(
          '   ❌ $studentCardId → $dateStr का record नहीं → Absent (default)');
      return 'Absent';
    } catch (e) {
      debugPrint('   ❌ $studentCardId failed: $e');
      return 'Absent';
    }
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

  // ==================== DATE PICKER ====================
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.indigo,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      // 🔹 नई date का data fetch करो
      await _fetchStudents();
    }
  }

  // ==================== SUBMIT ====================
  Future<void> _handleSubmit(List<StudentAttendance> list) async {
    if (list.isEmpty) {
      Get.snackbar('No Data', 'Koi student select nahi hai');
      return;
    }

    // 🔹 चुनी हुई date use करो (आज की नहीं)
    final dateStr = selectedDateStr;

    // 🔹 UI से data collect करो
    final items = list.map((s) {
      return StudentAttendanceItem(
        studentCardId: s.rollNumber,
        studentName: s.name,
        studentClass: '${s.sClass}th',
        schoolType: section, // 'A'
        date: dateStr,
        attendanceStatus: s.status.toLowerCase(),
        remarks: '',
      );
    }).toList();

    debugPrint('📤 Submitting ${items.length} students for $dateStr...');

    final success =
    await studentAttendanceController.submitBulkAttendance(items);

    if (success) {
      debugPrint('✅ Attendance saved!');
    } else {
      debugPrint('❌ Failed to save');
    }
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (studentListController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (studentListController.errorMessage.value.isNotEmpty) {
          return _buildErrorState();
        }

        return isLoading
            ? _buildSkeleton()
            : errorMessage.isNotEmpty
            ? _buildErrorState()
            : _buildMarkAttendanceTab();
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.indigo,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon:
        const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
      ),
      title: const Text(
        'Class Attendance',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
      ),
      centerTitle: true,
    );
  }

  // ==================== MAIN TAB ====================
  Widget _buildMarkAttendanceTab() {
    final filtered = students.where((s) {
      final studentClass = s.className.split(' ').first;
      final classMatch =
          selectedClass == 'All' || studentClass == selectedClass;

      final searchMatch = searchQuery.isEmpty ||
          s.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          s.rollNumber.contains(searchQuery);

      return classMatch && searchMatch;
    }).toList();

    return Column(
      children: [
        _buildStatsRow(filtered),
        _buildSearchAndBulk(),
        Expanded(
          child: filtered.isEmpty
              ? _buildEmptySearch()
              : ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 100),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final student = filtered[index];
              return _buildStudentCard(student);
            },
          ),
        ),
        _buildBottomSubmitBar(filtered),
      ],
    );
  }

  // ==================== STATS ====================
  Widget _buildStatsRow([List<StudentAttendance>? data]) {
    final list = data ?? students;
    final present = list.where((s) => s.status == 'Present').length;
    final absent = list.where((s) => s.status == 'Absent').length;
    final leave = list.where((s) => s.status == 'Leave').length;
    final total = list.length;

    // ✅ selectedDate दिखाओ (आज की नहीं)
    final displayDate = selectedDateStr;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// date select
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: _pickDate, // 👈 date picker open
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.indigo.withOpacity(0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          const Icon(Icons.calendar_month,
                              size: 20, color: Colors.indigo),
                          Text(
                            "Date: $displayDate",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_drop_down,
                              size: 18, color: Colors.indigo),
                        ],
                      ),
                    ),
                  ),
                  
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.indigo.withOpacity(0.25),
                        ),
                      ),
                      child: Text("0 Leave", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.red),),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StudentLeaveRequestScreen(),));
                    },
                  ),
                ],
              ),
            ),
            Row(
              children: [
                _statChip(
                    'Present', present, Colors.green, Icons.check_circle_rounded),
                _statChip('Absent', absent, Colors.red, Icons.cancel_rounded),
                _statChip(
                    'Leave', leave, Colors.orange, Icons.beach_access_rounded),
                _statChip(
                    'Total', total, Colors.indigo, Icons.people_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip(String label, int count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          spacing: 4,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$count',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
            Text(label,
                style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  // ==================== SEARCH + CLASS FILTER ====================
  Widget _buildSearchAndBulk() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _showClassFilterSheet,
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: selectedClass == 'All'
                        ? Colors.white
                        : Colors.indigo.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedClass == 'All'
                          ? Colors.grey.withOpacity(0.3)
                          : Colors.indigo.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedClass == 'All'
                            ? "All Class"
                            : "Class $selectedClass",
                        style: TextStyle(
                          color: selectedClass == 'All'
                              ? Colors.black
                              : Colors.indigo,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 18,
                        color: selectedClass == 'All'
                            ? Colors.black54
                            : Colors.indigo,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
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
                      hintStyle:
                      TextStyle(fontSize: 13, color: Colors.grey[400]),
                      prefixIcon:
                      Icon(Icons.search, size: 20, color: Colors.grey[500]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== CLASS FILTER HELPERS ====================
  List<String> _getUniqueClasses() {
    final set = <String>{};
    for (final s in students) {
      final cls = s.className.split(' ').first;
      if (cls.isNotEmpty) set.add(cls);
    }
    final list = set.toList();
    list.sort();
    return ['All', ...list];
  }

  void _showClassFilterSheet() {
    final classes = _getUniqueClasses();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Select Class',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: classes.map((cls) {
                  final isSelected = selectedClass == cls;
                  return ChoiceChip(
                    label: Text(cls),
                    selected: isSelected,
                    onSelected: (_) {
                      setModalState(() => selectedClass = cls);
                      setState(() {});
                      Get.back();
                    },
                    selectedColor: Colors.indigo,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    backgroundColor: Colors.grey.shade100,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              if (selectedClass != 'All')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() => selectedClass = 'All');
                      Get.back();
                    },
                    icon: const Icon(Icons.clear, size: 18),
                    label: const Text('Clear Class Filter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
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
            InkWell(
              onTap: () {
                Get.to(() => StudentAttendanceDetailScreen(
                  studentCardId: student.rollNumber,
                  studentName: student.name,
                  studentClass: student.sClass,
                ));
              },
              child: Container(
                width: 60,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Class: ${student.sClass}th',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[900]),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'ID: ${student.rollNumber}',
                        style:
                        TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _statusBtn(student, 'Present', Colors.green),
                      _statusBtn(student, 'Absent', Colors.red),
                      _statusBtn(student, 'Leave', Colors.orange),
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

  Widget _statusBtn(StudentAttendance s, String status, Color color) {
    final isSelected = s.status == status;
    return GestureDetector(
      onTap: () => _updateStudentStatus(s.id, status),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(left: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.25),
            width: 1.4,
          ),
        ),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : color,
          ),
        ),
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
          Text(
            'No student found',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ==================== BOTTOM SUBMIT ====================
  Widget _buildBottomSubmitBar([List<StudentAttendance>? data]) {
    final list = data ?? students;
    final present = list.where((s) => s.status == 'Present').length;
    final total = list.length;

    // 👇 controller का reactive isSubmitting use करो
    return Obx(() {
      final submitting = studentAttendanceController.isSubmitting.value;

      return Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$present/$total Marked',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.indigo,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: submitting ? null : () => _handleSubmit(list),
                icon: submitting
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.save_rounded, size: 18),
                label: Text(submitting ? 'Saving...' : 'Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
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
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 120, height: 12, color: Colors.grey.shade200),
                    const SizedBox(height: 6),
                    Container(
                        width: 60, height: 10, color: Colors.grey.shade100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
  final String sClass;

  StudentAttendance({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.className,
    required this.status,
    required this.sClass,
  });

  StudentAttendance copyWith({
    String? id,
    String? name,
    String? rollNumber,
    String? className,
    String? status,
    String? sClass,
  }) {
    return StudentAttendance(
      id: id ?? this.id,
      name: name ?? this.name,
      rollNumber: rollNumber ?? this.rollNumber,
      className: className ?? this.className,
      status: status ?? this.status,
      sClass: sClass ?? this.sClass,
    );
  }
}