// lib/feature/auth/controller/school_auth_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:untitled/router/app_routes.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../repository/school_auth_repository.dart';
import '../model/school_auth_model.dart';
import '../service/school_auth_shared_pref_service.dart';

class SchoolAuthController extends GetxController {
  final SchoolAuthRepository _authRepository = SchoolAuthRepository();

  // Observable variables
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final userType = 'student'.obs;
  final userName = ''.obs;
  final userId = 0.obs;

  // Form controllers
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isStudentMode = true.obs;

  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    try {
      final loggedIn = await _authRepository.isLoggedIn();
      isLoggedIn.value = loggedIn;

      if (loggedIn) {
        await loadUserData();
        // _navigateToDashboard();
      }
    } catch (e) {
      print('Error checking login status: $e');
    }
  }

  Future<void> loadUserData() async {
    try {
      userType.value = await _authRepository.getUserType();
      userId.value = await _authRepository.getUserId();
      userName.value = await _authRepository.getUserName();
      isStudentMode.value = userType.value == 'student';
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // void _navigateToDashboard() {
  //   if (userType.value == 'student') {
  //     Get.offAllNamed(AppRoutes.studentDashboard);
  //   } else {
  //     Get.offAllNamed(AppRoutes.teacherDashboard);
  //   }
  // }

  Future<void> studentLogin() async {
    if (!_validateForm()) return;

    isLoading.value = true;
    try {
      final request = SchoolAuthLoginRequest(
        idCard: idController.text.trim(),
        password: passwordController.text,
      );

      final response = await _authRepository.studentLogin(request);

      if (response.success && response.data != null) {
        isLoggedIn.value = true;
        await loadUserData();
        FlutterToast.success('Welcome ${response.data!.studentName} 🎉');
        // Navigate using Get.offAll with named route
        Get.offAllNamed(AppRoutes.studentDashboard);
      } else {
        FlutterToast.error(response.message);
      }
    } catch (e) {
      FlutterToast.error('Login failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> teacherLogin() async {
    if (!_validateForm()) return;

    isLoading.value = true;
    try {
      final request = SchoolAuthTeacherLoginRequest(
        idCard: idController.text.trim(),
        password: passwordController.text,
      );

      final response = await _authRepository.teacherLogin(request);

      if (response.success && response.data != null) {
        isLoggedIn.value = true;
        await loadUserData();
        FlutterToast.success('Welcome ${response.data!.teacherName} 🎉');
        // Navigate using Get.offAll with named route
        Get.offAllNamed(AppRoutes.teacherDashboard);
      } else {
        FlutterToast.error(response.message);
      }
    } catch (e) {
      FlutterToast.error('Login failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleMode(bool isStudent) {
    isStudentMode.value = isStudent;
    idController.clear();
    passwordController.clear();
    formKey.currentState?.reset();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool _validateForm() {
    if (idController.text.trim().isEmpty) {
      FlutterToast.error('Please enter your ${isStudentMode.value ? "Student" : "Teacher"} ID');
      return false;
    }
    if (passwordController.text.isEmpty) {
      FlutterToast.error('Please enter your password');
      return false;
    }
    return true;
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      isLoggedIn.value = false;
      idController.clear();
      passwordController.clear();
      FlutterToast.success('Logged out successfully');
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      FlutterToast.error('Logout failed: $e');
    }
  }

  @override
  void onClose() {
    idController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}