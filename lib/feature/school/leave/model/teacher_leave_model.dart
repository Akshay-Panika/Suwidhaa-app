// lib/feature/school/leave/model/teacher_leave_model.dart
import '../../homework/model/homework_model.dart'; // TeacherData

class TeacherLeaveModel {
  final int? id;
  final String teacherId;
  final String teacherIdCard;

  /// ✅ 'pending' | 'approved' | 'rejected'
  final String applyStatus;

  final String? reasonMsg;
  final String startDate;
  final String endDate;
  final String? image;
  final String? createdDate;

  /// ✅ Full teacher object (with nested school)
  final TeacherData? teacher;

  TeacherLeaveModel({
    this.id,
    required this.teacherId,
    required this.teacherIdCard,
    required this.applyStatus,
    this.reasonMsg,
    required this.startDate,
    required this.endDate,
    this.image,
    this.createdDate,
    this.teacher,
  });

  factory TeacherLeaveModel.fromJson(Map<String, dynamic> json) {
    TeacherData? teacherObj;
    final rawT = json['teacher'];
    if (rawT is Map) {
      try {
        teacherObj = TeacherData.fromJson(Map<String, dynamic>.from(rawT));
      } catch (_) {}
    }

    // ✅ Normalize — tolerate old bool data too
    String normalizeStatus(dynamic v) {
      if (v == true) return 'approved';
      if (v == false) return 'pending';
      final s = v?.toString().toLowerCase().trim() ?? 'pending';
      if (s == 'approved' || s == 'rejected' || s == 'pending') return s;
      return 'pending';
    }

    return TeacherLeaveModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse('${json['id']}'),
      teacherId: json['teacher_id']?.toString() ?? '',
      teacherIdCard: json['teacher_id_card']?.toString() ?? '',
      applyStatus: normalizeStatus(json['apply_status']),
      reasonMsg: json['reason_msg']?.toString(),
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      image: json['image']?.toString(),
      createdDate: json['created_date']?.toString(),
      teacher: teacherObj,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'teacher_id': teacherId,
    'teacher_id_card': teacherIdCard,
    'apply_status': applyStatus,
    'reason_msg': reasonMsg,
    'start_date': startDate,
    'end_date': endDate,
  };

  // ── Status helpers ──
  bool get isApproved => applyStatus.toLowerCase() == 'approved';
  bool get isPending => applyStatus.toLowerCase() == 'pending';
  bool get isRejected => applyStatus.toLowerCase() == 'rejected';

  /// Capitalized label for UI
  String get statusLabel {
    switch (applyStatus.toLowerCase()) {
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  /// Number of days (inclusive)
  int get totalDays {
    final s = DateTime.tryParse(startDate);
    final e = DateTime.tryParse(endDate);
    if (s == null || e == null) return 0;
    return e.difference(s).inDays + 1;
  }

  /// ✅ Multi-day leave indicator (replaces old "Full/Half Day")
  bool get isMultiDay => totalDays > 1;

  /// True if today falls within the leave range
  bool get isActive {
    final s = DateTime.tryParse(startDate);
    final e = DateTime.tryParse(endDate);
    if (s == null || e == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return !today.isBefore(DateTime(s.year, s.month, s.day)) &&
        !today.isAfter(DateTime(e.year, e.month, e.day));
  }

  // ── Teacher helpers ──
  String get teacherDisplayName =>
      (teacher?.fullName.isNotEmpty == true)
          ? teacher!.fullName
          : (teacherIdCard.isNotEmpty ? teacherIdCard : 'Teacher');

  String? get teacherProfile => teacher?.teacherProfile;
  String? get schoolName => teacher?.school?.schoolName;
  String? get schoolCity => teacher?.school?.city;
}