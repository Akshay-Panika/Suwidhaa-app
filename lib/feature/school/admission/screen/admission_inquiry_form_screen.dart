// screens/admission_inquiry_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../profile/controller/teacher_controller.dart';
import '../model/new_student_model.dart';

class AdmissionInquiryFormScreen extends StatefulWidget {
  final AdmissionInquiry? existing;

  const AdmissionInquiryFormScreen({super.key, this.existing});

  bool get isEdit => existing != null;

  @override
  State<AdmissionInquiryFormScreen> createState() => _AdmissionInquiryFormScreenState();
}

class _AdmissionInquiryFormScreenState extends State<AdmissionInquiryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final teacherController = Get.find<TeacherController>();

  late TextEditingController _studentCtrl;
  late TextEditingController _parentCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _altPhoneCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _prevSchoolCtrl;
  late TextEditingController _notesCtrl;

  String _interestedClass = '10th';
  InquiryStatus _status = InquiryStatus.newInquiry;

  bool _isSubmitting = false;
  bool _dirty = false;

  final List<String> _classes = const [
    '1st', '2nd', '3rd', '4th', '5th',
    '6th', '7th', '8th', '9th', '10th', '11th', '12th',
  ];

  @override
  void initState() {
    super.initState();
    final s = widget.existing;

    _studentCtrl = TextEditingController(text: s?.studentName ?? '');
    _parentCtrl = TextEditingController(text: s?.parentName ?? '');
    _phoneCtrl = TextEditingController(text: s?.phone ?? '');
    _altPhoneCtrl = TextEditingController(text: s?.altPhone ?? '');
    _emailCtrl = TextEditingController(text: s?.email ?? '');
    _prevSchoolCtrl = TextEditingController(text: s?.previousSchool ?? '');
    _notesCtrl = TextEditingController(text: s?.notes ?? '');

    if (s != null) {
      _interestedClass =
      _classes.contains(s.interestedClass) ? s.interestedClass : '10th';
      _status = s.status;
    }
  }

  @override
  void dispose() {
    for (final c in [
      _studentCtrl, _parentCtrl, _phoneCtrl, _altPhoneCtrl,
      _emailCtrl, _prevSchoolCtrl, _notesCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.heavyImpact();
      return;
    }

    setState(() => _isSubmitting = true);
    HapticFeedback.mediumImpact();

    final inquiry = AdmissionInquiry(
      id: widget.existing?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      studentName: _studentCtrl.text.trim(),
      parentName: _parentCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      altPhone: _altPhoneCtrl.text.trim().isEmpty
          ? null
          : _altPhoneCtrl.text.trim(),
      email:
      _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      interestedClass: _interestedClass,
      previousSchool: _prevSchoolCtrl.text.trim().isEmpty
          ? null
          : _prevSchoolCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      status: _status,
      inquiryDate: widget.existing?.inquiryDate ?? DateTime.now(),
    );

    Navigator.pop(context, inquiry);
  }

  Future<bool> _confirmDiscard() async {
    if (!_dirty || _isSubmitting) return true;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Discard changes?'),
        content: const Text(
            'You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep editing'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final ok = await _confirmDiscard();
        if (ok && mounted) Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            onPressed: () async {
              final ok = await _confirmDiscard();
              if (ok && mounted) Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, size: 20),
          ),
          title: Text(
            widget.isEdit ? 'Edit Inquiry' : 'New Admission Inquiry',
            style:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
        ),
        body: Obx(() {
          // Show shimmer loading
          if (teacherController.isLoading.value) {
            return CircularProgressIndicator();
          }


          // Show teacher data
          if (teacherController.hasData) {
            /// created by
            final  createdId = teacherController.teacherIdCard;
            final  createdName = teacherController.teacherIdCard;
            return  Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _summaryBanner(),
                    const SizedBox(height: 20),

                    // ---------- Student ----------
                    _sectionTitle('Student Details'),
                    const SizedBox(height: 10),
                    _field(
                      controller: _studentCtrl,
                      label: 'Student Name',
                      icon: Icons.person_outline_rounded,
                      cap: TextCapitalization.words,
                      validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Name required' : null,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: _parentCtrl,
                      label: 'Parent Name',
                      icon: Icons.family_restroom_rounded,
                      cap: TextCapitalization.words,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Parent name required'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    _classDropdown(),

                    const SizedBox(height: 20),

                    // ---------- Contact ----------
                    _sectionTitle('Contact Information'),
                    const SizedBox(height: 10),
                    _field(
                      controller: _phoneCtrl,
                      label: 'Phone',
                      icon: Icons.phone_rounded,
                      inputType: TextInputType.phone,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Phone required';
                        }
                        if (v.trim().length < 10) return 'Enter valid phone';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: _altPhoneCtrl,
                      label: 'Alternate Phone (optional)',
                      icon: Icons.phone_android_rounded,
                      inputType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: _emailCtrl,
                      label: 'Email (optional)',
                      icon: Icons.email_outlined,
                      inputType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 20),

                    // ---------- Additional ----------
                    _sectionTitle('Additional Info'),
                    const SizedBox(height: 10),
                    _field(
                      controller: _prevSchoolCtrl,
                      label: 'Previous School (optional)',
                      icon: Icons.school_outlined,
                      cap: TextCapitalization.words,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: _notesCtrl,
                      label: 'Notes / Message (optional)',
                      icon: Icons.notes_rounded,
                      maxLines: 3,
                      cap: TextCapitalization.sentences,
                    ),

                    const SizedBox(height: 20),

                    // ---------- Status ----------
                    _sectionTitle('Inquiry Status'),
                    const SizedBox(height: 10),
                    _statusSelector(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }

          // No data available
          return SizedBox.shrink();
        }),
        bottomNavigationBar: _bottomBar(),
      ),
    );
  }

  // ==================== SUMMARY ====================
  Widget _summaryBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.indigo, Color(0xFF5C6BC0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person_add_alt_1_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEdit ? 'Update Inquiry' : 'New Admission Inquiry',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Basic student & parent info',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== CLASS DROPDOWN ====================
  Widget _classDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _interestedClass,
          isExpanded: true,
          icon:
          const Icon(Icons.arrow_drop_down_rounded, color: Colors.indigo),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (v) => setState(() {
            _interestedClass = v!;
            _dirty = true;
          }),
          items: _classes
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
        ),
      ),
    );
  }

  // ==================== STATUS SELECTOR ====================
  Widget _statusSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: InquiryStatus.values.map((s) {
        final selected = _status == s;
        final color = Color(s.colorValue);
        return InkWell(
          onTap: () => setState(() {
            _status = s;
            _dirty = true;
          }),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? color : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? color : Colors.grey.shade300,
              ),
            ),
            child: Text(
              s.label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : color,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ==================== HELPERS ====================
  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.black54,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? inputType,
    TextCapitalization cap = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: inputType,
      textCapitalization: cap,
      validator: validator,
      onChanged: (_) {
        if (!_dirty) setState(() => _dirty = true);
      },
      style: const TextStyle(fontSize: 13, color: Color(0xFF1A1F36)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        prefixIcon: Icon(icon, size: 18, color: Colors.indigo),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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

  // ==================== BOTTOM BAR ====================
  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
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
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isSubmitting
                    ? null
                    : () async {
                  final ok = await _confirmDiscard();
                  if (ok && mounted) Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isSubmitting
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Icon(
                  widget.isEdit
                      ? Icons.check_rounded
                      : Icons.person_add_alt_1_rounded,
                  size: 18,
                ),
                label: Text(
                  _isSubmitting
                      ? 'Saving...'
                      : (widget.isEdit ? 'Update Inquiry' : 'Save Inquiry'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}