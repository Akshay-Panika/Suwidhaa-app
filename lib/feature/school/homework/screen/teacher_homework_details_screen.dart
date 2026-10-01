// lib/feature/school/homework/screen/teacher_homework_details_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_color.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../../student/controller/student_list_controller.dart';
import '../../student/model/student_list_model.dart';
import '../controller/homework_controller.dart';
import '../model/homework_model.dart';
import 'teacher_assign_add_homework_screen.dart';

class TeacherHomeworkDetailsScreen extends StatefulWidget {
  final int homeworkId;
  const TeacherHomeworkDetailsScreen({super.key, required this.homeworkId});

  @override
  State<TeacherHomeworkDetailsScreen> createState() =>
      _TeacherHomeworkDetailsScreenState();
}

class _TeacherHomeworkDetailsScreenState
    extends State<TeacherHomeworkDetailsScreen> {

  final hwController = Get.find<HomeworkController>();
  final studentListController = Get.find<StudentListController>();

  HomeworkModel? _homework;
  bool _loading = true;
  final Set<String> _togglingCards = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  Future<void> _load() async {
    // 1. Load homework
    final hw = await hwController.fetchHomeworkById(widget.homeworkId);

    // 2. Ensure student list is available for name/photo lookup
    if (hw != null && hw.schoolType != null && hw.schoolType!.isNotEmpty) {
      // Load students for the same school type
      await studentListController.loadStudentListBySchoolType(hw.schoolType!);
    }

    if (!mounted) return;
    setState(() {
      _homework = hw;
      _loading = false;
    });
  }

  Future<void> _toggleStudentStatus(
      HomeworkModel hw,
      StudentHomeworkEntry entry,
      ) async {
    final cardKey = entry.studentIdcard;
    final newValue = !entry.status;

    // ✅ Show loading on this card
    setState(() => _togglingCards.add(cardKey));

    try {
      final ok = await hwController.toggleStudentStatus(
        homeworkId: hw.id!,
        studentIdcard: entry.studentIdcard,
        explicitStatus: newValue,
      );

      if (ok) {
        // ✅ Update local entry
        final idx = hw.studentIdsList.indexWhere(
              (e) => e.studentIdcard == entry.studentIdcard,
        );
        if (idx >= 0) {
          hw.studentIdsList[idx] = StudentHomeworkEntry(
            studentIdcard: entry.studentIdcard,
            status: newValue,
          );
        }

        FlutterToast.success(
          newValue ? 'Homework is done' : 'Homework is pending',
        );
      } else {
        FlutterToast.error('Failed to update status');
      }
    } catch (e) {
      FlutterToast.error('Error: $e');
    } finally {
      // ✅ Always remove loading
      if (mounted) setState(() => _togglingCards.remove(cardKey));
    }
  }

  // ── Match a homework entry's studentIdCard with loaded students ──
  StudentListData? _findStudent(String idCard) {
    for (final s in studentListController.studentList) {
      if (s.studentIdCard == idCard) return s;
    }
    return null;
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
    final hw = _homework;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          'Homework Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: hw == null
                ? null
                : () async {
              await Get.to(
                    () => TeacherAssignAddHomeworkScreen(homework: hw),
              );
              _load();
            },
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 0.3),
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 20),
            ),
          ),
          IconButton(
            onPressed: hw == null ? null : () => _confirmDelete(hw),
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 0.3),
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : hw == null
            ? const Center(
          child: Text('Homework not found',
              style: TextStyle(color: Colors.grey)),
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Homework'),
              const SizedBox(height: 8),
              _buildHeaderCard(hw),
              const SizedBox(height: 20),
              _buildSectionTitle('Details'),
              const SizedBox(height: 8),
              _buildDetailsSection(hw),
              const SizedBox(height: 16),
              _buildSectionTitle('Info'),
              const SizedBox(height: 8),
              _buildInfoSection(hw),
              const SizedBox(height: 16),
              _buildSectionTitle('Students (${hw.studentIdsList.length})'),
              const SizedBox(height: 8),
              _buildStudentsList(hw),
              const SizedBox(height: 16),
              if ((hw.image ?? '').isNotEmpty) ...[
                _buildSectionTitle('Attachment'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _showFullImage(hw.image!),
                  child: _buildImagePreview(hw.image!),
                ),
              ],
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  // ✅ UPDATED: Students list with matched full data
  // ══════════════════════════════════════════════════════
  Widget _buildStudentsList(HomeworkModel hw) {
    if (hw.studentIdsList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('No students assigned'),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: hw.studentIdsList.map((entry) {
          final student = _findStudent(entry.studentIdcard);
          final isToggling = _togglingCards.contains(entry.studentIdcard);

          return Container(
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: entry.status
                    ? Colors.green.shade200
                    : Colors.grey[200]!,
              ),
              color: entry.status ? Colors.white : Colors.white,
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // ── Avatar ──
                CircleAvatar(
                  radius: 22,
                  backgroundColor: student != null
                      ? Colors.indigo.withOpacity(0.1)
                      : Colors.grey.shade100,
                  backgroundImage: (student?.studentProfile != null &&
                      student!.studentProfile!.isNotEmpty)
                      ? NetworkImage(student.studentProfile!)
                      : null,
                  child: (student?.studentProfile == null ||
                      student!.studentProfile!.isEmpty)
                      ? Text(
                    student != null && student.fullName.isNotEmpty
                        ? student.fullName
                        .substring(0, 1)
                        .toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: student != null
                          ? Colors.indigo
                          : Colors.grey.shade500,
                    ),
                  )
                      : null,
                ),
                const SizedBox(width: 12),

                // ── Name + ID + class ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student?.fullName ?? entry.studentIdcard,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          // ID chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.indigo.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.badge_rounded,
                                  size: 10,
                                  color: Colors.indigo,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  entry.studentIdcard,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (student != null &&
                              student.studentClass.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.class_rounded,
                                    size: 10,
                                    color: Colors.orange.shade700,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    "Class ${student.studentClass.replaceAll('Class ', '')}",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.orange.shade800,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Status label ──
                Text(
                  entry.status ? 'Done' : 'Pending',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: entry.status ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(width: 4),

                // ── Toggle Switch ──
                SizedBox(
                  height: 28,
                  child: isToggling
                      ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.indigo,
                      ),
                    ),
                  )
                      : Switch(
                    value: entry.status,
                    activeColor: Colors.green,
                    activeTrackColor: Colors.green.withOpacity(0.4),
                    inactiveThumbColor: Colors.orange,
                    inactiveTrackColor:
                    Colors.orange.withOpacity(0.3),
                    materialTapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
                    onChanged: (value) =>
                        _toggleStudentStatus(hw, entry),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHeaderCard(HomeworkModel hw) {
    final c = _subjectColor(hw.subjectName);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: c.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.menu_book_sharp, color: c, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hw.subjectName ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  hw.subjectTopic ?? '',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(HomeworkModel hw) {
    final d = hw.getRemainingDays();
    return _buildDetailCard(children: [
      if ((hw.className ?? '').isNotEmpty)
        _buildDetailRow('🏫 Class', hw.className!),
      _buildDetailRow('📅 Issue Date', hw.issueDate ?? '-'),
      _buildDetailRow('📅 Due Date', hw.endDate ?? '-'),
      _buildDetailRow(
        '⏰ Days Remaining',
        d > 0 ? '$d days' : d == 0 ? 'Due today' : 'Overdue by ${d.abs()} days',
      ),
    ]);
  }

  Widget _buildInfoSection(HomeworkModel hw) => _buildDetailCard(children: [
    if ((hw.teacherName ?? '').isNotEmpty)
      _buildDetailRow('👨‍🏫 Teacher', hw.teacherName!),
    if ((hw.teacherId ?? '').isNotEmpty)
      _buildDetailRow('🆔 Teacher ID', hw.teacherId!),
    if ((hw.schoolType ?? '').isNotEmpty)
      _buildDetailRow('🏛️ School Type', hw.schoolType!),
  ]);

  Widget _buildSectionTitle(String title) => Row(
    children: [
      Container(
        width: 4,
        height: 16,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 8),
      Text(title,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3)),
    ],
  );

  Widget _buildDetailCard({required List<Widget> children}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: children),
  );

  Widget _buildDetailRow(String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(v,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13),
              textAlign: TextAlign.right),
        ),
      ],
    ),
  );

  Widget _buildImagePreview(String url) => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.network(
      url,
      height: 220,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, p) => p == null
          ? child
          : Container(
        height: 220,
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorBuilder: (_, __, ___) => Container(
        height: 220,
        color: Colors.grey[200],
        child: const Center(
            child: Icon(Icons.error_outline, color: Colors.grey, size: 40)),
      ),
    ),
  );

  void _showFullImage(String url) {
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
                child: Image.network(url, fit: BoxFit.contain),
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

  void _confirmDelete(HomeworkModel hw) {
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Homework'),
        titleTextStyle: const TextStyle(
            fontSize: 20,
            color: Colors.indigo,
            fontWeight: FontWeight.w500),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete this homework?',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text('Subject: ${hw.subjectName}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Topic: ${hw.subjectTopic}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dCtx);
              final ok = await hwController.deleteHomework(hw.id!);
              if (ok) {
                FlutterToast.success('Homework deleted successfully');
                Get.back();
              } else {
                FlutterToast.error('Failed to delete homework');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}