import 'package:get/get.dart';
import '../controller/ecommerce_store_controller.dart';

class EcommerceStoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EcommerceStoreController>(
          () => EcommerceStoreController(),
      fenix: true,
    );
  }
}