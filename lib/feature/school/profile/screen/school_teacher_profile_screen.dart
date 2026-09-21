// lib/feature/school/dashboard/screen/school_teacher_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/widget/contact_helper.dart';
import '../../attendance/widget/teacher_attendance_card.dart';
import '../../auth/controller/school_auth_controller.dart';
import '../../student/widget/student_attendance_card.dart';
import '../controller/teacher_controller.dart';
import '../model/teacher_model.dart';
import '../widget/school_facilitie_card.dart';

class SchoolTeacherProfileScreen extends StatelessWidget {
  const SchoolTeacherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teacherController = Get.find<TeacherController>();
    final authController = Get.find<SchoolAuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        // Show shimmer loading
        if (teacherController.isLoading.value) {
          return _buildShimmerLoading();
        }

        // Show error message
        if (teacherController.errorMessage.value.isNotEmpty) {
          return _buildErrorState(teacherController);
        }

        // Show teacher data
        if (teacherController.hasData) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                toolbarHeight: 200,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                    background: _buildTeacherCard(teacherController)),
              ),
              SliverToBoxAdapter(child: TeacherAttendanceCard()),
              SliverToBoxAdapter(
                child: _buildSchoolFeatures(
                    context, teacherController, authController),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        }

        // No data available
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
                    Expanded(child: Container(color: Colors.indigo)), // ← blue → indigo
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
                    const SizedBox(height: 8),
                    Container(width: 150, height: 12, color: Colors.white),
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
                    _buildShimmerPersonalCard(),
                    const SizedBox(height: 12),
                    _buildShimmerSubjectsCard(),
                    const SizedBox(height: 12),
                    _buildShimmerAboutCard(),
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

  Widget _buildShimmerPersonalCard() {
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
          Container(width: 120, height: 14, color: Colors.white),
          const SizedBox(height: 8),
          ...List.generate(
            6,
                (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(width: 60, height: 12, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Container(height: 12, color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerSubjectsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50, // ← orange → indigo
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 100, height: 14, color: Colors.white),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              5,
                  (index) => Container(
                width: 60 + (index * 10).toDouble(),
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
          Container(width: double.infinity, height: 10, color: Colors.white),
          const SizedBox(height: 4),
          Container(width: double.infinity, height: 10, color: Colors.white),
          const SizedBox(height: 4),
          Container(width: 200, height: 10, color: Colors.white),
        ],
      ),
    );
  }

  // ==================== ERROR STATE ====================
  Widget _buildErrorState(TeacherController controller) {
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
            onPressed: () => controller.refreshProfile(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo, // ← blue → indigo
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

  // ==================== EMPTY STATE ====================
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No teacher data available',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ==================== TEACHER CARD ====================
  Widget _buildTeacherCard(TeacherController teacherController) {
    final teacher = teacherController.teacherData.value;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            Expanded(child: Container(color: Colors.indigo)), // already indigo
            Expanded(child: Container(color: Colors.white)),
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
                  color: Colors.indigo.shade300, // ← blue → indigo
                  width: 2,
                ),
                image: teacher?.teacherProfile != null &&
                    teacher!.teacherProfile!.isNotEmpty
                    ? DecorationImage(
                  image: NetworkImage(teacher.teacherProfile!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: teacher?.teacherProfile == null ||
                  teacher!.teacherProfile!.isEmpty
                  ? Text(
                teacherController.fullName.isNotEmpty
                    ? teacherController.fullName[0].toUpperCase()
                    : 'T',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo, // ← blue → indigo
                ),
              )
                  : null,
            ),
            // Teacher Name
            Text(
              teacherController.fullName.isNotEmpty
                  ? teacherController.fullName
                  : "Teacher Name",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            // Teacher ID
            Text(
              "Teacher ID: ${teacherController.teacherIdCard}",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 4),
            // Experience
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_outline, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  "Experience: ${teacherController.experienceString}",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
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
      TeacherController teacherController,
      SchoolAuthController authController,
      ) {
    final teacher = teacherController.teacherData.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPersonalInfoCard(teacher),
            const SizedBox(height: 12),
            _buildSubjectsCard(teacherController),
            const SizedBox(height: 12),
            _buildAboutSchool(),
            const SizedBox(height: 16),
            _buildContactSection(context, authController),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard(TeacherData? teacher) {
    if (teacher == null) return const SizedBox.shrink();

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
          Row(
            children: [
              Icon(
                Icons.person_outline,
                color: Colors.indigo, // ← blue → indigo
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                "Personal Information",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.email, "Email", teacher.email),
          _buildInfoRow(Icons.phone, "Phone", teacher.phone),
          _buildInfoRow(Icons.location_on, "Address", teacher.address),
          _buildInfoRow(Icons.calendar_today, "Join Date", teacher.joinDate),
          _buildInfoRow(Icons.attach_money, "Salary", "₹${teacher.salary}"),
          _buildInfoRow(Icons.work, "Experience", teacher.experienceString),
          _buildInfoRow(Icons.person, "Gender", teacher.gender),
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

  Widget _buildSubjectsCard(TeacherController teacherController) {
    if (teacherController.subjects.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50, // ← orange → indigo
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.indigo.shade200, // ← orange → indigo
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.book,
                color: Colors.indigo.shade700, // ← orange → indigo
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Subjects (${teacherController.subjectsCount})",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo.shade700, // ← orange → indigo
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: teacherController.subjects.map((subject) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.indigo.shade200, // ← orange → indigo
                  ),
                ),
                child: Text(
                  subject,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.indigo.shade700, // ← orange → indigo
                  ),
                ),
              );
            }).toList(),
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
        border: Border.all(color: Colors.grey.shade200),
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
            style: TextStyle(fontSize: 13, height: 1.5, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(
      BuildContext context, SchoolAuthController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
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
            color: Colors.indigo, // ← blue → indigo
            onPressed: () =>
                ContactHelper.whatsapp('+918989207770', "Hello Akshay"),
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
      BuildContext context, SchoolAuthController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Logout",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: const Text(
          "Are you sure you want to logout?",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey, fontSize: 16),
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
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}