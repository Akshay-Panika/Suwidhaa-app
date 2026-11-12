import 'package:get/get.dart';
import '../controller/ngo_history_controller.dart';

class NgoHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NgoHistoryController>(
          () => NgoHistoryController(),
      fenix: true,
    );
  }
}