// lib/feature/school/leave/widget/teacher_current_leave_request_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  final teacherLeaveController = Get.find<TeacherLeaveController>();

  static const Color _primary = Colors.indigo;
  static const Color _primaryDark = Color(0xFF283593);
  static const Color _primaryLight = Color(0xFFE8EAF6);

  @override
  void initState() {
    super.initState();
    _loadLeaves();
  }

  /// ✅ No param — controller reads teacher_id from SharedPrefs
  Future<void> _loadLeaves() async {
    await teacherLeaveController.fetchLeavesByTeacherId();
  }

  Future<void> _openNewRequest() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TeacherLeaveFormScreen(),
      ),
    );
    if (result == true) {
      await teacherLeaveController.fetchLeavesByTeacherId(forceRefresh: true);
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
  /// ✅ Model's statusLabel: 'Approved' / 'Rejected' / 'Pending'
  String _status(TeacherLeaveModel leave) => leave.statusLabel;

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
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
      default:
        return Icons.hourglass_top_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──
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

        // ── Body ──
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
          child:
          CircularProgressIndicator(strokeWidth: 2, color: _primary),
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
            decoration: const BoxDecoration(
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

  // ────────────────────────────  SINGLE LEAVE CARD
  Widget _buildSingleLeaveCard(TeacherLeaveModel leave) {
    // ✅ Multi/Single Day from totalDays (no more apply_status as bool)
    final multiDay = leave.isMultiDay;
    final typeColor = multiDay
        ? const Color(0xFF2563EB)
        : const Color(0xFFEA580C);
    final typeText = multiDay ? "Multi Day" : "Single Day";
    final typeIcon = multiDay ? Icons.date_range : Icons.wb_sunny;

    final status = _status(leave);
    final statusColor = _statusColor(status);

    // ✅ Teacher avatar from nested teacher
    final hasProfile = (leave.teacherProfile ?? '').isNotEmpty;

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
              // ── Header row ──
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(10),
                      image: hasProfile
                          ? DecorationImage(
                        image: NetworkImage(leave.teacherProfile!),
                        fit: BoxFit.cover,
                        onError: (_, __) {},
                      )
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: !hasProfile
                        ? Text(
                      leave.teacherDisplayName.isNotEmpty
                          ? leave.teacherDisplayName[0].toUpperCase()
                          : 'T',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _primary,
                      ),
                    )
                        : null,
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
                            if ((leave.schoolName ?? '').isNotEmpty) ...[
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  leave.schoolName!,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
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

              // ── Info box ──
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
                    if ((leave.reasonMsg ?? '').isNotEmpty) ...[
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
                    if ((leave.createdDate ?? '').isNotEmpty) ...[
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

              // ── Image ──
              if ((leave.image ?? '').isNotEmpty) ...[
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