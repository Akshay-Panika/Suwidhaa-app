// lib/feature/school/student_leave/screen/student_leave_request_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/student_leave_controller.dart';
import '../model/student_leave_list_model.dart';

class StudentLeaveRequestScreen extends StatelessWidget {
  const StudentLeaveRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentLeaveController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            const SizedBox(height: 16),
            _buildCombinedFilterBar(controller),
            _buildStatusHeader(controller),
            const SizedBox(height: 16),
            Expanded(
              child: controller.filteredRequests.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                onRefresh: controller.fetchStudentLeaveList,
                child: ListView.builder(
                  padding:
                  const EdgeInsets.fromLTRB(12, 4, 12, 20),
                  itemCount: controller.filteredRequests.length,
                  itemBuilder: (_, i) => _buildRequestCard(
                    controller,
                    controller.filteredRequests[i],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ==================== APP BAR ====================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.indigo,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios_new,
            color: Colors.white, size: 20),
      ),
      title: const Text(
        'Leave Requests',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () =>
              Get.find<StudentLeaveController>().fetchStudentLeaveList(),
          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
        ),
      ],
    );
  }

  // ==================== COMBINED FILTER BAR ====================
  Widget _buildCombinedFilterBar(StudentLeaveController controller) {
    return Obx(() {
      final hasDate = controller.selectedDate.value != null;
      final selectedClass = controller.selectedClass.value;

      return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tune_rounded,
                    size: 16, color: Colors.indigo),
                const SizedBox(width: 6),
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                    letterSpacing: 0.3,
                  ),
                ),
                const Spacer(),
                if (controller.hasActiveFilters)
                  GestureDetector(
                    onTap: controller.clearFilters,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.close_rounded,
                              size: 12, color: Colors.red),
                          SizedBox(width: 3),
                          Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // CLASS SELECTOR
                GestureDetector(
                  onTap: () => _showClassFilterSheet(controller),
                  child: Container(
                    height: 42,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: selectedClass == 'All'
                          ? Colors.grey.shade50
                          : Colors.indigo.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selectedClass == 'All'
                            ? Colors.grey.shade200
                            : Colors.indigo.withOpacity(0.4),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.class_rounded,
                          size: 16,
                          color: selectedClass == 'All'
                              ? Colors.grey[500]
                              : Colors.indigo,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          selectedClass == 'All'
                              ? 'Class'
                              : 'Class $selectedClass',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: selectedClass == 'All'
                                ? FontWeight.w500
                                : FontWeight.w600,
                            color: selectedClass == 'All'
                                ? Colors.grey[600]
                                : Colors.indigo,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.arrow_drop_down_rounded,
                          size: 20,
                          color: selectedClass == 'All'
                              ? Colors.grey[500]
                              : Colors.indigo,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // DATE SELECTOR
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showCalendarPicker(controller),
                    child: Container(
                      height: 42,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: hasDate
                            ? Colors.indigo.withOpacity(0.08)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: hasDate
                              ? Colors.indigo.withOpacity(0.4)
                              : Colors.grey.shade200,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 16,
                            color: hasDate
                                ? Colors.indigo
                                : Colors.grey[500],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              hasDate
                                  ? DateFormat('dd MMM yyyy').format(
                                  controller.selectedDate.value!)
                                  : 'Date',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: hasDate
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: hasDate
                                    ? Colors.indigo
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 20,
                            color: hasDate
                                ? Colors.indigo
                                : Colors.grey[500],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // ==================== STATUS HEADER ====================
  Widget _buildStatusHeader(StudentLeaveController controller) {
    // ✅ Only 3 statuses + All
    final statuses = ['All', 'Pending', 'Approved', 'Rejected'];

    return Obx(() {
      final selectedStatus = controller.selectedStatus.value;

      return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.filter_alt_rounded,
                    size: 16, color: Colors.indigo),
                const SizedBox(width: 6),
                const Text(
                  'Filter by Status',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: statuses.map((status) {
                  final isSelected = selectedStatus == status;
                  final color = _statusColor(status);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => controller.setStatusFilter(status),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color
                              : color.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? color
                                : color.withOpacity(0.3),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _statusIcon(status),
                              size: 13,
                              color: isSelected ? Colors.white : color,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ==================== HELPERS ====================
  Color _statusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      case 'All':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Approved':
        return Icons.check_circle_rounded;
      case 'Rejected':
        return Icons.cancel_rounded;
      case 'All':
        return Icons.apps_rounded;
      default:
        return Icons.hourglass_top_rounded;
    }
  }

  // ==================== CALENDAR PICKER ====================
  Future<void> _showCalendarPicker(
      StudentLeaveController controller) async {
    final now = DateTime.now();
    DateTime tempPicked = controller.selectedDate.value ?? now;

    final picked = await showModalBottomSheet<DateTime>(
      context: Get.context!,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded,
                            color: Colors.indigo, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Select Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded,
                              size: 20),
                        ),
                      ],
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 320,
                      child: CalendarDatePicker(
                        initialDate: tempPicked,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        onDateChanged: (date) {
                          setModalState(() => tempPicked = date);
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              controller.setDateFilter(null);
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                              side:
                              BorderSide(color: Colors.grey[300]!),
                            ),
                            child: Text(
                              'Clear',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () =>
                                Navigator.pop(context, tempPicked),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Apply',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (picked != null) {
      controller.setDateFilter(picked);
    }
  }

  // ==================== CLASS FILTER SHEET ====================
  void _showClassFilterSheet(StudentLeaveController controller) {
    final classes = controller.getUniqueClasses();
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildFilterSheet(
        title: 'Select Class',
        options: classes,
        selected: controller.selectedClass.value,
        onSelect: (val) {
          controller.setClassFilter(val);
          Get.back();
        },
      ),
    );
  }

  Widget _buildFilterSheet({
    required String title,
    required List<String> options,
    required String selected,
    required Function(String) onSelect,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((opt) {
              final isSelected = selected == opt;
              return ChoiceChip(
                label: Text(opt),
                selected: isSelected,
                onSelected: (_) => onSelect(opt),
                selectedColor: Colors.indigo,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                backgroundColor: Colors.grey.shade100,
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ==================== FULL SCREEN IMAGE VIEWER ====================
  void _showFullImage(String imageUrl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(
                          color: Colors.white),
                    );
                  },
                  errorBuilder: (_, __, ___) => const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.broken_image_rounded,
                            color: Colors.white54, size: 48),
                        SizedBox(height: 8),
                        Text('Failed to load image',
                            style: TextStyle(color: Colors.white54)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 22),
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: true,
    );
  }

  // ==================== REQUEST CARD ====================
  Widget _buildRequestCard(
      StudentLeaveController controller,
      StudentLeaveData req,
      ) {
    final statusColor = _statusColor(req.displayStatus);
    final isPending = req.isPending;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: statusColor.withOpacity(0.25), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ────── Header: student + status ──────
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    req.studentName.isNotEmpty
                        ? req.studentName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        req.studentName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            'ID: ${req.studentIdCard}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.indigo.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Class ${req.studentClass}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border:
                    Border.all(color: statusColor.withOpacity(0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_statusIcon(req.displayStatus),
                          size: 11, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        req.displayStatus,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ────── Leave info ──────
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.event_note_rounded,
                          size: 14, color: Colors.indigo),
                      const SizedBox(width: 6),
                      const Text(
                        'Leave Request',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.calendar_today_rounded,
                          size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        '${req.formattedStartDate} → ${req.formattedEndDate}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.notes_rounded,
                          size: 13, color: Colors.grey[500]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          req.reasonMsg,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (req.teacherName != null &&
                      req.teacherName!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.person_rounded,
                            size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          'Handled by: ${req.teacherName}',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        'Applied on: ${req.formattedCreatedDate}',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  // ✅ Image (only if available)
                  if (req.hasImage) ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.image_rounded,
                              size: 13, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            'Attachment',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () => _showFullImage(req.image!),
                      borderRadius: BorderRadius.circular(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Image.network(
                              req.image!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  height: 200,
                                  color: Colors.grey.shade100,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (_, __, ___) => Container(
                                height: 200,
                                color: Colors.grey.shade100,
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                          Icons.broken_image_rounded,
                                          color: Colors.grey[400],
                                          size: 32),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Image not available',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                  Colors.black.withOpacity(0.6),
                                  borderRadius:
                                  BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.zoom_in_rounded,
                                        size: 12,
                                        color: Colors.white),
                                    SizedBox(width: 4),
                                    Text(
                                      'View',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ────── Action buttons (API call) ──────
            if (isPending) ...[
              const SizedBox(height: 10),
              Obx(() {
                if (controller.isUpdating.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: _actionButton(
                        label: 'Approve',
                        icon: Icons.check_rounded,
                        color: Colors.green,
                        onTap: () =>
                            _updateStatus(controller, req, 'Approved'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _actionButton(
                        label: 'Reject',
                        icon: Icons.close_rounded,
                        color: Colors.red,
                        onTap: () =>
                            _updateStatus(controller, req, 'Rejected'),
                      ),
                    ),
                  ],
                );
              }),
            ] else ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () =>
                      _updateStatus(controller, req, 'Pending'),
                  icon: const Icon(Icons.undo_rounded,
                      size: 14, color: Colors.indigo),
                  label: const Text(
                    'Undo',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.indigo,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ==================== PATCH API CALL ====================
  Future<void> _updateStatus(
      StudentLeaveController controller,
      StudentLeaveData req,
      String newStatus,
      ) async {
    HapticFeedback.mediumImpact();

    // Confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Mark as $newStatus?'),
        content: Text(
          'Are you sure you want to mark ${req.studentName}\'s leave request as $newStatus?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _statusColor(newStatus),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Get.back(result: true),
            child: Text(newStatus),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await controller.updateLeaveApproval(
      request: req,
      newStatus: newStatus,
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.4), width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_rounded, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'No leave requests found',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try changing the filters',
            style: TextStyle(fontSize: 12, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}