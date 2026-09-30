// lib/feature/school/report/screen/student_report_card_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../profile/controller/student_controller.dart';
import '../controller/report_card_controller.dart';
import '../model/report_card_model.dart';

class StudentReportCardScreen extends StatefulWidget {
  const StudentReportCardScreen({super.key});

  @override
  State<StudentReportCardScreen> createState() => _StudentReportCardScreenState();
}

class _StudentReportCardScreenState extends State<StudentReportCardScreen> {
  final studentController = Get.find<StudentController>();
  final reportController = Get.find<ReportCardController>();

  // ✅ Screen-level filters
  final selectedDate = Rxn<DateTime>();
  final selectedResult = 'All'.obs; // All / Pass / Fail
  final resultFilters = const ['All', 'Pass', 'Fail'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadIfPossible());
  }

  void _loadIfPossible() {
    if (studentController.hasData) {
      final id = studentController.studentIdCard;
      if (id.isNotEmpty) {
        reportController.loadReportCardsByStudent(id);
      }
    }
  }

  // ============================================================
  // Apply date + result filters
  // ============================================================
  List<ReportCardData> get _filteredList {
    final all = reportController.studentReportCards;

    return all.where((r) {
      // Result filter
      if (selectedResult.value != 'All') {
        final wantPass = selectedResult.value == 'Pass';
        if (r.isPass != wantPass) return false;
      }

      // Date filter — match yyyy-MM-dd
      if (selectedDate.value != null) {
        if (r.createdAt.isEmpty) return false;
        try {
          final created = DateTime.parse(r.createdAt).toLocal();
          final sel = selectedDate.value!;
          final sameDay = created.year == sel.year &&
              created.month == sel.month &&
              created.day == sel.day;
          if (!sameDay) return false;
        } catch (_) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  bool get _hasActiveFilters =>
      selectedDate.value != null || selectedResult.value != 'All';

  void _clearFilters() {
    selectedDate.value = null;
    selectedResult.value = 'All';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Obx(() {
        // 1. Student profile still loading
        if (studentController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. No student data
        if (!studentController.hasData) {
          return _buildEmptyState(
            message: 'No student data available',
            icon: Icons.person_off_outlined,
          );
        }

        // 3. Student available → show filters + list
        final studentId = studentController.studentIdCard;

        // Kick off load if not yet started
        if (!reportController.isLoadingStudent.value &&
            reportController.studentReportCards.isEmpty &&
            studentId.isNotEmpty) {
          Future.microtask(
                () => reportController.loadReportCardsByStudent(studentId),
          );
        }

        return Column(
          children: [
            _buildFilterBar(),
            const SizedBox(height: 4),
            Expanded(child: _buildBody(studentId)),
          ],
        );
      }),
    );
  }

  // ============================================================
  // App bar
  // ============================================================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Report Card'),
      titleTextStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),
      centerTitle: false,
      leading: IconButton(onPressed: () {
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),
      elevation: 0,
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.indigo,
      actions: [
        IconButton(
          onPressed: () {
            if (studentController.hasData) {
              reportController.loadReportCardsByStudent(
                studentController.studentIdCard,
              );
            }
          },
          icon: const Icon(Icons.refresh_rounded, color: Colors.white,),
        ),
      ],
    );
  }

  // ============================================================
  // Combined filter bar (Date + Result)
  // ============================================================
  Widget _buildFilterBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
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
                  letterSpacing: 0.3,
                ),
              ),
              const Spacer(),
              Obx(() {
                if (!_hasActiveFilters) return const SizedBox.shrink();
                return GestureDetector(
                  onTap: _clearFilters,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                );
              }),
            ],
          ),
          const SizedBox(height: 8),

          // Date picker
          Obx(() {
            final hasDate = selectedDate.value != null;
            return GestureDetector(
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
                            .format(selectedDate.value!)
                            : 'Filter by Date',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                          hasDate ? FontWeight.w600 : FontWeight.w500,
                          color:
                          hasDate ? Colors.indigo : Colors.grey[600],
                        ),
                      ),
                    ),
                    if (hasDate)
                      GestureDetector(
                        onTap: () => selectedDate.value = null,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Icon(Icons.close_rounded,
                              size: 16, color: Colors.indigo),
                        ),
                      ),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 20,
                      color: hasDate ? Colors.indigo : Colors.grey[500],
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 10),

          // Result chips
          Row(
            children: [
              const Icon(Icons.filter_alt_rounded,
                  size: 14, color: Colors.indigo),
              const SizedBox(width: 6),
              const Text(
                'Result',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(
                      () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: resultFilters.map((f) {
                        final isSel = selectedResult.value == f;
                        final color = f == 'Pass'
                            ? Colors.green
                            : f == 'Fail'
                            ? Colors.red
                            : Colors.indigo;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => selectedResult.value = f,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: isSel
                                    ? color
                                    : color.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSel
                                      ? color
                                      : color.withOpacity(0.3),
                                  width: 1.2,
                                ),
                              ),
                              child: Text(
                                f,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isSel ? Colors.white : color,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
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

  // ============================================================
  // Calendar picker sheet
  // ============================================================
  Future<void> _showCalendarPicker() async {
    final now = DateTime.now();
    DateTime temp = selectedDate.value ?? now;

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
                          icon: const Icon(Icons.close_rounded, size: 20),
                        ),
                      ],
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 320,
                      child: CalendarDatePicker(
                        initialDate: temp,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        onDateChanged: (d) => setModalState(() => temp = d),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              selectedDate.value = null;
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
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
                            onPressed: () =>
                                Navigator.pop(context, temp),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
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

    if (picked != null) selectedDate.value = picked;
  }

  // ============================================================
  // Body
  // ============================================================
  Widget _buildBody(String studentId) {
    return Obx(() {
      if (reportController.isLoadingStudent.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final list = _filteredList;

      // Empty state (also covers active filter = no match)
      if (list.isEmpty) {
        return RefreshIndicator(
          onRefresh: () =>
              reportController.loadReportCardsByStudent(studentId),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(Get.context!).size.height * 0.22,
              ),
              _buildEmptyState(
                message: _hasActiveFilters
                    ? 'No report cards match the selected filters'
                    : (reportController.errorMessage.value.isEmpty
                    ? 'No report cards found for $studentId'
                    : reportController.errorMessage.value),
                icon: Icons.description_outlined,
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () =>
            reportController.loadReportCardsByStudent(studentId),
        child: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: list.length,
          itemBuilder: (context, i) => _ReportCardTile(data: list[i]),
        ),
      );
    });
  }

  // ============================================================
  // Empty / error state
  // ============================================================
  Widget _buildEmptyState({
    required String message,
    required IconData icon,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// Report card tile
// ================================================================
class _ReportCardTile extends StatelessWidget {
  final ReportCardData data;
  const _ReportCardTile({required this.data});

  @override
  Widget build(BuildContext context) {
    final isPass = data.isPass;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.indigo,width: 0.3)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: subject + result chip
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.subjectName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${data.examName} • Class ${data.className}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                _ResultChip(isPass: isPass, result: data.result),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 14),

            // Stats
            Row(
              children: [
                _StatBox(
                  label: 'Obtained',
                  value: '${data.studentMarks}',
                  color: isPass ? Colors.green : Colors.red,
                ),
                _StatBox(
                  label: 'Total',
                  value: '${data.subjectMaxMarks}',
                  color: Colors.blueGrey,
                ),
                _StatBox(
                  label: 'Passing',
                  value: '${data.passingMaxMarks}',
                  color: Colors.blueGrey,
                ),
                _StatBox(
                  label: 'Grade',
                  value: data.grade,
                  color: Colors.deepPurple,
                ),
              ],
            ),

            if (data.remark.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  data.remark,
                  style: TextStyle(
                      color: Colors.grey.shade800, fontSize: 13),
                ),
              ),
            ],

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Admin: ${data.adminId}',
                  style: TextStyle(
                      color: Colors.grey.shade500, fontSize: 11),
                ),
                Text(
                  data.createdAt.isNotEmpty
                      ? data.createdAt.split('T').first
                      : '',
                  style: TextStyle(
                      color: Colors.grey.shade500, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultChip extends StatelessWidget {
  final bool isPass;
  final String result;
  const _ResultChip({required this.isPass, required this.result});

  @override
  Widget build(BuildContext context) {
    final color = isPass ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        result.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}