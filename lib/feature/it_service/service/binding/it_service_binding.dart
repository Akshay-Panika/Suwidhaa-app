import 'package:get/get.dart';
import '../controller/it_service_controller.dart';

class ItServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItServiceController>(
          () => ItServiceController(),
      fenix: true,
    );
  }
}