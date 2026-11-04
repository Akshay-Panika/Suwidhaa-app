// lib/feature/school/leave/screen/teacher_leave_form_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../profile/controller/teacher_controller.dart';
import '../controller/teacher_leave_controller.dart';
import '../model/teacher_leave_model.dart';

class TeacherLeaveFormScreen extends StatefulWidget {
  /// If non-null → EDIT mode
  final TeacherLeaveModel? existing;

  const TeacherLeaveFormScreen({super.key, this.existing});

  bool get isEditMode => existing != null;

  @override
  State<TeacherLeaveFormScreen> createState() =>
      _TeacherLeaveFormScreenState();
}

class _TeacherLeaveFormScreenState extends State<TeacherLeaveFormScreen> {
  final teacherController = Get.find<TeacherController>();
  final teacherLeaveController = Get.find<TeacherLeaveController>();

  final _formKey = GlobalKey<FormState>();
  final reasonController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  DateTime? fromDate;
  DateTime? toDate;
  File? _pickedImage;
  bool _keepExistingImage = true;

  static const Color _primary = Colors.indigo;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) _hydrateFromExisting(widget.existing!);
  }

  void _hydrateFromExisting(TeacherLeaveModel leave) {
    fromDate = DateTime.tryParse(leave.startDate);
    toDate = DateTime.tryParse(leave.endDate);
    reasonController.text = leave.reasonMsg ?? '';
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.indigo),
        ),
        title: Text(
          widget.isEditMode ? "Edit Leave" : "Apply for Leave",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.indigo,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (teacherController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: _primary),
          );
        }
        if (teacherController.errorMessage.value.isNotEmpty) {
          return const SizedBox.shrink();
        }
        if (teacherController.hasData || widget.isEditMode) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          'From Date',
                          fromDate,
                              () => _pickDate(true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDateField(
                          'To Date',
                          toDate,
                              () => _pickDate(false),
                        ),
                      ),
                    ],
                  ),
                  if (fromDate != null && toDate != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.date_range_rounded,
                              size: 16, color: Colors.indigo),
                          const SizedBox(width: 8),
                          Text(
                            'Total: ${toDate!.difference(fromDate!).inDays + 1} day(s)',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.indigo,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Reason Text...',
                    'Leave Reason / Message',
                    reasonController,
                  ),
                  const SizedBox(height: 16),
                  _buildUploadTile(),
                  const SizedBox(height: 30),
                  _buildActionButtons(),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Widget _buildDateField(
      String label, DateTime? date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    date != null
                        ? DateFormat('dd MMM yyyy').format(date)
                        : 'Select date',
                    style: TextStyle(
                      fontSize: 13,
                      color: date != null
                          ? Colors.black87
                          : Colors.grey.shade500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: _primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: _primary),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.all(12),
          ),
          validator: (v) =>
          v?.isEmpty ?? true ? 'Please enter leave reason' : null,
        ),
      ],
    );
  }

  Widget _buildUploadTile() {
    final existingImage = widget.existing?.image ?? '';
    final hasExistingImage = widget.isEditMode &&
        _keepExistingImage &&
        existingImage.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_pickedImage != null || hasExistingImage) ...[
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _pickedImage != null
                    ? Image.file(
                  _pickedImage!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: Colors.grey.shade200,
                    child: const Center(
                        child: Icon(Icons.broken_image)),
                  ),
                )
                    : Image.network(
                  existingImage,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: Colors.grey.shade200,
                    child: const Center(
                        child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => setState(() {
                    _pickedImage = null;
                    _keepExistingImage = false;
                  }),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
        GestureDetector(
          onTap: () async {
            final XFile? picked =
            await _picker.pickImage(source: ImageSource.gallery);
            if (picked != null) {
              setState(() {
                _pickedImage = File(picked.path);
                _keepExistingImage = false;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _pickedImage != null
                            ? "Change Attachment"
                            : hasExistingImage
                            ? "Replace Attachment"
                            : "Upload Attachment (Optional)",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (_pickedImage != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          _pickedImage!.path.split('/').last,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _pickedImage == null
                        ? Icons.upload_file
                        : Icons.refresh,
                    color: Colors.indigo.shade700,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _resetForm,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.indigo.shade300),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Reset",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(() {
            final loading = teacherLeaveController.isLoading.value;
            return ElevatedButton(
              onPressed: loading ? null : _submitLeave,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: loading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : Text(
                widget.isEditMode ? "Update Leave" : "Submit Leave",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom
          ? (fromDate ?? DateTime.now())
          : (toDate ?? fromDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context)
            .copyWith(colorScheme: const ColorScheme.light(primary: _primary)),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
          if (toDate != null && fromDate!.isAfter(toDate!)) toDate = null;
        } else if (fromDate != null && picked.isBefore(fromDate!)) {
          _showSnack('To date cannot be before from date', Colors.red);
        } else {
          toDate = picked;
        }
      });
    }
  }

  void _resetForm() {
    setState(() {
      fromDate = toDate = null;
      _pickedImage = null;
      _keepExistingImage = widget.isEditMode;
      reasonController.clear();
      if (widget.isEditMode) _hydrateFromExisting(widget.existing!);
    });
    _formKey.currentState?.reset();
    _showSnack('Form has been reset', Colors.grey);
  }

  Future<void> _submitLeave() async {
    if (!_formKey.currentState!.validate()) return;
    if (fromDate == null) {
      _showSnack('Please select from date', Colors.red);
      return;
    }
    if (toDate == null) {
      _showSnack('Please select to date', Colors.red);
      return;
    }

    final startStr = DateFormat('yyyy-MM-dd').format(fromDate!);
    final endStr = DateFormat('yyyy-MM-dd').format(toDate!);

    final success = widget.isEditMode
        ? await teacherLeaveController.updateLeave(
      id: widget.existing!.id!,
      reasonMsg: reasonController.text.trim(),
      startDate: startStr,
      endDate: endStr,
      imagePath: _pickedImage?.path,
    )
        : await teacherLeaveController.createLeave(
      reasonMsg: reasonController.text.trim(),
      startDate: startStr,
      endDate: endStr,
      imagePath: _pickedImage?.path,
    );

    if (!success) return;
    if (!mounted) return;

    // Return true so caller refreshes
    Navigator.pop(context, true);
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }
}