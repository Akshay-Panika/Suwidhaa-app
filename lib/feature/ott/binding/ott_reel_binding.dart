// lib/feature/ott_platform/binding/ott_reel_binding.dart
import 'package:get/get.dart';
import '../controller/ott_reel_controller.dart';

class OttReelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OttReelController>(
          () => OttReelController(),
      fenix: true,
    );
  }
}