// lib/feature/school/student_leave/screen/student_leave_details_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/student_leave_controller.dart';
import '../model/student_leave_list_model.dart';
import 'student_leave_form_screen.dart';

class StudentLeaveDetailsScreen extends StatefulWidget {
  final int leaveId;
  final StudentLeaveData? initialData;

  const StudentLeaveDetailsScreen({
    super.key,
    required this.leaveId,
    this.initialData,
  });

  @override
  State<StudentLeaveDetailsScreen> createState() =>
      _StudentLeaveDetailsScreenState();
}

class _StudentLeaveDetailsScreenState
    extends State<StudentLeaveDetailsScreen> {
  final controller = Get.find<StudentLeaveController>();

  StudentLeaveData? _leave;

  static const Color _primary = Colors.indigo;

  @override
  void initState() {
    super.initState();
    _leave = widget.initialData;
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    final data = await controller.getLeaveById(widget.leaveId);
    if (!mounted) return;
    if (data != null) {
      setState(() => _leave = data);
    }
  }

  // ═══════════════════════════════════════════════
  // DELETE
  // ═══════════════════════════════════════════════
  Future<void> _confirmDelete() async {
    if (_leave == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        title: const Text(
          'Delete Leave?',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to delete this leave request? '
              'This action cannot be undone.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final ok = await controller.deleteLeave(_leave!);

    if (!mounted) return;

    if (ok) {
      Navigator.pop(context, true); // list screen ko signal
    }
  }

  // ═══════════════════════════════════════════════
  // EDIT — FormScreen open karo (reuse)
  // ═══════════════════════════════════════════════
  Future<void> _openEditScreen() async {
    if (_leave == null) return;

    final result = await Get.to<bool>(
          () => StudentLeaveFormScreen(editLeave: _leave),
    );

    if (result == true) {
      await _loadDetail();
    }
  }

  // ═══════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: _primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Leave Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          // 🔹 Pending hone par hi edit/delete
          if (_leave != null && _leave!.isPending) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.white),
              onPressed: _openEditScreen,
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: _confirmDelete,
              tooltip: 'Delete',
            ),
          ],
        ],
      ),
      body: Obx(() {
        if (controller.isFetchingDetail.value && _leave == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_leave == null) {
          return const Center(
            child: Text(
              'Leave not found',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          );
        }

        return _buildBody(_leave!);
      }),
    );
  }

  Widget _buildBody(StudentLeaveData leave) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusBanner(leave),
          const SizedBox(height: 16),
          _buildInfoCard(leave),
          if (leave.hasImage) ...[
            const SizedBox(height: 16),
            _buildImageCard(leave.image!),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(StudentLeaveData leave) {
    final status = leave.displayStatus;
    final color = _statusColor(status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.35), width: 1.2),
      ),
      child: Row(
        children: [
          Icon(_statusIcon(status), color: color, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Leave #${leave.id}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(StudentLeaveData leave) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Leave Information',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 14),
          _row(Icons.person_outline_rounded, 'Student', leave.studentName),
          _divider(),
          _row(Icons.badge_outlined, 'Student ID Card',
              leave.studentIdCard),
          _divider(),
          _row(Icons.class_outlined, 'Class', leave.studentClass),
          _divider(),
          _row(Icons.calendar_today_rounded, 'Start Date',
              leave.formattedStartDate),
          _divider(),
          _row(Icons.calendar_today_rounded, 'End Date',
              leave.formattedEndDate),
          _divider(),
          _row(Icons.notes_rounded, 'Reason',
              leave.reasonMsg.isEmpty ? '-' : leave.reasonMsg),
          _divider(),
          _row(Icons.access_time_rounded, 'Applied On',
              leave.formattedCreatedDate),
          if (leave.teacherName != null &&
              leave.teacherName!.isNotEmpty) ...[
            _divider(),
            _row(Icons.verified_user_outlined, 'Reviewed By',
                leave.teacherName!),
          ],
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(
    height: 1,
    color: Colors.grey.shade100,
  );

  Widget _buildImageCard(String imageUrl) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
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
              Icon(Icons.image_outlined,
                  size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              const Text(
                'Attachment',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: Colors.grey.shade200,
                child: const Center(child: Icon(Icons.broken_image)),
              ),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 200,
                  color: Colors.grey.shade100,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

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
}