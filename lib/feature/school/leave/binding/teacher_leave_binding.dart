import 'package:get/get.dart';
import '../controller/teacher_leave_controller.dart';

class TeacherLeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherLeaveController>(
          () => TeacherLeaveController(),
      fenix: true,
    );
  }
}