// lib/feature/ecommerce/banner/binding/ecommerce_banner_binding.dart

import 'package:get/get.dart';
import '../controller/ecommerce_banner_controller.dart';

class EcommerceBannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EcommerceBannerController>(
          () => EcommerceBannerController(),
      fenix: true,
    );
  }
}