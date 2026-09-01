import 'package:get/get.dart';
import '../controller/school_event_controller.dart';

class SchoolEventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SchoolEventController>(
          () => SchoolEventController(),
      fenix: true,
    );
  }
}