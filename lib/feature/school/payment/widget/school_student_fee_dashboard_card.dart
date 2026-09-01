import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screen/student_fee_screen.dart';
import '../../profile/controller/student_controller.dart';

class SchoolStudentFeeDashboardCard extends StatelessWidget {
  const SchoolStudentFeeDashboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    final StudentController controller = Get.find<StudentController>();

    return Obx(() {
      // Show loading state
      if (controller.isLoading.value) {
        return _buildDashboardBox(
          icon: Icons.account_balance_wallet_outlined,
          title: "Fee Status",
          value: "Loading...",
          subtitle: "Please wait",
          iconColor: Colors.grey,
        );
      }

      // Show error state
      if (controller.errorMessage.value.isNotEmpty) {
        return _buildDashboardBox(
          icon: Icons.error_outline,
          title: "Fee Status",
          value: "Error",
          subtitle: controller.errorMessage.value,
          iconColor: Colors.red,
        );
      }

      // No data state
      if (!controller.hasData) {
        return _buildDashboardBox(
          icon: Icons.account_balance_wallet_outlined,
          title: "Fee Status",
          value: "No Data",
          subtitle: "Student data not available",
          iconColor: Colors.grey,
        );
      }

      final student = controller.studentData.value!;

      // Calculate fee details
      final total = double.tryParse(student.feeAmount) ?? 0;
      final paid = double.tryParse(student.paidAmount) ?? 0;
      final remaining = student.remainingFee;

      // Determine status color
      Color statusColor;
      String statusText;
      String dueDate = "10 Sep 2026"; // Default due date (can be customized)

      if (remaining <= 0) {
        statusColor = Colors.green;
        statusText = "Fully Paid";
      } else if (paid > 0) {
        statusColor = Colors.orange;
        statusText = "₹${remaining.toStringAsFixed(2)} Pending";
      } else {
        statusColor = Colors.red;
        statusText = "₹${remaining.toStringAsFixed(2)} Due";
      }

      return InkWell(
        onTap: () {
          Get.to(() => const StudentFeeScreen());
        },
        borderRadius: BorderRadius.circular(10),
        child: _buildDashboardBox(
          icon: Icons.account_balance_wallet_outlined,
          title: "Fee Status",
          value: statusText,
          subtitle: "Due on $dueDate",
          iconColor: statusColor,
        ),
      );
    });
  }

  Widget _buildDashboardBox({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}