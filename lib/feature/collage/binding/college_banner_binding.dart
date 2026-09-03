// lib/feature/college/binding/college_banner_binding.dart
import 'package:get/get.dart';
import '../controller/college_banner_controller.dart';

class CollegeBannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CollegeBannerController>(
          () => CollegeBannerController(),
    );
  }
}