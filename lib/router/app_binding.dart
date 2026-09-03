// lib/app_bindings.dart
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../feature/collage/controller/college_banner_controller.dart';
import '../feature/collage/controller/college_controller.dart';
import '../feature/collage/controller/room_controller.dart';
import '../feature/collage/controller/tiffin_controller.dart';
import '../feature/school/auth/controller/school_auth_controller.dart';
import '../feature/school/event/controller/school_event_controller.dart';
import '../feature/school/homework/controller/homework_controller.dart';
import '../feature/school/profile/controller/student_controller.dart';
import '../feature/school/profile/controller/teacher_controller.dart';
import '../feature/school/student/controller/student_list_controller.dart';
import '../feature/school/transport/controller/transport_controller.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    // Use lazyPut for most controllers (they'll be created when first used)
    Get.lazyPut<SchoolAuthController>(() => SchoolAuthController(), fenix: true);
    Get.lazyPut<StudentController>(() => StudentController(), fenix: true);
    Get.lazyPut<TeacherController>(() => TeacherController(), fenix: true);
    Get.lazyPut<StudentListController>(() => StudentListController(), fenix: true);
    Get.lazyPut<HomeworkController>(() => HomeworkController(), fenix: true);
    Get.lazyPut<SchoolEventController>(() => SchoolEventController(), fenix: true);
    Get.lazyPut<TransportController>(() => TransportController(), fenix: true);
    Get.lazyPut<CollegeBannerController>(() => CollegeBannerController(), fenix: true);
    Get.lazyPut<CollegeController>(() => CollegeController(), fenix: true);
    Get.lazyPut<RoomController>(() => RoomController(), fenix: true);
    Get.lazyPut<TiffinController>(() => TiffinController(), fenix: true);
  }
}