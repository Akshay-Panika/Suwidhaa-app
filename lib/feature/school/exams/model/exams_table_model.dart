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
  final dynamic id;
  final String subject;
  final DateTime date;
  final String startTime;
  final String endTime;

  /// ✅ Backend `invigilator` FK — Teacher DB pk (send as-is in payload)
  final int? invigilatorId;

  /// ✅ Display name — from `invigilator_details.first_name + last_name`
  final String invigilator;

  final String room;

  SubjectSchedule({
    this.id,
    required this.subject,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.invigilatorId,
    required this.invigilator,
    required this.room,
  });

  String get formattedDate =>
      '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';

  /// ============ API MAPPING ============
  factory SubjectSchedule.fromJson(Map<String, dynamic> json) {
    // Parse nested teacher object → display name
    String displayName = '';
    final details = json['invigilator_details'];
    if (details is Map<String, dynamic>) {
      final f = (details['first_name'] ?? '').toString().trim();
      final m = (details['middle_name'] ?? '').toString().trim();
      final l = (details['last_name'] ?? '').toString().trim();
      displayName = [f, m, l].where((p) => p.isNotEmpty).join(' ');
    }

    // Invigilator ID (write field, backend returns as int or null)
    int? invId;
    final rawInv = json['invigilator'];
    if (rawInv is int) {
      invId = rawInv;
    } else if (rawInv is String && rawInv.isNotEmpty) {
      invId = int.tryParse(rawInv);
    }

    return SubjectSchedule(
      id: json['id'],
      subject: json['subject'] ?? '',
      date: DateTime.parse(json['date']),
      startTime: json['start_time'] ?? '10:00',
      endTime: json['end_time'] ?? '13:00',
      invigilatorId: invId,
      invigilator: displayName,
      room: json['room'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'subject': subject,
    'date':
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
    'start_time': startTime,
    'end_time': endTime,
    // ✅ Send invigilator as FK id (int) — not name string
    'invigilator': invigilatorId,
    'room': room,
  };

  SubjectSchedule copyWith({
    dynamic id,
    String? subject,
    DateTime? date,
    String? startTime,
    String? endTime,
    int? invigilatorId,
    String? invigilator,
    String? room,
  }) {
    return SubjectSchedule(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      invigilatorId: invigilatorId ?? this.invigilatorId,
      invigilator: invigilator ?? this.invigilator,
      room: room ?? this.room,
    );
  }
}

// ==================== CLASS EXAM TIMETABLE ====================
class ClassExamTimetable {
  final dynamic id;
  final String className;
  final String section;
  final ExamType examType;
  final DateTime fromDate;
  final DateTime toDate;
  final List<SubjectSchedule> schedules;

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

  factory ClassExamTimetable.fromJson(Map<String, dynamic> json) {
    final rawSchedules = json['schedules'] as List<dynamic>? ?? [];
    return ClassExamTimetable(
      id: json['id'],
      className: json['class_name'] ?? '',
      section: '',
      examType: ExamTypeLabel.fromApi(json['exam_type'] ?? 'board'),
      fromDate: DateTime.parse(json['from_date']),
      toDate: DateTime.parse(json['to_date']),
      schedules: rawSchedules
          .whereType<Map<String, dynamic>>()
          .map(SubjectSchedule.fromJson)
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