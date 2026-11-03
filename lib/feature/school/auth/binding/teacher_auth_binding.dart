import 'package:get/get.dart';
import '../controller/teacher_auth_controller.dart';

class TeacherAuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherAuthController>(
          () => TeacherAuthController(),
      fenix: true,
    );
  }
}