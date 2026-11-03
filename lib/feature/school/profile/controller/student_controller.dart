// lib/feature/school/student/controller/student_controller.dart
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/student_model.dart';
import '../repsitory/student_repository.dart';

class StudentController extends GetxController {
  final StudentRepository _repository = StudentRepository();

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

      final studentId = await _repository.getStudentId();

      if (studentId == 0) {
        errorMessage.value = 'Student ID not found. Please login again.';
        isLoading.value = false;
        return;
      }

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

  Future<void> refreshProfile() async {
    await loadStudentProfile();
  }

  // ==================== GETTERS ====================
  String get fullName => studentData.value?.fullName ?? '';
  String get schoolName => studentData.value?.schoolName ?? '';
  String get schoolType => studentData.value?.schoolType ?? '';
  SchoolInfo? get school => studentData.value?.school;
  String get profileImage => studentData.value?.studentProfile ?? '';
  String get studentClass => studentData.value?.studentClass ?? '';
  String get rollNumber => studentData.value?.rollNumber ?? '';
  String get studentIdCard => studentData.value?.studentIdCard ?? '';
  String get feeStatus => studentData.value?.feeStatus ?? '';
  double get remainingFee => studentData.value?.remainingFee ?? 0;
  bool get hasData => studentData.value != null;
}