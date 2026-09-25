import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/widget/contact_helper.dart';
import '../controller/transport_controller.dart';
import '../model/transport_model.dart';


class TransportDetailScreen extends StatefulWidget {
  final TransportModel transport;

  const TransportDetailScreen({super.key, required this.transport});

  @override
  State<TransportDetailScreen> createState() => _TransportDetailScreenState();
}

class _TransportDetailScreenState extends State<TransportDetailScreen> {
  static const Color _primary = Colors.indigo;
  static const Color _primaryLight = Color(0xFFE8EAF6);

  late TransportController _transportController;
  late TransportModel transport;

  @override
  void initState() {
    super.initState();
    transport = widget.transport;
    _transportController = Get.find<TransportController>();
  }

  // ==================== CONFIRM + DELETE ====================
  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.delete_forever_rounded,
                  color: Colors.red.shade600, size: 20),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Delete Transport?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete '
              '"${transport.routeName ?? transport.vehicleNumber}"?\n\n'
              'This will also remove all assigned students from this transport. '
              'This action cannot be undone.',
          style: const TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            icon: const Icon(Icons.delete_rounded, size: 16),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success =
      await _transportController.deleteTransport(transport.id);
      if (success && mounted) {
        // Return true so caller can refresh list
        Navigator.pop(context, true);
      }
    }
  }

  // ==================== CONFIRM + REMOVE STUDENT ====================
  Future<void> _confirmRemoveStudent(StudentData student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.person_remove_rounded,
                  color: Colors.red.shade600, size: 20),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Remove Student?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to remove '
              '"${student.studentName}" (ID: ${student.studentId}) from this transport?',
          style: const TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            icon: const Icon(Icons.delete_rounded, size: 16),
            label: const Text('Remove'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _transportController.removeStudentFromTransport(
        transportId: transport.id,
        studentId: student.studentId,
      );

      if (success && mounted) {
        setState(() {
          transport = transport.copyWith(
            students: transport.students
                .where((s) => s.studentId != student.studentId)
                .toList(),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transport.routeName ?? 'Transport Route',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              'Vehicle: ${transport.vehicleNumber}',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDriverCard(),
                  const SizedBox(height: 20),
                  _buildStudentList(transport.students),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          Obx(() {
            final deleting = _transportController.isDeleting.value;
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: OutlinedButton.icon(
                onPressed: deleting ? null : _confirmDelete,
                icon: deleting
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.red,
                  ),
                )
                    : const Icon(Icons.delete_outline_rounded, size: 18),
                label: Text(deleting ? 'Deleting...' : 'Delete Transport'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.red.shade300),
                  foregroundColor: Colors.red.shade700,
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ==================== DRIVER CARD ====================
  Widget _buildDriverCard() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person_rounded,
                  color: Colors.white, size: 14),
            ),
            const SizedBox(width: 8),
            const Text(
              'Driver Details',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _primaryLight.withOpacity(0.4),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _primary.withOpacity(0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: _primary, width: 2),
                    ),
                    child: transport.driverImage != null &&
                        transport.driverImage!.isNotEmpty
                        ? ClipOval(
                      child: Image.network(
                        transport.driverImage!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            size: 32,
                            color: _primary),
                      ),
                    )
                        : const Icon(Icons.person,
                        size: 32, color: _primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transport.driverName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _driverInfoRow(
                            Icons.phone_rounded, transport.driverNumber),
                        if (transport.capacity != null &&
                            transport.capacity!.isNotEmpty)
                          _driverInfoRow(Icons.person_outline,
                              'Capacity: ${transport.capacity}'),
                        if (transport.schoolType != null &&
                            transport.schoolType!.isNotEmpty)
                          _driverInfoRow(
                              Icons.school_rounded, transport.schoolType!),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          ContactHelper.call(transport.driverNumber),
                      icon: const Icon(Icons.call_rounded, size: 16),
                      label: const Text('Call'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: Colors.green.shade300),
                        foregroundColor: Colors.green.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => ContactHelper.whatsapp(
                          transport.driverNumber,
                          'Hello, I need assistance with my transport service.'),
                      icon: const Icon(Icons.chat_rounded, size: 16),
                      label: const Text('WhatsApp'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: const BorderSide(color: Color(0xFF25D366)),
                        foregroundColor: const Color(0xFF25D366),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _driverInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 13, color: _primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== STUDENT LIST ====================
  Widget _buildStudentList(List<StudentData> students) {
    if (students.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_off_outlined,
                    size: 32, color: _primary),
              ),
              const SizedBox(height: 10),
              const Text(
                'No students assigned',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: _primaryLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.school_rounded,
                  size: 12, color: _primary),
            ),
            const SizedBox(width: 8),
            Text(
              'Assigned Students (${students.length})',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: students.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return _buildStudentTile(students[index]);
          },
        ),
      ],
    );
  }

  Widget _buildStudentTile(StudentData student) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    student.studentName.isNotEmpty
                        ? student.studentName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.studentName.isNotEmpty
                          ? student.studentName
                          : 'Unknown Student',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID: ${student.studentId.isNotEmpty ? student.studentId : 'N/A'}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (student.address != null && student.address!.isNotEmpty)
                      Text(
                        'Address: ${student.address}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // ==================== TIME BADGES ====================
              Column(
                spacing: 4,
                children: [
                  if (student.pickupTime != null &&
                      student.pickupTime!.isNotEmpty) ...[
                    _buildTimeBadge(
                      Icons.arrow_upward_rounded,
                      student.pickupTime!,
                      Colors.green,
                    ),
                    const SizedBox(width: 6),
                  ],
                  if (student.dropTime != null &&
                      student.dropTime!.isNotEmpty) ...[
                    _buildTimeBadge(
                      Icons.arrow_downward_rounded,
                      student.dropTime!,
                      Colors.orange,
                    ),
                  ],
                ],
              ),
              const SizedBox(width: 14),
            ],
          ),
        ),
        Positioned(
          top:-10,right: -10,
          child: Obx(() {
            final removing =
            _transportController.isRemovingStudent(student.studentId);
            return IconButton(
              onPressed: removing
                  ? null
                  : () => _confirmRemoveStudent(student),
              tooltip: 'Remove Student',
              icon: removing
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.red,
                ),
              )
                  : Icon(
                Icons.delete_outline_rounded,
                size: 20,
                color: Colors.red.shade400,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 36,
                minHeight: 36,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTimeBadge(IconData icon, String time, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            time,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}