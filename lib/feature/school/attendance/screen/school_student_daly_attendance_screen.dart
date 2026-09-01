import 'package:flutter/material.dart';

class SchoolStudentDailyAttendanceScreen extends StatefulWidget {
  const SchoolStudentDailyAttendanceScreen({super.key});

  @override
  State<SchoolStudentDailyAttendanceScreen> createState() =>
      _SchoolStudentDailyAttendanceScreenState();
}

class _SchoolStudentDailyAttendanceScreenState
    extends State<SchoolStudentDailyAttendanceScreen> {
  // Local state variables
  String selectedDate = '';
  String className = '10th Grade';
  String section = 'A';
  bool isLoading = false;
  bool isSubmitting = false;
  String errorMessage = '';

  // Student data
  List<StudentAttendance> students = [];

  // Counts
  int presentCount = 0;
  int absentCount = 0;
  int leaveCount = 0;
  int totalStudents = 0;

  @override
  void initState() {
    super.initState();
    // Set current date
    final now = DateTime.now();
    selectedDate =
    '${now.day}-${now.month}-${now.year}';
    // Initialize with mock data
    _fetchStudents();
  }

  void _fetchStudents() {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    // Mock data - Replace with actual API call
    final mockStudents = [
      StudentAttendance(
        id: '1',
        name: 'Ahmed Khan',
        rollNumber: '01',
        className: '10th A',
        status: 'Present',
      ),
      StudentAttendance(
        id: '2',
        name: 'Sara Ahmed',
        rollNumber: '02',
        className: '10th A',
        status: 'Absent',
      ),
      StudentAttendance(
        id: '3',
        name: 'Muhammad Ali',
        rollNumber: '03',
        className: '10th A',
        status: 'Leave',
      ),
      StudentAttendance(
        id: '4',
        name: 'Fatima Noor',
        rollNumber: '04',
        className: '10th A',
        status: 'Present',
      ),
      StudentAttendance(
        id: '5',
        name: 'Usman Malik',
        rollNumber: '05',
        className: '10th A',
        status: 'Present',
      ),
      StudentAttendance(
        id: '6',
        name: 'Ayesha Bibi',
        rollNumber: '06',
        className: '10th A',
        status: 'Absent',
      ),
      StudentAttendance(
        id: '7',
        name: 'Hassan Raza',
        rollNumber: '07',
        className: '10th A',
        status: 'Present',
      ),
      StudentAttendance(
        id: '8',
        name: 'Zainab Ali',
        rollNumber: '08',
        className: '10th A',
        status: 'Leave',
      ),
      StudentAttendance(
        id: '9',
        name: 'Bilal Ahmed',
        rollNumber: '09',
        className: '10th A',
        status: 'Present',
      ),
      StudentAttendance(
        id: '10',
        name: 'Hira Noor',
        rollNumber: '10',
        className: '10th A',
        status: 'Absent',
      ),
    ];

    setState(() {
      students = mockStudents;
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

  void _updateStudentStatus(String studentId, String status) {
    setState(() {
      final index = students.indexWhere((s) => s.id == studentId);
      if (index != -1) {
        students[index] = students[index].copyWith(status: status);
        _updateCounts();
      }
    });
  }

  void _refreshAttendance() {
    _fetchStudents();
  }

  void _submitAttendance() {
    setState(() {
      isSubmitting = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      // Prepare data
      final attendanceData = students.map((s) => {
        'student_id': s.id,
        'name': s.name,
        'status': s.status,
        'date': selectedDate,
      }).toList();

      print('Attendance Data: $attendanceData');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attendance submitted successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      setState(() {
        isSubmitting = false;
      });
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit attendance'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isSubmitting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          'Daily Attendance',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _refreshAttendance,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      )
          : errorMessage.isNotEmpty
          ? _buildErrorState()
          : Column(
        children: [
          // Date and Class Info
          _buildHeader(),
          // Stats Summary
          _buildStatsSummary(),
          // Student List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: students.length,
              itemBuilder: (context, index) {
                return _buildStudentCard(students[index]);
              },
            ),
          ),
          // Submit Button
          _buildSubmitButton(),
          SizedBox(height: 12,)
        ],
      ),
    );
  }

  // ==================== HEADER ====================
  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.calendar_today_rounded,
              color: Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedDate,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Class: $className • Section: $section',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$presentCount Present',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== STATS SUMMARY ====================
  Widget _buildStatsSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _buildStatItem(
            label: 'Present',
            count: presentCount,
            color: Colors.green,
            icon: Icons.check_circle_rounded,
          ),
          _buildStatItem(
            label: 'Absent',
            count: absentCount,
            color: Colors.red,
            icon: Icons.cancel_rounded,
          ),
          _buildStatItem(
            label: 'Leave',
            count: leaveCount,
            color: Colors.orange,
            icon: Icons.beach_access_rounded,
          ),
          _buildStatItem(
            label: 'Total',
            count: totalStudents,
            color: Colors.blue,
            icon: Icons.people_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 14),
                const SizedBox(width: 4),
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== STUDENT CARD ====================
  Widget _buildStudentCard(StudentAttendance student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: _getStatusColor(student.status).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student Avatar
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    student.name[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Student Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Roll: ${student.rollNumber}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),

                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Class: ${student.className}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              // Status Radio Buttons
              Row(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStatusOption(
                    status: 'Present',
                    currentStatus: student.status,
                    onChanged: (value) {
                      _updateStudentStatus(student.id, 'Present');
                    },
                    color: Colors.green,
                    icon: Icons.check_circle_rounded,
                  ),
                  _buildStatusOption(
                    status: 'Absent',
                    currentStatus: student.status,
                    onChanged: (value) {
                      _updateStudentStatus(student.id, 'Absent');
                    },
                    color: Colors.red,
                    icon: Icons.cancel_rounded,
                  ),
                  _buildStatusOption(
                    status: 'Leave',
                    currentStatus: student.status,
                    onChanged: (value) {
                      _updateStudentStatus(student.id, 'Leave');
                    },
                    color: Colors.orange,
                    icon: Icons.beach_access_rounded,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatusOption({
    required String status,
    required String currentStatus,
    required Function(String?) onChanged,
    required Color color,
    required IconData icon,
  }) {
    final isSelected = currentStatus == status;
    return GestureDetector(
      onTap: () => onChanged(status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        margin: const EdgeInsets.only(left: 4),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey[400],
              size: 16,
            ),
            const SizedBox(width: 2),
            Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== SUBMIT BUTTON ====================
  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isSubmitting ? null : _submitAttendance,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isSubmitting
              ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.save_rounded),
              SizedBox(width: 8),
              Text(
                'Submit Attendance',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== ERROR STATE ====================
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading students',
            style: TextStyle(
              color: Colors.red[700],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refreshAttendance,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // ==================== COLOR HELPER ====================
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