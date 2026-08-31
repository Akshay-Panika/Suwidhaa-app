// lib/feature/school/student_list/binding/student_list_binding.dart
import 'package:get/get.dart';
import '../controller/student_list_controller.dart';

class StudentListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentListController>(() => StudentListController());
  }
}