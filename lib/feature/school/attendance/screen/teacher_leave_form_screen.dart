import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../profile/controller/teacher_controller.dart';
import '../controller/teacher_leave_controller.dart';

class TeacherLeaveFormScreen extends StatefulWidget {
  const TeacherLeaveFormScreen({super.key});

  @override
  State<TeacherLeaveFormScreen> createState() => _TeacherLeaveFormScreenState();
}

class _TeacherLeaveFormScreenState extends State<TeacherLeaveFormScreen> {
  final teacherController = Get.find<TeacherController>();
  final teacherLeaveController = Get.find<TeacherLeaveController>();

  final _formKey = GlobalKey<FormState>();
  final reasonController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? leaveType;
  DateTime? fromDate;
  DateTime? toDate;
  bool isHalfDay = false;
  File? _pickedImage;

  final List<Color> leaveColors = [
    Colors.green,
    Colors.orange,
    Colors.blue,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
        ),
        title: const Text(
          "Apply for Leave",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (teacherController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (teacherController.errorMessage.value.isNotEmpty) {
          return const SizedBox.shrink();
        }

        if (teacherController.hasData) {
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
                  _buildSwitchTile(
                    'Apply as Half Day',
                    isHalfDay,
                        (val) => setState(() => isHalfDay = val),
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
        }

        return const SizedBox.shrink();
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                      color:
                      date != null ? Colors.black87 : Colors.grey.shade500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ────────────────────────────────  SWITCH TILE
  Widget _buildSwitchTile(
      String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue,
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
              borderSide: BorderSide(color: Colors.blue),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show preview if image picked
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
                    child: const Center(
                      child: Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),
              // Remove (X) button
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
        ],

        // Upload tile (tap to pick)
        GestureDetector(
          onTap: () async {
            final XFile? picked =
            await _picker.pickImage(source: ImageSource.gallery);
            if (picked != null) {
              setState(() => _pickedImage = File(picked.path));
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
                            ? "Upload Attachment (Optional)"
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
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _pickedImage == null
                        ? Icons.upload_file
                        : Icons.refresh,
                    color: Colors.blue.shade700,
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
              side: BorderSide(color: Colors.blue.shade300),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Reset",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                backgroundColor: Colors.blue,
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
                  : const Text(
                "Submit Leave",
                style: TextStyle(
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
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.blue),
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
    setState(() {
      leaveType = null;
      fromDate = toDate = null;
      isHalfDay = false;
      _pickedImage = null;
      reasonController.clear();
    });
    _formKey.currentState?.reset();
    _showSnack('Form has been reset', Colors.grey);
  }

  // ────────────────────────────────  SUBMIT (API CALL)
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

    final teacherId = teacherController.id.toString();
    final teacherIdCard = teacherController.teacherIdCard;

    if (teacherId.isEmpty || teacherId == '0' || teacherIdCard.isEmpty) {
      _showSnack('Teacher profile not loaded', Colors.red);
      return;
    }

    final startStr = DateFormat('yyyy-MM-dd').format(fromDate!);
    final endStr = DateFormat('yyyy-MM-dd').format(toDate!);

    final success = await teacherLeaveController.createLeave(
      teacherId: teacherId,
      teacherIdCard: teacherIdCard,
      applyStatus: true,
      reasonMsg: reasonController.text.trim(),
      startDate: startStr,
      endDate: endStr,
      imagePath: _pickedImage?.path,
    );

    if (!success) return;
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Leave Applied Successfully!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your leave request has been submitted for approval.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
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

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }
}