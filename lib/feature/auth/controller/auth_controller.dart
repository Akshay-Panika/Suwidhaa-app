import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/router/app_routes.dart';
import '../../../core/widget/flutter_toast.dart';
import '../model/auth_model.dart';
import '../repository/auth_repository.dart';
import '../shared_preferences/auth_shared_preferences.dart';

enum AuthStep { phone, otp }

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  // Observables
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final Rx<UserData?> currentUser = Rx<UserData?>(null);
  final RxString errorMessage = ''.obs;
  final Rx<AuthStep> currentStep = AuthStep.phone.obs;

  // Text controllers
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  // Focus nodes
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode otpFocusNode = FocusNode();

  // OTP related
  final RxBool isOtpSent = false.obs;
  final RxBool isResendEnabled = false.obs;
  final RxInt resendTimer = 60.obs;
  Timer? _resendTimerHandle;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  @override
  void onClose() {
    _resendTimerHandle?.cancel();
    phoneController.dispose();
    otpController.dispose();
    phoneFocusNode.dispose();
    otpFocusNode.dispose();
    super.onClose();
  }

  Future<void> checkLoginStatus() async {
    try {
      final loggedIn = await AuthSharedPreferences.isLoggedIn();
      if (loggedIn) {
        final user = await AuthSharedPreferences.getUserData();
        if (user != null) {
          currentUser.value = user;
          isLoggedIn.value = true;
          print('✅ User already logged in: ${user.phoneNumber}');
        }
      }
    } catch (e) {
      print('❌ Error checking login status: $e');
    }
  }

  /// STEP 1 — Send OTP
  Future<void> sendOtp() async {
    errorMessage.value = '';
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      FlutterToast.error('Please enter your phone number');
      phoneFocusNode.requestFocus();
      return;
    }
    final cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length != 10) {
      FlutterToast.error('Please enter a valid 10-digit phone number');
      phoneFocusNode.requestFocus();
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authRepository.sendOtp(phoneNumber: cleaned);
      if (response.success) {
        isOtpSent.value = true;
        currentStep.value = AuthStep.otp;
        _startResendTimer();
        FlutterToast.success(response.message ?? 'OTP sent successfully');
        Future.delayed(const Duration(milliseconds: 300), () {
          otpFocusNode.requestFocus();
        });
      } else {
        errorMessage.value = response.error ?? 'Failed to send OTP';
        FlutterToast.error(errorMessage.value);
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// STEP 2 — Verify OTP + save everything
  Future<void> verifyOtp() async {
    errorMessage.value = '';
    final phone =
    phoneController.text.trim().replaceAll(RegExp(r'[^0-9]'), '');
    final otp = otpController.text.trim();

    if (otp.isEmpty || otp.length < 4) {
      FlutterToast.error('Please enter a valid OTP');
      otpFocusNode.requestFocus();
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authRepository.verifyOtp(
        phoneNumber: phone,
        otp: otp,
      );

      if (response.success && response.data != null) {
        // ✅ Save FULL user data in shared prefs
        await AuthSharedPreferences.saveUserData(response.data!);
        currentUser.value = response.data!;
        isLoggedIn.value = true;

        FlutterToast.success(response.message ?? 'Login successful');
        await Future.delayed(const Duration(milliseconds: 500));
        _navigateToDashboard();
      } else {
        errorMessage.value = response.error ?? 'OTP verification failed';
        FlutterToast.error(errorMessage.value);
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Resend OTP
  Future<void> resendOtp() async {
    if (!isResendEnabled.value) return;
    otpController.clear();
    await sendOtp();
  }

  /// Back to phone step
  void editPhone() {
    currentStep.value = AuthStep.phone;
    isOtpSent.value = false;
    otpController.clear();
    _resendTimerHandle?.cancel();
    isResendEnabled.value = false;
    resendTimer.value = 60;
    phoneFocusNode.requestFocus();
  }

  void _startResendTimer() {
    isResendEnabled.value = false;
    resendTimer.value = 60;
    _resendTimerHandle?.cancel();
    _resendTimerHandle = Timer.periodic(const Duration(seconds: 1), (t) {
      if (resendTimer.value <= 1) {
        t.cancel();
        isResendEnabled.value = true;
      } else {
        resendTimer.value--;
      }
    });
  }

  /// Logout — also hits API
  Future<void> logout() async {
    try {
      final phoneRaw =
          currentUser.value?.phoneNumber ?? phoneController.text;
      final phone = phoneRaw.replaceAll(RegExp(r'[^0-9]'), '');

      if (phone.isNotEmpty) {
        await _authRepository.logout(phoneNumber: phone);
      }

      await AuthSharedPreferences.clearUserData();
      currentUser.value = null;
      isLoggedIn.value = false;
      FlutterToast.success('Logged out successfully');
      Get.offAllNamed(AppRoutes.auth);
    } catch (e) {
      print('❌ Error logging out: $e');
    }
  }

  /// Delete account
  Future<bool> deleteAccount() async {
    if (currentUser.value == null) return false;
    final ok = await _authRepository.deleteUser(currentUser.value!.id);
    if (ok) {
      await AuthSharedPreferences.clearUserData();
      currentUser.value = null;
      isLoggedIn.value = false;
      FlutterToast.success('Account deleted successfully');
      Get.offAllNamed(AppRoutes.auth);
    } else {
      FlutterToast.error('Failed to delete account');
    }
    return ok;
  }

  void _navigateToDashboard() {
    Get.offAllNamed(AppRoutes.location);
  }

  // Getters
  String get getUserName => currentUser.value?.name ?? '';
  String get getUserPhone => currentUser.value?.phoneNumber ?? '';
  int get getUserId => currentUser.value?.id ?? 0;
  bool get isUserLoggedIn => isLoggedIn.value;
}