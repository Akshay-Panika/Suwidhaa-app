import 'package:get/get.dart';
import '../controller/it_service_category_controller.dart';

class ItServiceCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItServiceCategoryController>(
          () => ItServiceCategoryController(),
      fenix: true,
    );
  }
}