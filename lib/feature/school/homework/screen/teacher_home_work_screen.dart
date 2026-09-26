import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:untitled/feature/school/homework/screen/teacher_add_homework_screen.dart';
import 'package:untitled/feature/school/homework/screen/teacher_homework_details_screen.dart';
import 'dart:io';

import '../../../../core/utils/app_color.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../../profile/controller/teacher_controller.dart';
import '../controller/homework_controller.dart';
import '../model/homework_model.dart';

class TeacherHomeworkScreen extends StatelessWidget {
  const TeacherHomeworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeworkController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          'Homework',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          // ✅ Filter icon with badge
          Obx(() => Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () => _showFilterSheet(context, controller),
                icon: const Icon(Icons.tune_rounded, color: Colors.white),
              ),
              if (controller.activeFilterCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${controller.activeFilterCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          )),
          IconButton(
            onPressed: () => controller.refreshHomework(),
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Get.to(() => const TeacherAddHomeworkScreen()),
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => _buildHeader(controller)),
              const SizedBox(height: 16),

              // ── Status chips ──
              Obx(() => _buildFilterChips(controller)),
              const SizedBox(height: 12),

              // ── ✅ NEW: Year + Month quick filters ──
              Obx(() => _buildQuickFilters(controller)),

              const SizedBox(height: 12),

              // ── List ──
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (controller.errorMessage.isNotEmpty) {
                    return _buildErrorState(controller.errorMessage.value);
                  }

                  final filteredList = controller.getFilteredHomework();

                  if (filteredList.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    itemCount: filteredList.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return _buildHomeworkItem(
                        context,
                        filteredList[index],
                        controller,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Header
  // ─────────────────────────────────────────────
  Widget _buildHeader(HomeworkController controller) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.assignment_rounded,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Assignments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${controller.getFilteredHomework().length} of ${controller.homeworkList.length} shown',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${controller.getCompletedCount()}/${controller.homeworkList.length}',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Status chips (existing)
  // ─────────────────────────────────────────────
  Widget _buildFilterChips(HomeworkController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: controller.filters.map((filter) {
          final isSelected = controller.selectedFilter.value == filter;
          final color = controller.getStatusColor(filter);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => controller.setFilter(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? color : color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? color : color.withOpacity(0.3),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: isSelected ? Colors.white : color,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      filter,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ✅ NEW: Quick Year + Month Filter Row
  // ─────────────────────────────────────────────
  Widget _buildQuickFilters(HomeworkController controller) {
    return Row(
      children: [
        // ── Subject dropdown ──
        Expanded(
          child: _buildMiniDropdown(
            icon: Icons.menu_book_rounded,
            value: controller.selectedSubject.value,
            items: controller.subjectFilters.toList(),
            onChanged: controller.setSelectedSubject,
            color: Colors.indigo,
            hint: 'Subject',
          ),
        ),
        const SizedBox(width: 8),

        // ── Year dropdown ──
        Expanded(
          child: _buildMiniDropdown(
            icon: Icons.calendar_today_rounded,
            value: controller.selectedYear.value,
            items: controller.yearFilters.toList(),
            onChanged: controller.setSelectedYear,
            color: Colors.teal,
            hint: 'Year',
          ),
        ),
        const SizedBox(width: 8),

        // ── Month dropdown ──
        Expanded(
          child: _buildMiniDropdown(
            icon: Icons.event_rounded,
            value: controller.selectedMonth.value,
            items: controller.monthFilters.toList(),
            onChanged: controller.setSelectedMonth,
            color: Colors.orange,
            hint: 'Month',
          ),
        ),

        // ── Reset button ──
        if (controller.hasActiveFilter) ...[
          const SizedBox(width: 6),
          GestureDetector(
            onTap: controller.resetFilters,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.withOpacity(0.35)),
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 16,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Mini dropdown widget
  // ─────────────────────────────────────────────
  Widget _buildMiniDropdown({
    required IconData icon,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
    required Color color,
    required String hint,
  }) {
    final safeValue = items.contains(value) ? value : items.first;

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: safeValue,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: color,
                ),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                dropdownColor: Colors.white,
                items: items
                    .map((e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(
                    e,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) onChanged(v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ✅ NEW: Full Filter Bottom Sheet
  // ─────────────────────────────────────────────
  void _showFilterSheet(
      BuildContext context, HomeworkController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.tune_rounded,
                        color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Filter Homework',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (controller.hasActiveFilter)
                    TextButton(
                      onPressed: controller.resetFilters,
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),

              // Subject chips
              _sheetSectionTitle('Subject'),
              const SizedBox(height: 8),
              Obx(() => _sheetChipWrap(
                items: controller.subjectFilters.toList(),
                selected: controller.selectedSubject.value,
                onTap: controller.setSelectedSubject,
                color: Colors.indigo,
              )),
              const SizedBox(height: 20),

              // Year chips
              _sheetSectionTitle('Year'),
              const SizedBox(height: 8),
              Obx(() => _sheetChipWrap(
                items: controller.yearFilters.toList(),
                selected: controller.selectedYear.value,
                onTap: controller.setSelectedYear,
                color: Colors.teal,
              )),
              const SizedBox(height: 20),

              // Month chips
              _sheetSectionTitle('Month'),
              const SizedBox(height: 8),
              Obx(() => _sheetChipWrap(
                items: controller.monthFilters.toList(),
                selected: controller.selectedMonth.value,
                onTap: controller.setSelectedMonth,
                color: Colors.orange,
              )),
              const SizedBox(height: 24),

              // Apply button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Obx(() => Text(
                    controller.hasActiveFilter
                        ? 'Apply (${controller.getFilteredHomework().length} results)'
                        : 'Show All (${controller.homeworkList.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _sheetSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _sheetChipWrap({
    required List<String> items,
    required String selected,
    required Function(String) onTap,
    required Color color,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((e) {
        final active = e == selected;
        return GestureDetector(
          onTap: () => onTap(e),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: active ? color : color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: active ? color : color.withOpacity(0.3),
                width: 1.2,
              ),
            ),
            child: Text(
              e,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : color,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─────────────────────────────────────────────
  // Homework Item
  // ─────────────────────────────────────────────
  Widget _buildHomeworkItem(
      BuildContext context,
      HomeworkModel hw,
      HomeworkController controller,
      ) {
    final subjectColor = controller.getSubjectColor(hw.subjectName);
    final subjectIcon = controller.getSubjectIcon(hw.subjectName);
    final daysRemaining = hw.getRemainingDays();
    final hasImage = hw.image != null && hw.image!.isNotEmpty;

    final status = hw.getStatus();
    final priority = hw.getPriority();
    final statusColor = controller.getStatusColor(status);
    final priorityColor = controller.getPriorityColor(priority);

    return InkWell(
      onTap: () => Get.to(
            () => TeacherHomeworkDetailsScreen(homeworkId: hw.id!),
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: statusColor.withOpacity(0.25),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image / Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: subjectColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: hasImage
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  hw.image!,
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    subjectIcon,
                    color: subjectColor,
                    size: 40,
                  ),
                ),
              )
                  : Icon(subjectIcon, color: subjectColor, size: 40),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          hw.subjectName ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: statusColor.withOpacity(0.35)),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hw.subjectTopic ?? '',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: priorityColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: priorityColor.withOpacity(0.35)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.bolt_rounded,
                                size: 10, color: priorityColor),
                            const SizedBox(width: 2),
                            Text(
                              priority,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: priorityColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          daysRemaining > 0
                              ? 'Due in $daysRemaining days'
                              : daysRemaining == 0
                              ? 'Due today'
                              : 'Overdue by ${daysRemaining.abs()} days',
                          style: TextStyle(
                            color: daysRemaining < 0
                                ? Colors.red
                                : daysRemaining == 0
                                ? Colors.blue
                                : Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (hw.teacherName != null &&
                      hw.teacherName!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 12,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Teacher: ${hw.teacherName}',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Empty State
  // ─────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_turned_in_rounded,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No homework found',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try changing your filters',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Error State
  // ─────────────────────────────────────────────
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading homework',
            style: TextStyle(
              color: Colors.red[700],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                Get.find<HomeworkController>().refreshHomework(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}