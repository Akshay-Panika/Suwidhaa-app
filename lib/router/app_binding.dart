import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../feature/school/auth/controller/school_auth_controller.dart';
import '../feature/school/profile/controller/student_controller.dart';
import '../feature/school/profile/controller/teacher_controller.dart';
import '../feature/school/student/controller/student_list_controller.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<SchoolAuthController>(SchoolAuthController(), permanent: true);
    Get.put<StudentController>(StudentController(), permanent: true);
    Get.put<TeacherController>(TeacherController(), permanent: true);
    Get.put<StudentListController>(StudentListController(), permanent: true);
  }
}
