// lib/feature/school/teacher/controller/teacher_controller.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/teacher_model.dart';
import '../repsitory/teacher_repository.dart';

class TeacherController extends GetxController {
  final TeacherRepository _repository = TeacherRepository();

  // Observable variables
  final isLoading = false.obs;
  final teacherData = Rxn<TeacherData>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadTeacherProfile();
  }

  Future<void> loadTeacherProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get teacher ID from shared preferences
      final teacherId = await _repository.getTeacherId();

      if (teacherId == 0) {
        errorMessage.value = 'Teacher ID not found. Please login again.';
        isLoading.value = false;
        return;
      }

      // Fetch teacher profile
      final response = await _repository.getTeacherProfile(teacherId);

      if (response.success) {
        teacherData.value = response.data;
      } else {
        errorMessage.value = 'Failed to load teacher profile';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      FlutterToast.error('Failed to load profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh teacher profile
  Future<void> refreshProfile() async {
    await loadTeacherProfile();
  }

  // Get full name
  String get fullName => teacherData.value?.fullName ?? '';

  // Get profile image URL
  String get profileImage => teacherData.value?.teacherProfile ?? '';

  // Get teacher ID card
  String get teacherIdCard => teacherData.value?.teacherIdCard ?? '';

  // Get qualification
  String get qualification => teacherData.value?.qualification ?? '';

  // Get experience
  String get experienceString => teacherData.value?.experienceString ?? '';

  // Get subjects
  List<String> get subjects => teacherData.value?.subjects ?? [];

  // Get subjects as string
  String get subjectsString => teacherData.value?.subjectsString ?? '';

  // Get subjects count
  int get subjectsCount => teacherData.value?.subjectsCount ?? 0;

  // Get email
  String get email => teacherData.value?.email ?? '';

  // Get phone
  String get phone => teacherData.value?.phone ?? '';

  // Get address
  String get address => teacherData.value?.address ?? '';

  // Get gender icon
  IconData get genderIcon => teacherData.value?.genderIcon ?? Icons.person;

  // Get gender color
  Color get genderColor => teacherData.value?.genderColor ?? Colors.blue;

  // Get salary
  String get salary => teacherData.value?.salary ?? '0.00';

  // Get join date
  String get joinDate => teacherData.value?.joinDate ?? '';

  // Check if teacher data is available
  bool get hasData => teacherData.value != null;

  @override
  void onClose() {
    super.onClose();
  }
}