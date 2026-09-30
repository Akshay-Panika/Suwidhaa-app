class StudentHomeworkEntry {
  final String studentIdcard;
  final bool status;

  StudentHomeworkEntry({
    required this.studentIdcard,
    required this.status,
  });

  factory StudentHomeworkEntry.fromJson(Map<String, dynamic> json) {
    return StudentHomeworkEntry(
      studentIdcard: json['studentIdcard']?.toString() ?? '',
      status: json['status'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    "studentIdcard": studentIdcard,
    "status": status,
  };
}

class HomeworkModel {
  final int? id;
  final String? schoolType;
  final String? className;
  final String? subjectName;      // maps to `subject` in API
  final String? subjectTopic;
  final String? issueDate;
  final String? endDate;
  final List<StudentHomeworkEntry> studentIdsList;
  final String? image;
  final String? teacherId;
  final String? teacherName;
  final String? createdAt;
  final String? updatedAt;

  HomeworkModel({
    this.id,
    this.schoolType,
    this.className,
    this.subjectName,
    this.subjectTopic,
    this.issueDate,
    this.endDate,
    this.studentIdsList = const [],
    this.image,
    this.teacherId,
    this.teacherName,
    this.createdAt,
    this.updatedAt,
  });

  // ── FROM JSON ──
  factory HomeworkModel.fromJson(Map<String, dynamic> json) {
    // Parse student_ids_list which comes as list of dicts
    List<StudentHomeworkEntry> students = [];
    final raw = json['student_ids_list'];
    if (raw is List) {
      students = raw.map((e) {
        if (e is Map) {
          return StudentHomeworkEntry.fromJson(Map<String, dynamic>.from(e));
        }
        // fallback: string or int
        return StudentHomeworkEntry(
          studentIdcard: e.toString(),
          status: false,
        );
      }).toList();
    }

    return HomeworkModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      schoolType: json['school_type']?.toString(),
      className: json['class_name']?.toString(),
      subjectName: json['subject']?.toString(),
      subjectTopic: json['subject_topic']?.toString(),
      issueDate: json['issue_date']?.toString(),
      endDate: json['end_date']?.toString(),
      studentIdsList: students,
      image: json['image']?.toString(),
      teacherId: json['teacher_id']?.toString(),
      teacherName: json['teacher_name']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  // ── Helpers used by detail screen ──
  String getStatus() {
    final end = DateTime.tryParse(endDate ?? '');
    if (end == null) return 'Pending';
    final now = DateTime.now();
    if (end.isBefore(DateTime(now.year, now.month, now.day))) {
      return 'Overdue';
    }
    if (end.year == now.year &&
        end.month == now.month &&
        end.day == now.day) {
      return 'Today';
    }
    return 'Pending';
  }

  int getRemainingDays() {
    final end = DateTime.tryParse(endDate ?? '');
    if (end == null) return 0;
    return end.difference(DateTime.now()).inDays;
  }

  String getPriority() {
    final d = getRemainingDays();
    if (d <= 0) return 'High';
    if (d <= 3) return 'Medium';
    return 'Low';
  }
}