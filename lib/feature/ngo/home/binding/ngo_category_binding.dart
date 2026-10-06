import 'package:get/get.dart';
import '../controller/ngo_category_controller.dart';

class NgoCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NgoCategoryController>(() => NgoCategoryController());
  }
}