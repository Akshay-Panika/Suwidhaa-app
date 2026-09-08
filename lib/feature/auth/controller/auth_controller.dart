import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:untitled/router/app_routes.dart';
import '../../../core/widget/flutter_toast.dart';
import '../model/auth_model.dart';
import '../repository/auth_repository.dart';
import '../shared_preferences/auth_shared_preferences.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  // Observables
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final Rx<UserData?> currentUser = Rx<UserData?>(null);
  final RxString errorMessage = ''.obs;

  // Text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  // Focus nodes
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode otpFocusNode = FocusNode();

  // OTP related
  final RxBool isOtpSent = false.obs;
  final RxBool isResendEnabled = false.obs;
  final RxInt resendTimer = 60.obs;
  final RxString generatedOTP = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    otpController.dispose();
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    otpFocusNode.dispose();
    super.onClose();
  }

  // Check if user is already logged in
  Future<void> checkLoginStatus() async {
    try {
      final loggedIn = await AuthSharedPreferences.isLoggedIn();
      if (loggedIn) {
        final user = await AuthSharedPreferences.getUserData();
        if (user != null) {
          currentUser.value = user;
          isLoggedIn.value = true;
          print('✅ User already logged in: ${user.name}');
        }
      }
    } catch (e) {
      print('❌ Error checking login status: $e');
    }
  }

  // Authenticate user (register or login)
  Future<void> authenticate() async {
    // Validate name (only for new registration)
    if (nameController.text.trim().isEmpty) {
      FlutterToast.error('Please enter your name');
      nameFocusNode.requestFocus();
      return;
    }

    if (nameController.text.trim().length < 2) {
      FlutterToast.error('Name must be at least 2 characters');
      nameFocusNode.requestFocus();
      return;
    }

    // Validate phone
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      FlutterToast.error('Please enter your phone number');
      phoneFocusNode.requestFocus();
      return;
    }

    final cleanedPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedPhone.length != 10) {
      FlutterToast.error('Please enter a valid 10-digit phone number');
      phoneFocusNode.requestFocus();
      return;
    }

    // OTP is optional - we ignore it
    // Just proceed with authentication

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _authRepository.authenticate(
        phoneNumber: cleanedPhone,
        name: nameController.text.trim(),
      );

      if (response.success && response.data != null) {
        // Save user data
        await AuthSharedPreferences.saveUserData(response.data!);
        currentUser.value = response.data!;
        isLoggedIn.value = true;

        // Show success message
        if (response.action == 'register') {
          FlutterToast.success('Welcome ${response.data!.name}! 🎉');
        } else {
          FlutterToast.success('Welcome back ${response.data!.name}! 👋');
        }

        // Navigate to dashboard
        await Future.delayed(const Duration(milliseconds: 500));
        _navigateToDashboard();
      } else {
        errorMessage.value = response.error ?? 'Authentication failed';
        FlutterToast.error(response.error ?? 'Authentication failed. Please try again.');
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      FlutterToast.error('An unexpected error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Generate OTP (optional - for UI only)
  void generateOTP() {
    // This is optional - just for UI demonstration
    final otp = '123456';
    generatedOTP.value = otp;
    isOtpSent.value = true;
    isResendEnabled.value = false;
    resendTimer.value = 60;
    startResendTimer();
    FlutterToast.success('OTP sent successfully!');
  }

  void startResendTimer() {
    // Timer logic for UI only
  }

  // Logout
  Future<void> logout() async {
    try {
      await AuthSharedPreferences.clearUserData();
      currentUser.value = null;
      isLoggedIn.value = false;
      FlutterToast.success('Logged out successfully');
      Get.offAllNamed(AppRoutes.auth);
    } catch (e) {
      print('❌ Error logging out: $e');
    }
  }

  // Navigation
  void _navigateToDashboard() {
    // Navigate to your dashboard
    Get.offAllNamed('/');
  }

  // Getters
  String get getUserName => currentUser.value?.name ?? '';
  String get getUserPhone => currentUser.value?.phoneNumber ?? '';
  int get getUserId => currentUser.value?.id ?? 0;
  bool get isUserLoggedIn => isLoggedIn.value;

  // Clear OTP state
  void resetOTPState() {
    isOtpSent.value = false;
    generatedOTP.value = '';
    otpController.clear();
  }
}