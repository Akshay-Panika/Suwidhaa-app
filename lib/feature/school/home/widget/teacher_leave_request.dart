import 'package:flutter/material.dart';

import '../../attendance/screen/school_student_daly_attendance_screen.dart';

class TeacherLeaveRequestButton extends StatelessWidget {
  const TeacherLeaveRequestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SchoolStudentDailyAttendanceScreen(),
          ),
        );
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.orange.shade100,
          ),
        ),
        child: Icon(Icons.calendar_month,color: Colors.green,),
      ),
    );
  }
}