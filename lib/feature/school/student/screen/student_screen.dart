import 'package:flutter/material.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  // Teacher's assigned classes
  final List<String> teacherClasses = ['Class 10 - A', 'Class 10 - B', 'Class 12 - A'];
  String _selectedClass = 'Class 10 - A';

  // Student data by class
  final Map<String, List<Map<String, dynamic>>> classStudents = {
    'Class 10 - A': [
      {'name': 'Aarav Sharma', 'rollNo': '101', 'gender': 'Male', 'present': true},
      {'name': 'Priya Patel', 'rollNo': '102', 'gender': 'Female', 'present': true},
      {'name': 'Rohit Singh', 'rollNo': '103', 'gender': 'Male', 'present': false},
      {'name': 'Sneha Reddy', 'rollNo': '104', 'gender': 'Female', 'present': true},
      {'name': 'Vikram Malhotra', 'rollNo': '105', 'gender': 'Male', 'present': true},
      {'name': 'Anjali Gupta', 'rollNo': '106', 'gender': 'Female', 'present': false},
      {'name': 'Karan Verma', 'rollNo': '107', 'gender': 'Male', 'present': true},
      {'name': 'Neha Jain', 'rollNo': '108', 'gender': 'Female', 'present': true},
    ],
    'Class 10 - B': [
      {'name': 'Amit Kumar', 'rollNo': '201', 'gender': 'Male', 'present': true},
      {'name': 'Pooja Singh', 'rollNo': '202', 'gender': 'Female', 'present': false},
      {'name': 'Rajesh Yadav', 'rollNo': '203', 'gender': 'Male', 'present': true},
      {'name': 'Kavita Reddy', 'rollNo': '204', 'gender': 'Female', 'present': true},
      {'name': 'Sanjay Patel', 'rollNo': '205', 'gender': 'Male', 'present': false},
      {'name': 'Meera Sharma', 'rollNo': '206', 'gender': 'Female', 'present': true},
    ],
    'Class 12 - A': [
      {'name': 'Aditya Singh', 'rollNo': '301', 'gender': 'Male', 'present': true},
      {'name': 'Shreya Gupta', 'rollNo': '302', 'gender': 'Female', 'present': true},
      {'name': 'Rahul Verma', 'rollNo': '303', 'gender': 'Male', 'present': false},
      {'name': 'Nisha Patel', 'rollNo': '304', 'gender': 'Female', 'present': true},
      {'name': 'Deepak Kumar', 'rollNo': '305', 'gender': 'Male', 'present': true},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final students = classStudents[_selectedClass] ?? [];

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
          'Students',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
        ],
      ),
      body: Column(
        children: [

          const SizedBox(height: 10),

          // Class Selector
          _buildClassSelector(),
          const SizedBox(height: 10),

          // Stats Row
          _buildStatsRow(students),
          const SizedBox(height: 10),

          // Student List
          Expanded(
            child: students.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: students.length,
              itemBuilder: (context, index) {
                return _buildStudentCard(students[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==================== CLASS SELECTOR ====================
  Widget _buildClassSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: teacherClasses.map((className) {
            final isSelected = _selectedClass == className;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isSelected,
                label: Text(
                  className,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 13,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
                backgroundColor: Colors.white,
                selectedColor: Colors.blue,
                onSelected: (selected) {
                  setState(() {
                    _selectedClass = className;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ==================== STATS ROW (Simple) ====================
  Widget _buildStatsRow(List<Map<String, dynamic>> students) {
    final total = students.length;
    final present = students.where((s) => s['present'] == true).length;
    final absent = total - present;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('👨‍🎓', '$total'),
          Container(width: 1, height: 25, color: Colors.grey[200]),
          _buildStatItem('✅', '$present'),
          Container(width: 1, height: 25, color: Colors.grey[200]),
          _buildStatItem('❌', '$absent'),
          Container(width: 1, height: 25, color: Colors.grey[200]),
          _buildStatItem('📊', '${total > 0 ? ((present / total) * 100).toStringAsFixed(0) : 0}%'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String emoji, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // ==================== STUDENT CARD (Simple) ====================
  Widget _buildStudentCard(Map<String, dynamic> student) {
    final isPresent = student['present'] as bool;
    final gender = student['gender'] as String;
    final color = gender == 'Male' ? Colors.blue : Colors.pink;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPresent ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                student['name'][0],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Name & Roll No
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Roll: ${student['rollNo']} • $gender',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPresent ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isPresent ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  isPresent ? 'Present' : 'Absent',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isPresent ? Colors.green : Colors.red,
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
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 12),
          Text(
            'No students found',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select a different class',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}