// lib/feature/ecommerce/product/binding/ecommerce_product_binding.dart

import 'package:get/get.dart';
import '../controller/ecommerce_product_controller.dart';

class EcommerceProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EcommerceProductController>(
          () => EcommerceProductController(),
      fenix: true,
    );
  }
}