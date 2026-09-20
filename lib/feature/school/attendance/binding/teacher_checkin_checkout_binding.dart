// lib/feature/school/attendance/binding/teacher_checkin_checkout_binding.dart

import 'package:get/get.dart';
import '../controller/teacher_checkin_checkout_controller.dart';

class TeacherCheckInOutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherCheckInOutController>(
          () => TeacherCheckInOutController(),
      fenix: true,
    );
  }
}