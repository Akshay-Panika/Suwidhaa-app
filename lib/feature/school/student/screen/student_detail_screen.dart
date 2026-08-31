// lib/feature/school/student/screen/student_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/student_list_model.dart';

class StudentDetailScreen extends StatelessWidget {
  final StudentListData student;

  const StudentDetailScreen({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPaid = student.feeStatus.toLowerCase() == 'paid';
    final Color primaryColor = student.genderColor;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Student Profile Card - Hero Style
            _buildHeroProfileCard(student, primaryColor, isPaid),
            const SizedBox(height: 16),

            // Quick Stats Row
            _buildQuickStats(student),
            const SizedBox(height: 16),

            // Tab View for Information
            _buildTabView(student, isPaid),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ==================== APP BAR ====================
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
      title: const Text(
        'Student Report Card',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            // Share or download functionality
            Get.snackbar(
              'Download',
              'Report card downloading...',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          },
          icon: const Icon(Icons.download, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            // Edit functionality
            Get.snackbar(
              'Edit',
              'Edit student profile...',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.blue,
              colorText: Colors.white,
            );
          },
          icon: const Icon(Icons.edit, color: Colors.white),
        ),
      ],
    );
  }

  // ==================== HERO PROFILE CARD ====================
  Widget _buildHeroProfileCard(StudentListData student, Color primaryColor, bool isPaid) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.8),
            primaryColor.withOpacity(0.4),
            Colors.white,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.9),
            ],
          ),
        ),
        child: Column(
          children: [
            // Profile Image with Border
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: student.studentProfile != null && student.studentProfile!.isNotEmpty
                        ? DecorationImage(
                      image: NetworkImage(student.studentProfile!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: student.studentProfile == null || student.studentProfile!.isEmpty
                      ? Container(
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        student.displayName,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                      : null,
                ),
                // Online Status Badge
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Student Name
            Text(
              student.fullName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),

            // Student ID & Class
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInfoChip(
                  Icons.badge,
                  'ID: ${student.studentIdCard}',
                  Colors.white.withOpacity(0.3),
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  Icons.class_,
                  'Class ${student.studentClass}',
                  Colors.white.withOpacity(0.3),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Fee Status with Animation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isPaid ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: (isPaid ? Colors.green : Colors.orange).withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPaid ? Icons.check_circle : Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isPaid ? 'FEE PAID ✓' : 'FEE PENDING ⚠',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Quick Info Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickInfo(
                  Icons.calendar_today,
                  'DOB',
                  student.dob,
                  Colors.white.withOpacity(0.9),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildQuickInfo(
                  Icons.attach_money,
                  'Fee',
                  '₹${student.feeAmount}',
                  Colors.white.withOpacity(0.9),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildQuickInfo(
                  Icons.phone,
                  'Contact',
                  student.parentPhone,
                  Colors.white.withOpacity(0.9),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfo(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 10,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ==================== QUICK STATS ====================
  Widget _buildQuickStats(StudentListData student) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.school,
            'Roll No',
            student.rollNumber,
            Colors.blue,
          ),
          _buildVerticalDivider(),
          _buildStatItem(
            Icons.people,
            'Gender',
            student.gender,
            student.genderColor,
          ),
          _buildVerticalDivider(),
          _buildStatItem(
            Icons.category,
            'Caste',
            student.casteCategory.isEmpty ? 'N/A' : student.casteCategory,
            Colors.purple,
          ),
          _buildVerticalDivider(),
          _buildStatItem(
            Icons.percent,
            'Fee Paid',
            '${student.feeAmount.isNotEmpty && double.tryParse(student.feeAmount) != null ? ((double.tryParse(student.paidAmount)! / double.tryParse(student.feeAmount)!) * 100).toStringAsFixed(0) : 0}%',
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[500],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.grey[200],
    );
  }

  // ==================== TAB VIEW ====================
  Widget _buildTabView(StudentListData student, bool isPaid) {
    return DefaultTabController(
      length: 3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                tabs: const [
                  Tab(text: '📋 Personal'),
                  Tab(text: '👨‍👩‍👦 Family'),
                  Tab(text: '💰 Fee'),
                ],
              ),
            ),

            // Tab Bar Views
            SizedBox(
              height: 450,
              child: TabBarView(
                children: [
                  _buildPersonalTab(student),
                  _buildFamilyTab(student),
                  _buildFeeTab(student, isPaid),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== PERSONAL TAB ====================
  Widget _buildPersonalTab(StudentListData student) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionCard(
            icon: Icons.person,
            title: 'Personal Details',
            children: [
              _buildDetailRow('Full Name', student.fullName, Icons.person),
              _buildDetailRow('Date of Birth', student.dob, Icons.cake),
              _buildDetailRow('Gender', student.gender, Icons.male),
              _buildDetailRow('Roll Number', student.rollNumber, Icons.numbers),
              _buildDetailRow('Student ID', student.studentIdCard, Icons.badge),
            ],
          ),
          const SizedBox(height: 12),
          _buildSectionCard(
            icon: Icons.school,
            title: 'Academic Details',
            children: [
              _buildDetailRow('Class', student.studentClass, Icons.class_),
              _buildDetailRow('School Type', student.schoolType, Icons.school),
              _buildDetailRow('SSSMID', student.sssmid, Icons.fingerprint),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== FAMILY TAB ====================
  Widget _buildFamilyTab(StudentListData student) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionCard(
            icon: Icons.family_restroom,
            title: 'Parent Information',
            children: [
              _buildDetailRow('Father\'s Name', student.fatherName, Icons.person_outline),
              _buildDetailRow('Mother\'s Name', student.motherName, Icons.person_outline),
              _buildDetailRow('Parent Phone', student.parentPhone, Icons.phone),
              _buildDetailRow('Alternative Phone', student.alternativePhone, Icons.phone_android),
            ],
          ),
          const SizedBox(height: 12),
          _buildSectionCard(
            icon: Icons.location_on,
            title: 'Address Details',
            children: [
              _buildDetailRow('Address', student.address, Icons.home),
              _buildDetailRow('Adhar Number', student.adharNumber, Icons.credit_card),
              _buildDetailRow('Caste Category', student.casteCategory, Icons.category),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== FEE TAB ====================
  Widget _buildFeeTab(StudentListData student, bool isPaid) {
    final double totalFee = double.tryParse(student.feeAmount) ?? 0;
    final double paidFee = double.tryParse(student.paidAmount) ?? 0;
    final double remainingFee = totalFee - paidFee;
    final double progress = totalFee > 0 ? paidFee / totalFee : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Fee Summary Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isPaid
                    ? [Colors.green.shade400, Colors.green.shade700]
                    : [Colors.orange.shade400, Colors.orange.shade700],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Fee',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      '₹${student.feeAmount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Paid Amount',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      '₹${student.paidAmount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Remaining',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      '₹${remainingFee.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: remainingFee > 0 ? Colors.yellow.shade300 : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}% Paid',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      '${(remainingFee / totalFee * 100).toStringAsFixed(0)}% Remaining',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Payment History
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.history, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Payment History',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildPaymentItem(
                        'Fee Payment',
                        '₹${student.paidAmount}',
                        'Paid',
                        Colors.green,
                      ),
                      _buildDivider(),
                      _buildPaymentItem(
                        'Previous Balance',
                        '₹0',
                        'Cleared',
                        Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Fee Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isPaid ? Colors.green.shade50 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isPaid ? Colors.green.shade200 : Colors.orange.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isPaid ? Icons.check_circle : Icons.warning_amber,
                  color: isPaid ? Colors.green : Colors.orange,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPaid ? 'Fee Status: Paid' : 'Fee Status: Pending',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isPaid ? Colors.green : Colors.orange,
                        ),
                      ),
                      Text(
                        isPaid
                            ? 'All fees have been cleared successfully'
                            : 'Please clear the remaining fee of ₹${remainingFee.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: isPaid ? Colors.green.shade700 : Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== SECTION CARD ====================
  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.blue, size: 18),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  // ==================== DETAIL ROW ====================
  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[500]),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? 'N/A' : value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== PAYMENT ITEM ====================
  Widget _buildPaymentItem(String label, String amount, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[200],
    );
  }

  // ==================== FORMAT DATE ====================
  String _formatDate(String dateTime) {
    if (dateTime.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateTime);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateTime;
    }
  }
}