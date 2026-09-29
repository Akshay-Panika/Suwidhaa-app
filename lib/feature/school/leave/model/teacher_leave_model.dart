class TeacherLeaveModel {
  final int? id;
  final String teacherId;
  final String teacherIdCard;
  final bool applyStatus;
  final String? reasonMsg;
  final String startDate;
  final String endDate;
  final String? image;
  final String? createdDate;

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
  });

  factory TeacherLeaveModel.fromJson(Map<String, dynamic> json) {
    return TeacherLeaveModel(
      id: json['id'],
      teacherId: json['teacher_id']?.toString() ?? '',
      teacherIdCard: json['teacher_id_card']?.toString() ?? '',
      applyStatus: json['apply_status'] ?? false,
      reasonMsg: json['reason_msg'],
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      image: json['image'],
      createdDate: json['created_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'teacher_id': teacherId,
      'teacher_id_card': teacherIdCard,
      'apply_status': applyStatus,
      'reason_msg': reasonMsg,
      'start_date': startDate,
      'end_date': endDate,
      // image is sent as a file via FormData, not in JSON
    };
  }
}