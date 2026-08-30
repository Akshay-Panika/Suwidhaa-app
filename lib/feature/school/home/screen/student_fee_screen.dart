import 'package:flutter/material.dart';
import '../../../../core/utils/app_color.dart';

class StudentFeeScreen extends StatefulWidget {
  const StudentFeeScreen({super.key});

  @override
  State<StudentFeeScreen> createState() => _StudentFeeScreenState();
}

class _StudentFeeScreenState extends State<StudentFeeScreen> {
  String _selectedYear = '2026-2027';
  String _selectedFilter = 'All';
  final List<String> _years = ['2026-2027', '2025-2026', '2024-2025'];
  final List<String> _filters = ['All', 'Paid', 'Pending', 'Overdue'];

  final List<Map<String, dynamic>> feeDetails = [
    // ==================== 2026-2027 CURRENT YEAR FEES ====================
    {
      'title': 'Tuition Fee',
      'emoji': '📚',
      'amount': '₹15,000',
      'status': 'Pending',
      'color': Colors.orange,
      'category': 'Current Year',
      'installments': [
        {'month': 'April', 'amount': '₹3,750', 'status': 'Paid'},
        {'month': 'May', 'amount': '₹3,750', 'status': 'Paid'},
        {'month': 'June', 'amount': '₹3,750', 'status': 'Pending'},
        {'month': 'July', 'amount': '₹3,750', 'status': 'Pending'},
      ],
      'dueDate': '10 July 2026',
      'year': '2026-2027',
    },
    {
      'title': 'Admission Fee',
      'emoji': '🎓',
      'amount': '₹5,000',
      'status': 'Paid',
      'color': Colors.green,
      'category': 'Current Year',
      'installments': [
        {'month': 'April', 'amount': '₹5,000', 'status': 'Paid'},
      ],
      'dueDate': '15 April 2026',
      'year': '2026-2027',
    },
    {
      'title': 'Annual Charges',
      'emoji': '📅',
      'amount': '₹3,000',
      'status': 'Overdue',
      'color': Colors.red,
      'category': 'Current Year',
      'installments': [
        {'month': 'April', 'amount': '₹3,000', 'status': 'Overdue'},
      ],
      'dueDate': '30 April 2026',
      'year': '2026-2027',
    },
    {
      'title': 'Development Fund',
      'emoji': '🏗️',
      'amount': '₹2,000',
      'status': 'Pending',
      'color': Colors.orange,
      'category': 'Current Year',
      'installments': [
        {'month': 'June', 'amount': '₹2,000', 'status': 'Pending'},
      ],
      'dueDate': '20 June 2026',
      'year': '2026-2027',
    },

    // ==================== 2025-2026 PREVIOUS YEAR FEES ====================
    {
      'title': 'Tuition Fee',
      'emoji': '📚',
      'amount': '₹14,000',
      'status': 'Paid',
      'color': Colors.green,
      'category': 'Previous Year',
      'installments': [
        {'month': 'April', 'amount': '₹3,500', 'status': 'Paid'},
        {'month': 'May', 'amount': '₹3,500', 'status': 'Paid'},
        {'month': 'June', 'amount': '₹3,500', 'status': 'Paid'},
        {'month': 'July', 'amount': '₹3,500', 'status': 'Paid'},
      ],
      'dueDate': '10 July 2025',
      'year': '2025-2026',
    },
    {
      'title': 'Library Fee',
      'emoji': '📖',
      'amount': '₹1,000',
      'status': 'Paid',
      'color': Colors.green,
      'category': 'Previous Year',
      'installments': [
        {'month': 'May', 'amount': '₹1,000', 'status': 'Paid'},
      ],
      'dueDate': '15 May 2025',
      'year': '2025-2026',
    },
    {
      'title': 'Science Lab Fee',
      'emoji': '🔬',
      'amount': '₹800',
      'status': 'Paid',
      'color': Colors.green,
      'category': 'Previous Year',
      'installments': [
        {'month': 'June', 'amount': '₹800', 'status': 'Paid'},
      ],
      'dueDate': '20 June 2025',
      'year': '2025-2026',
    },
    {
      'title': 'Exam Fee',
      'emoji': '📝',
      'amount': '₹2,000',
      'status': 'Paid',
      'color': Colors.green,
      'category': 'Previous Year',
      'installments': [
        {'month': 'March', 'amount': '₹2,000', 'status': 'Paid'},
      ],
      'dueDate': '25 March 2025',
      'year': '2025-2026',
    },

    // ==================== 2024-2025 OLD YEAR FEES ====================
    {
      'title': 'Tuition Fee',
      'emoji': '📚',
      'amount': '₹12,000',
      'status': 'Paid',
      'color': Colors.green,
      'category': 'Previous Year',
      'installments': [
        {'month': 'April', 'amount': '₹3,000', 'status': 'Paid'},
        {'month': 'May', 'amount': '₹3,000', 'status': 'Paid'},
        {'month': 'June', 'amount': '₹3,000', 'status': 'Paid'},
        {'month': 'July', 'amount': '₹3,000', 'status': 'Paid'},
      ],
      'dueDate': '10 July 2024',
      'year': '2024-2025',
    },
    {
      'title': 'Transport Fee',
      'emoji': '🚌',
      'amount': '₹2,500',
      'status': 'Paid',
      'color': Colors.green,
      'category': 'Previous Year',
      'installments': [
        {'month': 'May', 'amount': '₹2,500', 'status': 'Paid'},
      ],
      'dueDate': '15 May 2024',
      'year': '2024-2025',
    },
    {
      'title': 'Sports Fee',
      'emoji': '⚽',
      'amount': '₹1,500',
      'status': 'Paid',
      'color': Colors.green,
      'category': 'Previous Year',
      'installments': [
        {'month': 'June', 'amount': '₹1,500', 'status': 'Paid'},
      ],
      'dueDate': '20 June 2024',
      'year': '2024-2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredList = _getFilteredList();
    final totalPaid = _getTotalPaid();
    final totalPending = _getTotalPending();
    final totalOverdue = _getTotalOverdue();
    final totalAmount = totalPaid + totalPending + totalOverdue;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.school,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          'Fee Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.receipt_long_rounded, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Card
            _buildTotalCard(totalAmount, totalPaid, totalPending, totalOverdue),
            const SizedBox(height: 16),

            // Year Selector
            _buildYearSelector(),
            const SizedBox(height: 12),

            // Filter Chips
            _buildFilterChips(),
            const SizedBox(height: 12),

            // Section Header
            _buildSectionHeader("📋 Fee Breakdown"),
            const SizedBox(height: 8),

            // Fee List
            ...filteredList.map((fee) => _buildFeeCard(fee)).toList(),

            // No Results
            if (filteredList.isEmpty) _buildEmptyState(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ==================== TOTAL CARD ====================
  Widget _buildTotalCard(double total, double paid, double pending, double overdue) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.school, Color(0xFFD97706)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.school.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Fee",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹${(total).toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.payment_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTotalStat("✅ Paid", "₹${paid.toStringAsFixed(0)}", Colors.green),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildTotalStat("⏳ Pending", "₹${pending.toStringAsFixed(0)}", Colors.orange),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildTotalStat("🔴 Overdue", "₹${overdue.toStringAsFixed(0)}", Colors.red),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildTotalStat("📊 Progress", "${((paid / total) * 100).toStringAsFixed(0)}%", Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalStat(String label, String amount, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          amount,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  // ==================== YEAR SELECTOR ====================
  Widget _buildYearSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _years.map((year) {
          final isSelected = _selectedYear == year;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              selected: isSelected,
              label: Text(
                year,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 13,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
              backgroundColor: Colors.grey[100],
              selectedColor: AppColors.school,
              onSelected: (selected) {
                setState(() {
                  _selectedYear = year;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppColors.school : Colors.transparent,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==================== FILTER CHIPS ====================
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(
                filter,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 13,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
              backgroundColor: Colors.grey[100],
              selectedColor: AppColors.school,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppColors.school : Colors.transparent,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==================== SECTION HEADER ====================
  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textMain,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'View All',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== FEE CARD ====================
  Widget _buildFeeCard(Map<String, dynamic> fee) {
    final String status = fee['status'];
    final Color statusColor = status == 'Paid'
        ? Colors.green
        : status == 'Pending'
        ? Colors.orange
        : Colors.red;
    final Color bgColor = (fee['color'] as Color);
    final bool isCurrentYear = fee['category'] == 'Current Year';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentYear
              ? Colors.blue.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          width: isCurrentYear ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isCurrentYear
                ? Colors.blue.withOpacity(0.05)
                : Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon/Emoji
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  fee['emoji'],
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(width: 12),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          fee['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.textMain,
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (isCurrentYear)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Current',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Due: ${fee['dueDate']}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    fee['amount'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fee['year'],
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Installments
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Installments',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: (fee['installments'] as List<Map<String, dynamic>>).map((installment) {
                    final status = installment['status'];
                    final color = status == 'Paid'
                        ? Colors.green
                        : status == 'Pending'
                        ? Colors.orange
                        : Colors.red;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: color.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${installment['month']}: ${installment['amount']}',
                            style: TextStyle(
                              fontSize: 10,
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== EMPTY STATE ====================
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.credit_card_off_rounded,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 12),
          Text(
            'No fees found',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try changing the filter',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== HELPER METHODS ====================
  List<Map<String, dynamic>> _getFilteredList() {
    List<Map<String, dynamic>> filtered = feeDetails;

    // Filter by year
    filtered = filtered.where((fee) => fee['year'] == _selectedYear).toList();

    // Filter by status
    if (_selectedFilter != 'All') {
      filtered = filtered.where((fee) => fee['status'] == _selectedFilter).toList();
    }

    return filtered;
  }

  double _getTotalPaid() {
    return feeDetails
        .where((fee) => fee['status'] == 'Paid' && fee['year'] == _selectedYear)
        .fold(0.0, (sum, fee) {
      String amount = fee['amount'].toString().replaceAll('₹', '').replaceAll(',', '');
      return sum + double.parse(amount);
    });
  }

  double _getTotalPending() {
    return feeDetails
        .where((fee) => fee['status'] == 'Pending' && fee['year'] == _selectedYear)
        .fold(0.0, (sum, fee) {
      String amount = fee['amount'].toString().replaceAll('₹', '').replaceAll(',', '');
      return sum + double.parse(amount);
    });
  }

  double _getTotalOverdue() {
    return feeDetails
        .where((fee) => fee['status'] == 'Overdue' && fee['year'] == _selectedYear)
        .fold(0.0, (sum, fee) {
      String amount = fee['amount'].toString().replaceAll('₹', '').replaceAll(',', '');
      return sum + double.parse(amount);
    });
  }
}