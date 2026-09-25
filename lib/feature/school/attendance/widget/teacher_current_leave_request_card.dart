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

  // ================= PRIMARY COLOR =================
  static const Color _primary = Colors.indigo;
  static const Color _primaryDark = Color(0xFF283593);
  static const Color _primaryLight = Color(0xFFE8EAF6);

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

  // ================= STATUS HELPERS =================
  String _status(TeacherLeaveModel leave) {
    // Example: return leave.status ?? 'Pending';
    return 'Pending';
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'ignored':
        return Colors.grey;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      case 'ignored':
        return Icons.visibility_off_rounded;
      default:
        return Icons.hourglass_top_rounded;
    }
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: _primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.event_note_rounded,
                      size: 15, color: _primary),
                ),
                const SizedBox(width: 10),
                const Text(
                  "My Leave",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: _openNewRequest,
              icon: const Icon(Icons.add, size: 16, color: Colors.white),
              label: const Text(
                "New",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Center(
        child: SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
              strokeWidth: 2, color: _primary),
        ),
      ),
    );
  }

  // ────────────────────────────  EMPTY STATE
  Widget _buildEmptyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.event_available_outlined,
                size: 32, color: _primary),
          ),
          const SizedBox(height: 12),
          const Text(
            "No leave requests yet",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tap 'New' to apply for leave",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────  SINGLE LEAVE CARD (MATCHED WITH LIST SCREEN)
  Widget _buildSingleLeaveCard(TeacherLeaveModel leave) {
    final isFullDay = leave.applyStatus;
    final typeColor =
    isFullDay ? const Color(0xFF2563EB) : const Color(0xFFEA580C);
    final typeText = isFullDay ? "Full Day" : "Half Day";
    final typeIcon = isFullDay ? Icons.wb_sunny : Icons.brightness_2;

    final status = _status(leave);
    final statusColor = _statusColor(status);

    return GestureDetector(
      onTap: _openList,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border:
          Border.all(color: statusColor.withOpacity(0.25), width: 1.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: avatar + Leave # + status badge
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'T',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Leave #${leave.id ?? '-'}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.indigo.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                typeText,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.indigo,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Status badge
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border:
                      Border.all(color: statusColor.withOpacity(0.35)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_statusIcon(status),
                            size: 11, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Info box
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(typeIcon, size: 14, color: typeColor),
                        const SizedBox(width: 6),
                        Text(
                          typeText,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.calendar_today_rounded,
                            size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            _formatDateRange(
                                leave.startDate, leave.endDate),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (leave.reasonMsg != null &&
                        leave.reasonMsg!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.notes_rounded,
                              size: 13, color: Colors.grey[500]),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              leave.reasonMsg!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (leave.createdDate != null &&
                        leave.createdDate!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded,
                              size: 12, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            'Applied on: ${_formatCreatedDate(leave.createdDate)}',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Image
              if (leave.image != null && leave.image!.isNotEmpty) ...[
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
                                    strokeWidth: 2, color: _primary),
                              ),
                            ),
                          );
                        },
                      ),
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
            ],
          ),
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