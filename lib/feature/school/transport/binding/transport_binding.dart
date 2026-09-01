// lib/feature/school/transport/binding/transport_binding.dart
import 'package:get/get.dart';
import '../controller/transport_controller.dart';

class TransportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransportController>(() => TransportController());
  }
}