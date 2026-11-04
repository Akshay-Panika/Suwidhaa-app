// lib/feature/school/report/model/report_card_model.dart
import '../../homework/model/homework_model.dart';       // TeacherData
import '../../student/model/student_list_model.dart';    // StudentListData

// ═══════════════════════════════════════════════════════════
// LIST RESPONSE wrapper
// ═══════════════════════════════════════════════════════════
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
        (json['data'] as List).map((x) => ReportCardData.fromJson(x)),
      )
          : [],
    );
  }
}

// ═══════════════════════════════════════════════════════════
// READ MODEL — full teacher + student nested
// ═══════════════════════════════════════════════════════════
class ReportCardData {
  final int id;
  final String teacherId;   // teacher_id_card
  final String studentId;   // student DB integer id (stringified)
  final String className;
  final String subjectName;
  final String examName;
  final int totalMarks;     // sujectmaks_marks
  final int passingMarks;   // pasingmaks_marks
  final int studentMarks;
  final String result;
  final String? description;
  final String createdAt;
  final String updatedAt;

  // ✅ Full nested models
  final TeacherData? teacher;
  final StudentListData? student;

  ReportCardData({
    required this.id,
    required this.teacherId,
    required this.studentId,
    required this.className,
    required this.subjectName,
    required this.examName,
    required this.totalMarks,
    required this.passingMarks,
    required this.studentMarks,
    required this.result,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.teacher,
    this.student,
  });

  factory ReportCardData.fromJson(Map<String, dynamic> json) {
    int _i(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    TeacherData? teacherObj;
    final rawT = json['teacher'];
    if (rawT is Map) {
      try {
        teacherObj = TeacherData.fromJson(Map<String, dynamic>.from(rawT));
      } catch (_) {}
    }

    StudentListData? studentObj;
    final rawS = json['student'];
    if (rawS is Map) {
      try {
        studentObj =
            StudentListData.fromJson(Map<String, dynamic>.from(rawS));
      } catch (_) {}
    }

    return ReportCardData(
      id: _i(json['id']),
      teacherId: json['teacher_id']?.toString() ?? '',
      studentId: json['student_id']?.toString() ?? '',
      className: json['class_name']?.toString() ?? '',
      subjectName: json['subject_name']?.toString() ?? '',
      examName: json['exam_name']?.toString() ?? '',
      totalMarks: _i(json['sujectmaks_marks']),
      passingMarks: _i(json['pasingmaks_marks']),
      studentMarks: _i(json['student_marks']),
      result: json['result']?.toString() ?? '',
      description: json['description']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      teacher: teacherObj,
      student: studentObj,
    );
  }

  // ── Computed helpers ──
  bool get isPass => result.toLowerCase() == 'pass';

  String get grade {
    if (totalMarks <= 0) return '-';
    final pct = (studentMarks / totalMarks) * 100;
    if (pct >= 90) return 'A+';
    if (pct >= 80) return 'A';
    if (pct >= 70) return 'B+';
    if (pct >= 60) return 'B';
    if (pct >= 50) return 'C';
    if (pct >= 33) return 'D';
    return 'F';
  }

  double get percentage {
    if (totalMarks <= 0) return 0;
    return (studentMarks / totalMarks) * 100;
  }

  // ── Compat getters (old UI names) ──
  String get adminId => teacherId;
  int get subjectMaxMarks => totalMarks;
  int get passingMaxMarks => passingMarks;
  String get remark => description ?? '';
  String get schoolType => '';

  String get studentDisplayName =>
      (student?.fullName.isNotEmpty == true)
          ? student!.fullName
          : 'Student #$studentId';

  String get teacherDisplayName =>
      (teacher?.fullName.isNotEmpty == true)
          ? teacher!.fullName
          : 'Teacher';
}

// ═══════════════════════════════════════════════════════════
// CREATE / UPDATE request payload
// ═══════════════════════════════════════════════════════════
class CreateReportCardRequest {
  final String teacherId;
  final String studentId;
  final String className;
  final String subjectName;
  final String examName;
  final int totalMarks;
  final int passingMarks;
  final int studentMarks;
  final String result;
  final String? description;

  CreateReportCardRequest({
    required this.teacherId,
    required this.studentId,
    required this.className,
    required this.subjectName,
    required this.examName,
    required this.totalMarks,
    required this.passingMarks,
    required this.studentMarks,
    required this.result,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'teacher_id': teacherId,
    'student_id': studentId,
    'class_name': className,
    'subject_name': subjectName,
    'exam_name': examName,
    'sujectmaks_marks': totalMarks,
    'pasingmaks_marks': passingMarks,
    'student_marks': studentMarks,
    'result': result,
    if (description != null && description!.isNotEmpty)
      'description': description,
  };

  /// Compact row for /bulk-create/ payload
  Map<String, dynamic> toBulkRow() => {
    'student_id': studentId,
    'student_marks': studentMarks,
    'result': result,
    if (description != null && description!.isNotEmpty)
      'description': description,
  };
}

// ═══════════════════════════════════════════════════════════
// BULK result
// ═══════════════════════════════════════════════════════════
class BulkCreateResult {
  final List<int> created;
  final List<String> failures;

  BulkCreateResult({required this.created, required this.failures});

  bool get hasFailures => failures.isNotEmpty;
  int get successCount => created.length;
}