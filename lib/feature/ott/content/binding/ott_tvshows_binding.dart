import 'package:get/get.dart';
import '../controller/ott_tvshows_controller.dart';

class OttTvShowsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OttTvShowsController>(
          () => OttTvShowsController(),
      fenix: true,
    );
  }
}