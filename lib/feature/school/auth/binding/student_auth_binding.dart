import 'package:get/get.dart';
import '../controller/student_auth_controller.dart';

class StudentAuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentAuthController>(
          () => StudentAuthController(),
      fenix: true,
    );
  }
}