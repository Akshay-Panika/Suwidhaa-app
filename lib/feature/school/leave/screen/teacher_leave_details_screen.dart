// lib/feature/school/leave/screen/teacher_leave_details_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/widget/flutter_toast.dart';
import '../controller/teacher_leave_controller.dart';
import '../model/teacher_leave_model.dart';
import 'teacher_leave_form_screen.dart';

class TeacherLeaveDetailsScreen extends StatefulWidget {
  final TeacherLeaveModel leave;
  const TeacherLeaveDetailsScreen({super.key, required this.leave});

  @override
  State<TeacherLeaveDetailsScreen> createState() =>
      _TeacherLeaveDetailsScreenState();
}

class _TeacherLeaveDetailsScreenState
    extends State<TeacherLeaveDetailsScreen> {
  final controller = Get.find<TeacherLeaveController>();

  late TeacherLeaveModel _leave;
  bool _changed = false;

  static const Color _primary = Colors.indigo;

  @override
  void initState() {
    super.initState();
    _leave = widget.leave;
  }

  // ── Status helpers ──
  Color _statusColor(String s) {
    switch (s.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _statusIcon(String s) {
    switch (s.toLowerCase()) {
      case 'approved':
        return Icons.check_circle_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      default:
        return Icons.hourglass_top_rounded;
    }
  }

  // ── Actions ──
  Future<void> _openEdit() async {
    final result = await Get.to(
          () => TeacherLeaveFormScreen(existing: _leave),
    );
    if (result == true) {
      final fresh = await controller.fetchById(_leave.id!);
      if (fresh != null && mounted) {
        setState(() {
          _leave = fresh;
          _changed = true;
        });
      }
    }
  }

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Leave?"),
        content: const Text(
          "This will permanently delete this leave request. This action cannot be undone.",
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child:
            const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final success = await controller.deleteLeave(_leave.id!);
    if (success && mounted) {
      FlutterToast.success('Leave deleted');
      Get.back(result: true);
    }
  }

  Future<void> _updateStatus(String status) async {
    final ok = await controller.updateLeaveStatus(
      id: _leave.id!,
      status: status,
    );
    if (ok) {
      final fresh = await controller.fetchById(_leave.id!);
      if (fresh != null && mounted) {
        setState(() {
          _leave = fresh;
          _changed = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _leave.statusLabel;
    final statusColor = _statusColor(status);
    final canModerate = _leave.isPending;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(result: _changed),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          "Leave Details",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        actions: [
          IconButton(
            onPressed: _openEdit,
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
          ),
          IconButton(
            onPressed: _confirmDelete,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Status header ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [statusColor, statusColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_statusIcon(status),
                        color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          status.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Leave #${_leave.id ?? '-'}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Teacher card ──
            _buildSectionTitle('Teacher'),
            const SizedBox(height: 8),
            _buildTeacherCard(),
            const SizedBox(height: 20),

            // ── Date range ──
            _buildSectionTitle('Duration'),
            const SizedBox(height: 8),
            _buildSection(
              icon: Icons.date_range_rounded,
              iconColor: Colors.indigo,
              title: 'From → To',
              value:
              '${_formatDate(_leave.startDate)} → ${_formatDate(_leave.endDate)}',
              trailing: _leave.isMultiDay
                  ? '${_leave.totalDays} days'
                  : '1 day',
            ),
            const SizedBox(height: 20),

            // ── Reason ──
            if ((_leave.reasonMsg ?? '').isNotEmpty) ...[
              _buildSectionTitle('Reason'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  _leave.reasonMsg!,
                  style: const TextStyle(fontSize: 13, height: 1.5),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // ── Attachment ──
            if ((_leave.image ?? '').isNotEmpty) ...[
              _buildSectionTitle('Attachment'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showFullImage(_leave.image!),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _leave.image!,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 220,
                      color: Colors.grey.shade200,
                      child: const Center(
                          child: Icon(Icons.broken_image, size: 40)),
                    ),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 220,
                        color: Colors.grey.shade100,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // ── Metadata ──
            _buildSectionTitle('Info'),
            const SizedBox(height: 8),
            _buildSection(
              icon: Icons.access_time_rounded,
              iconColor: Colors.grey.shade700,
              title: 'Applied on',
              value: _formatDateTime(_leave.createdDate),
            ),

            const SizedBox(height: 30),

            // ── Quick approve / reject for pending ──
            if (canModerate) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _updateStatus('rejected'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: BorderSide(color: Colors.red.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.close_rounded,
                          color: Colors.red[600], size: 18),
                      label: Text("Reject",
                          style: TextStyle(
                              color: Colors.red[600],
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _updateStatus('approved'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.check_rounded,
                          color: Colors.white, size: 18),
                      label: const Text("Approve",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            // ── Edit + Delete ──
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _openEdit,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: const BorderSide(color: Colors.indigo),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.edit,
                        color: Colors.indigo, size: 18),
                    label: const Text("Edit",
                        style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() {
                    final deleting = controller.isLoading.value;
                    return OutlinedButton.icon(
                      onPressed: deleting ? null : _confirmDelete,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: BorderSide(color: Colors.red.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: deleting
                          ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.red),
                      )
                          : Icon(Icons.delete_outline,
                          color: Colors.red[600], size: 18),
                      label: Text(
                        deleting ? "Deleting…" : "Delete",
                        style: TextStyle(
                            color: Colors.red[600],
                            fontWeight: FontWeight.w600),
                      ),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Row(
    children: [
      Container(
        width: 4,
        height: 14,
        decoration: BoxDecoration(
          color: _primary,
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

  Widget _buildTeacherCard() {
    final hasProfile = (_leave.teacherProfile ?? '').isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.indigo.withOpacity(0.12),
            backgroundImage:
            hasProfile ? NetworkImage(_leave.teacherProfile!) : null,
            child: !hasProfile
                ? Text(
              _leave.teacherDisplayName.isNotEmpty
                  ? _leave.teacherDisplayName[0].toUpperCase()
                  : 'T',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _primary,
              ),
            )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _leave.teacherDisplayName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if ((_leave.teacherIdCard).isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.badge_rounded,
                          size: 11, color: Colors.grey[600]),
                      const SizedBox(width: 3),
                      Text(
                        _leave.teacherIdCard,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
                if ((_leave.schoolName ?? '').isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.school_rounded,
                          size: 11, color: Colors.grey[600]),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          _leave.schoolName!,
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
    );
  }

  Widget _buildSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    String? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                  TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                trailing,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.indigo,
                ),
              ),
            ),
        ],
      ),
    );
  }

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

  String _formatDate(String iso) {
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;
    return DateFormat('dd MMM yyyy').format(d);
  }

  String _formatDateTime(String? iso) {
    if (iso == null || iso.isEmpty) return '-';
    try {
      final d = DateTime.parse(iso).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(d);
    } catch (_) {
      return iso;
    }
  }
}