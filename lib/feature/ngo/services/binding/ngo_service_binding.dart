import 'package:get/get.dart';
import '../controller/ngo_service_controller.dart';

class NgoServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NgoServiceController>(() => NgoServiceController());
  }
}