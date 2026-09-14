// lib/feature/college/binding/college_booking_binding.dart

import 'package:get/get.dart';
import '../controller/college_booking_controller.dart';

class CollegeBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CollegeBookingController>(
          () => CollegeBookingController(),
      fenix: true,
    );
  }
}