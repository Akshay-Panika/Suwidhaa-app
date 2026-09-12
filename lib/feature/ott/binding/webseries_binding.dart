// lib/feature/ott_platform/binding/webseries_binding.dart

import 'package:get/get.dart';
import '../controller/webseries_controller.dart';

class WebseriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebseriesController>(
          () => WebseriesController(),
      fenix: true,
    );
  }
}