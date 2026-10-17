import 'package:get/get.dart';
import '../controller/ecommerce_subcategory_controller.dart';

class EcommerceSubCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EcommerceSubCategoryController>(
          () => EcommerceSubCategoryController(),
      fenix: true,
    );
  }
}