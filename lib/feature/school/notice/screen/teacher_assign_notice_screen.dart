import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/notice_controller.dart';
import 'teacher_assign_details_screen.dart';
import 'teacher_assign_notice_form_screen.dart';

class TeacherAssignNoticeScreen extends StatelessWidget {
  const TeacherAssignNoticeScreen({super.key});

  // ==================== COLORS / ICONS ====================
  Color _priorityColor(String p) {
    switch (p) {
      case "Urgent":
        return Colors.red;
      case "Important":
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _priorityIcon(String p) {
    switch (p) {
      case "Urgent":
        return Icons.priority_high_rounded;
      case "Important":
        return Icons.star_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  Color _audienceColor(String a) {
    switch (a) {
      case "Parents":
        return Colors.purple;
      case "Both":
        return Colors.teal;
      case "Staff":
        return Colors.blueGrey;
      default:
        return Colors.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<NoticeController>();

    // Fetch on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ctrl.notices.isEmpty && !ctrl.isLoading.value) {
        ctrl.fetchNotices();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: _buildAppBar(ctrl),
      body: Obx(() {
        // Initial full-screen loading
        if (ctrl.isLoading.value && ctrl.notices.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error state
        if (ctrl.error.value.isNotEmpty && ctrl.notices.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded,
                    size: 60, color: Colors.red.shade300),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(ctrl.error.value,
                      textAlign: TextAlign.center),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ctrl.fetchNotices(),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            const SizedBox(height: 12),
            _buildCombinedFilterBar(ctrl),
            const SizedBox(height: 12),
            Expanded(child: _buildNoticeList(ctrl)),
          ],
        );
      }),
    );
  }

  // ==================== APP BAR ====================
  PreferredSizeWidget _buildAppBar(NoticeController ctrl) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios, size: 20),
      ),
      title: const Text(
        "Assign Notice",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
      ),
      actions: [
        InkWell(
          customBorder: const CircleBorder(),
          onTap: () async {
            await Get.to(
                    () => const TeacherAssignNoticeFormScreen());
            ctrl.fetchNotices(silent: true);
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 0.3),
            ),
            child: Icon(Icons.add, size: 20),
          ),
        ),
        SizedBox(width: 20,),

      ],
    );
  }

  // ==================== COMBINED FILTER BAR ====================
  Widget _buildCombinedFilterBar(NoticeController ctrl) {
    return Obx(() {
      final hasDate = ctrl.selectedDate.value != null;
      final selectedClass = ctrl.selectedClass.value;

      return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
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
                if (ctrl.hasActiveFilters)
                  GestureDetector(
                    onTap: ctrl.clearFilters,
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

            // Selectors
            Row(
              children: [
                // ---- CLASS SELECTOR ----
                GestureDetector(
                  onTap: () => _showClassFilterSheet(ctrl),
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
                        ConstrainedBox(
                          constraints:
                          const BoxConstraints(maxWidth: 130),
                          child: Text(
                            selectedClass == 'All'
                                ? 'Class'
                                : (selectedClass == 'All Classes'
                                ? 'All Classes'
                                : 'Class $selectedClass'),
                            overflow: TextOverflow.ellipsis,
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

                // ---- DATE SELECTOR ----
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showCalendarPicker(ctrl),
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
                                  ctrl.selectedDate.value!)
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

  // ==================== NOTICE LIST ====================
  Widget _buildNoticeList(NoticeController ctrl) {
    return Obx(() {
      final list = ctrl.filteredNotices;

      if (list.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_rounded,
                  size: 64, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(
                ctrl.hasActiveFilters
                    ? "No notices match your filters"
                    : "No notices yet",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              if (ctrl.hasActiveFilters)
                Text(
                  "Try changing the filters",
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade400),
                ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => ctrl.fetchNotices(),
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(14, 4, 14, 20),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final n = list[index];
            return _buildNoticeCard(ctrl, n);
          },
        ),
      );
    });
  }

  Widget _buildNoticeCard(NoticeController ctrl, dynamic n) {
    final pc = _priorityColor(n.priority);
    final ac = _audienceColor(n.audience);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        await Get.to(() => TeacherAssignDetailsScreen(notice: n));
        ctrl.fetchNotices(silent: true);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: pc.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_priorityIcon(n.priority),
                      color: pc, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (n.isPinned) ...[
                            const Icon(Icons.push_pin_rounded,
                                size: 14, color: Colors.orange),
                            const SizedBox(width: 4),
                          ],
                          Flexible(
                            child: Text(
                              n.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        n.displayDate,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: Colors.grey),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              n.description,
              style: TextStyle(fontSize: 12, color: Colors.grey[800]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _tag(n.priority, pc),
                _tag(n.audience, ac, icon: Icons.groups_rounded),
                _tag(n.assignedClass, Colors.grey.shade600,
                    icon: Icons.class_rounded),
                if (n.hasAttachment)
                  _tag(
                    n.attachmentType == "image" ? "Image" : "PDF",
                    n.attachmentType == "image"
                        ? Colors.blue
                        : Colors.red,
                    icon: n.attachmentType == "image"
                        ? Icons.image_rounded
                        : Icons.picture_as_pdf_rounded,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==================== TAG ====================
  Widget _tag(String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  // ==================== CALENDAR PICKER ====================
  Future<void> _showCalendarPicker(NoticeController ctrl) async {
    final now = DateTime.now();
    DateTime tempPicked = ctrl.selectedDate.value ?? now;

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
                        firstDate:
                        DateTime(now.year - 1, now.month, now.day),
                        lastDate:
                        DateTime(now.year + 1, now.month, now.day),
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
                              ctrl.setDateFilter(null);
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
      ctrl.setDateFilter(picked);
    }
  }

  // ==================== CLASS FILTER SHEET ====================
  void _showClassFilterSheet(NoticeController ctrl) {
    final classes = ctrl.getUniqueClasses();
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildFilterSheet(
        title: 'Select Class',
        options: classes,
        selected: ctrl.selectedClass.value,
        onSelect: (val) {
          ctrl.setClassFilter(val);
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
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(Get.context!).size.height * 0.7,
      ),
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
          Flexible(
            child: SingleChildScrollView(
              child: Wrap(
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
                      color: isSelected
                          ? Colors.white
                          : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    backgroundColor: Colors.grey.shade100,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}