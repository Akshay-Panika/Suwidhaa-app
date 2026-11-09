import 'package:get/get.dart';
import '../controller/ott_category_controller.dart';

class OttCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<OttCategoryController>(OttCategoryController(), permanent: true);
  }
}