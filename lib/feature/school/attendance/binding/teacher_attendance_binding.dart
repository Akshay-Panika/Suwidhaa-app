// lib/feature/school/attendance/binding/teacher_attendance_binding.dart

import 'package:get/get.dart';
import '../controller/teacher_attendance_controller.dart';

class TeacherAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherAttendanceController>(
          () => TeacherAttendanceController(),
      fenix: true,
    );
  }
}