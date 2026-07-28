import 'package:flutter/material.dart';
import '../../../../core/utils/app_color.dart';

class ClassmatesScreen extends StatefulWidget {
  const ClassmatesScreen({super.key});

  @override
  State<ClassmatesScreen> createState() => _ClassmatesScreenState();
}

class _ClassmatesScreenState extends State<ClassmatesScreen> {
  String _selectedClass = '10-B';
  String _selectedSort = 'Name';

  final List<String> _classes = ['10-A', '10-B', '10-C', '9-A', '9-B', '8-A', '8-B'];
  final List<String> _sortOptions = ['Name', 'Roll No', 'Attendance'];

  // Class Teacher Data
  final Map<String, Map<String, dynamic>> _classTeachers = {
    '10-A': {
      'name': 'Dr. Sanjay Sharma',
      'subject': 'Mathematics',
      'email': 'sanjay.sharma@school.com',
      'phone': '+91 98765 43001',
      'experience': '15 years',
      'qualification': 'Ph.D. in Mathematics',
      'room': '101',
    },
    '10-B': {
      'name': 'Mrs. Priya Verma',
      'subject': 'English',
      'email': 'priya.verma@school.com',
      'phone': '+91 98765 43002',
      'experience': '12 years',
      'qualification': 'M.A. in English Literature',
      'room': '201',
    },
    '10-C': {
      'name': 'Mr. Rajesh Kumar',
      'subject': 'Physics',
      'email': 'rajesh.kumar@school.com',
      'phone': '+91 98765 43003',
      'experience': '10 years',
      'qualification': 'M.Sc. in Physics',
      'room': '301',
    },
    '9-A': {
      'name': 'Mrs. Anita Singh',
      'subject': 'Chemistry',
      'email': 'anita.singh@school.com',
      'phone': '+91 98765 43004',
      'experience': '8 years',
      'qualification': 'M.Sc. in Chemistry',
      'room': '401',
    },
    '9-B': {
      'name': 'Mr. Suresh Patel',
      'subject': 'Social Studies',
      'email': 'suresh.patel@school.com',
      'phone': '+91 98765 43005',
      'experience': '14 years',
      'qualification': 'M.A. in History',
      'room': '501',
    },
    '8-A': {
      'name': 'Mrs. Meera Gupta',
      'subject': 'Science',
      'email': 'meera.gupta@school.com',
      'phone': '+91 98765 43006',
      'experience': '9 years',
      'qualification': 'M.Sc. in Biology',
      'room': '601',
    },
    '8-B': {
      'name': 'Mr. Vikram Rao',
      'subject': 'Mathematics',
      'email': 'vikram.rao@school.com',
      'phone': '+91 98765 43007',
      'experience': '11 years',
      'qualification': 'M.Sc. in Mathematics',
      'room': '701',
    },
  };

  final Map<String, List<Map<String, dynamic>>> _classStudents = {
    '10-A': [
      {'name': 'Aarav Sharma', 'rollNo': '1', 'email': 'aarav.s@email.com', 'attendance': '95%', 'gender': 'Male', 'phone': '+91 98765 43210'},
      {'name': 'Priya Patel', 'rollNo': '2', 'email': 'priya.p@email.com', 'attendance': '88%', 'gender': 'Female', 'phone': '+91 98765 43211'},
      {'name': 'Rahul Kumar', 'rollNo': '3', 'email': 'rahul.k@email.com', 'attendance': '92%', 'gender': 'Male', 'phone': '+91 98765 43212'},
      {'name': 'Sneha Reddy', 'rollNo': '4', 'email': 'sneha.r@email.com', 'attendance': '97%', 'gender': 'Female', 'phone': '+91 98765 43213'},
      {'name': 'Vikram Singh', 'rollNo': '5', 'email': 'vikram.s@email.com', 'attendance': '85%', 'gender': 'Male', 'phone': '+91 98765 43214'},
      {'name': 'Ananya Gupta', 'rollNo': '6', 'email': 'ananya.g@email.com', 'attendance': '90%', 'gender': 'Female', 'phone': '+91 98765 43215'},
      {'name': 'Arjun Mehta', 'rollNo': '7', 'email': 'arjun.m@email.com', 'attendance': '78%', 'gender': 'Male', 'phone': '+91 98765 43216'},
      {'name': 'Kavya Nair', 'rollNo': '8', 'email': 'kavya.n@email.com', 'attendance': '94%', 'gender': 'Female', 'phone': '+91 98765 43217'},
    ],
    '10-B': [
      {'name': 'Rohan Verma', 'rollNo': '1', 'email': 'rohan.v@email.com', 'attendance': '92%', 'gender': 'Male', 'phone': '+91 98765 43218'},
      {'name': 'Meera Joshi', 'rollNo': '2', 'email': 'meera.j@email.com', 'attendance': '96%', 'gender': 'Female', 'phone': '+91 98765 43219'},
      {'name': 'Amit Shah', 'rollNo': '3', 'email': 'amit.s@email.com', 'attendance': '89%', 'gender': 'Male', 'phone': '+91 98765 43220'},
      {'name': 'Pooja Desai', 'rollNo': '4', 'email': 'pooja.d@email.com', 'attendance': '93%', 'gender': 'Female', 'phone': '+91 98765 43221'},
      {'name': 'Kunal Patil', 'rollNo': '5', 'email': 'kunal.p@email.com', 'attendance': '87%', 'gender': 'Male', 'phone': '+91 98765 43222'},
      {'name': 'Riya Malhotra', 'rollNo': '6', 'email': 'riya.m@email.com', 'attendance': '91%', 'gender': 'Female', 'phone': '+91 98765 43223'},
      {'name': 'Sanjay Rao', 'rollNo': '7', 'email': 'sanjay.r@email.com', 'attendance': '82%', 'gender': 'Male', 'phone': '+91 98765 43224'},
      {'name': 'Neha Gupta', 'rollNo': '8', 'email': 'neha.g@email.com', 'attendance': '95%', 'gender': 'Female', 'phone': '+91 98765 43225'},
    ],
    '10-C': [
      {'name': 'Deepak Yadav', 'rollNo': '1', 'email': 'deepak.y@email.com', 'attendance': '88%', 'gender': 'Male', 'phone': '+91 98765 43226'},
      {'name': 'Shreya Singh', 'rollNo': '2', 'email': 'shreya.s@email.com', 'attendance': '94%', 'gender': 'Female', 'phone': '+91 98765 43227'},
      {'name': 'Manoj Kumar', 'rollNo': '3', 'email': 'manoj.k@email.com', 'attendance': '79%', 'gender': 'Male', 'phone': '+91 98765 43228'},
      {'name': 'Anjali Sharma', 'rollNo': '4', 'email': 'anjali.s@email.com', 'attendance': '97%', 'gender': 'Female', 'phone': '+91 98765 43229'},
      {'name': 'Rajesh Patel', 'rollNo': '5', 'email': 'rajesh.p@email.com', 'attendance': '86%', 'gender': 'Male', 'phone': '+91 98765 43230'},
    ],
    '9-A': [
      {'name': 'Aryan Singh', 'rollNo': '1', 'email': 'aryan.s@email.com', 'attendance': '93%', 'gender': 'Male', 'phone': '+91 98765 43231'},
      {'name': 'Isha Sharma', 'rollNo': '2', 'email': 'isha.s@email.com', 'attendance': '96%', 'gender': 'Female', 'phone': '+91 98765 43232'},
      {'name': 'Tanya Gupta', 'rollNo': '3', 'email': 'tanya.g@email.com', 'attendance': '89%', 'gender': 'Female', 'phone': '+91 98765 43233'},
      {'name': 'Karan Mehta', 'rollNo': '4', 'email': 'karan.m@email.com', 'attendance': '91%', 'gender': 'Male', 'phone': '+91 98765 43234'},
      {'name': 'Nisha Patel', 'rollNo': '5', 'email': 'nisha.p@email.com', 'attendance': '94%', 'gender': 'Female', 'phone': '+91 98765 43235'},
    ],
    '9-B': [
      {'name': 'Ravi Kumar', 'rollNo': '1', 'email': 'ravi.k@email.com', 'attendance': '87%', 'gender': 'Male', 'phone': '+91 98765 43236'},
      {'name': 'Sonia Reddy', 'rollNo': '2', 'email': 'sonia.r@email.com', 'attendance': '92%', 'gender': 'Female', 'phone': '+91 98765 43237'},
      {'name': 'Gaurav Singh', 'rollNo': '3', 'email': 'gaurav.s@email.com', 'attendance': '85%', 'gender': 'Male', 'phone': '+91 98765 43238'},
      {'name': 'Pallavi Gupta', 'rollNo': '4', 'email': 'pallavi.g@email.com', 'attendance': '90%', 'gender': 'Female', 'phone': '+91 98765 43239'},
    ],
    '8-A': [
      {'name': 'Dhruv Sharma', 'rollNo': '1', 'email': 'dhruv.s@email.com', 'attendance': '95%', 'gender': 'Male', 'phone': '+91 98765 43240'},
      {'name': 'Maya Patel', 'rollNo': '2', 'email': 'maya.p@email.com', 'attendance': '88%', 'gender': 'Female', 'phone': '+91 98765 43241'},
      {'name': 'Siddharth Rao', 'rollNo': '3', 'email': 'siddharth.r@email.com', 'attendance': '92%', 'gender': 'Male', 'phone': '+91 98765 43242'},
      {'name': 'Tanvi Singh', 'rollNo': '4', 'email': 'tanvi.s@email.com', 'attendance': '96%', 'gender': 'Female', 'phone': '+91 98765 43243'},
    ],
    '8-B': [
      {'name': 'Aditya Kumar', 'rollNo': '1', 'email': 'aditya.k@email.com', 'attendance': '90%', 'gender': 'Male', 'phone': '+91 98765 43244'},
      {'name': 'Divya Sharma', 'rollNo': '2', 'email': 'divya.s@email.com', 'attendance': '94%', 'gender': 'Female', 'phone': '+91 98765 43245'},
      {'name': 'Rishi Gupta', 'rollNo': '3', 'email': 'rishi.g@email.com', 'attendance': '87%', 'gender': 'Male', 'phone': '+91 98765 43246'},
      {'name': 'Aisha Singh', 'rollNo': '4', 'email': 'aisha.s@email.com', 'attendance': '91%', 'gender': 'Female', 'phone': '+91 98765 43247'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final students = _classStudents[_selectedClass] ?? [];
    final sortedStudents = _getSortedStudents(students);
    final classTeacher = _classTeachers[_selectedClass];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Class Selector
          _buildClassSelector(),
          const SizedBox(height: 16),

          // Class Teacher Card
          if (classTeacher != null) _buildClassTeacherCard(classTeacher),
          const SizedBox(height: 16),

          // Statistics Card
          _buildStatisticsCard(sortedStudents),
          const SizedBox(height: 16),

          // Sort & Filter
          _buildSortFilter(),
          const SizedBox(height: 12),

          // Section Header
          _buildSectionHeader("👥 Classmates (${sortedStudents.length})"),
          const SizedBox(height: 8),

          // Student List
          if (sortedStudents.isNotEmpty)
            ...sortedStudents.map((student) => _buildStudentCard(student))
          else
            _buildEmptyState(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ==================== CLASS SELECTOR ====================
  Widget _buildClassSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.people_rounded, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Select Class',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _classes.length,
              itemBuilder: (context, index) {
                final classItem = _classes[index];
                final isSelected = _selectedClass == classItem;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedClass = classItem;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                          colors: [AppColors.primary, Color(0xFFFF6B35)],
                        )
                            : null,
                        color: isSelected ? null : Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey[300]!,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        classItem,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
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
    );
  }

  // ==================== CLASS TEACHER CARD ====================
  Widget _buildClassTeacherCard(Map<String, dynamic> teacher) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6C63FF), Color(0xFF3F3D9E)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Center(
                  child: Text(
                    teacher['name'][0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacher['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Class Teacher',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            teacher['subject'],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            color: Colors.white.withOpacity(0.2),
            height: 1,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTeacherInfo(
                Icons.email_rounded,
                teacher['email'],
                Colors.white,
              ),
              _buildTeacherInfo(
                Icons.phone_rounded,
                teacher['phone'],
                Colors.white,
              ),
              _buildTeacherInfo(
                Icons.workspace_premium_rounded,
                teacher['experience'],
                Colors.white,
              ),
              _buildTeacherInfo(
                Icons.meeting_room_rounded,
                'Room ${teacher['room']}',
                Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherInfo(IconData icon, String text, Color color) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color.withOpacity(0.8),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== STATISTICS CARD ====================
  Widget _buildStatisticsCard(List<Map<String, dynamic>> students) {
    final totalStudents = students.length;
    final maleCount = students.where((s) => s['gender'] == 'Male').length;
    final femaleCount = students.where((s) => s['gender'] == 'Female').length;
    final avgAttendance = students.isEmpty
        ? 0
        : students.fold(0.0, (sum, s) {
      String att = s['attendance'].toString().replaceAll('%', '');
      return sum + double.parse(att);
    }) / totalStudents;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal, Colors.cyan],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('👥', '$totalStudents', 'Students', Colors.white),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildStatItem('👨', '$maleCount', 'Boys', Colors.white),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildStatItem('👩', '$femaleCount', 'Girls', Colors.white),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildStatItem('📊', '${avgAttendance.toStringAsFixed(0)}%', 'Attendance', Colors.white),
        ],
      ),
    );
  }

  Widget _buildStatItem(String emoji, String value, String label, Color textColor) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: textColor.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // ==================== SORT & FILTER ====================
  Widget _buildSortFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Sort by:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(
            height: 32,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: _sortOptions.length,
              itemBuilder: (context, index) {
                final option = _sortOptions[index];
                final isSelected = _selectedSort == option;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSort = option;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
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
    );
  }

  // ==================== SECTION HEADER ====================
  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textMain,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Class ${_selectedClass}',
            style: TextStyle(
              color: Colors.teal,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== STUDENT CARD ====================
  Widget _buildStudentCard(Map<String, dynamic> student) {
    final bool isMale = student['gender'] == 'Male';
    final Color genderColor = isMale ? Colors.blue : Colors.pink;
    final String attendance = student['attendance'].toString().replaceAll('%', '');
    final double attendanceValue = double.parse(attendance);
    final Color attendanceColor = attendanceValue >= 90
        ? Colors.green
        : attendanceValue >= 75
        ? Colors.orange
        : Colors.red;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: genderColor.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [genderColor, genderColor.withOpacity(0.6)],
              ),
            ),
            child: Center(
              child: Text(
                student['name'][0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Student Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      student['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: genderColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Roll #${student['rollNo']}',
                        style: TextStyle(
                          color: genderColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.email_rounded,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          student['email'],
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_rounded,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          student['phone'],
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Attendance
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: attendanceColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: attendanceColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      student['attendance'],
                      style: TextStyle(
                        color: attendanceColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: genderColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  student['gender'],
                  style: TextStyle(
                    color: genderColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== EMPTY STATE ====================
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.people_outline_rounded,
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

  // ==================== HELPER METHODS ====================
  List<Map<String, dynamic>> _getSortedStudents(List<Map<String, dynamic>> students) {
    List<Map<String, dynamic>> sorted = List.from(students);

    switch (_selectedSort) {
      case 'Name':
        sorted.sort((a, b) => a['name'].compareTo(b['name']));
        break;
      case 'Roll No':
        sorted.sort((a, b) => int.parse(a['rollNo']).compareTo(int.parse(b['rollNo'])));
        break;
      case 'Attendance':
        sorted.sort((a, b) {
          double attA = double.parse(a['attendance'].toString().replaceAll('%', ''));
          double attB = double.parse(b['attendance'].toString().replaceAll('%', ''));
          return attB.compareTo(attA);
        });
        break;
    }
    return sorted;
  }
}