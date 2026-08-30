import 'package:flutter/material.dart';
import '../../../../core/utils/app_color.dart';

class SchoolEventScreen extends StatefulWidget {
  const SchoolEventScreen({super.key});

  @override
  State<SchoolEventScreen> createState() => _SchoolEventScreenState();
}

class _SchoolEventScreenState extends State<SchoolEventScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Upcoming', 'Ongoing', 'Completed'];

  final List<Map<String, dynamic>> events = [
    // ==================== UPCOMING EVENTS ====================
    {
      'title': 'Annual Sports Day 2026',
      'description': 'Inter-house sports competition featuring athletics, cricket, football, basketball, and various track events. All students are encouraged to participate.',
      'date': '15 February 2026',
      'time': '8:00 AM - 5:00 PM',
      'location': 'School Sports Ground',
      'category': 'Sports',
      'status': 'Upcoming',
      'color': AppColors.primary,
      'icon': Icons.sports_rounded,
      'organizer': 'Sports Department - Mr. Rajesh Kumar',
      'participants': '200+ Students',
      'image': '🏃',
      'for': 'Students & Parents',
      'registration': 'Open till 10 Feb',
      'contact': '+91 98765 43001',
    },
    {
      'title': 'Science Exhibition 2026',
      'description': 'Students showcase innovative science projects, working models, and research experiments. Prizes for best projects in each category.',
      'date': '20 February 2026',
      'time': '9:00 AM - 3:00 PM',
      'location': 'Science Lab & Exhibition Hall',
      'category': 'Academic',
      'status': 'Upcoming',
      'color': AppColors.ngo,
      'icon': Icons.science_rounded,
      'organizer': 'Science Department - Dr. S. Verma',
      'participants': '150+ Students',
      'image': '🔬',
      'for': 'Students (Class 6-12)',
      'registration': 'Team registration required',
      'contact': '+91 98765 43002',
    },
    {
      'title': 'Inter-School Debate Competition',
      'description': 'Annual debate competition with 15+ schools participating. Topics: Current affairs, Social issues, and Environmental concerns.',
      'date': '25 February 2026',
      'time': '8:30 AM - 2:00 PM',
      'location': 'School Auditorium',
      'category': 'Academic',
      'status': 'Upcoming',
      'color': Colors.teal,
      'icon': Icons.record_voice_over_rounded,
      'organizer': 'English Department - Mrs. Priya Sharma',
      'participants': '80+ Students',
      'image': '🎤',
      'for': 'Students (Class 8-12)',
      'registration': 'Limited seats available',
      'contact': '+91 98765 43003',
    },
    {
      'title': 'Annual Day Celebration',
      'description': 'Grand celebration featuring cultural performances, award ceremony, guest speeches, and dinner. Parents are invited to attend.',
      'date': '28 February 2026',
      'time': '6:00 PM - 10:00 PM',
      'location': 'School Auditorium',
      'category': 'Cultural',
      'status': 'Upcoming',
      'color': Colors.pink,
      'icon': Icons.stars_rounded,
      'organizer': 'School Management Committee',
      'participants': '500+ Students & Parents',
      'image': '🌟',
      'for': 'Students & Parents',
      'registration': 'Compulsory for all students',
      'contact': '+91 98765 43004',
    },
    {
      'title': 'Art & Craft Workshop',
      'description': 'Hands-on workshop on painting, pottery, paper craft, and recycled art. Learn new creative skills from expert artists.',
      'date': '5 March 2026',
      'time': '10:00 AM - 4:00 PM',
      'location': 'Art Room & Activity Hall',
      'category': 'Cultural',
      'status': 'Upcoming',
      'color': Colors.orange,
      'icon': Icons.brush_rounded,
      'organizer': 'Art Department - Ms. Anjali Gupta',
      'participants': '60 Students',
      'image': '🎨',
      'for': 'Students (Class 3-10)',
      'registration': 'Limited seats - Register now',
      'contact': '+91 98765 43005',
    },
    {
      'title': 'Parent-Teacher Meeting (PTM)',
      'description': 'Annual parent-teacher interaction to discuss student academic progress, behavior, and overall development. Report cards will be distributed.',
      'date': '10 March 2026',
      'time': '9:00 AM - 1:00 PM',
      'location': 'School Premises (All Classrooms)',
      'category': 'Academic',
      'status': 'Upcoming',
      'color': Colors.purple,
      'icon': Icons.people_rounded,
      'organizer': 'Administration - Principal Office',
      'participants': 'All Students & Parents',
      'image': '👨‍👩‍👧',
      'for': 'Parents & Students',
      'registration': 'Not required',
      'contact': '+91 98765 43006',
    },

    // ==================== ONGOING EVENTS ====================
    {
      'title': 'Cultural Fest 2026',
      'description': 'Three-day cultural festival featuring dance competitions, music performances, drama, fashion show, and art exhibitions.',
      'date': '12-14 February 2026',
      'time': '10:00 AM - 8:00 PM',
      'location': 'School Auditorium & Ground',
      'category': 'Cultural',
      'status': 'Ongoing',
      'color': AppColors.ott,
      'icon': Icons.music_note_rounded,
      'organizer': 'Cultural Committee - Mr. Amit Singh',
      'participants': '300+ Participants',
      'image': '🎭',
      'for': 'Students & Parents',
      'registration': 'Day 2 registration available',
      'contact': '+91 98765 43007',
    },
    {
      'title': 'National Science Day',
      'description': 'Celebrating National Science Day with special lectures, science quiz, experiments, and project displays by students.',
      'date': '28 February 2026',
      'time': '9:00 AM - 2:00 PM',
      'location': 'Science Block & Seminar Hall',
      'category': 'Academic',
      'status': 'Ongoing',
      'color': Colors.blue,
      'icon': Icons.science_rounded,
      'organizer': 'Science Club - Dr. R. Gupta',
      'participants': '120 Students',
      'image': '🧪',
      'for': 'Students (Class 6-12)',
      'registration': 'On-spot registration',
      'contact': '+91 98765 43008',
    },

    // ==================== COMPLETED EVENTS ====================
    {
      'title': 'Winter Festival 2026',
      'description': 'Winter carnival with food stalls, games, talent show, and cultural performances. Great participation from students and parents.',
      'date': '25-26 January 2026',
      'time': '10:00 AM - 6:00 PM',
      'location': 'School Ground',
      'category': 'Cultural',
      'status': 'Completed',
      'color': Colors.cyan,
      'icon': Icons.wb_sunny_rounded,
      'organizer': 'Student Council',
      'participants': '400+ Students & Parents',
      'image': '☀️',
      'for': 'Students & Parents',
      'registration': 'Closed',
      'contact': '+91 98765 43009',
    },
    {
      'title': 'Republic Day Celebration',
      'description': 'Flag hoisting ceremony, patriotic songs, dance performances, and speeches by students. Chief guest: District Education Officer.',
      'date': '26 January 2026',
      'time': '7:00 AM - 11:00 AM',
      'location': 'School Ground',
      'category': 'Cultural',
      'status': 'Completed',
      'color': Colors.orange,
      'icon': Icons.flag_rounded,
      'organizer': 'School Management',
      'participants': 'All Students & Staff',
      'image': '🇮🇳',
      'for': 'All Students & Staff',
      'registration': 'Closed',
      'contact': '+91 98765 43010',
    },
    {
      'title': 'Educational Trip: Science Museum',
      'description': 'Educational trip to the National Science Museum. Students explored various scientific exhibits and interactive displays.',
      'date': '15 January 2026',
      'time': '8:00 AM - 5:00 PM',
      'location': 'Science Museum, Delhi',
      'category': 'Academic',
      'status': 'Completed',
      'color': Colors.indigo,
      'icon': Icons.museum_rounded,
      'organizer': 'Science Department - Dr. S. Verma',
      'participants': '90 Students',
      'image': '🏛️',
      'for': 'Students (Class 8-10)',
      'registration': 'Closed',
      'contact': '+91 98765 43011',
    },
    {
      'title': 'School Fete 2026',
      'description': 'Annual school fete with fun games, food stalls, lucky draw, and entertainment. Funds raised for charity.',
      'date': '5-6 January 2026',
      'time': '11:00 AM - 9:00 PM',
      'location': 'School Ground',
      'category': 'Cultural',
      'status': 'Completed',
      'color': Colors.pink,
      'icon': Icons.celebration_rounded,
      'organizer': 'PTA & Student Council',
      'participants': '600+ Visitors',
      'image': '🎪',
      'for': 'Students, Parents & Public',
      'registration': 'Closed',
      'contact': '+91 98765 43012',
    },
    {
      'title': 'Career Counseling Workshop',
      'description': 'Workshop on career options, stream selection, and future planning for class 10 students. Expert counselors guided students.',
      'date': '2 January 2026',
      'time': '10:00 AM - 1:00 PM',
      'location': 'Conference Hall',
      'category': 'Academic',
      'status': 'Completed',
      'color': Colors.deepPurple,
      'icon': Icons.work_rounded,
      'organizer': 'Career Cell - Mrs. Neha Gupta',
      'participants': '80 Students',
      'image': '💼',
      'for': 'Students (Class 10)',
      'registration': 'Closed',
      'contact': '+91 98765 43013',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _getFilteredEvents();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          'School Events',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _showEventCalendar();
            },
            icon: const Icon(Icons.calendar_month_rounded, color: Colors.white),
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

          // Events List
          Expanded(
            child: filteredEvents.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return _buildEventCard(event);
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
                selectedColor: Colors.blue,
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
                    color: isSelected ? AppColors.primary : Colors.grey[300]!,
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
    final upcoming = events.where((e) => e['status'] == 'Upcoming').length;
    final ongoing = events.where((e) => e['status'] == 'Ongoing').length;
    final completed = events.where((e) => e['status'] == 'Completed').length;
    final total = events.length;

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
          _buildStatItem('📅', '$upcoming', 'Upcoming'),
          Container(width: 1, height: 30, color: Colors.grey[200]),
          _buildStatItem('🔄', '$ongoing', 'Ongoing'),
          Container(width: 1, height: 30, color: Colors.grey[200]),
          _buildStatItem('✅', '$completed', 'Completed'),
          Container(width: 1, height: 30, color: Colors.grey[200]),
          _buildStatItem('📋', '$total', 'Total'),
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

  // ==================== EVENT CARD ====================
  Widget _buildEventCard(Map<String, dynamic> event) {
    final status = event['status'] as String;
    final color = event['color'] as Color;
    final statusColor = status == 'Upcoming'
        ? Colors.orange
        : status == 'Ongoing'
        ? Colors.green
        : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: status == 'Ongoing'
              ? Colors.green.withOpacity(0.3)
              : Colors.grey.shade100,
          width: status == 'Ongoing' ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: status == 'Ongoing'
                ? Colors.green.withOpacity(0.05)
                : Colors.grey.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Status & Category
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    event['image'] as String,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              event['category'],
                              style: TextStyle(
                                fontSize: 10,
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              event['for'],
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['description'],
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // Info Grid
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    _buildInfoItem(Icons.calendar_today_rounded, event['date']),
                    _buildInfoItem(Icons.access_time_rounded, event['time']),
                    _buildInfoItem(Icons.location_on_rounded, event['location']),
                    _buildInfoItem(Icons.people_rounded, event['participants']),
                  ],
                ),

                const SizedBox(height: 10),

                // Registration & Contact
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.assignment_rounded,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '📝 ${event['registration']}',
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
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event['contact'],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Action Buttons
                if (status == 'Ongoing')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showEventDetails(event);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'View Details & Join',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                else if (status == 'Upcoming')
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        _showEventDetails(event);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.school,
                        side: BorderSide(color: AppColors.school),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        _showEventDetails(event);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        side: BorderSide(color: Colors.grey[300]!),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'View Event Summary',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== INFO ITEM ====================
  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ==================== EVENT DETAILS ====================
  void _showEventDetails(Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final color = event['color'] as Color;
        final statusColor = event['status'] == 'Upcoming'
            ? Colors.orange
            : event['status'] == 'Ongoing'
            ? Colors.green
            : Colors.grey;

        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
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

                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          event['image'] as String,
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['title'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    event['category'],
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: statusColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        event['status'],
                                        style: TextStyle(
                                          color: statusColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Description
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              event['description'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                          Divider(color: Colors.grey[200]),
                          const SizedBox(height: 16),

                          // Details
                          _buildDetailRow('📅 Date', event['date']),
                          _buildDetailRow('⏰ Time', event['time']),
                          _buildDetailRow('📍 Location', event['location']),
                          _buildDetailRow('👤 Organizer', event['organizer']),
                          _buildDetailRow('👥 Participants', event['participants']),
                          _buildDetailRow('🎯 For', event['for']),
                          _buildDetailRow('📝 Registration', event['registration']),
                          _buildDetailRow('📞 Contact', event['contact']),

                          const SizedBox(height: 16),
                          Divider(color: Colors.grey[200]),
                          const SizedBox(height: 16),

                          // Action Buttons
                          if (event['status'] == 'Ongoing')
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('✅ Successfully joined the event!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Join Event Now',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                          else if (event['status'] == 'Upcoming')
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('✅ Registration successful!'),
                                      backgroundColor: AppColors.school,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.school,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Register Now',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
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
                    ),
                  ),
                ],
              ),
            );
          },
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
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== CALENDAR VIEW ====================
  void _showEventCalendar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '📅 Event Calendar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: events.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.grey[200]),
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final statusColor = event['status'] == 'Upcoming'
                        ? Colors.orange
                        : event['status'] == 'Ongoing'
                        ? Colors.green
                        : Colors.grey;
                    return ListTile(
                      leading: Text(
                        event['image'] as String,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(
                        event['title'],
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        '${event['date']} • ${event['category']}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          event['status'],
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _showEventDetails(event);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================== EMPTY STATE ====================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 12),
          Text(
            'No events found',
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
  List<Map<String, dynamic>> _getFilteredEvents() {
    if (_selectedFilter == 'All') {
      return events;
    }
    return events.where((e) => e['status'] == _selectedFilter).toList();
  }
}