import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../controller/notice_controller.dart';
import '../model/notice_model.dart';
import 'teacher_assign_notice_form_screen.dart';

class TeacherAssignDetailsScreen extends StatefulWidget {
  final NoticeModel notice;
  const TeacherAssignDetailsScreen({super.key, required this.notice});

  @override
  State<TeacherAssignDetailsScreen> createState() =>
      _TeacherAssignDetailsScreenState();
}

class _TeacherAssignDetailsScreenState
    extends State<TeacherAssignDetailsScreen> {
  final _ctrl = Get.find<NoticeController>();
  late NoticeModel _notice;

  @override
  void initState() {
    super.initState();
    _notice = widget.notice;
  }

  // ==================== HELPERS ====================
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

  // ==================== ATTACHMENT ====================
  Future<void> _openAttachment() async {
    if (!_notice.hasAttachment) return;
    final uri = Uri.parse(_notice.attachmentUrl!);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        FlutterToast.error("Cannot open attachment");
      }
    } catch (_) {
      FlutterToast.error("Error opening attachment");
    }
  }

  void _openFullImage() {
    Get.to(() => Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _notice.attachmentName,
          style: const TextStyle(fontSize: 14),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5, maxScale: 5,
          child: Image.network(
            _notice.attachmentUrl!,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
            },
            errorBuilder: (_, __, ___) => const Icon(
              Icons.broken_image_rounded, color: Colors.white, size: 40,
            ),
          ),
        ),
      ),
    ));
  }

  // ==================== ACTIONS ====================
  Future<void> _delete() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Notice?"),
        content: Text("Delete \"${_notice.title}\"?",
            style: const TextStyle(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Get.back(result: true),
            child: const Text("Delete",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    final ok = await _ctrl.deleteNotice(_notice.id);
    if (ok) {
      FlutterToast.success("Notice deleted");
      Get.back(result: true);
    } else {
      FlutterToast.error(_ctrl.error.value);
    }
  }

  Future<void> _edit() async {
    await Get.to(() => TeacherAssignNoticeFormScreen(notice: _notice));
    // refetch latest from store
    final fresh = _ctrl.notices.firstWhereOrNull(
          (n) => n.id == _notice.id,
    );
    if (fresh != null) setState(() => _notice = fresh);
  }

  Future<void> _togglePin() async {
    final ok = await _ctrl.togglePin(_notice.id);
    if (ok) {
      final fresh = _ctrl.notices.firstWhereOrNull(
            (n) => n.id == _notice.id,
      );
      if (fresh != null) setState(() => _notice = fresh);
    } else {
      FlutterToast.error(_ctrl.error.value);
    }
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    final pc = _priorityColor(_notice.priority);
    final ac = _audienceColor(_notice.audience);

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
          "Notice Details",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        actions: [
          InkWell(
            onTap: _togglePin,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 0.3),
              ),
              child: Icon(size: 20,
                _notice.isPinned
                    ? Icons.push_pin_rounded
                    : Icons.push_pin_outlined,
                color: _notice.isPinned ? Colors.orange : Colors.white,
              ),
            ),
          ),
          SizedBox(width: 20,),
          InkWell(
            onTap: _edit,
            child:  Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 0.3),
                ),
                child: Icon(Icons.edit_rounded, size: 20,)),
          ),
          SizedBox(width: 20,),
          InkWell(
            onTap: _delete,
            child:  Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 0.3),
                ),
                child: Icon(Icons.delete_outline_rounded, size: 20,)),
          ),
          SizedBox(width: 20,),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Priority header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: pc.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: pc.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: pc.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(_priorityIcon(_notice.priority),
                        color: pc, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _notice.priority.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: pc,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(_notice.displayDate,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700])),
                      ],
                    ),
                  ),
                  if (_notice.isPinned)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.push_pin_rounded,
                              size: 12, color: Colors.orange),
                          SizedBox(width: 4),
                          Text(
                            "Pinned",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(_notice.title,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800, height: 1.3)),
            const SizedBox(height: 16),

            Wrap(
              spacing: 8, runSpacing: 8,
              children: [
                _infoChip(Icons.groups_rounded, _notice.audience, ac),
                _infoChip(Icons.class_rounded, _notice.assignedClass,
                    Colors.indigo),
                _infoChip(Icons.person_rounded, _notice.createdBy,
                    Colors.blueGrey),
              ],
            ),
            const SizedBox(height: 22),

            const Text("Description",
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(_notice.description,
                  style: const TextStyle(fontSize: 13, height: 1.5)),
            ),

            if (_notice.hasAttachment) ...[
              const SizedBox(height: 22),
              const Text("Attachment",
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              _buildAttachmentPreview(),
            ],

            const SizedBox(height: 22),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _metaRow("Notice ID", "#${_notice.id}"),
                  const Divider(height: 18),
                  _metaRow("Created By", _notice.createdBy),
                  const Divider(height: 18),
                  _metaRow("Created At", _notice.createdAt),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _delete,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: const Text("Delete",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _edit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.edit_rounded,
                        color: Colors.white, size: 18),
                    label: const Text("Edit",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentPreview() {
    if (_notice.attachmentType == "image") {
      return GestureDetector(
        onTap: _openFullImage,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.network(
                _notice.attachmentUrl!,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    height: 180, width: double.infinity,
                    color: Colors.grey.shade100,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  height: 180, width: double.infinity,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Icons.broken_image_rounded,
                        size: 40, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                right: 8, bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.zoom_in_rounded,
                          size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text("Tap to zoom",
                          style: TextStyle(
                              fontSize: 10, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: _openAttachment,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.picture_as_pdf_rounded,
                  color: Colors.red, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_notice.attachmentName,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text("Tap to open PDF",
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey[600])),
                ],
              ),
            ),
            const Icon(Icons.open_in_new_rounded,
                color: Colors.indigo, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 6),
          Text(text,
              style: TextStyle(
                  fontSize: 11, color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _metaRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}