
import 'package:get/get.dart';
import '../controller/ott_ads_controller.dart';

class OttAdsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<OttAdsController>(OttAdsController(), permanent: true);
  }
}