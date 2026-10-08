import 'package:get/get.dart';
import '../controller/it_service_banner_controller.dart';

class ItServiceBannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItServiceBannerController>(
          () => ItServiceBannerController(),
      fenix: true,
    );
  }
}