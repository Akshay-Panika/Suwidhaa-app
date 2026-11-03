import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:untitled/feature/school/auth/controller/student_auth_controller.dart';
import 'package:untitled/feature/school/profile/controller/student_controller.dart';
import 'package:untitled/feature/school/profile/model/student_model.dart';
import '../../../../core/widget/contact_helper.dart';
import '../../student/widget/student_attendance_card.dart';

class SchoolStudentProfileScreen extends StatelessWidget {
  const SchoolStudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentController = Get.find<StudentController>();
    final authController = Get.find<StudentAuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.indigo),
      body: Obx(() {
        if (studentController.isLoading.value) {
          return _buildShimmerLoading();
        }
        if (studentController.errorMessage.value.isNotEmpty) {
          return _buildErrorState(studentController);
        }
        if (studentController.hasData) {
          return Column(
            children: [
              Expanded(child: _buildStudentCard(studentController)),
              const StudentAttendanceCard(),
              Expanded(
                flex: 2,
                child: _buildSchoolFeatures(
                    context, studentController, authController),
              ),
            ],
          );
        }
        return _buildEmptyState();
      }),
    );
  }

  // ==================== SHIMMER LOADING ====================
  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    Expanded(child: Container(color: Colors.blue)),
                    Expanded(child: Container(color: Colors.white)),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      margin: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(width: 150, height: 18, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(
                      width: 180,
                      height: 26,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(width: 120, height: 12, color: Colors.white),
                    const SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShimmerAttendanceItem(),
                _buildShimmerAttendanceItem(),
                _buildShimmerAttendanceItem(),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 150, height: 20, color: Colors.white),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildShimmerFacilityItem()),
                        const SizedBox(width: 10),
                        Expanded(child: _buildShimmerFacilityItem()),
                        const SizedBox(width: 10),
                        Expanded(child: _buildShimmerFacilityItem()),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildShimmerFacilityItem()),
                        const SizedBox(width: 10),
                        Expanded(child: _buildShimmerFacilityItem()),
                        const SizedBox(width: 10),
                        Expanded(child: _buildShimmerFacilityItem()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildShimmerAddressCard(),
                    const SizedBox(height: 12),
                    _buildShimmerAboutCard(),
                    const SizedBox(height: 16),
                    _buildShimmerFeeCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerAttendanceItem() {
    return Column(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Container(width: 40, height: 10, color: Colors.white),
        const SizedBox(height: 2),
        Container(width: 25, height: 8, color: Colors.white),
      ],
    );
  }

  Widget _buildShimmerFacilityItem() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 6),
          Container(width: 40, height: 10, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildShimmerAddressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 80, height: 10, color: Colors.white),
                const SizedBox(height: 4),
                Container(
                    width: double.infinity, height: 14, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerAboutCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 100, height: 14, color: Colors.white),
          const SizedBox(height: 8),
          Container(
              width: double.infinity, height: 10, color: Colors.white),
          const SizedBox(height: 4),
          Container(
              width: double.infinity, height: 10, color: Colors.white),
          const SizedBox(height: 4),
          Container(width: 200, height: 10, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildShimmerFeeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 100, height: 14, color: Colors.white),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 60, height: 12, color: Colors.white),
              Container(
                width: 60,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 60, height: 12, color: Colors.white),
              Container(width: 80, height: 12, color: Colors.white),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 60, height: 12, color: Colors.white),
              Container(width: 80, height: 12, color: Colors.white),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 60, height: 12, color: Colors.white),
              Container(width: 80, height: 12, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== ERROR / EMPTY ====================
  Widget _buildErrorState(StudentController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            controller.errorMessage.value,
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.refreshProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text('No student data available',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  // ==================== STUDENT CARD ====================
  Widget _buildStudentCard(StudentController studentController) {
    final student = studentController.studentData.value;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            Expanded(child: Container(color: Colors.indigo)),
            Expanded(child: Container(color: Colors.white)),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 80,
              width: 80,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue.shade300, width: 2),
                image: (student?.studentProfile.isNotEmpty ?? false)
                    ? DecorationImage(
                  image: NetworkImage(student!.studentProfile),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: (student?.studentProfile.isEmpty ?? true)
                  ? Text(
                studentController.fullName.isNotEmpty
                    ? studentController.fullName[0].toUpperCase()
                    : 'S',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              )
                  : null,
            ),
            Text(
              studentController.fullName.isNotEmpty
                  ? studentController.fullName
                  : "Student Name",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Text(
                "Class: ${studentController.studentClass} - Roll No: ${studentController.rollNumber}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Student ID: ${studentController.studentIdCard}",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ],
    );
  }

  // ==================== SCHOOL FEATURES ====================
  Widget _buildSchoolFeatures(
      BuildContext context,
      StudentController studentController,
      StudentAuthController authController,
      ) {
    final student = studentController.studentData.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPersonalInfoCard(student),
            const SizedBox(height: 12),
            _buildAboutSchool(studentController),
            const SizedBox(height: 16),
            _buildFeeStatusCard(studentController),
            const SizedBox(height: 16),
            _buildContactSection(context, authController),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard(StudentData? student) {
    if (student == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.person_outline, color: Colors.indigo, size: 20),
              SizedBox(width: 8),
              Text(
                "Student Information",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.phone, "Phone", student.parentPhone),
          _buildInfoRow(Icons.location_on, "Address", student.address),
          _buildInfoRow(Icons.calendar_today, "Join Date", student.createdAt),
          _buildInfoRow(Icons.attach_money, "Fee", "₹${student.feeAmount}"),
          _buildInfoRow(Icons.work, "Class", student.studentClass),
          _buildInfoRow(Icons.person, "Gender", student.gender),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            "$label:",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: const TextStyle(fontSize: 12, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSchool(StudentController studentController) {
    final school = studentController.school;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "About School",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 7),
          if (school != null) ...[
            if (school.schoolName.isNotEmpty)
              Text(
                school.schoolName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              school.fullAddress.isNotEmpty
                  ? school.fullAddress
                  : 'Address not available',
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.grey,
              ),
            ),
            if (school.board.isNotEmpty || school.schoolType.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                [
                  if (school.board.isNotEmpty) 'Board: ${school.board}',
                  if (school.schoolType.isNotEmpty) school.schoolType,
                ].join('  •  '),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ] else
            const Text(
              "School information not available.",
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeeStatusCard(StudentController studentController) {
    final student = studentController.studentData.value;
    if (student == null) return const SizedBox.shrink();

    final isPaid = student.feeStatus.toLowerCase() == 'paid';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Fee Status",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Status:",
                  style: TextStyle(fontSize: 13, color: Colors.grey)),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isPaid ? Colors.green.shade100 : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  student.feeStatus,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isPaid
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _feeRow("Total Fee:", "₹${student.feeAmount}", Colors.black87),
          const SizedBox(height: 4),
          _feeRow("Paid Amount:", "₹${student.paidAmount}", Colors.green),
          const SizedBox(height: 4),
          _feeRow(
            "Remaining Fee:",
            "₹${studentController.remainingFee.toStringAsFixed(2)}",
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _feeRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(
      BuildContext context,
      StudentAuthController controller,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildContactButton(
            icon: Icons.call,
            label: "Contact",
            color: Colors.green,
            onPressed: () => ContactHelper.call('+918989207770'),
          ),
          _buildContactButton(
            icon: Icons.help_outline,
            label: "Help",
            color: Colors.blue,
            onPressed: () =>
                ContactHelper.whatsapp('+918989207770', "Hello Suwidhaa"),
          ),
          _buildContactButton(
            icon: Icons.logout,
            label: "Log Out",
            color: Colors.red,
            onPressed: () => _showLogoutDialog(context, controller),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color, size: 22),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        backgroundColor: color.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showLogoutDialog(
      BuildContext context,
      StudentAuthController controller,
      ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Logout",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content:
        const Text("Are you sure you want to logout?", style: TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Logout",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}