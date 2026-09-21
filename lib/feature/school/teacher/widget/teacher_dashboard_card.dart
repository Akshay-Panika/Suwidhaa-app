import 'package:flutter/material.dart';
import 'package:untitled/feature/school/teacher/widget/teacher_attendance_dashboard_card.dart';
import '../../attendance/widget/class_attendance_card.dart';
import '../../attendance/widget/subject_attendance_card.dart';
import '../../event/widget/school_event_dashboard_card.dart';

class TeacherDashboardCard extends StatelessWidget {
  const TeacherDashboardCard({super.key});


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
                        child: TeacherAttendanceDashboardCard(),
                      ),
                      SubjectAttendanceCard(),
                    ],
                  ),
                ),

                // RIGHT SIDE
                Expanded(
                  child: Column(
                    spacing: 10,
                    children: [

                      ClassAttendanceCard(),

                      // Events Carousel
                      Expanded(
                        child:  SchoolEventDashboardCard(),
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
}