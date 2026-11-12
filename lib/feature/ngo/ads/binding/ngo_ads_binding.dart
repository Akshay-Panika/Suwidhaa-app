import 'package:get/get.dart';
import '../controller/ngo_ads_controller.dart';

class NgoAdsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NgoAdsController>(NgoAdsController(), permanent: true);
  }
}