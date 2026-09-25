// lib/feature/school/transport/view/add_bus_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../controller/transport_controller.dart';

class AddBusScreen extends StatefulWidget {
  const AddBusScreen({super.key});

  @override
  State<AddBusScreen> createState() => _AddBusScreenState();
}

class _AddBusScreenState extends State<AddBusScreen> {
  static const Color _primary = Colors.indigo;
  static const Color _primaryDark = Color(0xFF283593);
  static const Color _primaryLight = Color(0xFFE8EAF6);

  final _formKey = GlobalKey<FormState>();

  final _transportTypeCtrl = TextEditingController();
  final _vehicleNumberCtrl = TextEditingController();
  final _driverNameCtrl = TextEditingController();
  final _driverNumberCtrl = TextEditingController();
  final _capacityCtrl = TextEditingController();
  final _routeNameCtrl = TextEditingController();

  // School Type — Single select
  String? _selectedSchoolType;

  // Image
  File? _driverImage;
  final ImagePicker _picker = ImagePicker();

  // Available school types
  static const List<String> _schoolTypeOptions = ['School A', 'School B'];

  @override
  void dispose() {
    _transportTypeCtrl.dispose();
    _vehicleNumberCtrl.dispose();
    _driverNameCtrl.dispose();
    _driverNumberCtrl.dispose();
    _capacityCtrl.dispose();
    _routeNameCtrl.dispose();
    super.dispose();
  }

  // ==================== PICK IMAGE ====================
  Future<void> _pickImage() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (file != null) {
        setState(() => _driverImage = File(file.path));
      }
    } catch (e) {
      FlutterToast.error('Failed to pick image');
    }
  }

  // ==================== SELECT SCHOOL TYPE ====================
  void _selectSchoolType(String type) {
    setState(() {
      // Toggle: same tap = deselect, different tap = replace
      _selectedSchoolType = _selectedSchoolType == type ? null : type;
    });
  }

  // ==================== SAVE ====================
  Future<void> _saveBus() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSchoolType == null || _selectedSchoolType!.isEmpty) {
      FlutterToast.error('Please select a school type');
      return;
    }

    final controller = Get.find<TransportController>();

    final success = await controller.createTransport(
      transportType: _transportTypeCtrl.text.trim(),
      schoolType: _selectedSchoolType!,
      vehicleNumber: _vehicleNumberCtrl.text.trim().toUpperCase(),
      driverName: _driverNameCtrl.text.trim(),
      driverNumber: _driverNumberCtrl.text.trim(),
      capacity: _capacityCtrl.text.trim(),
      routeName: _routeNameCtrl.text.trim(),
      driverImage: _driverImage,
    );

    if (success) {
      FlutterToast.success('Bus added successfully');
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransportController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _primary,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Bus',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ==================== SCROLLABLE BODY ====================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ========== Step 1 — Transport Info ==========
                      _stepHeader(
                        step: 1,
                        title: 'Transport Info',
                        icon: Icons.directions_bus_rounded,
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: _transportTypeCtrl,
                        label: 'Transport Type',
                        hint: 'e.g. Bus, Van, Auto',
                        icon: Icons.directions_bus_rounded,
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: _vehicleNumberCtrl,
                        label: 'Vehicle Number',
                        hint: 'e.g. MH12AB1234',
                        icon: Icons.confirmation_number_rounded,
                        textCapitalization: TextCapitalization.characters,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (v.trim().length < 2) return 'Too short';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: _routeNameCtrl,
                        label: 'Route Name',
                        hint: 'e.g. Route A - Andheri',
                        icon: Icons.route_rounded,
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: _capacityCtrl,
                        label: 'Capacity',
                        hint: 'e.g. 40',
                        icon: Icons.person_outline_rounded,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 22),

                      // ========== Step 2 — School Type ==========
                      _stepHeader(
                        step: 2,
                        title: 'School Type',
                        icon: Icons.school_rounded,
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 34),
                        child: Text(
                          'Select one school',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSchoolTypeSelector(),

                      const SizedBox(height: 22),

                      // ========== Step 3 — Driver Info ==========
                      _stepHeader(
                        step: 3,
                        title: 'Driver Info',
                        icon: Icons.person_rounded,
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: _driverNameCtrl,
                        label: 'Driver Name',
                        hint: 'e.g. Rajesh Kumar',
                        icon: Icons.person_rounded,
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: _driverNumberCtrl,
                        label: 'Driver Number',
                        hint: 'e.g. 9876543210',
                        icon: Icons.phone_rounded,
                        keyboardType: TextInputType.phone,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (v.trim().length < 10) return 'Invalid number';
                          return null;
                        },
                      ),

                      const SizedBox(height: 22),

                      // ========== Step 4 — Driver Photo ==========
                      _stepHeader(
                        step: 4,
                        title: 'Driver Photo (Optional)',
                        icon: Icons.photo_camera_rounded,
                      ),
                      const SizedBox(height: 12),
                      _buildImagePicker(),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // ==================== STICKY SAVE BUTTON ====================
            _buildBottomBar(controller),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SCHOOL TYPE SELECTOR (Single select)
  // ============================================================
  Widget _buildSchoolTypeSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedSchoolType == null
              ? Colors.grey.shade300
              : _primary.withOpacity(0.3),
          width: _selectedSchoolType == null ? 1 : 1.5,
        ),
      ),
      child: Row(
        spacing: 8,
        children: _schoolTypeOptions.map((type) {
          final isSelected = _selectedSchoolType == type;
          return Expanded(
            child: InkWell(
              onTap: () => _selectSchoolType(type),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? _primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? _primary : Colors.grey.shade300,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.school_outlined,
                      size: 14,
                      color: isSelected
                          ? Colors.white
                          : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ============================================================
  // STEP HEADER
  // ============================================================
  Widget _stepHeader({
    required int step,
    required String title,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: _primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$step',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Icon(icon, size: 16, color: _primary),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BOTTOM BAR (Sticky Save)
  // ============================================================
  Widget _buildBottomBar(TransportController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Obx(() {
        final isSaving = controller.isCreating.value;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isSaving ? null : _saveBus,
            icon: isSaving
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Icon(Icons.check_rounded, size: 18),
            label: Text(isSaving ? 'Saving...' : 'Save Bus'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: _primary.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      }),
    );
  }

  // ============================================================
  // IMAGE PICKER
  // ============================================================
  Widget _buildImagePicker() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Preview
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _primaryLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _primary.withOpacity(0.2)),
            ),
            child: _driverImage != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _driverImage!,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            )
                : const Icon(Icons.person_rounded,
                size: 28, color: _primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _driverImage == null
                      ? 'No image selected'
                      : 'Image ready to upload',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'JPG, PNG • Auto-compressed',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_library_rounded,
                          size: 14, color: _primary),
                      label: Text(
                        _driverImage == null ? 'Choose' : 'Change',
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: _primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    if (_driverImage != null) ...[
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () =>
                            setState(() => _driverImage = null),
                        icon: const Icon(Icons.close_rounded,
                            size: 14, color: Colors.red),
                        label: const Text(
                          'Remove',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD FIELD
  // ============================================================
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: _primary),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}