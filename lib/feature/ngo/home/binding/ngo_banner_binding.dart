import 'package:get/get.dart';
import '../controller/ngo_banner_controller.dart';

class NgoBannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NgoBannerController>(() => NgoBannerController());
  }
}