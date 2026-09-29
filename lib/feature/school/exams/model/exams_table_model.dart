// lib/feature/school/exams/model/exams_table_model.dart

// ==================== ENUM ====================
enum ExamType { board, halfYearly, annual, preBoard, unitTest }

extension ExamTypeLabel on ExamType {
  String get label {
    switch (this) {
      case ExamType.board:
        return 'Board Exam';
      case ExamType.halfYearly:
        return 'Half Yearly';
      case ExamType.annual:
        return 'Annual Exam';
      case ExamType.preBoard:
        return 'Pre-Board';
      case ExamType.unitTest:
        return 'Unit Test';
    }
  }

  /// Maps to backend values: board, halfYearly, annual, preBoard, unitTest
  String get apiValue {
    switch (this) {
      case ExamType.board:
        return 'board';
      case ExamType.halfYearly:
        return 'halfYearly';
      case ExamType.annual:
        return 'annual';
      case ExamType.preBoard:
        return 'preBoard';
      case ExamType.unitTest:
        return 'unitTest';
    }
  }

  static ExamType fromApi(String value) {
    switch (value) {
      case 'board':
        return ExamType.board;
      case 'halfYearly':
        return ExamType.halfYearly;
      case 'annual':
        return ExamType.annual;
      case 'preBoard':
        return ExamType.preBoard;
      case 'unitTest':
        return ExamType.unitTest;
      default:
        return ExamType.board;
    }
  }
}

// ==================== SUBJECT SCHEDULE ====================
class SubjectSchedule {
  final dynamic id; // can be int (from API) or String
  final String subject;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String invigilator;
  final String room;

  SubjectSchedule({
    this.id,
    required this.subject,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.invigilator,
    required this.room,
  });

  String get formattedDate =>
      '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';

  /// ============ API MAPPING ============
  factory SubjectSchedule.fromJson(Map<String, dynamic> json) {
    return SubjectSchedule(
      id: json['id'],
      subject: json['subject'] ?? '',
      date: DateTime.parse(json['date']),
      startTime: json['start_time'] ?? '10:00',
      endTime: json['end_time'] ?? '13:00',
      invigilator: json['invigilator'] ?? '',
      room: json['room'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'subject': subject,
    'date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
    'start_time': startTime,
    'end_time': endTime,
    'invigilator': invigilator,
    'room': room,
  };
}

// ==================== CLASS EXAM TIMETABLE ====================
class ClassExamTimetable {
  final dynamic id; // int from API, String when created locally
  final String className;
  final String section;
  final ExamType examType;
  final DateTime fromDate;
  final DateTime toDate;
  final List<SubjectSchedule> schedules;

  // audit
  final String? createdByName;
  final String? createdById;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ClassExamTimetable({
    this.id,
    required this.className,
    this.section = '',
    required this.examType,
    required this.fromDate,
    required this.toDate,
    required this.schedules,
    this.createdByName,
    this.createdById,
    this.createdAt,
    this.updatedAt,
  });

  String get formattedRange =>
      '${fromDate.day}-${fromDate.month}-${fromDate.year}  to  ${toDate.day}-${toDate.month}-${toDate.year}';

  String get displayTitle => '$className • ${examType.label}';

  /// ============ API MAPPING ============
  factory ClassExamTimetable.fromJson(Map<String, dynamic> json) {
    final rawSchedules = json['schedules'] as List<dynamic>? ?? [];
    return ClassExamTimetable(
      id: json['id'],
      className: json['class_name'] ?? '',
      section: '', // backend doesn't return section
      examType: ExamTypeLabel.fromApi(json['exam_type'] ?? 'board'),
      fromDate: DateTime.parse(json['from_date']),
      toDate: DateTime.parse(json['to_date']),
      schedules: rawSchedules
          .map((s) => SubjectSchedule.fromJson(s as Map<String, dynamic>))
          .toList(),
      createdByName: json['created_by_name'],
      createdById: json['created_by_id'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'class_name': className,
    'exam_type': examType.apiValue,
    'from_date':
    '${fromDate.year}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}',
    'to_date':
    '${toDate.year}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}',
    'created_by_id': createdById,
    'created_by_name': createdByName,
    'schedules': schedules.map((s) => s.toJson()).toList(),
  };

  ClassExamTimetable copyWith({
    dynamic id,
    String? className,
    String? section,
    ExamType? examType,
    DateTime? fromDate,
    DateTime? toDate,
    List<SubjectSchedule>? schedules,
    String? createdByName,
    String? createdById,
  }) {
    return ClassExamTimetable(
      id: id ?? this.id,
      className: className ?? this.className,
      section: section ?? this.section,
      examType: examType ?? this.examType,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      schedules: schedules ?? this.schedules,
      createdByName: createdByName ?? this.createdByName,
      createdById: createdById ?? this.createdById,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}