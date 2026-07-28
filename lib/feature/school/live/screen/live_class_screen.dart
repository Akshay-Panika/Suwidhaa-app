import 'package:flutter/material.dart';
import '../../../../core/utils/app_color.dart';

class LiveClassScreen extends StatefulWidget {
  const LiveClassScreen({super.key});

  @override
  State<LiveClassScreen> createState() => _LiveClassScreenState();
}

class _LiveClassScreenState extends State<LiveClassScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Live', 'Upcoming', 'Completed'];

  final List<Map<String, dynamic>> classes = [
    {
      'title': 'Calculus Basics',
      'subject': 'Mathematics',
      'teacher': 'Mr. Gupta',
      'time': '10:00 AM',
      'date': 'Today',
      'isLive': true,
      'color': AppColors.primary,
      'students': 45,
      'duration': '45 min',
    },
    {
      'title': "Newton's Laws of Motion",
      'subject': 'Physics',
      'teacher': 'Dr. Sharma',
      'time': '11:30 AM',
      'date': 'Today',
      'isLive': false,
      'color': AppColors.ott,
      'students': 32,
      'duration': '60 min',
    },
    {
      'title': 'Organic Chemistry Basics',
      'subject': 'Chemistry',
      'teacher': 'Ms. Verma',
      'time': '02:00 PM',
      'date': 'Today',
      'isLive': false,
      'color': AppColors.ngo,
      'students': 28,
      'duration': '50 min',
    },
    {
      'title': 'Trigonometry Fundamentals',
      'subject': 'Mathematics',
      'teacher': 'Mr. Kumar',
      'time': '09:00 AM',
      'date': 'Tomorrow',
      'isLive': false,
      'color': Colors.purple,
      'students': 38,
      'duration': '45 min',
    },
    {
      'title': 'Quantum Physics Intro',
      'subject': 'Physics',
      'teacher': 'Dr. Singh',
      'time': '03:30 PM',
      'date': 'Tomorrow',
      'isLive': false,
      'color': Colors.cyan,
      'students': 25,
      'duration': '60 min',
    },
    {
      'title': 'Chemical Bonding',
      'subject': 'Chemistry',
      'teacher': 'Ms. Patel',
      'time': '10:30 AM',
      'date': 'Yesterday',
      'isLive': false,
      'completed': true,
      'color': Colors.orange,
      'students': 30,
      'duration': '50 min',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredClasses = _getFilteredClasses();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          'Live Classes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.ott,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_outlined, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          _buildFilterChips(),
          const SizedBox(height: 8),

          // Stats Row
          _buildStatsRow(),
          const SizedBox(height: 8),

          // Class List
          Expanded(
            child: filteredClasses.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredClasses.length,
              itemBuilder: (context, index) {
                final classData = filteredClasses[index];
                return _buildClassCard(classData);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==================== FILTER CHIPS ====================
  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isSelected,
                label: Text(
                  filter,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
                backgroundColor: Colors.white,
                selectedColor: AppColors.ott,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppColors.ott : Colors.grey[300]!,
                    width: 1,
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

  // ==================== STATS ROW ====================
  Widget _buildStatsRow() {
    final liveCount = classes.where((c) => c['isLive'] == true).length;
    final todayCount = classes.where((c) => c['date'] == 'Today').length;
    final totalStudents = classes.fold(0, (sum, c) => sum + (c['students'] as int));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('🔴', '$liveCount', 'Live Now'),
          Container(width: 1, height: 30, color: Colors.grey[200]),
          _buildStatItem('📅', '$todayCount', 'Today'),
          Container(width: 1, height: 30, color: Colors.grey[200]),
          _buildStatItem('👥', '$totalStudents', 'Students'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textMain,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  // ==================== CLASS CARD ====================
  Widget _buildClassCard(Map<String, dynamic> classData) {
    final bool isLive = classData['isLive'] ?? false;
    final bool isCompleted = classData['completed'] ?? false;
    final Color color = classData['color'] as Color;
    final String status = isLive ? 'Live' : isCompleted ? 'Completed' : 'Upcoming';
    final Color statusColor = isLive ? Colors.red : isCompleted ? Colors.grey : AppColors.ott;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLive ? Colors.red.withOpacity(0.2) : Colors.grey.shade100,
          width: isLive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isLive ? Colors.red.withOpacity(0.05) : Colors.grey.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Live Indicator
              if (isLive) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],

              // Date Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  classData['date'] ?? '',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const Spacer(),

              // Duration
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '⏱ ${classData['duration'] ?? ''}',
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              // Subject Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getSubjectIcon(classData['subject']),
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classData['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${classData['subject']} • ${classData['teacher']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          classData['time'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.people_rounded,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${classData['students']} students',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
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

          // Action Buttons
          Row(
            children: [
              if (isLive)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showJoinDialog(classData);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Join Now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
              else if (!isCompleted)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showReminderDialog(classData);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.ott,
                      side: BorderSide(color: AppColors.ott),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Set Reminder',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Completed',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

              const SizedBox(width: 10),

              IconButton(
                onPressed: () {
                  _showClassDetails(classData);
                },
                icon: Icon(
                  Icons.info_outline_rounded,
                  color: Colors.grey[400],
                  size: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== DIALOGS ====================
  void _showJoinDialog(Map<String, dynamic> classData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.video_call_rounded, color: Colors.red),
              ),
              const SizedBox(width: 10),
              const Text('Join Live Class'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                classData['title'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${classData['subject']} • ${classData['teacher']}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.people_rounded, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('${classData['students']} students joined'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🎥 Joining live class...'),
                    backgroundColor: AppColors.ott,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Join Now'),
            ),
          ],
        );
      },
    );
  }

  void _showReminderDialog(Map<String, dynamic> classData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('⏰ Set Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reminder set for "${classData['title']}"',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.ott.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time_rounded, color: AppColors.ott),
                    const SizedBox(width: 8),
                    Text(
                      '${classData['date']} at ${classData['time']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Reminder set successfully!'),
                    backgroundColor: AppColors.ngo,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ott,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Set Reminder'),
            ),
          ],
        );
      },
    );
  }

  void _showClassDetails(Map<String, dynamic> classData) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (classData['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getSubjectIcon(classData['subject']),
                      color: classData['color'],
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classData['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${classData['subject']} • ${classData['teacher']}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey[200]),
              const SizedBox(height: 16),
              _buildDetailRow('📅 Date', classData['date']),
              _buildDetailRow('⏰ Time', classData['time']),
              _buildDetailRow('⏱ Duration', classData['duration']),
              _buildDetailRow('👥 Students', '${classData['students']}'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ott,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
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
            Icons.video_library_rounded,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 12),
          Text(
            'No classes found',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try changing the filter',
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
  List<Map<String, dynamic>> _getFilteredClasses() {
    if (_selectedFilter == 'All') {
      return classes;
    }
    final filterMap = {
      'Live': (Map<String, dynamic> c) => c['isLive'] == true,
      'Upcoming': (Map<String, dynamic> c) =>
      c['isLive'] == false && (c['completed'] == null || c['completed'] == false),
      'Completed': (Map<String, dynamic> c) => c['completed'] == true,
    };
    return classes.where(filterMap[_selectedFilter] ?? (_) => true).toList();
  }

  IconData _getSubjectIcon(String subject) {
    final iconMap = {
      'Mathematics': Icons.calculate_rounded,
      'Physics': Icons.science_rounded,
      'Chemistry': Icons.science_rounded,
      'Biology': Icons.biotech_rounded,
      'English': Icons.menu_book_rounded,
      'Hindi': Icons.translate_rounded,
      'History': Icons.history_rounded,
      'Geography': Icons.public_rounded,
      'Computer': Icons.computer_rounded,
    };
    return iconMap[subject] ?? Icons.school_rounded;
  }
}