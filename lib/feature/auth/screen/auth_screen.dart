import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_color.dart';
import '../controller/auth_controller.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController(), permanent: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Sign In',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        final isOtpStep = authController.currentStep.value == AuthStep.otp;
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLogoWithText(),
              const SizedBox(height: 32),
              if (!isOtpStep) _buildPhoneInput() else _buildOtpInput(),
              const SizedBox(height: 20),
              _buildActionButton(isOtpStep),
              const SizedBox(height: 12),
              if (isOtpStep) _buildResendRow(),
              const SizedBox(height: 24),
              _buildTermsText(),
              if (authController.errorMessage.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      authController.errorMessage.value,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLogoWithText() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/logo/Suwidhaa.png'),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Welcome to Suwidhaa',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in with OTP to continue exploring\ncolleges, accommodations, and more',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            height: 1.6,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return _inputContainer(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Icon(Icons.phone_android,
                    color: AppColors.primary, size: 22),
                SizedBox(width: 8),
                Text(
                  '+91',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(color: Colors.grey, width: 1),
          Expanded(
            child: TextField(
              controller: authController.phoneController,
              focusNode: authController.phoneFocusNode,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'Enter phone number',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => authController.sendOtp(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpInput() {
    final phone = authController.phoneController.text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'OTP sent to +91 $phone',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: authController.editPhone,
              child: const Text('Change'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _inputContainer(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(Icons.lock_outline,
                    color: AppColors.primary, size: 22),
              ),
              const VerticalDivider(color: Colors.grey, width: 1),
              Expanded(
                child: TextField(
                  controller: authController.otpController,
                  focusNode: authController.otpFocusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    letterSpacing: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Enter OTP',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onSubmitted: (_) => authController.verifyOtp(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _inputContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: child,
    );
  }

  Widget _buildActionButton(bool isOtpStep) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: authController.isLoading.value
            ? null
            : (isOtpStep
            ? authController.verifyOtp
            : authController.sendOtp),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: authController.isLoading.value
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Text(
          isOtpStep ? 'Verify & Continue' : 'Send OTP',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildResendRow() {
    return Obx(() {
      final enabled = authController.isResendEnabled.value;
      return TextButton(
        onPressed: enabled ? authController.resendOtp : null,
        child: Text(
          enabled
              ? 'Resend OTP'
              : 'Resend in ${authController.resendTimer.value}s',
          style: TextStyle(
            color: enabled ? AppColors.primary : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    });
  }

  Widget _buildTermsText() {
    return Text(
      'By continuing, you agree to our Terms of Service\nand Privacy Policy',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.grey[500],
        fontSize: 12,
        height: 1.5,
      ),
    );
  }
}