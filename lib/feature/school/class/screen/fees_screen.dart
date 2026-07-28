import 'package:flutter/material.dart';
import '../../../../core/utils/app_color.dart';

class FeesScreen extends StatefulWidget {
  const FeesScreen({super.key});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  final List<Map<String, dynamic>> feeDetails = [
    {
      'title': 'Tuition Fee',
      'emoji': '📚',
      'amount': '₹15,000',
      'status': 'Paid',
      'date': 'June 2026',
      'color': AppColors.primary,
      'paymentMethod': 'UPI',
      'transactionId': 'TXN123456',
    },
    {
      'title': 'Transport Fee',
      'emoji': '🚌',
      'amount': '₹2,500',
      'status': 'Pending',
      'date': 'July 2026',
      'color': AppColors.ngo,
      'paymentMethod': '-',
      'transactionId': '-',
    },
    {
      'title': 'Library Fee',
      'emoji': '📖',
      'amount': '₹1,000',
      'status': 'Paid',
      'date': 'June 2026',
      'color': AppColors.itServices,
      'paymentMethod': 'Card',
      'transactionId': 'TXN789012',
    },
    {
      'title': 'Exam Fee',
      'emoji': '📝',
      'amount': '₹2,000',
      'status': 'Pending',
      'date': 'August 2026',
      'color': AppColors.ott,
      'paymentMethod': '-',
      'transactionId': '-',
    },
    {
      'title': 'Sports Fee',
      'emoji': '⚽',
      'amount': '₹1,500',
      'status': 'Paid',
      'date': 'May 2026',
      'color': Colors.orange,
      'paymentMethod': 'Cash',
      'transactionId': 'TXN345678',
    },
    {
      'title': 'Lab Fee',
      'emoji': '🔬',
      'amount': '₹800',
      'status': 'Pending',
      'date': 'September 2026',
      'color': Colors.purple,
      'paymentMethod': '-',
      'transactionId': '-',
    },
  ];

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Paid', 'Pending'];

  @override
  Widget build(BuildContext context) {
    final filteredList = _getFilteredList();
    final totalPaid = _getTotalPaid();
    final totalPending = _getTotalPending();
    final totalAmount = totalPaid + totalPending;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Card
          _buildTotalCard(totalAmount, totalPaid, totalPending),
          const SizedBox(height: 16),

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
    );
  }

  // ==================== TOTAL CARD ====================
  Widget _buildTotalCard(double total, double paid, double pending) {
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Fee",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "₹20,500",
                    style: TextStyle(
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
      children: [
        Text(
          amount,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
      ],
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
    final bool isPaid = fee['status'] == 'Paid';
    final Color statusColor = isPaid ? AppColors.ngo : AppColors.school;
    final Color bgColor = (fee['color'] as Color);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPaid ? AppColors.ngo.withOpacity(0.2) : AppColors.school.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
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
                Text(
                  fee['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textMain,
                  ),
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
                      "Due: ${fee['date']}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (isPaid) ...[
                      const SizedBox(width: 12),
                      Icon(
                        Icons.payment_rounded,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        fee['paymentMethod'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Amount & Status
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
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
                      fee['status'],
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
    if (_selectedFilter == 'All') {
      return feeDetails;
    }
    return feeDetails
        .where((fee) => fee['status'] == _selectedFilter)
        .toList();
  }

  double _getTotalPaid() {
    return feeDetails
        .where((fee) => fee['status'] == 'Paid')
        .fold(0.0, (sum, fee) {
      String amount = fee['amount'].toString().replaceAll('₹', '').replaceAll(',', '');
      return sum + double.parse(amount);
    });
  }

  double _getTotalPending() {
    return feeDetails
        .where((fee) => fee['status'] == 'Pending')
        .fold(0.0, (sum, fee) {
      String amount = fee['amount'].toString().replaceAll('₹', '').replaceAll(',', '');
      return sum + double.parse(amount);
    });
  }
}