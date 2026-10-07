import 'package:get/get.dart';
import '../controller/ngo_staff_controller.dart';

class NgoStaffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NgoStaffController>(
          () => NgoStaffController(),
      fenix: true,
    );
  }
}