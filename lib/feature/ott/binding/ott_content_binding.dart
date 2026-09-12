import 'package:get/get.dart';

import '../controller/ott_content_controller.dart';

class OttContentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OttContentController>(
          () => OttContentController(),
      fenix: true,
    );
  }
}