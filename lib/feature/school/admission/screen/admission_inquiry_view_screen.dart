// screens/admission_inquiry_view_screen.dart
import 'package:flutter/material.dart';
import '../model/new_student_model.dart';
import 'admission_inquiry_form_screen.dart';

class AdmissionInquiryViewScreen extends StatefulWidget {
  final AdmissionInquiry inquiry;

  const AdmissionInquiryViewScreen({super.key, required this.inquiry});

  @override
  State<AdmissionInquiryViewScreen> createState() =>
      _AdmissionInquiryViewScreenState();
}

class _AdmissionInquiryViewScreenState
    extends State<AdmissionInquiryViewScreen> {
  late AdmissionInquiry _inquiry;

  @override
  void initState() {
    super.initState();
    _inquiry = widget.inquiry;
  }

  // ==================== EDIT ====================
  Future<void> _editInquiry() async {
    final result = await Navigator.push<AdmissionInquiry>(
      context,
      MaterialPageRoute(
        builder: (_) => AdmissionInquiryFormScreen(existing: _inquiry),
      ),
    );
    if (result != null) {
      setState(() => _inquiry = result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Inquiry updated'),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  // ==================== UPDATE STATUS ====================
  Future<void> _updateStatus(InquiryStatus newStatus) async {
    if (newStatus == _inquiry.status) return;

    setState(() {
      _inquiry = _inquiry.copyWith(status: newStatus);
    });

    final color = Color(newStatus.colorValue);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status updated to ${newStatus.label}'),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // ==================== CONTACT ACTIONS ====================
  Future<void> _call(String phone) async {
    // TODO: integrate with your ContactHelper
    // await ContactHelper.call(phone);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling $phone'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> _whatsapp(String phone, String name) async {
    final clean = phone.replaceAll(RegExp(r'[^0-9]'), '');
    // TODO: integrate with your ContactHelper
    // await ContactHelper.whatsapp(clean, msg);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening WhatsApp for $name'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    final statusColor = Color(_inquiry.status.colorValue);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Inquiry Details',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit',
            onPressed: _editInquiry,
            icon: const Icon(Icons.edit_outlined),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Profile Header ----------
            _headerCard(statusColor),

            const SizedBox(height: 20),

            // ---------- Student Details ----------
            _sectionTitle('Student Details'),
            const SizedBox(height: 10),
            _card([
              _row(Icons.person_outline_rounded, 'Student Name',
                  _inquiry.studentName),
              _row(Icons.class_rounded, 'Interested Class',
                  _inquiry.interestedClass),
            ]),

            const SizedBox(height: 16),

            // ---------- Parent / Contact ----------
            _sectionTitle('Parent / Contact'),
            const SizedBox(height: 10),
            _card([
              _row(Icons.family_restroom_rounded, 'Parent Name',
                  _inquiry.parentName),
              _row(Icons.phone_rounded, 'Phone', _inquiry.phone,
                  isPhone: true),
              if (_inquiry.altPhone != null &&
                  _inquiry.altPhone!.isNotEmpty)
                _row(Icons.phone_android_rounded, 'Alt Phone',
                    _inquiry.altPhone!, isPhone: true),
              if (_inquiry.email != null && _inquiry.email!.isNotEmpty)
                _row(Icons.email_outlined, 'Email', _inquiry.email!),
            ]),

            const SizedBox(height: 16),

            // ---------- Additional Info ----------
            if ((_inquiry.previousSchool != null &&
                _inquiry.previousSchool!.isNotEmpty) ||
                (_inquiry.notes != null && _inquiry.notes!.isNotEmpty)) ...[
              _sectionTitle('Additional Info'),
              const SizedBox(height: 10),
              _card([
                if (_inquiry.previousSchool != null &&
                    _inquiry.previousSchool!.isNotEmpty)
                  _row(Icons.school_outlined, 'Previous School',
                      _inquiry.previousSchool!),
                if (_inquiry.notes != null && _inquiry.notes!.isNotEmpty)
                  _row(Icons.notes_rounded, 'Notes', _inquiry.notes!),
              ]),
              const SizedBox(height: 16),
            ],

            // ---------- Status ----------
            _sectionTitle('Inquiry Status'),
            const SizedBox(height: 10),
            _statusCard(statusColor),

            const SizedBox(height: 16),

            // ---------- Change Status ----------
            _sectionTitle('Update Status'),
            const SizedBox(height: 10),
            _statusSelector(),
          ],
        ),
      ),
    );
  }

  // ==================== HEADER CARD ====================
  Widget _headerCard(Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          // Avatar
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.20),
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: Text(
              _inquiry.initials,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Name
          Text(
            _inquiry.studentName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),

          // Parent
          Text(
            'Parent: ${_inquiry.parentName}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // Class + status pills
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _headerPill(
                icon: Icons.class_rounded,
                label: 'Class ${_inquiry.interestedClass}',
              ),
              const SizedBox(width: 8),
              _headerPill(
                icon: Icons.circle,
                label: _inquiry.status.label,
                iconSize: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerPill({
    required IconData icon,
    required String label,
    double iconSize = 12,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: iconSize),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }


  // ==================== STATUS CARD ====================
  Widget _statusCard(Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _inquiry.status.label.toUpperCase(),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _statusHint(_inquiry.status),
                  style: TextStyle(
                    color: color.withOpacity(0.75),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Inquiry Date',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _inquiry.formattedInquiryDate,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF1A1F36),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusHint(InquiryStatus s) {
    switch (s) {
      case InquiryStatus.newInquiry:
        return 'Fresh inquiry — not yet contacted';
      case InquiryStatus.contacted:
        return 'Parent has been contacted';
      case InquiryStatus.interested:
        return 'Showed interest in admission';
      case InquiryStatus.admitted:
        return 'Admission completed successfully';
      case InquiryStatus.rejected:
        return 'Inquiry closed / not proceeding';
    }
  }

  // ==================== STATUS SELECTOR ====================
  Widget _statusSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: InquiryStatus.values.map((s) {
        final selected = _inquiry.status == s;
        final color = Color(s.colorValue);
        return InkWell(
          onTap: () => _updateStatus(s),
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  const Icon(Icons.check_rounded,
                      size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                ],
                Text(
                  s.label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : color,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ==================== CARD / ROW ====================
  Widget _card(List<Widget> children) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(children: children),
  );

  Widget _row(IconData icon, String label, String value,
      {bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.indigo),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: isPhone ? Colors.indigo : const Color(0xFF1A1F36),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== SECTION TITLE ====================
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
}