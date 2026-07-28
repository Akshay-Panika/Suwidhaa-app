import 'package:flutter/material.dart';
import '../../../../core/utils/app_color.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  String _selectedClass = '10-B';
  String _selectedSection = 'B';

  final List<String> _classes = ['10-A', '10-B', '10-C', '9-A', '9-B', '8-A', '8-B'];

  final Map<String, List<Map<String, dynamic>>> _classSubjects = {
    '10-A': [
      {'name': 'Mathematics', 'teacher': 'Mr. Sharma', 'room': '101', 'time': '09:00 AM', 'color': Colors.blue, 'icon': Icons.calculate_rounded},
      {'name': 'Physics', 'teacher': 'Mrs. Verma', 'room': '102', 'time': '10:00 AM', 'color': Colors.green, 'icon': Icons.science_rounded},
      {'name': 'Chemistry', 'teacher': 'Dr. Patel', 'room': '103', 'time': '11:00 AM', 'color': Colors.orange, 'icon': Icons.science_rounded},
      {'name': 'English', 'teacher': 'Ms. Singh', 'room': '104', 'time': '12:00 PM', 'color': Colors.purple, 'icon': Icons.menu_book_rounded},
      {'name': 'Hindi', 'teacher': 'Mr. Gupta', 'room': '105', 'time': '02:00 PM', 'color': Colors.red, 'icon': Icons.translate_rounded},
    ],
    '10-B': [
      {'name': 'Mathematics', 'teacher': 'Mr. Kumar', 'room': '201', 'time': '08:30 AM', 'color': Colors.blue, 'icon': Icons.calculate_rounded},
      {'name': 'Biology', 'teacher': 'Dr. Singh', 'room': '202', 'time': '09:30 AM', 'color': Colors.green, 'icon': Icons.science_rounded},
      {'name': 'Physics', 'teacher': 'Mr. Reddy', 'room': '203', 'time': '10:30 AM', 'color': Colors.orange, 'icon': Icons.science_rounded},
      {'name': 'English', 'teacher': 'Ms. Sharma', 'room': '204', 'time': '11:30 AM', 'color': Colors.purple, 'icon': Icons.menu_book_rounded},
      {'name': 'Social Studies', 'teacher': 'Mrs. Patel', 'room': '205', 'time': '01:30 PM', 'color': Colors.teal, 'icon': Icons.public_rounded},
    ],
    '10-C': [
      {'name': 'Mathematics', 'teacher': 'Mr. Verma', 'room': '301', 'time': '09:00 AM', 'color': Colors.blue, 'icon': Icons.calculate_rounded},
      {'name': 'Chemistry', 'teacher': 'Dr. Gupta', 'room': '302', 'time': '10:00 AM', 'color': Colors.orange, 'icon': Icons.science_rounded},
      {'name': 'Physics', 'teacher': 'Mr. Singh', 'room': '303', 'time': '11:00 AM', 'color': Colors.green, 'icon': Icons.science_rounded},
      {'name': 'Hindi', 'teacher': 'Mrs. Sharma', 'room': '304', 'time': '12:00 PM', 'color': Colors.red, 'icon': Icons.translate_rounded},
      {'name': 'English', 'teacher': 'Mr. Kumar', 'room': '305', 'time': '02:00 PM', 'color': Colors.purple, 'icon': Icons.menu_book_rounded},
    ],
    '9-A': [
      {'name': 'Mathematics', 'teacher': 'Mr. Singh', 'room': '401', 'time': '08:00 AM', 'color': Colors.blue, 'icon': Icons.calculate_rounded},
      {'name': 'Science', 'teacher': 'Mrs. Verma', 'room': '402', 'time': '09:00 AM', 'color': Colors.green, 'icon': Icons.science_rounded},
      {'name': 'English', 'teacher': 'Ms. Gupta', 'room': '403', 'time': '10:00 AM', 'color': Colors.purple, 'icon': Icons.menu_book_rounded},
      {'name': 'Social Studies', 'teacher': 'Mr. Sharma', 'room': '404', 'time': '11:00 AM', 'color': Colors.teal, 'icon': Icons.public_rounded},
    ],
    '9-B': [
      {'name': 'Mathematics', 'teacher': 'Mrs. Kumar', 'room': '501', 'time': '08:30 AM', 'color': Colors.blue, 'icon': Icons.calculate_rounded},
      {'name': 'Science', 'teacher': 'Mr. Patel', 'room': '502', 'time': '09:30 AM', 'color': Colors.green, 'icon': Icons.science_rounded},
      {'name': 'Hindi', 'teacher': 'Ms. Singh', 'room': '503', 'time': '10:30 AM', 'color': Colors.red, 'icon': Icons.translate_rounded},
      {'name': 'English', 'teacher': 'Mr. Gupta', 'room': '504', 'time': '11:30 AM', 'color': Colors.purple, 'icon': Icons.menu_book_rounded},
    ],
    '8-A': [
      {'name': 'Mathematics', 'teacher': 'Mr. Rao', 'room': '601', 'time': '09:00 AM', 'color': Colors.blue, 'icon': Icons.calculate_rounded},
      {'name': 'Science', 'teacher': 'Mrs. Singh', 'room': '602', 'time': '10:00 AM', 'color': Colors.green, 'icon': Icons.science_rounded},
      {'name': 'English', 'teacher': 'Ms. Verma', 'room': '603', 'time': '11:00 AM', 'color': Colors.purple, 'icon': Icons.menu_book_rounded},
      {'name': 'Social Studies', 'teacher': 'Mr. Kumar', 'room': '604', 'time': '12:00 PM', 'color': Colors.teal, 'icon': Icons.public_rounded},
    ],
    '8-B': [
      {'name': 'Mathematics', 'teacher': 'Mrs. Sharma', 'room': '701', 'time': '08:00 AM', 'color': Colors.blue, 'icon': Icons.calculate_rounded},
      {'name': 'Science', 'teacher': 'Mr. Gupta', 'room': '702', 'time': '09:00 AM', 'color': Colors.green, 'icon': Icons.science_rounded},
      {'name': 'Hindi', 'teacher': 'Ms. Patel', 'room': '703', 'time': '10:00 AM', 'color': Colors.red, 'icon': Icons.translate_rounded},
      {'name': 'English', 'teacher': 'Mr. Singh', 'room': '704', 'time': '11:00 AM', 'color': Colors.purple, 'icon': Icons.menu_book_rounded},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final subjects = _classSubjects[_selectedClass] ?? [];
    final totalSubjects = subjects.length;
    final totalTeachers = subjects.map((s) => s['teacher']).toSet().length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Class Selector
          _buildClassSelector(),
          const SizedBox(height: 16),

          // Statistics Card
          _buildStatisticsCard(totalSubjects, totalTeachers),
          const SizedBox(height: 16),

          // Section Header
          _buildSectionHeader("📚 Subjects (${subjects.length})"),
          const SizedBox(height: 8),

          // Subject List
          if (subjects.isNotEmpty)
            ...subjects.map((subject) => _buildSubjectCard(subject))
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
              Icon(Icons.school_rounded, color: AppColors.primary),
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

  // ==================== STATISTICS CARD ====================
  Widget _buildStatisticsCard(int totalSubjects, int totalTeachers) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFFFF6B35)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            '📚',
            '$totalSubjects',
            'Subjects',
            Colors.white,
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildStatItem(
            '👨‍🏫',
            '$totalTeachers',
            'Teachers',
            Colors.white,
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildStatItem(
            '⏰',
            '${totalSubjects * 45}',
            'Min/Week',
            Colors.white,
          ),
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
        const SizedBox(height: 4),
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
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Class ${_selectedClass}',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== SUBJECT CARD ====================
  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    final Color color = subject['color'] as Color;
    final IconData icon = subject['icon'] as IconData;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Subject Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),

          // Subject Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.person_rounded,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      subject['teacher'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.meeting_room_rounded,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Room ${subject['room']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: color,
                ),
                const SizedBox(width: 4),
                Text(
                  subject['time'],
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.school_rounded,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 12),
          Text(
            'No subjects found',
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