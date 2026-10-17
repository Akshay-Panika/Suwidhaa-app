// lib/feature/ecommerce/category/binding/ecommerce_category_binding.dart

import 'package:get/get.dart';
import '../controller/ecommerce_category_controller.dart';

class EcommerceCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EcommerceCategoryController>(
          () => EcommerceCategoryController(),
      fenix: true,
    );
  }
}