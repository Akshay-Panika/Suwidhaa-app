// lib/feature/school/exams/binding/exams_binding.dart
import 'package:get/get.dart';
import '../controller/exams_controller.dart';

class ExamsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExamsController>(() => ExamsController(), fenix: true);
  }
}