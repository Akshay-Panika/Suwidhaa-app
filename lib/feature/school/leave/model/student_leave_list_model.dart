// lib/feature/school/student_leave/model/student_leave_list_model.dart

class StudentLeaveListModel {
  final bool status;
  final List<StudentLeaveData> data;
  final String? message;

  StudentLeaveListModel({
    required this.status,
    required this.data,
    this.message,
  });

  factory StudentLeaveListModel.fromJson(Map<String, dynamic> json) {
    return StudentLeaveListModel(
      status: json['status'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => StudentLeaveData.fromJson(e))
          .toList() ??
          [],
      message: json['message'],
    );
  }
}

class StudentLeaveData {
  final int id;
  final String studentIdCard;
  final String studentName;
  final String studentClass;
  final String schoolType;
  final String reasonMsg;
  final String startDate;
  final String endDate;
  final String? image;
  final String leaveStatus;
  final String? teacherCardId;
  final String? teacherName;
  final String createdDate;

  StudentLeaveData({
    required this.id,
    required this.studentIdCard,
    required this.studentName,
    required this.studentClass,
    required this.schoolType,
    required this.reasonMsg,
    required this.startDate,
    required this.endDate,
    this.image,
    required this.leaveStatus,
    this.teacherCardId,
    this.teacherName,
    required this.createdDate,
  });

  factory StudentLeaveData.fromJson(Map<String, dynamic> json) {
    return StudentLeaveData(
      id: json['id'] ?? 0,
      studentIdCard: json['student_id_card'] ?? '',
      studentName: json['student_name'] ?? '',
      studentClass: json['student_class'] ?? '',
      schoolType: json['school_type'] ?? '',
      reasonMsg: json['reason_msg'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      image: json['image'],
      leaveStatus: json['leave_status'] ?? 'pending',
      teacherCardId: json['teacher_card_id'],
      teacherName: json['teacher_name'],
      createdDate: json['created_date'] ?? '',
    );
  }

  // ────── Copy with (for local status update) ──────
  StudentLeaveData copyWith({String? leaveStatus}) {
    return StudentLeaveData(
      id: id,
      studentIdCard: studentIdCard,
      studentName: studentName,
      studentClass: studentClass,
      schoolType: schoolType,
      reasonMsg: reasonMsg,
      startDate: startDate,
      endDate: endDate,
      image: image,
      leaveStatus: leaveStatus ?? this.leaveStatus,
      teacherCardId: teacherCardId,
      teacherName: teacherName,
      createdDate: createdDate,
    );
  }

  // ────── Helpers ──────
  String get formattedStartDate => _formatDate(startDate);
  String get formattedEndDate => _formatDate(endDate);
  String get formattedCreatedDate => _formatDateTime(createdDate);

  String _formatDate(String date) {
    try {
      final dt = DateTime.parse(date);
      return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
    } catch (_) {
      return date;
    }
  }

  String _formatDateTime(String date) {
    try {
      final dt = DateTime.parse(date);
      return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
    } catch (_) {
      return date;
    }
  }

  String get displayStatus {
    switch (leaveStatus.toLowerCase()) {
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'pending':
        return 'Pending';
      default:
        return leaveStatus;
    }
  }

  bool get isPending => leaveStatus.toLowerCase() == 'pending';
  bool get hasImage => image != null && image!.trim().isNotEmpty;

}


/// Probable
// lib/feature/school/student_leave/model/student_leave_list_model.dart

class StudentLeaveApprovalResponse {
  final bool status;
  final String? message;
  final StudentLeaveData? data;

  StudentLeaveApprovalResponse({
    required this.status,
    this.message,
    this.data,
  });

  factory StudentLeaveApprovalResponse.fromJson(Map<String, dynamic> json) {
    return StudentLeaveApprovalResponse(
      status: json['status'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? StudentLeaveData.fromJson(json['data'])
          : null,
    );
  }
}

class StudentLeaveApprovalRequest {
  final String leaveStatus;
  final String? teacherCardId;
  final String? teacherName;

  StudentLeaveApprovalRequest({
    required this.leaveStatus,
    this.teacherCardId,
    this.teacherName,
  });

  Map<String, dynamic> toJson() => {
    'leave_status': leaveStatus,
    if (teacherCardId != null) 'teacher_card_id': teacherCardId,
    if (teacherName != null) 'teacher_name': teacherName,
  };
}