// lib/feature/school/student/view/student_fee_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../../profile/controller/student_controller.dart';
import '../../profile/model/student_model.dart';

class StudentFeeScreen extends StatelessWidget {
  const StudentFeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StudentController controller = Get.find<StudentController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Fee Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: () => controller.refreshProfile(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshProfile(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!controller.hasData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_off_outlined,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'No student data available',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }

        final student = controller.studentData.value!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Info Card
            _buildStudentInfoCard(student),
            const SizedBox(height: 16),

            // Fee Summary Card
            _buildFeeSummaryCard(student),

            // Payment History
            _buildPaymentHistory(student),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SafeArea(child: _buildActionButtons()),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStudentInfoCard(StudentData student) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Student Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: student.studentProfile.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  student.studentProfile,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Text(
                    student.fullName.isNotEmpty ? student.fullName[0].toUpperCase() : 'S',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
                  : Text(
                student.fullName.isNotEmpty ? student.fullName[0].toUpperCase() : 'S',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _buildInfoChip(
                      Icons.class_outlined,
                      student.studentClass.isNotEmpty ? student.studentClass : 'N/A',
                      Colors.purple,
                    ),
                    _buildInfoChip(
                      Icons.tag,
                      'Roll: ${student.rollNumber.isNotEmpty ? student.rollNumber : 'N/A'}',
                      Colors.blue,
                    ),
                    _buildInfoChip(
                      Icons.credit_card,
                      student.studentIdCard.isNotEmpty ? student.studentIdCard : 'N/A',
                      Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeSummaryCard(StudentData student) {
    final total = double.tryParse(student.feeAmount) ?? 0;
    final paid = double.tryParse(student.paidAmount) ?? 0;
    final remaining = student.remainingFee;
    final progress = total > 0 ? (paid / total).clamp(0.0, 1.0) : 0.0;

    Color statusColor;
    if (student.feeStatus.toLowerCase().contains('paid') ||
        student.feeStatus.toLowerCase().contains('complete')) {
      statusColor = Colors.green;
    } else if (student.feeStatus.toLowerCase().contains('partial')) {
      statusColor = Colors.orange;
    } else if (student.feeStatus.toLowerCase().contains('pending')) {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,

        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Fee Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        student.feeStatus.isNotEmpty ? student.feeStatus : 'N/A',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progress > 0.7
                                ? Colors.green
                                : progress > 0.4
                                ? Colors.orange
                                : Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Fee Amounts
          Row(
            children: [
              Expanded(
                child: _buildAmountCard(
                  'Total Fee',
                  '₹${student.feeAmount}',
                  Colors.blue,
                  Icons.account_balance_wallet,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAmountCard(
                  'Paid',
                  '₹${student.paidAmount}',
                  Colors.green,
                  Icons.check_circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAmountCard(
                  'Remaining',
                  '₹${remaining.toStringAsFixed(2)}',
                  remaining > 0 ? Colors.red : Colors.green,
                  remaining > 0 ? Icons.warning : Icons.check_circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountCard(String label, String amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistory(StudentData student) {
    // Generate payment history from fee data
    final List<Map<String, dynamic>> paymentHistory = _generatePaymentHistory(student);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payment History',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '${paymentHistory.length} months',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: paymentHistory.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final payment = paymentHistory[index];
                  final isPaid = payment['status'] == 'Paid';
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isPaid ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Icon(
                              isPaid ? Icons.check_circle : Icons.pending,
                              color: isPaid ? Colors.green : Colors.orange,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${payment['month']} 2024',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                isPaid ? 'Paid on ${payment['date']}' : 'Pending',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isPaid ? Colors.green.shade700 : Colors.orange.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '₹${payment['amount']}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isPaid ? Colors.green.shade700 : Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isPaid ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            payment['status'],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isPaid ? Colors.green.shade700 : Colors.orange.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _generatePaymentHistory(StudentData student) {
    List<Map<String, dynamic>> payments = [];
    double paid = double.tryParse(student.paidAmount) ?? 0;
    double total = double.tryParse(student.feeAmount) ?? 0;

    if (total > 0) {
      List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
      double perMonth = total / months.length;
      int paidMonths = (paid / perMonth).round();

      for (int i = 0; i < months.length; i++) {
        bool isPaid = i < paidMonths && paidMonths <= months.length;
        payments.add({
          'month': months[i],
          'amount': perMonth.toStringAsFixed(2),
          'status': isPaid ? 'Paid' : 'Pending',
          'date': isPaid ? '2024-${(i+1).toString().padLeft(2, '0')}-15' : '-',
        });
      }
    }

    return payments;
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              FlutterToast.show(
                message: 'Pay fee feature coming soon!',
                backgroundColor: Colors.blue,
              );
            },
            icon: const Icon(Icons.payment, size: 18),
            label: const Text('Pay Now'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: BorderSide(color: Colors.blue.shade300),
              foregroundColor: Colors.blue.shade700,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              FlutterToast.show(
                message: 'Download receipt feature coming soon!',
                backgroundColor: Colors.purple,
              );
            },
            icon: const Icon(Icons.download, size: 18),
            label: const Text('Receipt'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: BorderSide(color: Colors.purple.shade300),
              foregroundColor: Colors.purple.shade700,
            ),
          ),
        ),
      ],
    );
  }
}