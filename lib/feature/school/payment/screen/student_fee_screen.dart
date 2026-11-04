import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/utils/app_color.dart';
import '../../profile/controller/student_controller.dart';
import '../../profile/model/student_model.dart';
import '../controller/student_fee_history_controller.dart';
import '../model/student_fee_model.dart';

class StudentFeeScreen extends StatelessWidget {
  const StudentFeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StudentController controller = Get.find<StudentController>();
    final StudentFeeHistoryController historyController =
    Get.find<StudentFeeHistoryController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Fee Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black87,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        actions: [
          IconButton(
            onPressed: () {
              controller.refreshProfile();
              historyController.refresh();
            },
            icon: const Icon(Icons.refresh,color: Colors.white,),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
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
                Icon(Icons.person_off_outlined,
                    size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  'No student data available',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }

        final student = controller.studentData.value!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStudentInfoCard(student),
            const SizedBox(height: 16),
            _buildFeeSummaryCard(student, historyController),
            _buildPaymentHistory(historyController),
          ],
        );
      }),
    );
  }

  // ----------------------------------------------------------------
  // Student Info Card
  // ----------------------------------------------------------------
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
                    student.fullName.isNotEmpty
                        ? student.fullName[0].toUpperCase()
                        : 'S',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
                  : Text(
                student.fullName.isNotEmpty
                    ? student.fullName[0].toUpperCase()
                    : 'S',
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
                      student.studentClass.isNotEmpty
                          ? student.studentClass
                          : 'N/A',
                      Colors.purple,
                    ),
                    _buildInfoChip(
                      Icons.tag,
                      'Roll: ${student.rollNumber.isNotEmpty ? student.rollNumber : 'N/A'}',
                      Colors.blue,
                    ),
                    _buildInfoChip(
                      Icons.credit_card,
                      student.studentIdCard.isNotEmpty
                          ? student.studentIdCard
                          : 'N/A',
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

  // ----------------------------------------------------------------
  // Fee Summary Card — progress based on transactions
  // ----------------------------------------------------------------
  Widget _buildFeeSummaryCard(
      StudentData student, StudentFeeHistoryController hc) {
    return Obx(() {
      // Explicit reference → Obx tracks historyList changes
      final txList = hc.historyList;

      final total = double.tryParse(student.feeAmount) ?? 0;
      final fallbackPaid = double.tryParse(student.paidAmount) ?? 0;

      // Real paid amount = sum of transactions (falls back to profile value
      // while history is still loading or empty)
      final paidFromTx =
      txList.fold(0.0, (s, e) => s + (double.tryParse(e.amountPaid) ?? 0.0));
      final paid = paidFromTx > 0 ? paidFromTx : fallbackPaid;

      final remaining = (total - paid).clamp(0.0, double.infinity);
      final progress = total > 0 ? (paid / total).clamp(0.0, 1.0) : 0.0;

      // Status derived from actual data
      String status;
      Color statusColor;
      if (total <= 0) {
        status = 'No Fee';
        statusColor = Colors.grey;
      } else if (remaining <= 0) {
        status = 'Paid';
        statusColor = Colors.green;
      } else if (paid > 0) {
        status = 'Partial';
        statusColor = Colors.orange;
      } else {
        status = 'Pending';
        statusColor = Colors.red;
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: statusColor.withOpacity(0.2)),
                        ),
                        child: Text(
                          status,
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
            Row(
              children: [
                Expanded(
                  child: _buildAmountCard(
                    'Total Fee',
                    '₹${total.toStringAsFixed(2)}',
                    Colors.blue,
                    Icons.account_balance_wallet,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildAmountCard(
                    'Paid',
                    '₹${paid.toStringAsFixed(2)}',
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
    });
  }

  Widget _buildAmountCard(
      String label, String amount, Color color, IconData icon) {
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

  // ----------------------------------------------------------------
  // Payment History — YEAR-WISE
  // ----------------------------------------------------------------
  Widget _buildPaymentHistory(StudentFeeHistoryController c) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header + overall total
            Obx(() {
              final totalPaid = c.totalPaidFromTransactions;
              return Row(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${totalPaid.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        '${c.historyList.length} payments',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                // Loading
                if (c.isLoadingHistory.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error
                if (c.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          c.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => c.refresh(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // Empty
                if (c.historyList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_outlined,
                            size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          'No payment history yet',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  );
                }

                // Year-wise list
                final byYear = c.historyByYear;
                final currentYear = DateTime.now().year;

                return RefreshIndicator(
                  onRefresh: c.refresh,
                  child: ListView(
                    children: byYear.entries.map((entry) {
                      return _buildYearSection(
                        c,
                        entry.key,
                        entry.value,
                        c.totalForYear(entry.key),
                        isCurrentYear: entry.key == currentYear,
                      );
                    }).toList(),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearSection(
      StudentFeeHistoryController c,
      int year,
      List<FeeHistoryModel> items,
      double yearTotal, {
        required bool isCurrentYear,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        initiallyExpanded: isCurrentYear,
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        childrenPadding:
        const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 0),
        shape: const Border(),
        collapsedShape: const Border(),
        title: Row(
          children: [
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isCurrentYear
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$year${isCurrentYear ? ' (This Year)' : ''}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isCurrentYear ? Colors.blue.shade700 : Colors.grey.shade700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${items.length} txns',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
            const Spacer(),
            Text(
              '₹${yearTotal.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: yearTotal > 0 ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
        children: items
            .map((item) => _buildHistoryTile(c, item))
            .toList(),
      ),
    );
  }

  Widget _buildHistoryTile(
      StudentFeeHistoryController c, FeeHistoryModel item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.check_circle, color: Colors.green, size: 18),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹${item.amountPaid}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  (item.remarks != null && item.remarks!.isNotEmpty)
                      ? item.remarks!
                      : 'Fee payment',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatDate(item.paymentDate),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Delete transaction',
            icon: Icon(Icons.delete_outline,
                size: 20, color: Colors.red.shade400),
            onPressed: () => _confirmDelete(c, item),
          ),
        ],
      ),
    );
  }

  String _formatDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $h:$m';
    } catch (_) {
      return raw;
    }
  }

  Future<void> _confirmDelete(
      StudentFeeHistoryController c, FeeHistoryModel item) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Transaction'),
        content: Text(
          'Are you sure you want to delete the payment of ₹${item.amountPaid}?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await c.deleteTransaction(item.id);
    }
  }
}