import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../profile/controller/teacher_controller.dart';
import '../controller/teacher_leave_controller.dart';
import '../model/teacher_leave_model.dart';
import '../screen/teacher_leave_form_screen.dart';
import '../screen/teacher_leave_list_screen.dart';

class TeacherCurrentLeaveRequestCard extends StatefulWidget {
  const TeacherCurrentLeaveRequestCard({super.key});

  @override
  State<TeacherCurrentLeaveRequestCard> createState() =>
      _TeacherCurrentLeaveRequestCardState();
}

class _TeacherCurrentLeaveRequestCardState
    extends State<TeacherCurrentLeaveRequestCard> {
  final teacherController = Get.find<TeacherController>();
  final teacherLeaveController = Get.find<TeacherLeaveController>();

  @override
  void initState() {
    super.initState();
    _loadLeaves();
  }

  Future<void> _loadLeaves() async {
    final idCard = teacherController.teacherIdCard;
    if (idCard.isNotEmpty) {
      await teacherLeaveController.fetchLeavesByTeacherIdCard(idCard);
    }
  }

  Future<void> _openNewRequest() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TeacherLeaveFormScreen(),
      ),
    );
    if (result == true) {
      await teacherLeaveController.fetchLeavesByTeacherIdCard(
        teacherController.teacherIdCard,
        forceRefresh: true,
      );
    }
  }

  Future<void> _openList() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TeacherLeaveListScreen(),
      ),
    );
    _loadLeaves();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "My Leave",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _openNewRequest,
              icon: const Icon(Icons.add, size: 16, color: Colors.white),
              label: const Text(
                "New Request",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Body
        Obx(() {
          if (teacherLeaveController.isLoading.value &&
              teacherLeaveController.leaves.isEmpty) {
            return _skeletonBox();
          }

          if (teacherLeaveController.leaves.isEmpty) {
            return _buildEmptyCard();
          }

          final leave = teacherLeaveController.leaves.first;
          return _buildSingleLeaveCard(leave);
        }),
      ],
    );
  }

  // ────────────────────────────  SKELETON
  Widget _skeletonBox() {
    return Container(
      width: double.infinity,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Center(
        child: SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  // ────────────────────────────  EMPTY STATE
  Widget _buildEmptyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.event_available_outlined,
              size: 40, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            "No leave requests yet",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tap 'New Request' to apply for leave",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────  SINGLE LEAVE CARD
  Widget _buildSingleLeaveCard(TeacherLeaveModel leave) {
    final isFullDay = leave.applyStatus;
    final accent =
    isFullDay ? const Color(0xFF2563EB) : const Color(0xFFEA580C);
    final accentBg =
    isFullDay ? const Color(0xFFDBEAFE) : const Color(0xFFFFEDD5);
    final typeText = isFullDay ? "Full Day" : "Half Day";
    final typeIcon = isFullDay ? Icons.wb_sunny : Icons.brightness_2;
    final hasImage = leave.image != null && leave.image!.isNotEmpty;

    return GestureDetector(
      onTap: _openList,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top strip
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: accentBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(typeIcon, size: 18, color: accent),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              typeText,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: accent,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Leave #${leave.id ?? '-'}",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 14, color: Colors.grey.shade400),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
                  const SizedBox(height: 12),

                  // Dates
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 13, color: Colors.blue.shade700),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _formatDateRange(leave.startDate, leave.endDate),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // Reason
                  if (leave.reasonMsg != null &&
                      leave.reasonMsg!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.notes,
                            size: 13, color: Colors.grey.shade600),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            leave.reasonMsg!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // 👇 IMAGE (new)
                  if (hasImage) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Image.network(
                            leave.image!,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 140,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(Icons.broken_image,
                                    color: Colors.grey),
                              ),
                            ),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                height: 140,
                                color: Colors.grey.shade100,
                                child: const Center(
                                  child: SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                ),
                              );
                            },
                          ),
                          // Attachment badge
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.attachment,
                                      size: 11, color: Colors.white),
                                  SizedBox(width: 3),
                                  Text(
                                    "Attachment",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Created date
                  if (leave.createdDate != null &&
                      leave.createdDate!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.schedule,
                            size: 11, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          _formatCreatedDate(leave.createdDate),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
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

  // ────────────────────────────  HELPERS
  String _formatDateRange(String start, String end) {
    try {
      final s = DateTime.parse(start);
      final e = DateTime.parse(end);
      if (s.year == e.year && s.month == e.month && s.day == e.day) {
        return DateFormat('dd MMM yyyy').format(s);
      }
      return '${DateFormat('dd MMM').format(s)} - ${DateFormat('dd MMM yyyy').format(e)}';
    } catch (_) {
      return '$start - $end';
    }
  }

  String _formatCreatedDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final d = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(d);
    } catch (_) {
      return dateStr;
    }
  }
}