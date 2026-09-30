import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../controller/homework_controller.dart';
import '../model/homework_model.dart';
import 'teacher_assign_add_homework_screen.dart';

class TeacherHomeworkDetailsScreen extends StatefulWidget {
  final int homeworkId;
  const TeacherHomeworkDetailsScreen({super.key, required this.homeworkId,});

  @override
  State<TeacherHomeworkDetailsScreen> createState() => _TeacherHomeworkDetailsScreenState();
}

class _TeacherHomeworkDetailsScreenState extends State<TeacherHomeworkDetailsScreen> {

  final hwController = Get.find<HomeworkController>();
  HomeworkModel? _homework;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final hw = await hwController.fetchHomeworkById(widget.homeworkId);
    if (!mounted) return;
    setState(() {
      _homework = hw;
      _loading = false;
    });
  }


  Color _subjectColor(String? s) {
    if (s == null) return Colors.indigo;
    const colors = [
      Colors.indigo, Colors.teal, Colors.deepOrange,
      Colors.purple, Colors.blue, Colors.green,
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
            onPressed: () async {
              await Get.to(() => TeacherAssignAddHomeworkScreen(homework: _homework!),);
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
            onPressed: () => _confirmDelete(_homework!),
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 0.3),
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 20),
            ),
          ),
          SizedBox(width: 10,),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: hw.studentIdsList.map((s) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade100,
                  child: Icon(Icons.image,color: Colors.grey.shade400,),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name:",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        s.studentIdcard,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (s.status ? Colors.green : Colors.orange)
                        .withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    s.status ? 'Done' : 'Pending',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: s.status ? Colors.green : Colors.orange,
                    ),
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
              fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
    ],
  );

  Widget _buildDetailCard({required List<Widget> children}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
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
        titleTextStyle: TextStyle(fontSize: 20,color: Colors.indigo,fontWeight: FontWeight.w500),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text('Are you sure you want to delete this homework?',style: TextStyle(fontSize: 16,color: Colors.grey.shade600),),
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