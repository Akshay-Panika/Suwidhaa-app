// lib/feature/school/report/model/report_card_model.dart
class ReportCardResponse {
  final bool status;
  final String message;
  final int count;
  final List<ReportCardData> data;

  ReportCardResponse({
    required this.status,
    required this.message,
    required this.count,
    required this.data,
  });

  factory ReportCardResponse.fromJson(Map<String, dynamic> json) {
    return ReportCardResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      count: json['count'] ?? 0,
      data: json['data'] != null
          ? List<ReportCardData>.from(
          json['data'].map((x) => ReportCardData.fromJson(x)))
          : [],
    );
  }
}

class ReportCardData {
  final int id;
  final String adminId;
  final String studentId;
  final String schoolType;
  final String className;
  final String subjectName;
  final String examName;
  final int subjectMaxMarks;
  final int passingMaxMarks;
  final int studentMarks;
  final String result;
  final String? description;
  final String createdAt;
  final String updatedAt;

  ReportCardData({
    required this.id,
    required this.adminId,
    required this.studentId,
    required this.schoolType,
    required this.className,
    required this.subjectName,
    required this.examName,
    required this.subjectMaxMarks,
    required this.passingMaxMarks,
    required this.studentMarks,
    required this.result,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReportCardData.fromJson(Map<String, dynamic> json) {
    return ReportCardData(
      id: json['id'] ?? 0,
      adminId: json['admin_id'] ?? '',
      studentId: json['student_id'] ?? '',
      schoolType: json['school_type'] ?? '',
      className: json['class_name'] ?? '',
      subjectName: json['subject_name'] ?? '',
      examName: json['exam_name'] ?? '',
      // ⚠️ keep API spelling
      subjectMaxMarks: json['sujectmaks_marks'] ?? 0,
      passingMaxMarks: json['pasingmaks_marks'] ?? 0,
      studentMarks: json['student_marks'] ?? 0,
      result: json['result'] ?? '',
      description: json['description'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  bool get isPass => result.toLowerCase() == 'pass';

  String get grade {
    if (subjectMaxMarks <= 0) return '-';
    final pct = (studentMarks / subjectMaxMarks) * 100;
    if (pct >= 90) return "A+";
    if (pct >= 80) return "A";
    if (pct >= 70) return "B+";
    if (pct >= 60) return "B";
    if (pct >= 50) return "C";
    if (pct >= 33) return "D";
    return "F";
  }

  String get remark => description ?? '';
}

// ==================== CREATE REQUEST BODY ====================
class CreateReportCardRequest {
  final String adminId;
  final String studentId;
  final String schoolType;
  final String className;
  final String subjectName;
  final String examName;
  final int subjectMaxMarks;
  final int passingMaxMarks;
  final int studentMarks;
  final String result;
  final String? description;

  CreateReportCardRequest({
    required this.adminId,
    required this.studentId,
    required this.schoolType,
    required this.className,
    required this.subjectName,
    required this.examName,
    required this.subjectMaxMarks,
    required this.passingMaxMarks,
    required this.studentMarks,
    required this.result,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'admin_id': adminId,
    'student_id': studentId,
    'school_type': schoolType,
    'class_name': className,
    'subject_name': subjectName,
    'exam_name': examName,
    // ⚠️ keep API spelling on the way out too
    'sujectmaks_marks': subjectMaxMarks,
    'pasingmaks_marks': passingMaxMarks,
    'student_marks': studentMarks,
    'result': result,
    'description': description,
  };
}