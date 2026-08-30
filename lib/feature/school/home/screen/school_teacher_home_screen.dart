import 'package:flutter/material.dart';
import '../widget/teacher_attendance_card.dart';
import '../widget/teacher_dashboard_card.dart';
import '../widget/teacher_home_work.dart';
import '../widget/teacher_leave_request.dart';
import '../widget/teacher_profile_card.dart';

class SchoolTeacherHomeScreen extends StatelessWidget {
  const SchoolTeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TeacherProfileCard(),
          TeacherAttendanceCard(),
          Expanded(
            flex: 3,
            child: TeacherDashboardCard(),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Expanded(
                  child: TeacherHomeWork(),
                ),
                TeacherLeaveRequestButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
