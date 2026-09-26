import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/feature/school/homework/screen/teacher_add_homework_screen.dart';

import '../../../../core/utils/app_color.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../controller/homework_controller.dart';
import '../model/homework_model.dart';

class TeacherHomeworkDetailsScreen extends StatefulWidget {
  final int homeworkId;

  const TeacherHomeworkDetailsScreen({
    super.key,
    required this.homeworkId,
  });

  @override
  State<TeacherHomeworkDetailsScreen> createState() => _TeacherHomeworkDetailsScreenState();
}

class _TeacherHomeworkDetailsScreenState
    extends State<TeacherHomeworkDetailsScreen> {
  final controller = Get.find<HomeworkController>();

  @override
  void initState() {
    super.initState();
    // Fetch fresh details from API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchHomeworkById(widget.homeworkId);
    });
  }

  @override
  Widget build(BuildContext context) {
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
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          // Loading state
          if (controller.isLoading.value &&
              controller.selectedHomework.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final homework = controller.selectedHomework.value;

          // Error / not found
          if (homework == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value.isEmpty
                        ? 'Homework not found'
                        : controller.errorMessage.value,
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        controller.fetchHomeworkById(widget.homeworkId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Render details
          return RefreshIndicator(
            onRefresh: () =>
                controller.fetchHomeworkById(widget.homeworkId),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Homework'),
                  const SizedBox(height: 8),
                  _buildHeaderCard(homework, controller),
                  const SizedBox(height: 20),

                  _buildSectionTitle('Details'),
                  const SizedBox(height: 8),
                  _buildDetailsSection(homework, controller),
                  const SizedBox(height: 16),

                  _buildSectionTitle('Info'),
                  const SizedBox(height: 8),
                  _buildInfoSection(homework),
                  const SizedBox(height: 16),

                  if (homework.image != null &&
                      homework.image!.isNotEmpty) ...[
                    _buildSectionTitle('Attachment'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showFullImage(homework.image!),
                      child: _buildImagePreview(homework.image!),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Tap image to view full size',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  _buildActionButtons(context, homework, controller),
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
          );
        }),
      ),
    );
  }

  // ───── Header Card ─────
  Widget _buildHeaderCard(
      HomeworkModel homework, HomeworkController controller) {
    final subjectColor = controller.getSubjectColor(homework.subjectName);
    final subjectIcon = controller.getSubjectIcon(homework.subjectName);
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
              color: subjectColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.menu_book_sharp, color: subjectColor, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  homework.subjectName ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  homework.subjectTopic ?? '',
                  style:
                  TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───── Details Section ─────
  Widget _buildDetailsSection(
      HomeworkModel homework, HomeworkController controller) {
    final status = homework.getStatus();
    final priority = homework.getPriority();
    final daysRemaining = homework.getRemainingDays();

    return _buildDetailCard(
      children: [
        _buildDetailRow('📅 Issue Date', homework.issueDate ?? '-'),
        _buildDetailRow('📅 Due Date', homework.endDate ?? '-'),
        _buildColoredDetailRow(
            '📊 Status', status, controller.getStatusColor(status)),
        _buildColoredDetailRow('⚡ Priority', priority,
            controller.getPriorityColor(priority)),
        _buildDetailRow(
          '⏰ Days Remaining',
          daysRemaining > 0
              ? '$daysRemaining days'
              : daysRemaining == 0
              ? 'Due today'
              : 'Overdue by ${daysRemaining.abs()} days',
        ),
      ],
    );
  }

  // ───── Info Section ─────
  Widget _buildInfoSection(HomeworkModel homework) {
    return _buildDetailCard(
      children: [
        if (homework.className?.isNotEmpty ?? false)
          _buildDetailRow('🏫 Class', homework.className!),
        if (homework.teacherName?.isNotEmpty ?? false)
          _buildDetailRow('👨‍🏫 Teacher', homework.teacherName!),
        if (homework.teacherId?.isNotEmpty ?? false)
          _buildDetailRow('🆔 Teacher ID', homework.teacherId!),
        if (homework.schoolType?.isNotEmpty ?? false)
          _buildDetailRow('🏛️ School Type', homework.schoolType!),
      ],
    );
  }

  // ───── Action Buttons ─────
  Widget _buildActionButtons(BuildContext context, HomeworkModel homework,
      HomeworkController controller) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => Get.to(
                  () => TeacherAddHomeworkScreen(homework: homework),
            ),
            icon: const Icon(Icons.edit_rounded, size: 18),
            label: const Text('Edit',
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () =>
                _showDeleteConfirmation(context, controller, homework),
            icon: const Icon(Icons.delete_rounded, size: 18),
            label: const Text('Delete',
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  // ───── Section Title ─────
  Widget _buildSectionTitle(String title) {
    return Row(
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
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColoredDetailRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.35)),
            ),
            child: Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 220,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 220,
            color: Colors.grey[200],
            child: const Center(
              child:
              Icon(Icons.error_outline, color: Colors.grey, size: 40),
            ),
          );
        },
      ),
    );
  }

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
                            color: Colors.white));
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

  void _showDeleteConfirmation(BuildContext context,
      HomeworkController controller, HomeworkModel homework) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Homework'),
        titleTextStyle: const TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.w600,
            fontSize: 18),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete this homework?',
              style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text('Subject: ${homework.subjectName}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Topic: ${homework.subjectTopic}',
                style: const TextStyle(fontSize: 14)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
            onPressed: controller.isSubmitting.value
                ? null
                : () async {
              final success = await controller
                  .deleteHomework(homework.id);
              if (success) {
                FlutterToast.success(
                    'Homework deleted successfully');
                Navigator.pop(dialogContext);
                Get.back();
              } else {
                FlutterToast.error(
                    controller.errorMessage.value);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: controller.isSubmitting.value
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            )
                : const Text('Delete'),
          )),
        ],
      ),
    );
  }
}