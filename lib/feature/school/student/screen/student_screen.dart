// lib/feature/school/student_list/screen/student_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:untitled/feature/school/student/screen/student_detail_screen.dart';
import '../controller/student_list_controller.dart';
import '../model/student_list_model.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen>
    with SingleTickerProviderStateMixin {
  final StudentListController controller = Get.put(StudentListController());
  String _selectedClass = 'All';
  String _selectedFeeStatus = 'All';
  late TabController _tabController;

  // Search controller
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    controller.loadStudentList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerLoading();
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorState();
        }

        if (controller.studentList.isEmpty) {
          return _buildEmptyState();
        }

        // Get all classes with proper ordering
        final allClasses = _getOrderedClasses();
        final feeStatuses = ['All', 'Paid', 'Pending'];

        // Filter students based on selected filters and search
        final filteredStudents = controller.studentList.where((student) {
          // Class filter
          final classMatch = _selectedClass == 'All' ||
              student.studentClass == _selectedClass;

          // Fee status filter
          final feeMatch = _selectedFeeStatus == 'All' ||
              student.feeStatus.toLowerCase() == _selectedFeeStatus.toLowerCase();

          // Search filter
          final searchMatch = _searchQuery.isEmpty ||
              student.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              student.studentIdCard.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              student.studentClass.toLowerCase().contains(_searchQuery.toLowerCase());

          return classMatch && feeMatch && searchMatch;
        }).toList();

        return Column(
          children: [
            // Search Bar
            _buildSearchBar(),
            // Filter Section
            _buildFilterSection(allClasses, feeStatuses),
            // Stats Row
            _buildStatsRow(filteredStudents),
            // Tab Bar for Grid/List View
            _buildViewToggle(),
            // Student List
            Expanded(
              child: filteredStudents.isEmpty
                  ? _buildEmptyStateWithFilters()
                  : _buildStudentListView(filteredStudents),
            ),
          ],
        );
      }),
    );
  }

  // ==================== GET ORDERED CLASSES ====================
  List<String> _getOrderedClasses() {
    final classes = controller.getUniqueClasses();

    // Define class order
    final classOrder = [
      'All',
      'Nursery',
      'LKG',
      'UKG',
      '1st',
      '2nd',
      '3rd',
      '4th',
      '5th',
      '6th',
      '7th',
      '8th',
      '9th',
      '10th',
      '11th',
      '12th'
    ];

    // Sort classes based on predefined order
    final sortedClasses = <String>[];
    for (var order in classOrder) {
      if (order == 'All') {
        sortedClasses.add(order);
      } else if (classes.contains(order)) {
        sortedClasses.add(order);
      }
    }

    // Add any remaining classes not in the predefined list
    for (var cls in classes) {
      if (!sortedClasses.contains(cls) && cls != 'All') {
        sortedClasses.add(cls);
      }
    }

    return sortedClasses;
  }

  // ==================== APP BAR ====================
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
      title: Obx(() => Text(
        'Students (${controller.totalStudents})',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      )),
      centerTitle: true,
      actions: [
        Obx(() => Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.refreshStudents(),
              icon: Icon(
                controller.isLoading.value
                    ? Icons.hourglass_empty
                    : Icons.refresh,
                color: Colors.white,
              ),
            ),
            if (controller.isLoading.value)
              const Positioned(
                right: 8,
                top: 8,
                child: SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
          ],
        )),
        IconButton(
          onPressed: () {
            _showFilterDialog();
          },
          icon: const Icon(Icons.filter_list, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(12),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search by name, ID, or class...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey),
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _searchController.clear();
              });
            },
          )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  // ==================== FILTER SECTION ====================
  Widget _buildFilterSection(List<String> classes, List<String> feeStatuses) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Class Selector with Scroll
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.class_, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Class',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: classes.map((className) {
                      final isSelected = _selectedClass == className;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: _buildClassChip(className, isSelected),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Fee Status Filter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.payments, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Fee Status',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: feeStatuses.map((status) {
                      final isSelected = _selectedFeeStatus == status;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: _buildFeeChip(status, isSelected),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== CLASS CHIP ====================
  Widget _buildClassChip(String className, bool isSelected) {
    Color chipColor = isSelected ? Colors.blue : Colors.grey.shade100;
    Color textColor = isSelected ? Colors.white : Colors.grey[700]!;

    // Color coding for different classes
    if (!isSelected) {
      if (className.contains('Nursery') || className.contains('LKG') || className.contains('UKG')) {
        chipColor = Colors.purple.shade50;
        textColor = Colors.purple.shade700;
      } else if (className.contains('1st') || className.contains('2nd') || className.contains('3rd') ||
          className.contains('4th') || className.contains('5th')) {
        chipColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
      } else if (className.contains('6th') || className.contains('7th') || className.contains('8th')) {
        chipColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
      } else if (className.contains('9th') || className.contains('10th')) {
        chipColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
      } else if (className.contains('11th') || className.contains('12th')) {
        chipColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
      }
    }

    return FilterChip(
      selected: isSelected,
      label: Text(
        className,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 12,
          color: textColor,
        ),
      ),
      backgroundColor: chipColor,
      selectedColor: Colors.blue,
      onSelected: (selected) {
        setState(() {
          _selectedClass = className;
        });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.transparent,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  // ==================== FEE CHIP ====================
  Widget _buildFeeChip(String status, bool isSelected) {
    Color color;
    IconData icon;

    switch (status) {
      case 'Paid':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'Pending':
        color = Colors.orange;
        icon = Icons.warning_amber;
        break;
      default:
        color = Colors.blue;
        icon = Icons.filter_list;
    }

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status != 'All')
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : color,
            ),
          if (status != 'All') const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 12,
              color: isSelected ? Colors.white : color,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade50,
      selectedColor: color,
      onSelected: (selected) {
        setState(() {
          _selectedFeeStatus = status;
        });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? color : Colors.grey[300]!,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  // ==================== VIEW TOGGLE ====================
  Widget _buildViewToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        tabs: const [
          Tab(text: '📋 List View'),
          Tab(text: '📊 Grid View'),
        ],
      ),
    );
  }

  // ==================== STUDENT LIST VIEW ====================
  Widget _buildStudentListView(List<StudentListData> students) {
    return TabBarView(
      controller: _tabController,
      children: [
        // List View
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: students.length,
          itemBuilder: (context, index) {
            return _buildStudentCard(students[index]);
          },
        ),
        // Grid View
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: students.length,
          itemBuilder: (context, index) {
            return _buildStudentGridCard(students[index]);
          },
        ),
      ],
    );
  }

  // ==================== STUDENT CARD (List View) ====================
  Widget _buildStudentCard(StudentListData student) {
    final color = student.genderColor;
    final isPaid = student.feeStatus.toLowerCase() == 'paid';

    return GestureDetector(
      onTap: () {
        Get.to(() => StudentDetailScreen(student: student));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPaid ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade50,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar with Profile Image
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 2,
                ),
                image: student.studentProfile != null &&
                    student.studentProfile!.isNotEmpty
                    ? DecorationImage(
                  image: NetworkImage(student.studentProfile!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: student.studentProfile == null ||
                  student.studentProfile!.isEmpty
                  ? Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    student.displayName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              )
                  : null,
            ),
            const SizedBox(width: 12),

            // Name & Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.class_,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Class ${student.studentClass}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.badge_outlined,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        student.studentIdCard,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        student.gender,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.attach_money,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '₹${student.feeAmount}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Fee Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isPaid
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isPaid
                      ? Colors.green.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPaid ? Icons.check_circle : Icons.warning_amber,
                    size: 14,
                    color: isPaid ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    student.feeStatus,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: isPaid ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== STUDENT GRID CARD ====================
  Widget _buildStudentGridCard(StudentListData student) {
    final color = student.genderColor;
    final isPaid = student.feeStatus.toLowerCase() == 'paid';

    return GestureDetector(
      onTap: () {
        Get.to(() => StudentDetailScreen(student: student));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPaid ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 2,
                ),
                image: student.studentProfile != null &&
                    student.studentProfile!.isNotEmpty
                    ? DecorationImage(
                  image: NetworkImage(student.studentProfile!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: student.studentProfile == null ||
                  student.studentProfile!.isEmpty
                  ? Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    student.displayName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              )
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              student.fullName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              'Class ${student.studentClass}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isPaid
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPaid ? Icons.check_circle : Icons.warning_amber,
                    size: 12,
                    color: isPaid ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    student.feeStatus,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isPaid ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== STATS ROW ====================
  Widget _buildStatsRow(List<StudentListData> filteredStudents) {
    final total = filteredStudents.length;
    final paid = filteredStudents
        .where((s) => s.feeStatus.toLowerCase() == 'paid')
        .length;
    final pending = total - paid;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('👨‍🎓', '$total', 'Total'),
          Container(width: 1, height: 30, color: Colors.grey[200]),
          _buildStatItem('✅', '$paid', 'Paid'),
          Container(width: 1, height: 30, color: Colors.grey[200]),
          _buildStatItem('⏳', '$pending', 'Pending'),
          Container(width: 1, height: 30, color: Colors.grey[200]),
          _buildStatItem(
            '📊',
            '${total > 0 ? ((paid / total) * 100).toStringAsFixed(0) : 0}%',
            'Rate',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  // ==================== FILTER DIALOG ====================
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter Options',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Class Filter
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Class',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _getOrderedClasses().map((className) {
                  final isSelected = _selectedClass == className;
                  return ChoiceChip(
                    label: Text(className),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedClass = className;
                      });
                      Get.back();
                    },
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Fee Status Filter
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Fee Status',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['All', 'Paid', 'Pending'].map((status) {
                  final isSelected = _selectedFeeStatus == status;
                  Color color = status == 'Paid'
                      ? Colors.green
                      : status == 'Pending'
                      ? Colors.orange
                      : Colors.blue;
                  return ChoiceChip(
                    label: Text(status),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFeeStatus = status;
                      });
                      Get.back();
                    },
                    selectedColor: color,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Clear Filters
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedClass = 'All';
                    _selectedFeeStatus = 'All';
                    _searchQuery = '';
                    _searchController.clear();
                  });
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Clear All Filters',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // ==================== SHIMMER LOADING ====================
  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(4, (index) {
                return Column(
                  children: [
                    Container(
                      width: 30,
                      height: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 2),
                    Container(
                      width: 20,
                      height: 12,
                      color: Colors.white,
                    ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 100,
                              height: 10,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 80,
                              height: 10,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
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
    );
  }

  // ==================== ERROR STATE ====================
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            controller.errorMessage.value,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.refreshStudents(),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 12),
          Text(
            'No students found',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try changing filters or refresh',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== EMPTY STATE WITH FILTERS ====================
  Widget _buildEmptyStateWithFilters() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.filter_alt_off,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 12),
          Text(
            'No matching students',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try adjusting your filters or search',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedClass = 'All';
                _selectedFeeStatus = 'All';
                _searchQuery = '';
                _searchController.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Clear Filters',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}