// lib/feature/school/student/controller/student_controller.dart
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/student_model.dart';
import '../repsitory/student_repository.dart';

class StudentController extends GetxController {
  final StudentRepository _repository = StudentRepository();

  // Observable variables
  final isLoading = false.obs;
  final studentData = Rxn<StudentData>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadStudentProfile();
  }

  Future<void> loadStudentProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get student ID from shared preferences
      final studentId = await _repository.getStudentId();

      if (studentId == 0) {
        errorMessage.value = 'Student ID not found. Please login again.';
        isLoading.value = false;
        return;
      }

      // Fetch student profile
      final response = await _repository.getStudentProfile(studentId);

      if (response.success) {
        studentData.value = response.data;
      } else {
        errorMessage.value = 'Failed to load student profile';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      FlutterToast.error('Failed to load profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh student profile
  Future<void> refreshProfile() async {
    await loadStudentProfile();
  }

  // Get full name
  String get fullName => studentData.value?.fullName ?? '';

  // Get profile image URL
  String get profileImage => studentData.value?.studentProfile ?? '';

  // Get student class
  String get studentClass => studentData.value?.studentClass ?? '';

  // Get roll number
  String get rollNumber => studentData.value?.rollNumber ?? '';

  // Get student ID card
  String get studentIdCard => studentData.value?.studentIdCard ?? '';

  // Get fee status
  String get feeStatus => studentData.value?.feeStatus ?? '';

  // Get remaining fee
  double get remainingFee => studentData.value?.remainingFee ?? 0;

  // Check if student data is available
  bool get hasData => studentData.value != null;

  @override
  void onClose() {
    super.onClose();
  }
}