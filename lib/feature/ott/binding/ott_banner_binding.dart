import 'package:get/get.dart';

import '../controller/ott_banner_controller.dart';

class OttBannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OttBannerController>(
          () => OttBannerController(),
      fenix: true,
    );
  }
}