// lib/feature/auth/binding/school_auth_binding.dart
import 'package:get/get.dart';
import '../controller/school_auth_controller.dart';

class SchoolAuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SchoolAuthController>(() => SchoolAuthController());
  }
}