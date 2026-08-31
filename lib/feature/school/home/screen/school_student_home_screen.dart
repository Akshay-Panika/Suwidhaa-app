import 'package:flutter/material.dart';
import 'package:untitled/feature/school/home/widget/student_home_work.dart';
import 'package:untitled/feature/school/home/widget/student_leave_request.dart';

import '../widget/school_home_ads_card.dart';
import '../widget/student_attendance_card.dart';
import '../widget/student_dashboard_card.dart';
import '../widget/student_profile_card.dart';

class SchoolStudentHomeScreen extends StatelessWidget {
  const SchoolStudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          StudentProfileCard(),
          SchoolHomeAdsCard(),
          Expanded(
            flex: 3,
            child: StudentDashboardCard(),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Expanded(
                  child: StudentHomeWork(),
                ),
                // StudentLeaveRequestButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
