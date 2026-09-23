// lib/feature/school/salary/binding/teacher_salary_binding.dart

import 'package:get/get.dart';

import '../controller/teacher_salary_controller.dart';

class TeacherSalaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherSalaryController>(
          () => TeacherSalaryController(),
      fenix: true,
    );
  }
}