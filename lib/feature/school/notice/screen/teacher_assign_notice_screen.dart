import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/notice_controller.dart';
import 'teacher_assign_details_screen.dart';
import 'teacher_assign_notice_form_screen.dart';

class TeacherAssignNoticeScreen extends StatelessWidget {
  const TeacherAssignNoticeScreen({super.key});

  Color _priorityColor(String p) {
    switch (p) {
      case "Urgent": return Colors.red;
      case "Important": return Colors.orange;
      default: return Colors.blue;
    }
  }

  IconData _priorityIcon(String p) {
    switch (p) {
      case "Urgent": return Icons.priority_high_rounded;
      case "Important": return Icons.star_rounded;
      default: return Icons.info_outline_rounded;
    }
  }

  Color _audienceColor(String a) {
    switch (a) {
      case "Parents": return Colors.purple;
      case "Both": return Colors.teal;
      case "Staff": return Colors.blueGrey;
      default: return Colors.indigo;
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          "Assign Notice",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white,width: 0.6),
              shape: BoxShape.circle
            ),
            child: InkWell(
              onTap: () async {
                await Get.to(() => const TeacherAssignNoticeFormScreen());
                ctrl.fetchNotices(silent: true);
              },
              child: const Icon(Icons.add),
            ),
          ),
          SizedBox(width: 16,)
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value && ctrl.notices.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ctrl.error.value.isNotEmpty && ctrl.notices.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded,
                    size: 60, color: Colors.red.shade300),
                const SizedBox(height: 10),
                Text(ctrl.error.value, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ctrl.fetchNotices(),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        final list = ctrl.sortedNotices;

        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.inbox_rounded,
                    size: 60, color: Colors.grey.shade400),
                const SizedBox(height: 10),
                Text(
                  "No notices yet",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ctrl.fetchNotices(),
          child: ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final n = list[index];
              final pc = _priorityColor(n.priority);
              final ac = _audienceColor(n.audience);

              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () async {
                  await Get.to(() =>
                      TeacherAssignDetailsScreen(notice: n));
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
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (n.isPinned) ...[
                                      const Icon(Icons.push_pin_rounded,
                                          size: 14,
                                          color: Colors.orange),
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
                                        overflow:
                                        TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  n.displayDate,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600]),
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
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[800]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _tag(n.priority, pc),
                          _tag(n.audience, ac,
                              icon: Icons.groups_rounded),
                          _tag(n.assignedClass, Colors.grey.shade600,
                              icon: Icons.class_rounded),
                          if (n.hasAttachment)
                            _tag(
                              n.attachmentType == "image"
                                  ? "Image"
                                  : "PDF",
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
            },
          ),
        );
      }),
    );
  }

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
                fontSize: 10, color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}