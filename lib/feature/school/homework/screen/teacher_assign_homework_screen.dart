import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_color.dart';
import '../../profile/controller/teacher_controller.dart';
import '../controller/homework_controller.dart';
import '../model/homework_model.dart';
import 'teacher_assign_add_homework_screen.dart';
import 'teacher_homework_details_screen.dart';

class TeacherAssignHomeworkScreen extends StatefulWidget {
  const TeacherAssignHomeworkScreen({super.key});

  @override
  State<TeacherAssignHomeworkScreen> createState() => _TeacherAssignHomeworkScreenState();
}

class _TeacherAssignHomeworkScreenState extends State<TeacherAssignHomeworkScreen> {
  final hwController = Get.find<HomeworkController>();
  final teacherController = Get.find<TeacherController>();

  String _selectedClass = 'All';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadTeacherHomework();
  }

  Future<void> _loadTeacherHomework() async {
    final id = teacherController.teacherIdCard;
    if (id.isEmpty) {
      await hwController.fetchAllHomework();
    } else {
      await hwController.fetchHomeworkByTeacher(id);
    }
  }

  static String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  bool get _hasActiveFilters =>
      _selectedClass != 'All' || _selectedDate != null;

  void _clearFilters() {
    setState(() {
      _selectedClass = 'All';
      _selectedDate = null;
    });
  }

  List<String> get _uniqueClasses {
    final set = <String>{'All'};
    for (final h in hwController.homeworkList) {
      if ((h.className ?? '').isNotEmpty) set.add(h.className!);
    }
    final list = set.toList()..sort();
    list.remove('All');
    list.insert(0, 'All');
    return list;
  }

  List<HomeworkModel> get _filtered {
    return hwController.homeworkList.where((h) {
      if (_selectedClass != 'All' && h.className != _selectedClass) {
        return false;
      }
      if (_selectedDate != null) {
        final d = DateTime.tryParse(h.endDate ?? '');
        if (d == null) return false;
        if (d.year != _selectedDate!.year ||
            d.month != _selectedDate!.month ||
            d.day != _selectedDate!.day) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  Color _subjectColor(String? s) {
    if (s == null) return Colors.indigo;
    const colors = [
      Colors.indigo,
      Colors.teal,
      Colors.deepOrange,
      Colors.purple,
      Colors.blue,
      Colors.green,
    ];
    return colors[s.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildCombinedFilterBar(),
            Expanded(
              child: Obx(() {
                if (hwController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final list = _filtered;
                if (list.isEmpty) return _buildEmptyState();
                return RefreshIndicator(
                  onRefresh: _loadTeacherHomework,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: list.length,
                    itemBuilder: (_, i) => _buildHomeworkItem(context, list[i]),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
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
      actions: [
        IconButton(
          onPressed: _loadTeacherHomework,
          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
        ),
        SizedBox(width: 10,),
        InkWell(
          onTap: () async {
            await Get.to(() => const TeacherAssignAddHomeworkScreen());
            // _loadTeacherHomework();
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 0.3),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buildCombinedFilterBar() {
    final hasDate = _selectedDate != null;
    final selectedClass = _selectedClass;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune_rounded, size: 16, color: Colors.indigo),
              const SizedBox(width: 6),
              const Text(
                'Filters',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
              const Spacer(),
              if (_hasActiveFilters)
                GestureDetector(
                  onTap: _clearFilters,
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
                        Icon(Icons.close_rounded, size: 12, color: Colors.red),
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
              GestureDetector(
                onTap: _showClassFilterSheet,
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
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
                      const Icon(Icons.arrow_drop_down_rounded, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: _showCalendarPicker,
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
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
                          color: hasDate ? Colors.indigo : Colors.grey[500],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            hasDate
                                ? DateFormat('dd MMM yyyy')
                                .format(_selectedDate!)
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
                        const Icon(Icons.arrow_drop_down_rounded, size: 20),
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
  }

  Future<void> _showCalendarPicker() async {
    final now = DateTime.now();
    DateTime tempPicked = _selectedDate ?? now;

    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => SafeArea(
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
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close_rounded, size: 20),
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
                    onDateChanged: (date) =>
                        setModalState(() => tempPicked = date),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _selectedDate = null);
                          Navigator.pop(ctx);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
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
                        onPressed: () => Navigator.pop(ctx, tempPicked),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Apply',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _showClassFilterSheet() {
    final classes = _uniqueClasses;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
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
            const Text(
              'Select Class',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: classes.map((opt) {
                final isSelected = _selectedClass == opt;
                return ChoiceChip(
                  label: Text(opt),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _selectedClass = opt);
                    Navigator.pop(context);
                  },
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
      ),
    );
  }

  Widget _buildHomeworkItem(BuildContext context, HomeworkModel hw) {
    final subjectColor = _subjectColor(hw.subjectName);
    final hasImage = hw.image != null && hw.image!.isNotEmpty;

    return GestureDetector(
      onTap: () => Get.to(() => TeacherHomeworkDetailsScreen(homeworkId: hw.id ?? 0),),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 100,
                height: 100,
                child: hasImage
                    ? Image.network(
                  hw.image!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: subjectColor.withOpacity(0.1),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: subjectColor,
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: subjectColor.withOpacity(0.12),
                    child: Icon(
                      Icons.menu_book_sharp,
                      color: subjectColor,
                      size: 32,
                    ),
                  ),
                )
                    : Container(
                  color: subjectColor.withOpacity(0.12),
                  child: Icon(
                    Icons.menu_book_sharp,
                    color: subjectColor,
                    size: 32,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      hw.subjectName ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hw.subjectTopic ?? '',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.class_rounded,
                            size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 3),
                        Text(
                          'Class ${hw.className ?? '-'}',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.calendar_today_rounded,
                            size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            hw.endDate ?? '-',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
          Icon(Icons.inbox_rounded, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'No homework found',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try changing filters',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}