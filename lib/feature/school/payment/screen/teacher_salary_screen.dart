import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../profile/controller/teacher_controller.dart';
import '../controller/teacher_salary_controller.dart';
import '../model/teacher_salary_model.dart';

class TeacherSalaryScreen extends StatefulWidget {
  const TeacherSalaryScreen({super.key});

  @override
  State<TeacherSalaryScreen> createState() => _TeacherSalaryScreenState();
}

class _TeacherSalaryScreenState extends State<TeacherSalaryScreen> {
  late final TeacherSalaryController controller;
  final teacherController = Get.find<TeacherController>();

  @override
  void initState() {
    super.initState();
    controller = Get.put(TeacherSalaryController());
    controller.fetchSalary(teacherController.teacherIdCard);
  }

  // ==================== FORMAT CURRENCY ====================
  String _formatCurrency(num value) {
    final str = value.toStringAsFixed(0);
    if (str.length <= 3) return "₹ $str";
    final last3 = str.substring(str.length - 3);
    var rest = str.substring(0, str.length - 3);
    final buf = StringBuffer();
    while (rest.length > 2) {
      buf.write(",${rest.substring(rest.length - 2)}");
      rest = rest.substring(0, rest.length - 2);
    }
    buf.write(rest);
    return "₹ $buf,$last3";
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          "Salary",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.summary.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () =>
              controller.refreshData(teacherController.teacherIdCard),
          child: _buildMonthlyTab(),
        );
      }),
    );
  }

  // ==================== MONTHLY TAB ====================
  Widget _buildMonthlyTab() {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // ==================== TOP SECTION ====================
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(),
                const SizedBox(height: 14),

                // YEAR + MONTH DROPDOWNS
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => _dropdown(
                        value: controller.selectedYear.value.isEmpty
                            ? null
                            : controller.selectedYear.value,
                        items: controller.availableYears,
                        onChanged: controller.onYearChanged,
                      )),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Obx(() => _dropdown(
                        value: controller.selectedMonth.value,
                        items: const [
                          "All",
                          "January",
                          "February",
                          "March",
                          "April",
                          "May",
                          "June",
                          "July",
                          "August",
                          "September",
                          "October",
                          "November",
                          "December",
                        ],
                        onChanged: controller.onMonthChanged,
                      )),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // STATUS FILTER
                Obx(() => Wrap(
                  spacing: 8,
                  children: ["All", "Paid", "Pending"].map((f) {
                    final selected = controller.statusFilter.value == f;
                    return ChoiceChip(
                      label: Text(f),
                      selected: selected,
                      onSelected: (_) => controller.onStatusChanged(f),
                      selectedColor: Colors.indigo,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.grey.shade300),
                      showCheckmark: false,
                    );
                  }).toList(),
                )),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Month-wise Salary",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Obx(() => Text(
                      "${controller.visibleMonths.length}/${controller.filteredMonths.length}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ==================== SALARY LIST ====================
        Obx(() {
          final list = controller.visibleMonths;

          if (list.isEmpty) {
            return SliverToBoxAdapter(
              child: _emptyState("No salary records found"),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    14,
                    index == 0 ? 8 : 0,
                    14,
                    index == list.length - 1 ? 0 : 8,
                  ),
                  child: _buildMonthTile(list[index]),
                );
              },
              childCount: list.length,
            ),
          );
        }),

        // ==================== LOAD MORE ====================
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 40),
            child: Obx(() {
              if (controller.hasMore) {
                return SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: controller.isLoadingMore.value
                        ? null
                        : controller.loadMore,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: controller.isLoadingMore.value
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.indigo,
                      ),
                    )
                        : const Text(
                      "Load More",
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              } else if (controller.visibleMonths.isEmpty) {
                return const SizedBox.shrink();
              } else {
                return Center(
                  child: Text(
                    "All ${controller.selectedYear.value} records loaded",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                );
              }
            }),
          ),
        ),
      ],
    );
  }

  // ==================== DROPDOWN ====================
  Widget _dropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          isDense: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.black54,
            size: 20,
          ),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
          items: items
              .map((v) => DropdownMenuItem(value: v, child: Text(v)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ==================== SUMMARY CARD ====================
// ==================== SUMMARY CARD ====================
  Widget _buildSummaryCard() {
    return Obx(() {
      final summary = controller.summary.value;
      final totalSalary = summary?.totalSalary ?? 0;
      final paidAmount = summary?.paidAmount ?? 0;
      final pendingAmount = summary?.pendingAmount ?? 0;
      final latest = summary?.latestSalary;

      // Monthly salary from teacher profile
      final monthlySalary =
          double.tryParse(teacherController.salary) ?? 0;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============ MONTHLY SALARY (from teacher profile) ============
            const Text(
              "Monthly Salary",
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
            const SizedBox(height: 4),
            Text(
              _formatCurrency(monthlySalary),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 12),

            // ============ TOTALS ROW ============
            Row(
              children: [
                Expanded(
                  child: _summaryMini(
                    label: "Total Paid",
                    value: _formatCurrency(paidAmount),
                  ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white24,
                ),
                Expanded(
                  child: _summaryMini(
                    label: "Total Pending",
                    value: _formatCurrency(pendingAmount),
                    valueColor: Colors.orange.shade200,
                  ),
                ),
              ],
            ),

            // ============ LATEST RECORD ============
            if (latest != null) ...[
              const SizedBox(height: 12),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Latest: ${latest.month} ${latest.year}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatCurrency(latest.amount),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: latest.isPaid
                          ? Colors.green.withOpacity(0.3)
                          : Colors.orange.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      latest.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

// ==================== MINI STAT ====================
  Widget _summaryMini({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ==================== EMPTY STATE ====================
  Widget _emptyState(String msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          Icon(Icons.inbox_rounded,
              size: 40, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            msg,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // ==================== MONTH TILE ====================
// ==================== MONTH TILE ====================
  Widget _buildMonthTile(SalaryMonth month) {
    final totalPaid = month.records.every((r) => r.isPaid);
    final statusColor = totalPaid ? Colors.green : Colors.orange;
    final statusText = totalPaid ? "Paid" : "Pending";

    // Collect unique payment methods for this month
    final methods = month.records
        .map((r) => r.paymentMethod)
        .where((m) => m.isNotEmpty)
        .toSet()
        .join(', ');

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _showSalaryDetailSheet(month),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${month.month} ${controller.selectedYear.value}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Payment method chips row
                  Row(
                    children: [
                      Icon(
                        _iconForMethod(month.records.first.paymentMethod),
                        size: 12,
                        color: Colors.indigo,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          methods.isNotEmpty ? methods : 'N/A',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.indigo,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${month.records.length} record(s)",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatCurrency(month.totalSalary),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 10,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// ==================== ICON FOR PAYMENT METHOD ====================
  IconData _iconForMethod(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return Icons.payments_outlined;
      case 'bank':
      case 'bank transfer':
        return Icons.account_balance_outlined;
      case 'upi':
        return Icons.qr_code_rounded;
      case 'cheque':
        return Icons.receipt_long_outlined;
      default:
        return Icons.payment_outlined;
    }
  }

  // ==================== SALARY DETAIL SHEET ====================
  void _showSalaryDetailSheet(SalaryMonth month) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "${month.month} ${controller.selectedYear.value}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "${month.records.length} payment(s)",
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),

                // TOTALS
                _simpleRow("Total Salary",
                    _formatCurrency(month.totalSalary)),
                _simpleRow("Paid",
                    _formatCurrency(month.paidAmount),
                    valueColor: Colors.green),
                _simpleRow("Pending",
                    _formatCurrency(month.pendingAmount),
                    valueColor: Colors.orange,
                    bold: true),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),

                const Text(
                  "Payment Records",
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                ...month.records.map((r) => _buildRecordRow(r)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecordRow(SalaryRecord r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============ METHOD + STATUS ROW ============
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _iconForMethod(r.paymentMethod),
                  size: 14,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  r.paymentMethod.isNotEmpty
                      ? r.paymentMethod
                      : 'N/A',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: r.isPaid
                      ? Colors.green.withOpacity(0.12)
                      : Colors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  r.status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: r.isPaid ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ============ AMOUNT DETAILS ============
          _simpleRow("Amount", _formatCurrency(r.amount)),
          _simpleRow("Paid", _formatCurrency(r.paidAmount),
              valueColor: Colors.green),
          if (r.pendingAmount > 0)
            _simpleRow("Pending", _formatCurrency(r.pendingAmount),
                valueColor: Colors.orange),
          if (r.paidDate != null && r.paidDate!.isNotEmpty)
            _simpleRow("Paid on", r.paidDate!),
          if (r.remark != null && r.remark!.isNotEmpty)
            _simpleRow("Remark", r.remark!),
        ],
      ),
    );
  }

  // ==================== SIMPLE ROW ====================
  Widget _simpleRow(
      String label,
      String value, {
        Color? valueColor,
        bool bold = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}