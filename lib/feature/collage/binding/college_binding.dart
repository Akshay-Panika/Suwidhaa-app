// lib/feature/college/binding/college_binding.dart
import 'package:get/get.dart';
import '../controller/college_controller.dart';

class CollegeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CollegeController>(() => CollegeController());
  }
}