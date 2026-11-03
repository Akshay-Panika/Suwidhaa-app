import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

import '../controller/student_auth_controller.dart';
import '../controller/teacher_auth_controller.dart';

class SchoolAuthScreen extends StatelessWidget {
  const SchoolAuthScreen({super.key});

  static const List<String> _schoolImages = [
    'https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=800&h=400&fit=crop',
    'https://images.unsplash.com/photo-1571260899304-425eee4c7efc?w=800&h=400&fit=crop',
    'https://images.unsplash.com/photo-1523050854058-8df90110c7f1?w=800&h=400&fit=crop',
    'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800&h=400&fit=crop',
  ];

  @override
  Widget build(BuildContext context) {
    final studentCtrl = Get.find<StudentAuthController>();
    final teacherCtrl = Get.find<TeacherAuthController>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: GetBuilder<StudentAuthController>(
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: _buildAppBar(controller),
            body: Stack(
              children: [
                _buildBannerBackground(controller),
                _buildDraggableSheet(context, controller, teacherCtrl),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(StudentAuthController controller) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.blue,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.school_outlined,
                size: 24, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Suwidhaa School",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.isStudentMode.value
                      ? "Student Portal"
                      : "Teacher Portal",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded,
                    color: Colors.white, size: 25),
              ),
              Positioned(
                right: 7,
                top: 7,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBannerBackground(StudentAuthController controller) {
    return SizedBox(
      width: double.infinity,
      height: Get.height * 0.3,
      child: Stack(
        children: [
          CarouselSlider(
            items: _schoolImages.map((imageUrl) {
              return SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.blue.shade900),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              pauseAutoPlayOnTouch: true,
              enableInfiniteScroll: true,
              height: double.infinity,
              viewportFraction: 1.0,
            ),
          ),
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() => Text(
                  controller.isStudentMode.value
                      ? "Welcome Student!"
                      : "Welcome Teacher!",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                const SizedBox(height: 4),
                Obx(() => Text(
                  controller.isStudentMode.value
                      ? "Student Portal"
                      : "Teacher Portal",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                )),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableSheet(
      BuildContext context,
      StudentAuthController controller,
      TeacherAuthController teacherController,
      ) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.7,
      maxChildSize: 1.0,
      expand: true,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: CustomScrollView(
            controller: scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // ✅ Scroll karte hi keyboard band
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildDragHandle(),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        "Login to your account",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        "Enter your credentials to continue",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _buildRoleToggle(controller),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                sliver: SliverToBoxAdapter(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        _buildTextField(controller),
                        const SizedBox(height: 16),
                        _buildPasswordField(controller),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus(); // ✅ Sheet open se pehle keyboard band
                              _openForgotPasswordSheet(
                                  context, controller, teacherController);
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildLoginButton(controller, teacherController),
                        const SizedBox(height: 16),
                        _buildInfoCard(controller),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            "School Management System v2.0",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildRoleToggle(StudentAuthController controller) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                controller.toggleMode(true);
              },
              child: Obx(() => Container(
                decoration: BoxDecoration(
                  color: controller.isStudentMode.value
                      ? Colors.blue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.school,
                        color: controller.isStudentMode.value
                            ? Colors.white
                            : Colors.grey.shade600,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Student",
                        style: TextStyle(
                          color: controller.isStudentMode.value
                              ? Colors.white
                              : Colors.grey.shade600,
                          fontWeight: controller.isStudentMode.value
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                controller.toggleMode(false);
              },
              child: Obx(() => Container(
                decoration: BoxDecoration(
                  color: !controller.isStudentMode.value
                      ? Colors.blue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color: !controller.isStudentMode.value
                            ? Colors.white
                            : Colors.grey.shade600,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Teacher",
                        style: TextStyle(
                          color: !controller.isStudentMode.value
                              ? Colors.white
                              : Colors.grey.shade600,
                          fontWeight: !controller.isStudentMode.value
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(StudentAuthController controller) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.isStudentMode.value ? "Student ID" : "Teacher ID",
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller.idController,
          textInputAction: TextInputAction.next,
          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(), // ✅ Bahar tap karne pe unfocus
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'Please enter your ID';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: controller.isStudentMode.value
                ? "Enter Student ID"
                : "Enter Teacher ID",
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            prefixIcon: Icon(
              controller.isStudentMode.value
                  ? Icons.person_outline
                  : Icons.badge_outlined,
              color: Colors.grey.shade600,
              size: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    ));
  }

  Widget _buildPasswordField(StudentAuthController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Password",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Obx(() => TextFormField(
          controller: controller.passwordController,
          obscureText: !controller.isPasswordVisible.value,
          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(), // ✅
          validator: (v) {
            if (v == null || v.isEmpty) return 'Please enter password';
            return null;
          },
          decoration: InputDecoration(
            hintText: "Enter Password",
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            prefixIcon: const Icon(Icons.lock_outline,
                color: Colors.grey, size: 20),
            suffixIcon: IconButton(
              onPressed: controller.togglePasswordVisibility,
              icon: Icon(
                controller.isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey.shade600,
                size: 20,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          ),
          style: const TextStyle(fontSize: 14),
        )),
      ],
    );
  }

  Widget _buildLoginButton(
      StudentAuthController controller,
      TeacherAuthController teacherController,
      ) {
    return Obx(() {
      final loading =
          controller.isLoading.value || teacherController.isLoading.value;

      return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: loading
              ? null
              : () {
            // ✅ 1. Form Validation
            if (controller.formKey.currentState?.validate() != true) {
              return;
            }

            // ✅ 2. Keyboard band karo taaki navigation pe crash na ho
            FocusManager.instance.primaryFocus?.unfocus();

            // ✅ 3. Call respective login
            if (controller.isStudentMode.value) {
              controller.studentLogin();
            } else {
              teacherController.idController.text =
                  controller.idController.text.trim();
              teacherController.passwordController.text =
                  controller.passwordController.text;
              teacherController.teacherLogin();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: loading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : const Text(
            "Login",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      );
    });
  }

  Widget _buildInfoCard(StudentAuthController controller) {
    return Obx(() => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: controller.isStudentMode.value
            ? Colors.green.shade50
            : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: controller.isStudentMode.value
              ? Colors.green.shade200
              : Colors.orange.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            controller.isStudentMode.value ? Icons.school : Icons.person,
            color: controller.isStudentMode.value
                ? Colors.green.shade700
                : Colors.orange.shade700,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              controller.isStudentMode.value
                  ? "Student: Access attendance, marks & more"
                  : "Teacher: Manage classes & attendance",
              style: TextStyle(
                fontSize: 12,
                color: controller.isStudentMode.value
                    ? Colors.green.shade700
                    : Colors.orange.shade700,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void _openForgotPasswordSheet(
      BuildContext context,
      StudentAuthController studentCtrl,
      TeacherAuthController teacherCtrl,
      ) {
    final isStudentMode = studentCtrl.isStudentMode.value;
    final dynamic auth = isStudentMode ? studentCtrl : teacherCtrl;

    auth.resetForgotPasswordState();
    auth.fpIdCardController.text = studentCtrl.idController.text.trim();
    auth.fpDobController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Obx(() {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // ✅
              child: auth.fpStep.value == 1
                  ? _buildFpStep1(auth, isStudentMode: isStudentMode)
                  : _buildFpStep2(auth, isStudentMode: isStudentMode),
            );
          }),
        );
      },
    );
  }

  Widget _buildFpStep1(dynamic controller, {required bool isStudentMode}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Forgot Password',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          isStudentMode
              ? 'Enter your Student ID and Date of Birth. We will send an OTP on WhatsApp to the registered phone number.'
              : 'Enter your Teacher ID and Date of Birth. We will send an OTP on WhatsApp to the registered phone number.',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 20),
        Text(
          isStudentMode ? 'Student ID' : 'Teacher ID',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller.fpIdCardController,
          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(), // ✅
          decoration: _fpInputDecoration(
            hint: isStudentMode ? 'e.g. st-student01' : 'e.g. t-teacher01',
            icon: Icons.person_outline,
          ),
        ),
        const SizedBox(height: 14),
        const Text('Date of Birth',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller.fpDobController,
          readOnly: true,
          onTap: () async {
            FocusManager.instance.primaryFocus?.unfocus(); // ✅ Date picker se pehle
            final initial =
                DateTime.tryParse(controller.fpDobController.text) ??
                    DateTime(1990, 1, 1);
            final picked = await showDatePicker(
              context: Get.context!,
              initialDate: initial,
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              final formatted = '${picked.year.toString().padLeft(4, '0')}-'
                  '${picked.month.toString().padLeft(2, '0')}-'
                  '${picked.day.toString().padLeft(2, '0')}';
              controller.fpDobController.text = formatted;
            }
          },
          decoration: _fpInputDecoration(
            hint: 'YYYY-MM-DD',
            icon: Icons.calendar_today_outlined,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: Obx(() => ElevatedButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus(); // ✅ API call se pehle
              if (!controller.fpLoading.value) controller.requestOtp();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: controller.fpLoading.value
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            )
                : const Text(
              'Send OTP on WhatsApp',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600),
            ),
          )),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildFpStep2(dynamic controller, {required bool isStudentMode}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Enter OTP',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          controller.fpSentMessage.value.isNotEmpty
              ? controller.fpSentMessage.value
              : 'An OTP was sent on WhatsApp. Please check the message.',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 20),
        const Text('6-Digit OTP',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller.fpOtpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(), // ✅
          decoration: _fpInputDecoration(
            hint: '• • • • • •',
            icon: Icons.lock_clock_outlined,
          ),
        ),
        const SizedBox(height: 6),
        const Text('New Password',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller.fpNewPasswordController,
          obscureText: true,
          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(), // ✅
          decoration: _fpInputDecoration(
            hint: 'Minimum 6 characters',
            icon: Icons.lock_outline,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: Obx(() => ElevatedButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus(); // ✅ Verify se pehle keyboard band
              if (!controller.fpLoading.value) controller.verifyOtpAndReset();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: controller.fpLoading.value
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            )
                : const Text(
              'Verify & Reset Password',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600),
            ),
          )),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus(); // ✅ Back se pehle
            controller.fpStep.value = 1;
            controller.fpOtpController.clear();
            controller.fpNewPasswordController.clear();
          },
          child: const Text('← Back / Resend OTP'),
        ),
      ],
    );
  }

  InputDecoration _fpInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
      prefixIcon: Icon(icon, color: Colors.grey.shade600, size: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding:
      const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
    );
  }
}