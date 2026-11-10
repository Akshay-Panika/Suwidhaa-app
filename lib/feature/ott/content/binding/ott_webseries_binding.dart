import 'package:get/get.dart';

import '../controller/ott_webseries_controller.dart';

class OttWebSeriesBinding extends Bindings {
  @override
  void dependencies() {
 Get.lazyPut<OttWebSeriesController>(
          () => OttWebSeriesController(),
      fenix: true,
    );
  }
}