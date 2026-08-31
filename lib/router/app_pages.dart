import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/feature/dashboard/screen/dashboard_screen.dart';
import 'package:untitled/feature/school/dashboard/screen/school_student_dashboard_screen.dart';
import '../feature/school/auth/screen/school_auth_screen.dart';
import '../feature/school/dashboard/screen/school_teacher_dashboard_screen.dart';
import '../feature/school/student/screen/student_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.schoolLogin,
      page: () => SchoolAuthScreen(),
      transition: Transition.fade,
    ),

    GetPage(
      name: AppRoutes.studentDashboard,
      page: () => SchoolStudentDashboardScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.teacherDashboard,
      page: () => SchoolTeacherDashboardScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.studentList,
      page: () => const StudentListScreen(),
      transition: Transition.fade,
    ),
  ];
}