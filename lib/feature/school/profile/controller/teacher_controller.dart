// lib/feature/school/teacher/controller/teacher_controller.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/teacher_model.dart';
import '../repsitory/teacher_repository.dart';

class TeacherController extends GetxController {
  final TeacherRepository _repository = TeacherRepository();

  // ==================== SINGLE PROFILE STATE ====================
  final isLoading = false.obs;
  final teacherData = Rxn<TeacherData>();
  final errorMessage = ''.obs;

  // ==================== TEACHER LIST STATE ====================
  final isListLoading = false.obs;
  final teacherList = <TeacherData>[].obs;
  final listErrorMessage = ''.obs;

  /// Currently selected school type filter (null = all)
  final selectedSchoolType = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadTeacherProfile();
  }

  // ==================== SINGLE PROFILE ====================
  Future<void> loadTeacherProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final teacherId = await _repository.getTeacherId();

      if (teacherId == 0) {
        errorMessage.value = 'Teacher ID not found. Please login again.';
        isLoading.value = false;
        return;
      }

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

  Future<void> refreshProfile() async {
    await loadTeacherProfile();
  }

  // ==================== TEACHER LIST (school_type wise) ====================
  /// Load teachers, optionally filtered by [schoolType].
  /// If [schoolType] is null, uses the current [selectedSchoolType].
  Future<void> loadTeacherList({String? schoolType}) async {
    try {
      isListLoading.value = true;
      listErrorMessage.value = '';

      // If an explicit schoolType is passed, remember it as selection
      if (schoolType != null) {
        selectedSchoolType.value = schoolType;
      }

      final response = await _repository.getTeacherList(
        schoolType: selectedSchoolType.value,
      );

      if (response.success) {
        teacherList.assignAll(response.data);
      } else {
        listErrorMessage.value = 'Failed to load teacher list';
      }
    } catch (e) {
      listErrorMessage.value = e.toString();
      FlutterToast.error('Failed to load teacher list: $e');
    } finally {
      isListLoading.value = false;
    }
  }

  /// Change the school type filter and reload.
  Future<void> filterBySchoolType(String? schoolType) async {
    selectedSchoolType.value = schoolType;
    await loadTeacherList(schoolType: schoolType);
  }

  Future<void> refreshTeacherList() async {
    await loadTeacherList();
  }

  // ==================== SINGLE PROFILE GETTERS ====================
  int get id => teacherData.value?.id ?? 0;
  String get fullName => teacherData.value?.fullName ?? '';
  String get profileImage => teacherData.value?.teacherProfile ?? '';
  String get teacherIdCard => teacherData.value?.teacherIdCard ?? '';
  String get schoolType => teacherData.value?.schoolType ?? '';
  String get qualification => teacherData.value?.qualification ?? '';
  String get experienceString => teacherData.value?.experienceString ?? '';
  List<String> get subjects => teacherData.value?.subjects ?? [];
  String get subjectsString => teacherData.value?.subjectsString ?? '';
  int get subjectsCount => teacherData.value?.subjectsCount ?? 0;
  String get email => teacherData.value?.email ?? '';
  String get phone => teacherData.value?.phone ?? '';
  String get address => teacherData.value?.address ?? '';
  IconData get genderIcon => teacherData.value?.genderIcon ?? Icons.person;
  Color get genderColor => teacherData.value?.genderColor ?? Colors.blue;
  String get salary => teacherData.value?.salary ?? '0.00';
  String get joinDate => teacherData.value?.joinDate ?? '';
  bool get hasData => teacherData.value != null;

  // ==================== LIST GETTERS ====================
  bool get hasListData => teacherList.isNotEmpty;
  int get teacherCount => teacherList.length;

  @override
  void onClose() {
    super.onClose();
  }
}