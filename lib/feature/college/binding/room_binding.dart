// lib/feature/college/bindings/room_binding.dart
import 'package:get/get.dart';
import '../controller/room_controller.dart';

class RoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoomController>(() => RoomController());
  }
}