// lib/feature/college/bindings/tiffin_binding.dart
import 'package:get/get.dart';

import '../controller/tiffin_controller.dart';

class TiffinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TiffinController>(() => TiffinController());
  }
}