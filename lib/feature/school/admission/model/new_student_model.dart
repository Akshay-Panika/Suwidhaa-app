// model/new_student_model.dart

enum InquiryStatus { newInquiry, contacted, interested, admitted, rejected }

extension InquiryStatusLabel on InquiryStatus {
  String get label {
    switch (this) {
      case InquiryStatus.newInquiry:
        return 'New';
      case InquiryStatus.contacted:
        return 'Contacted';
      case InquiryStatus.interested:
        return 'Interested';
      case InquiryStatus.admitted:
        return 'Admitted';
      case InquiryStatus.rejected:
        return 'Rejected';
    }
  }

  int get colorValue {
    switch (this) {
      case InquiryStatus.newInquiry:
        return 0xFF6366F1; // indigo
      case InquiryStatus.contacted:
        return 0xFF3B82F6; // blue
      case InquiryStatus.interested:
        return 0xFFF59E0B; // amber
      case InquiryStatus.admitted:
        return 0xFF10B981; // green
      case InquiryStatus.rejected:
        return 0xFFEF4444; // red
    }
  }
}

/// Admission Inquiry — a lead / prospective student
/// Teacher/Parent can register interest for admission.
class AdmissionInquiry {
  final String id;
  final String studentName;
  final String parentName;
  final String phone;
  final String? altPhone;      // optional
  final String? email;         // optional
  final String interestedClass; // "10th"
  final String? previousSchool; // optional
  final String? notes;         // optional message
  final InquiryStatus status;
  final DateTime inquiryDate;

  AdmissionInquiry({
    required this.id,
    required this.studentName,
    required this.parentName,
    required this.phone,
    this.altPhone,
    this.email,
    required this.interestedClass,
    this.previousSchool,
    this.notes,
    this.status = InquiryStatus.newInquiry,
    required this.inquiryDate,
  });

  String get formattedInquiryDate =>
      '${inquiryDate.day.toString().padLeft(2, '0')}-${inquiryDate.month.toString().padLeft(2, '0')}-${inquiryDate.year}';

  String get initials {
    final parts = studentName
        .trim()
        .split(' ')
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  AdmissionInquiry copyWith({
    String? id,
    String? studentName,
    String? parentName,
    String? phone,
    String? altPhone,
    String? email,
    String? interestedClass,
    String? previousSchool,
    String? notes,
    InquiryStatus? status,
    DateTime? inquiryDate,
  }) {
    return AdmissionInquiry(
      id: id ?? this.id,
      studentName: studentName ?? this.studentName,
      parentName: parentName ?? this.parentName,
      phone: phone ?? this.phone,
      altPhone: altPhone ?? this.altPhone,
      email: email ?? this.email,
      interestedClass: interestedClass ?? this.interestedClass,
      previousSchool: previousSchool ?? this.previousSchool,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      inquiryDate: inquiryDate ?? this.inquiryDate,
    );
  }
}