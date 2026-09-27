import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/notice_controller.dart';
import '../model/notice_model.dart';
import '../screen/teacher_assign_details_screen.dart';

class NoticePinedCard extends StatelessWidget {
  const NoticePinedCard({super.key});

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

    return Obx(() {
      // 🔑 Pick the FIRST pinned notice from the list
      final pinnedList =
      ctrl.notices.where((n) => n.isPinned).toList();
      if (pinnedList.isEmpty) return const SizedBox.shrink();

      // Sort by newest first (in case multiple pinned)
      pinnedList.sort((a, b) => b.id.compareTo(a.id));
      final n = pinnedList.first;

      final pc = _priorityColor(n.priority);
      final ac = _audienceColor(n.audience);

      return Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Colors.red,width: 0.3),
        ),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.notifications_active_outlined,
                      color: Colors.indigo,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔑 Main header line — audience + class
                        Text(
                          "Notice for ${n.audience} • ${n.assignedClass}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        // 🔑 Sub header — priority + date
                        Text(
                          "${n.priority} priority • ${n.displayDate}",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Optional: small indicator if attachment exists
                  if (n.hasAttachment)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.notifications_active_outlined,color: Colors.red,),
                    ),
                ],
              ),
            ),
            Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              color: Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                 // optional: open detail screen
                  Get.to(() => TeacherAssignDetailsScreen(notice: n));
                  ctrl.fetchNotices(silent: true);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ====== TOP ROW: PIN + PRIORITY + DATE ======
                      Row(
                        children: [
                          // Pinned badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.push_pin_rounded,
                                    size: 11, color: Colors.orange),
                                SizedBox(width: 4),
                                Text(
                                  "PINNED",
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.orange,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Priority chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: pc.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(_priorityIcon(n.priority),
                                    size: 11, color: pc),
                                const SizedBox(width: 4),
                                Text(
                                  n.priority,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: pc,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ====== TITLE ======
                      Text(
                        n.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // ====== DESCRIPTION ======
                      Text(
                        n.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 10),

                      // ====== BOTTOM ROW: TAGS + DATE ======
                      Row(
                        children: [
                          _tag(n.audience, ac, icon: Icons.groups_rounded),
                          const SizedBox(width: 6),
                          _tag(n.assignedClass, Colors.grey.shade600,
                              icon: Icons.class_rounded),
                          if (n.hasAttachment) ...[
                            const SizedBox(width: 6),
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
                          const Spacer(),
                          Text(
                            n.displayDate,
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),        ],
        ),
      );
    });
  }

  Widget _tag(String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: color),
            const SizedBox(width: 3),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 9.5,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}