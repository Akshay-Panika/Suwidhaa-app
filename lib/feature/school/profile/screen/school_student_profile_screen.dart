// lib/feature/school/dashboard/screen/school_student_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../auth/controller/school_auth_controller.dart';
import '../../home/widget/student_attendance_card.dart';
import '../controller/student_controller.dart';
import '../model/student_model.dart';

class SchoolStudentProfileScreen extends StatelessWidget {
  const SchoolStudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get student controller
    final studentController = Get.find<StudentController>();
    final authController = Get.find<SchoolAuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          // Show shimmer loading
          if (studentController.isLoading.value) {
            return _buildShimmerLoading();
          }

          // Show error message
          if (studentController.errorMessage.value.isNotEmpty) {
            return _buildErrorState(studentController);
          }

          // Show student data
          if (studentController.hasData) {
            return Column(
              children: [
                Expanded(
                  child: _buildStudentCard(studentController),
                ),
                const StudentAttendanceCard(),
                Expanded(
                  flex: 2,
                  child: _buildSchoolFeatures(context, studentController, authController),
                ),
              ],
            );
          }

          // No data available
          return _buildEmptyState();
        }),
      ),
    );
  }

  // ==================== SHIMMER LOADING ====================
  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          // Shimmer Header - Same as Student Card Design
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.blue,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Shimmer Profile Circle
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
                    // Shimmer Name
                    Container(
                      width: 150,
                      height: 18,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    // Shimmer Class Badge
                    Container(
                      width: 180,
                      height: 26,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Shimmer ID
                    Container(
                      width: 120,
                      height: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          ),
          // Shimmer Attendance Card - Same as StudentAttendanceCard
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
          // Shimmer School Features
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shimmer Section Title
                    Container(
                      width: 150,
                      height: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    // Shimmer Facilities Grid
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
                    // Shimmer Address Card
                    _buildShimmerAddressCard(),
                    const SizedBox(height: 12),
                    // Shimmer About Card
                    _buildShimmerAboutCard(),
                    const SizedBox(height: 16),
                    // Shimmer Fee Status Card
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
        Container(
          width: 40,
          height: 10,
          color: Colors.white,
        ),
        const SizedBox(height: 2),
        Container(
          width: 25,
          height: 8,
          color: Colors.white,
        ),
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
          Container(
            width: 40,
            height: 10,
            color: Colors.white,
          ),
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
                Container(
                  width: 80,
                  height: 10,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  height: 14,
                  color: Colors.white,
                ),
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
          Container(
            width: 100,
            height: 14,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 10,
            color: Colors.white,
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            height: 10,
            color: Colors.white,
          ),
          const SizedBox(height: 4),
          Container(
            width: 200,
            height: 10,
            color: Colors.white,
          ),
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
          Container(
            width: 100,
            height: 14,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 60,
                height: 12,
                color: Colors.white,
              ),
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
              Container(
                width: 60,
                height: 12,
                color: Colors.white,
              ),
              Container(
                width: 80,
                height: 12,
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 60,
                height: 12,
                color: Colors.white,
              ),
              Container(
                width: 80,
                height: 12,
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 60,
                height: 12,
                color: Colors.white,
              ),
              Container(
                width: 80,
                height: 12,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== ERROR STATE ====================
  Widget _buildErrorState(StudentController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            controller.errorMessage.value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.refreshProfile(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Retry',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== EMPTY STATE ====================
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 60,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No student data available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
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
            Expanded(
              child: Container(
                color: Colors.blue,
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Profile Image
            Container(
              height: 80,
              width: 80,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blue.shade300,
                  width: 2,
                ),
                image: student?.studentProfile != null && student!.studentProfile.isNotEmpty
                    ? DecorationImage(
                  image: NetworkImage(student.studentProfile),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: student?.studentProfile == null || student!.studentProfile.isEmpty
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
            // Student Name
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
            // Class and Section
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
            // Student ID
            Text(
              "Student ID: ${studentController.studentIdCard}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
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
      SchoolAuthController authController,
      ) {
    final student = studentController.studentData.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "School Facilities",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildFacilityItem(
                    Icons.local_library,
                    "Library",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildFacilityItem(
                    Icons.science,
                    "Science Lab",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildFacilityItem(
                    Icons.computer,
                    "Computer Lab",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildFacilityItem(
                    Icons.sports_soccer,
                    "Sports",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildFacilityItem(
                    Icons.directions_bus,
                    "Transport",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildFacilityItem(
                    Icons.restaurant,
                    "Canteen",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Address Card with real address
            _buildAddressCard(student),
            const SizedBox(height: 12),
            // About School
            _buildAboutSchool(),
            const SizedBox(height: 16),
            // Fee Status Card
            _buildFeeStatusCard(studentController),
            const SizedBox(height: 16),
            // Contact Section
            _buildContactSection(context, authController),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityItem(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 26,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(StudentData? student) {
    String address = student?.address ?? "Main Road, Raipur, Chhattisgarh, India";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.location_on,
            color: Colors.blue,
            size: 25,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "School Address",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSchool() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "About School",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 7),
          Text(
            "Suwidhaa Public School provides quality education "
                "with a focus on academic excellence, discipline, "
                "sports and overall personality development of students.",
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.shade200,
        ),
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
          // Fee Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Status:",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: student.feeStatus.toLowerCase() == 'paid'
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  student.feeStatus,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: student.feeStatus.toLowerCase() == 'paid'
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Fee Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Fee:",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              Text(
                "₹${student.feeAmount}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Paid Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Paid Amount:",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              Text(
                "₹${student.paidAmount}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Remaining Fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Remaining Fee:",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              Text(
                "₹${studentController.remainingFee.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, SchoolAuthController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildContactButton(
            icon: Icons.call,
            label: "Contact",
            color: Colors.green,
            onPressed: () {},
          ),
          _buildContactButton(
            icon: Icons.help_outline,
            label: "Help",
            color: Colors.blue,
            onPressed: () {},
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

  void _showLogoutDialog(BuildContext context, SchoolAuthController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Logout",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: const Text(
          "Are you sure you want to logout?",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
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
            child: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}