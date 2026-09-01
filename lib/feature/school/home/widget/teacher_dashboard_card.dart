import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:untitled/feature/school/home/widget/teacher_attendance_dashboard_card.dart';

import '../../../../router/app_routes.dart';
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

                      // Students Count
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.studentList);
                        },
                        child: _dashboardBox(
                          icon: Icons.people_outline,
                          title: "Total Students",
                          value: "120 Students",
                          subtitle: "Class 10 - 12",
                          iconColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),

                // RIGHT SIDE
                Expanded(
                  child: Column(
                    spacing: 10,
                    children: [

                      // Classes Today
                      _dashboardBox(
                        icon: Icons.class_,
                        title: "Classes Today",
                        value: "4 Classes",
                        subtitle: "8:00 AM - 2:00 PM",
                        iconColor: Colors.orange,
                      ),

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

}