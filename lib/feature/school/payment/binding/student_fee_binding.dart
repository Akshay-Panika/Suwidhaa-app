import 'package:get/get.dart';
import '../controller/student_fee_history_controller.dart';

class StudentFeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentFeeHistoryController>(() => StudentFeeHistoryController());
  }
}