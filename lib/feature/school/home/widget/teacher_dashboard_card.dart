import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:untitled/feature/school/home/screen/school_event_screen.dart';
import 'package:untitled/feature/school/student/screen/student_screen.dart';

class TeacherDashboardCard extends StatelessWidget {
  const TeacherDashboardCard({super.key});

  final List<Map<String, dynamic>> events = const [
    {
      'id': 1,
      'title': 'Parent-Teacher Meeting 2026',
      'date': '15 Sep 2026',
      'time': '10:00 AM - 4:00 PM',
      'location': 'School Auditorium',
      'image': 'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=400&h=300&fit=crop',
      'type': 'Meeting',
      'status': 'LIVE',
    },
    {
      'id': 2,
      'title': 'Teachers Training Workshop',
      'date': '20 Sep 2026',
      'time': '9:00 AM - 12:00 PM',
      'location': 'Conference Hall',
      'image': 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=300&fit=crop',
      'type': 'Training',
      'status': 'Upcoming',
    },
    {
      'id': 3,
      'title': 'Annual Sports Day',
      'date': '25 Sep 2026',
      'time': '10:00 AM - 3:00 PM',
      'location': 'School Ground',
      'image': 'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=400&h=300&fit=crop',
      'type': 'Sports',
      'status': 'Upcoming',
    },
    {
      'id': 4,
      'title': 'Staff Meeting',
      'date': '30 Sep 2026',
      'time': '6:00 PM - 9:00 PM',
      'location': 'Staff Room',
      'image': 'https://images.unsplash.com/photo-1511578314322-379afb476865?w=400&h=300&fit=crop',
      'type': 'Meeting',
      'status': 'Upcoming',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            spacing: 6,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Dashboard",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
              Expanded(
                child: Container(
                  height: 2,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              spacing: 10,
              children: [

                // LEFT SIDE
                Expanded(
                  child: Column(
                    spacing: 10,
                    children: [

                      // Attendance Graph
                      Expanded(
                        child: _attendanceGraph(),
                      ),

                      // Classes Today
                      _dashboardBox(
                        icon: Icons.class_,
                        title: "Classes Today",
                        value: "4 Classes",
                        subtitle: "8:00 AM - 2:00 PM",
                        iconColor: Colors.orange,
                      ),
                    ],
                  ),
                ),

                // RIGHT SIDE
                Expanded(
                  child: Column(
                    spacing: 10,
                    children: [

                      // Students Count
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => StudentScreen(),));
                        },
                        child: _dashboardBox(
                          icon: Icons.people_outline,
                          title: "Total Students",
                          value: "120 Students",
                          subtitle: "Class 10 - 12",
                          iconColor: Colors.blue,
                        ),
                      ),

                      // Events Carousel
                      Expanded(
                        child:  InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SchoolEventScreen(),));
                            },
                            child: _eventsCarousel()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ================= ATTENDANCE GRAPH =================

  Widget _attendanceGraph() {
    final attendance = [
      {"day": "Mon", "value": 0.9},
      {"day": "Tue", "value": 0.8},
      {"day": "Wed", "value": 0.95},
      {"day": "Thu", "value": 0.7},
      {"day": "Fri", "value": 0.85},
      {"day": "Sat", "value": 0.6},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  size: 20,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "Class Attendance",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Text(
                "80%",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: attendance.map((item) {
                final value = item["value"] as double;
                final day = item["day"] as String;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 18,
                          height: 65 * value,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      day,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ================= DASHBOARD BOX =================

  Widget _dashboardBox({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ================= EVENTS CAROUSEL =================

  Widget _eventsCarousel() {
    return CarouselSlider.builder(
      itemCount: events.length,
      itemBuilder: (context, index, realIndex) {
        return _eventBanner(events[index]);
      },
      options: CarouselOptions(
        height: double.infinity,
        viewportFraction: 1.0,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        pauseAutoPlayOnTouch: true,
      ),
    );
  }

  // ================= EVENT BANNER =================

  Widget _eventBanner(Map<String, dynamic> event) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // Network Image
            Image.network(
              event['image'],
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.purple.shade100,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        size: 30,
                        color: Colors.purple,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Event Image",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.purple.shade100,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.purple,
                    ),
                  ),
                );
              },
            ),

            // Overlay Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.75),
                    Colors.black.withOpacity(0.1),
                  ],
                ),
              ),
            ),

            // Content on top of image
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Status Badges
                  Row(
                    children: [
                      if (event['status'] == 'LIVE')
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "LIVE",
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          event['type'],
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event['title'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event['date'],
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event['time'],
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event['location'],
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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
}