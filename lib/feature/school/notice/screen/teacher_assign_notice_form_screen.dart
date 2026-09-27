import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../controller/notice_controller.dart';
import '../model/notice_model.dart';

class TeacherAssignNoticeFormScreen extends StatefulWidget {
  final NoticeModel? notice; // null = create, not null = update
  const TeacherAssignNoticeFormScreen({super.key, this.notice});

  @override
  State<TeacherAssignNoticeFormScreen> createState() =>
      _TeacherAssignNoticeFormScreenState();
}

class _TeacherAssignNoticeFormScreenState
    extends State<TeacherAssignNoticeFormScreen> {
  final _ctrl = Get.find<NoticeController>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String _priority = "Normal";
  String _selectedClass = "All Classes";
  String _selectedAudience = "Students";
  bool _pinNotice = false;

  // Attachment state
  PlatformFile? _pickedFile;   // newly picked file
  String? _existingUrl;        // from server (edit mode)
  String? _existingName;
  String? _existingType;       // "image" | "pdf"
  bool _removeExisting = false;

  final List<String> _classes = [
    "All Classes", "Class 10 - A", "Class 10 - B",
    "Class 9 - A", "Class 9 - B", "Class 8 - A",
  ];
  final List<String> _audiences = ["Students", "Parents", "Both", "Staff"];

  bool get isEdit => widget.notice != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final n = widget.notice!;
      _titleCtrl.text = n.title;
      _descCtrl.text = n.description;
      _priority = n.priority;
      _selectedClass = n.assignedClass;
      _selectedAudience = n.audience;
      _pinNotice = n.isPinned;
      if (n.hasAttachment) {
        _existingUrl = n.attachmentUrl;
        _existingName = n.attachmentName;
        _existingType = n.attachmentType;
      }
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
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

  // ==================== FILE PICKERS ====================
  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
          type: FileType.image, allowMultiple: false);
      if (result != null && result.files.single.path != null) {
        setState(() {
          _pickedFile = result.files.single;
          _removeExisting = false;
        });
      }
    } catch (_) {
      FlutterToast.error("Failed to pick image");
    }
  }

  Future<void> _pickPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          allowMultiple: false);
      if (result != null && result.files.single.path != null) {
        setState(() {
          _pickedFile = result.files.single;
          _removeExisting = false;
        });
      }
    } catch (_) {
      FlutterToast.error("Failed to pick PDF");
    }
  }

  void _removeAttachment() {
    setState(() {
      if (_pickedFile != null) {
        _pickedFile = null;
      } else if (_existingUrl != null) {
        _removeExisting = true;
      }
    });
  }

  void _showAttachmentSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Attach File",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(Icons.image_rounded, color: Colors.blue),
              ),
              title: const Text("Pick Image"),
              subtitle: const Text("JPG, PNG, GIF"),
              onTap: () { Navigator.pop(context); _pickImage(); },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFFEBEE),
                child: Icon(Icons.picture_as_pdf_rounded, color: Colors.red),
              ),
              title: const Text("Pick PDF"),
              subtitle: const Text("PDF document"),
              onTap: () { Navigator.pop(context); _pickPdf(); },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // ==================== SUBMIT ====================
  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty) {
      FlutterToast.warning("Please enter a notice title");
      return;
    }
    if (_descCtrl.text.trim().isEmpty) {
      FlutterToast.warning("Please enter notice description");
      return;
    }

    bool ok;

    if (isEdit) {
      ok = await _ctrl.updateNotice(
        id: widget.notice!.id,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        priority: _priority,
        audience: _selectedAudience,
        assignedClass: _selectedClass,
        isPinned: _pinNotice,
        createdBy: widget.notice!.createdBy.isEmpty
            ? 'teacher_101'
            : widget.notice!.createdBy,
        attachment: _pickedFile,
        removeAttachment: _removeExisting,
      );
    } else {
      ok = await _ctrl.createNotice(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        priority: _priority,
        audience: _selectedAudience,
        assignedClass: _selectedClass,
        isPinned: _pinNotice,
        attachment: _pickedFile,
      );
    }

    if (ok) {
      FlutterToast.success(
          isEdit ? "Notice updated successfully"
              : "Notice published successfully");
      Get.back(result: true);
    } else {
      FlutterToast.error(_ctrl.error.value);
    }
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
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
        title: Text(
          isEdit ? "Edit Notice" : "Create Notice",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.campaign_rounded,
                      color: Colors.blue, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isEdit
                          ? "Update the notice details below."
                          : "Create a notice and assign it to specific classes, students, or parents.",
                      style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Priority
            _sectionTitle("Priority"),
            const SizedBox(height: 8),
            Row(
              children: ["Normal", "Important", "Urgent"].map((p) {
                final sel = _priority == p;
                final c = _priorityColor(p);
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: p == "Urgent" ? 0 : 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => setState(() => _priority = p),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: sel ? c.withOpacity(0.1) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: sel ? c : Colors.grey.shade200,
                            width: sel ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(_priorityIcon(p),
                                color: sel ? c : Colors.grey, size: 20),
                            const SizedBox(height: 4),
                            Text(p,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: sel ? c : Colors.grey.shade700,
                                  fontWeight: sel
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            _sectionTitle("Notice Title"),
            const SizedBox(height: 8),
            _inputField(
              controller: _titleCtrl,
              hint: "e.g. Annual Sports Meet 2025",
              icon: Icons.title_rounded,
              maxLength: 80,
            ),
            const SizedBox(height: 18),

            _sectionTitle("Description"),
            const SizedBox(height: 8),
            _inputField(
              controller: _descCtrl,
              hint: "Write detailed notice here...",
              maxLines: 5,
              maxLength: 500,
            ),
            const SizedBox(height: 18),

            _sectionTitle("Assign to Class"),
            const SizedBox(height: 8),
            _dropdown(
              value: _selectedClass,
              items: _classes,
              icon: Icons.class_rounded,
              onChanged: (v) => setState(() => _selectedClass = v!),
            ),
            const SizedBox(height: 18),

            _sectionTitle("Audience"),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _audiences.map((a) {
                final sel = _selectedAudience == a;
                final c = _audienceColor(a);
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        a == "Students"
                            ? Icons.school_rounded
                            : a == "Parents"
                            ? Icons.family_restroom_rounded
                            : a == "Both"
                            ? Icons.groups_rounded
                            : Icons.badge_rounded,
                        size: 15,
                        color: sel ? Colors.white : c,
                      ),
                      const SizedBox(width: 6),
                      Text(a),
                    ],
                  ),
                  selected: sel,
                  onSelected: (_) =>
                      setState(() => _selectedAudience = a),
                  selectedColor: c,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: sel ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  side: BorderSide(color: sel ? c : Colors.grey.shade300),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            _sectionTitle("Attachment (optional)"),
            const SizedBox(height: 8),
            _buildAttachmentSection(),
            const SizedBox(height: 18),

            _toggleTile(
              icon: Icons.push_pin_rounded,
              title: "Pin to top",
              subtitle: "Keep notice at top of list",
              value: _pinNotice,
              onChanged: (v) => setState(() => _pinNotice = v),
            ),
            const SizedBox(height: 24),

            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _ctrl.isSubmitting.value ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _ctrl.isSubmitting.value
                    ? const SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                )
                    : Icon(
                  isEdit ? Icons.save_rounded : Icons.send_rounded,
                  color: Colors.white, size: 18,
                ),
                label: Text(
                  isEdit ? "Update Notice" : "Publish Notice",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            )),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ==================== ATTACHMENT SECTION ====================
  Widget _buildAttachmentSection() {
    final hasNew = _pickedFile != null;
    final hasExisting =
        _existingUrl != null && !_removeExisting;

    if (!hasNew && !hasExisting) {
      return InkWell(
        onTap: _showAttachmentSheet,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.attach_file_rounded,
                    color: Colors.indigo, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Attach file (PDF, Image)",
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey.shade600),
                ),
              ),
              const Icon(Icons.add_rounded, color: Colors.indigo),
            ],
          ),
        ),
      );
    }

    // ---- Show new picked file ----
    if (hasNew) {
      final isImg = _isImageFile(_pickedFile!.name);
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.indigo.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            if (isImg)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(_pickedFile!.path!),
                  width: 48, height: 48, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 48, height: 48,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image_rounded),
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.picture_as_pdf_rounded,
                    color: Colors.red, size: 24),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _pickedFile!.name,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isImg ? "Image" : "PDF Document",
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _removeAttachment,
              icon: const Icon(Icons.close_rounded,
                  size: 18, color: Colors.red),
            ),
          ],
        ),
      );
    }

    // ---- Show existing (from server) ----
    final isImg = _existingType == "image";
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.indigo.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          if (isImg)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _existingUrl!,
                width: 48, height: 48, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 48, height: 48,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image_rounded),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.picture_as_pdf_rounded,
                  color: Colors.red, size: 24),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _existingName ?? "Attachment",
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  isImg ? "Image (uploaded)" : "PDF (uploaded)",
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _removeAttachment,
            icon: const Icon(Icons.close_rounded,
                size: 18, color: Colors.red),
          ),
        ],
      ),
    );
  }

  bool _isImageFile(String name) {
    final n = name.toLowerCase();
    return n.endsWith('.png') || n.endsWith('.jpg') ||
        n.endsWith('.jpeg') || n.endsWith('.gif') ||
        n.endsWith('.webp');
  }

  // ==================== SMALL WIDGETS ====================
  Widget _sectionTitle(String title) => Text(
    title,
    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
  );

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    int maxLines = 1,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13),
        prefixIcon: icon != null
            ? Icon(icon, color: Colors.indigo, size: 18)
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        counterStyle: const TextStyle(fontSize: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.indigo, width: 1.4),
        ),
      ),
    );
  }

  Widget _dropdown<T>({
    required T value,
    required List<T> items,
    required IconData icon,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.indigo),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
          items: items.map((e) => DropdownMenuItem<T>(
            value: e,
            child: Row(
              children: [
                Icon(icon, color: Colors.indigo, size: 18),
                const SizedBox(width: 10),
                Text(e.toString()),
              ],
            ),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _toggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.indigo, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey[600])),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: Colors.indigo,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}