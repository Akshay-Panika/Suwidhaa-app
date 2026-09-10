import 'package:get/get.dart';

import '../controller/ott_controller.dart';

class OttBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OttController>(
          () => OttController(),
      fenix: true,
    );
  }
}