import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../../../../router/app_routes.dart';
import '../model/student_auth_model.dart';
import '../repository/student_auth_repository.dart';
import '../service/school_auth_shared_pref_service.dart';

class StudentAuthController extends GetxController {
  final StudentAuthRepository _repo = StudentAuthRepository();

  // ---------- LOGIN ----------
  final formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isStudentMode = true.obs;

  // ---------- FORGOT PASSWORD ----------
  final fpIdCardController      = TextEditingController();
  final fpDobController         = TextEditingController();
  final fpOtpController         = TextEditingController();
  final fpNewPasswordController = TextEditingController();

  var fpStep    = 1.obs;
  var fpLoading = false.obs;
  var fpExpirySeconds = 300.obs;
  var fpSentMessage   = ''.obs;

  @override
  void onClose() {
    idController.dispose();
    passwordController.dispose();
    fpIdCardController.dispose();
    fpDobController.dispose();
    fpOtpController.dispose();
    fpNewPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  void toggleMode(bool studentMode) {
    isStudentMode.value = studentMode;
    formKey.currentState?.reset(); // Switch karte hi purana error clear ho jayega
  }

  // ============================================================
  // 1) STUDENT LOGIN
  // ============================================================
  Future<void> studentLogin() async {
    // Note: Form validation UI button me ho chuki hai
    FocusScope.of(Get.context!).unfocus();
    isLoading.value = true;

    try {
      final json = await _repo.login(
        studentIdCard: idController.text.trim(),
        password: passwordController.text,
      );

      final parsed = StudentLoginResponse.fromJson(json);

      if (parsed.success && parsed.data != null) {
        await SchoolAuthSharedPrefService.saveStudentLogin(parsed.data!.toJson());

        FlutterToast.success(parsed.message.isNotEmpty
            ? parsed.message
            : 'Login successful');

        Get.offAllNamed(AppRoutes.studentDashboard);

      } else {
        FlutterToast.error(parsed.message.isNotEmpty
            ? parsed.message
            : 'Login failed');
      }
    } on DioException catch (e) {
      FlutterToast.error(_extractError(e));
    } catch (e) {
      FlutterToast.error('Unexpected error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // 2) FORGOT PASSWORD — STEP 1: REQUEST OTP
  // ============================================================
  Future<void> requestOtp() async {
    final idCard = fpIdCardController.text.trim();
    final dob    = fpDobController.text.trim();

    if (idCard.isEmpty) {
      FlutterToast.warning('Please enter your Student ID');
      return;
    }
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dob)) {
      FlutterToast.warning('Enter DOB in YYYY-MM-DD format');
      return;
    }

    fpLoading.value = true;
    try {
      final json = await _repo.requestOtp(studentIdCard: idCard, dob: dob);
      final parsed = RequestOtpResponse.fromJson(json);

      if (parsed.success) {
        fpSentMessage.value = parsed.message;
        fpExpirySeconds.value = parsed.expiresInSeconds ?? 300;
        fpStep.value = 2;
        FlutterToast.success('OTP sent on WhatsApp');
      } else {
        FlutterToast.error(parsed.message.isNotEmpty
            ? parsed.message
            : 'Failed to send OTP');
      }
    } on DioException catch (e) {
      FlutterToast.error(_extractError(e));
    } catch (e) {
      FlutterToast.error('Unexpected error: $e');
    } finally {
      fpLoading.value = false;
    }
  }

  // ============================================================
  // 3) FORGOT PASSWORD — STEP 2: VERIFY OTP + RESET
  // ============================================================
  Future<void> verifyOtpAndReset() async {
    final idCard      = fpIdCardController.text.trim();
    final otp         = fpOtpController.text.trim();
    final newPassword = fpNewPasswordController.text;

    if (otp.length != 6) {
      FlutterToast.warning('Enter the 6-digit OTP');
      return;
    }
    if (newPassword.length < 6) {
      FlutterToast.warning('Password must be at least 6 characters');
      return;
    }

    fpLoading.value = true;
    try {
      final json = await _repo.verifyOtpAndReset(
        studentIdCard: idCard,
        otp: otp,
        newPassword: newPassword,
      );
      final parsed = VerifyAndResetResponse.fromJson(json);

      if (parsed.success) {
        FlutterToast.success(parsed.message.isNotEmpty
            ? parsed.message
            : 'Password updated successfully');

        idController.text = idCard;
        passwordController.clear();

        resetForgotPasswordState();
        Get.back(); // close bottom sheet
      } else {
        FlutterToast.error(parsed.message.isNotEmpty
            ? parsed.message
            : 'Failed to reset password');
      }
    } on DioException catch (e) {
      FlutterToast.error(_extractError(e));
    } catch (e) {
      FlutterToast.error('Unexpected error: $e');
    } finally {
      fpLoading.value = false;
    }
  }

  void resetForgotPasswordState() {
    fpStep.value = 1;
    fpSentMessage.value = '';
    fpOtpController.clear();
    fpNewPasswordController.clear();
    fpExpirySeconds.value = 300;
  }

  // ============================================================
  // 4) LOGOUT
  // ============================================================
  Future<void> logout() async {
    final idCard = await SchoolAuthSharedPrefService.getStudentIdCard();
    try {
      if (idCard != null && idCard.isNotEmpty) {
        await _repo.logout(studentIdCard: idCard);
      }
    } catch (_) {}
    await SchoolAuthSharedPrefService.clearStudent();
    FlutterToast.success('Logged out successfully');
    Get.offAllNamed(AppRoutes.schoolLogin);
  }

  // ============================================================
  // ERROR EXTRACTION
  // ============================================================
  String _extractError(DioException e) {
    final res = e.response;
    if (res != null && res.data is Map) {
      final data = Map<String, dynamic>.from(res.data as Map);

      if (data['message'] != null && data['message'].toString().trim().isNotEmpty) {
        return data['message'].toString();
      }
      if (data['error'] != null && data['error'].toString().trim().isNotEmpty) {
        return data['error'].toString();
      }
      if (data['errors'] is Map) {
        final errs = Map<String, dynamic>.from(data['errors'] as Map);
        final parts = <String>[];
        errs.forEach((key, value) {
          if (value is List) {
            parts.add('$key: ${value.join(', ')}');
          } else {
            parts.add('$key: $value');
          }
        });
        if (parts.isNotEmpty) return parts.join('\n');
      }
    }
    if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out. Check your internet.';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'Cannot connect to server';
    }
    return e.message ?? 'Network error';
  }
}