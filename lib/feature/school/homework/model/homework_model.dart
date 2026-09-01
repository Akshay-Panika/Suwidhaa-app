class HomeworkModel {
  final int? id;
  final String? subjectName;
  final String? subjectTopic;
  final String? issueDate;
  final String? endDate;
  final String? image;
  final String? className;
  final String? teacherName;
  final String? teacherId;
  final String? schoolType;
  final String? createdAt;
  final String? updatedAt;

  HomeworkModel({
    this.id,
    this.subjectName,
    this.subjectTopic,
    this.issueDate,
    this.endDate,
    this.image,
    this.className,
    this.teacherName,
    this.teacherId,
    this.schoolType,
    this.createdAt,
    this.updatedAt,
  });

  factory HomeworkModel.fromJson(Map<String, dynamic> json) {
    return HomeworkModel(
      id: json['id'],
      subjectName: json['subject_name']?.toString(),
      subjectTopic: json['subject_topic']?.toString(),
      issueDate: json['issue_date']?.toString(),
      endDate: json['end_date']?.toString(),
      image: json['image']?.toString(),
      className: json['class_name']?.toString(),
      teacherName: json['teacher_name']?.toString(),
      teacherId: json['teacher_id']?.toString(),
      schoolType: json['school_type']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_name': subjectName,
      'subject_topic': subjectTopic,
      'issue_date': issueDate,
      'end_date': endDate,
      'class_name': className,
      'teacher_name': teacherName,
      'teacher_id': teacherId,
      'school_type': schoolType,
    };
  }

  HomeworkModel copyWith({
    int? id,
    String? subjectName,
    String? subjectTopic,
    String? issueDate,
    String? endDate,
    String? image,
    String? className,
    String? teacherName,
    String? teacherId,
    String? schoolType,
    String? createdAt,
    String? updatedAt,
  }) {
    return HomeworkModel(
      id: id ?? this.id,
      subjectName: subjectName ?? this.subjectName,
      subjectTopic: subjectTopic ?? this.subjectTopic,
      issueDate: issueDate ?? this.issueDate,
      endDate: endDate ?? this.endDate,
      image: image ?? this.image,
      className: className ?? this.className,
      teacherName: teacherName ?? this.teacherName,
      teacherId: teacherId ?? this.teacherId,
      schoolType: schoolType ?? this.schoolType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String getStatus() {
    if (endDate == null) return 'Pending';
    try {
      final endDateObj = DateTime.parse(endDate!);
      final now = DateTime.now();
      final days = endDateObj.difference(now).inDays;
      if (days < 0) return 'Overdue';
      if (days == 0) return 'Today';
      return 'Pending';
    } catch (e) {
      return 'Pending';
    }
  }

  String getPriority() {
    if (endDate == null) return 'Low';
    try {
      final endDateObj = DateTime.parse(endDate!);
      final now = DateTime.now();
      final days = endDateObj.difference(now).inDays;
      if (days < 0) return 'Critical';
      if (days <= 2) return 'High';
      if (days <= 5) return 'Medium';
      return 'Low';
    } catch (e) {
      return 'Low';
    }
  }

  int getRemainingDays() {
    if (endDate == null) return 0;
    try {
      final endDateObj = DateTime.parse(endDate!);
      final now = DateTime.now();
      return endDateObj.difference(now).inDays;
    } catch (e) {
      return 0;
    }
  }
}

class HomeworkResponse {
  final bool success;
  final String? message;
  final int? count;
  final List<HomeworkModel>? data;
  final HomeworkModel? homework;

  HomeworkResponse({
    required this.success,
    this.message,
    this.count,
    this.data,
    this.homework,
  });

  factory HomeworkResponse.fromJson(Map<String, dynamic> json) {
    List<HomeworkModel>? homeworkList;
    HomeworkModel? singleHomework;

    if (json['data'] != null) {
      if (json['data'] is List) {
        homeworkList = (json['data'] as List)
            .map((item) => HomeworkModel.fromJson(item))
            .toList();
      } else if (json['data'] is Map<String, dynamic>) {
        singleHomework = HomeworkModel.fromJson(json['data']);
      }
    }

    return HomeworkResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString(),
      count: json['count'],
      data: homeworkList,
      homework: singleHomework,
    );
  }
}