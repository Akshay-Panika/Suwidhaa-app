// lib/feature/school/student_leave/screen/student_leave_form_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../profile/controller/student_controller.dart';
import '../controller/student_leave_controller.dart';
import '../model/student_leave_list_model.dart';

class StudentLeaveFormScreen extends StatefulWidget {
  /// 🔹 Null = create mode, Non-null = edit mode
  final StudentLeaveData? editLeave;

  const StudentLeaveFormScreen({super.key, this.editLeave});

  bool get isEditMode => editLeave != null;

  @override
  State<StudentLeaveFormScreen> createState() =>
      _StudentLeaveFormScreenState();
}

class _StudentLeaveFormScreenState extends State<StudentLeaveFormScreen> {
  final studentController = Get.find<StudentController>();
  final studentLeaveController = Get.find<StudentLeaveController>();

  final _formKey = GlobalKey<FormState>();
  final reasonController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  DateTime? fromDate;
  DateTime? toDate;
  File? _pickedImage;

  // Edit mode: existing image
  String? _existingImageUrl;
  bool _removeExistingImage = false;

  static const Color _primary = Colors.indigo;

  bool get _isEdit => widget.isEditMode;

  @override
  void initState() {
    super.initState();
    _prefillIfEdit();
  }

  void _prefillIfEdit() {
    final e = widget.editLeave;
    if (e == null) return;

    reasonController.text = e.reasonMsg;
    _existingImageUrl = e.image;

    try {
      fromDate = DateTime.parse(e.startDate);
      toDate = DateTime.parse(e.endDate);
    } catch (_) {
      fromDate = null;
      toDate = null;
    }
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════
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
          _isEdit ? "Edit Leave" : "Apply for Leave",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.indigo,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final studentLoading = studentController.isLoading.value;

        if (!_isEdit && studentLoading) {
          return const Center(
            child: CircularProgressIndicator(color: _primary),
          );
        }


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
      }),
    );
  }

  // ────────────────────────────────  DATE FIELD
  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
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

  // ────────────────────────────────  TEXT FIELD
  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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

  // ────────────────────────────────  UPLOAD TILE
  Widget _buildUploadTile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Naya picked image (local file)
        if (_pickedImage != null) ...[
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _pickedImage!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: Colors.grey.shade200,
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _pickedImage = null);
                  },
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
        ]
        // 🔹 Edit mode me existing image (agar naya pick nahi kiya)
        else if (_isEdit &&
            _existingImageUrl != null &&
            _existingImageUrl!.isNotEmpty &&
            !_removeExistingImage) ...[
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  _existingImageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: Colors.grey.shade200,
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
              // Remove button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _removeExistingImage = true;
                    });
                  },
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
              // "Current" badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Current',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],

        // 🔹 Pick button
        GestureDetector(
          onTap: () async {
            final XFile? picked =
            await _picker.pickImage(source: ImageSource.gallery);
            if (picked != null) {
              setState(() {
                _pickedImage = File(picked.path);
                _removeExistingImage = false;
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
                        _pickedImage == null
                            ? (_isEdit
                            ? "Change Attachment (Optional)"
                            : "Upload Attachment (Optional)")
                            : "Change Attachment",
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

  // ────────────────────────────────  ACTION BUTTONS
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
            final loading = studentLeaveController.isLoading.value ||
                studentLeaveController.isUpdating.value;

            return ElevatedButton(
              onPressed: loading ? null : _submit,
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
                _isEdit ? "Update Leave" : "Submit Leave",
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

  // ────────────────────────────────  DATE PICKER
  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom
          ? (fromDate ?? DateTime.now())
          : (toDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: _primary),
        ),
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

  // ────────────────────────────────  RESET
  void _resetForm() {
    if (_isEdit) {
      // Edit mode: purane values pe wapas
      _prefillIfEdit();
      setState(() {
        _pickedImage = null;
        _removeExistingImage = false;
      });
    } else {
      setState(() {
        fromDate = toDate = null;
        _pickedImage = null;
        reasonController.clear();
      });
      _formKey.currentState?.reset();
    }
    _showSnack('Form has been reset', Colors.grey);
  }

  // ────────────────────────────────  SUBMIT (CREATE / UPDATE)
  Future<void> _submit() async {
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

    // 🔹 Student info
    final String studentIdCard;
    final String studentName;
    final String studentClass;
    final String schoolType;

    if (_isEdit) {
      final e = widget.editLeave!;
      studentIdCard = e.studentIdCard;
      studentName = e.studentName;
      studentClass = e.studentClass;
      schoolType = e.schoolType.isNotEmpty ? e.schoolType : 'A';
    } else {
      final studentData = studentController.studentData.value;
      if (studentData == null) {
        _showSnack('Student profile not loaded', Colors.red);
        return;
      }
      studentIdCard = studentData.studentIdCard;
      studentName = studentData.fullName;
      studentClass = studentData.studentClass;
      schoolType =
      studentData.schoolType.isNotEmpty ? studentData.schoolType : 'A';

      if (studentIdCard.isEmpty || studentName.isEmpty) {
        _showSnack('Student profile incomplete', Colors.red);
        return;
      }
    }

    final bool success;

    if (_isEdit) {
      // 🔹 UPDATE
      success = await studentLeaveController.updateLeave(
        leaveId: widget.editLeave!.id,
        studentIdCard: studentIdCard,
        studentName: studentName,
        studentClass: studentClass,
        schoolType: schoolType,
        reasonMsg: reasonController.text.trim(),
        startDate: startStr,
        endDate: endStr,
        imagePath: _pickedImage?.path,
        removeOldImage: _removeExistingImage,
      );
    } else {
      // 🔹 CREATE
      success = await studentLeaveController.createLeave(
        studentIdCard: studentIdCard,
        studentName: studentName,
        studentClass: studentClass,
        schoolType: schoolType,
        reasonMsg: reasonController.text.trim(),
        startDate: startStr,
        endDate: endStr,
        imagePath: _pickedImage?.path,
      );
    }

    if (!success) return;
    if (!mounted) return;

    // Success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 60,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isEdit
                  ? 'Leave Updated Successfully!'
                  : 'Leave Applied Successfully!',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isEdit
                  ? 'Your leave request has been updated.'
                  : 'Your leave request has been submitted for approval.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context, true); // close screen with result
            },
            child: const Text(
              'Done',
              style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────  SNACKBAR
  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }
}