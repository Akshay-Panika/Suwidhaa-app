import '../../student/model/student_list_model.dart';

// ═══════════════════════════════════════════════════════════
// 🏫 SCHOOL (nested in student + teacher)
// ═══════════════════════════════════════════════════════════
class SchoolData {
  final int? id;
  final String? schoolName;
  final String? schoolCode;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? email;
  final String? website;
  final String? board;
  final String? schoolType;
  final String? createdAt;
  final String? updatedAt;

  SchoolData({
    this.id,
    this.schoolName,
    this.schoolCode,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.latitude,
    this.longitude,
    this.phone,
    this.email,
    this.website,
    this.board,
    this.schoolType,
    this.createdAt,
    this.updatedAt,
  });

  factory SchoolData.fromJson(Map<String, dynamic> json) {
    return SchoolData(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      schoolName: json['school_name']?.toString(),
      schoolCode: json['school_code']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      pincode: json['pincode']?.toString(),
      latitude: json['latitude'] != null
          ? double.tryParse('${json['latitude']}')
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse('${json['longitude']}')
          : null,
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      website: json['website']?.toString(),
      board: json['board']?.toString(),
      schoolType: json['school_type']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "school_name": schoolName,
    "school_code": schoolCode,
    "address": address,
    "city": city,
    "state": state,
    "pincode": pincode,
    "latitude": latitude,
    "longitude": longitude,
    "phone": phone,
    "email": email,
    "website": website,
    "board": board,
    "school_type": schoolType,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };

  String get displayName => schoolName ?? schoolCode ?? 'School';
}

// ═══════════════════════════════════════════════════════════
// 👨‍🏫 TEACHER (full model — 20 fields)
// ═══════════════════════════════════════════════════════════
class TeacherData {
  final int? id;
  final String? teacherProfile;
  final SchoolData? school;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? dob;
  final String? phone;
  final String? altPhone;
  final String? email;
  final String? teacherIdCard;
  final String? address;
  final String? qualification;
  final int? experience;
  final String? salary;
  final String? joinDate;
  final bool checkBox;
  final List<String> subjects;
  final String? createdAt;
  final String? updatedAt;

  TeacherData({
    this.id,
    this.teacherProfile,
    this.school,
    this.firstName,
    this.lastName,
    this.gender,
    this.dob,
    this.phone,
    this.altPhone,
    this.email,
    this.teacherIdCard,
    this.address,
    this.qualification,
    this.experience,
    this.salary,
    this.joinDate,
    this.checkBox = false,
    this.subjects = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory TeacherData.fromJson(Map<String, dynamic> json) {
    // school (nested)
    SchoolData? schoolData;
    final rawSchool = json['school'];
    if (rawSchool is Map) {
      schoolData = SchoolData.fromJson(Map<String, dynamic>.from(rawSchool));
    }

    // subjects (list of strings)
    List<String> subjList = [];
    final rawSubjects = json['subjects'];
    if (rawSubjects is List) {
      subjList = rawSubjects.map((e) => e.toString()).toList();
    }

    return TeacherData(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      teacherProfile: json['teacher_profile']?.toString(),
      school: schoolData,
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      gender: json['gender']?.toString(),
      dob: json['dob']?.toString(),
      phone: json['phone']?.toString(),
      altPhone: json['alt_phone']?.toString(),
      email: json['email']?.toString(),
      teacherIdCard: json['teacher_id_card']?.toString(),
      address: json['address']?.toString(),
      qualification: json['qualification']?.toString(),
      experience: json['experience'] is int
          ? json['experience']
          : int.tryParse('${json['experience']}'),
      salary: json['salary']?.toString(),
      joinDate: json['join_date']?.toString(),
      checkBox: json['check_box'] == true,
      subjects: subjList,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "teacher_profile": teacherProfile,
    "school": school?.toJson(),
    "first_name": firstName,
    "last_name": lastName,
    "gender": gender,
    "dob": dob,
    "phone": phone,
    "alt_phone": altPhone,
    "email": email,
    "teacher_id_card": teacherIdCard,
    "address": address,
    "qualification": qualification,
    "experience": experience,
    "salary": salary,
    "join_date": joinDate,
    "check_box": checkBox,
    "subjects": subjects,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };

  String get fullName =>
      '${firstName ?? ''} ${lastName ?? ''}'.trim();
}

// ═══════════════════════════════════════════════════════════
// 👤 STUDENT ENTRY (per-student status inside homework)
// ═══════════════════════════════════════════════════════════
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

// ═══════════════════════════════════════════════════════════
// 📚 HOMEWORK MODEL (full — 15 fields + typed teacher + students)
// ═══════════════════════════════════════════════════════════
class HomeworkModel {
  final int? id;
  final String? schoolType;
  final String? className;
  final String? subjectName; // maps to `subject`
  final String? subjectTopic;
  final String? issueDate;
  final String? endDate;
  final List<StudentHomeworkEntry> studentIdsList;
  final String? image;
  final String? teacherId;
  final String? teacherName;
  final String? createdAt;
  final String? updatedAt;

  // ✅ Typed teacher object (was Map before)
  final TeacherData? teacher;

  // ✅ Full student list
  final List<StudentListData> students;

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
    this.teacher,
    this.students = const [],
  });

  // ── FROM JSON ──
  factory HomeworkModel.fromJson(Map<String, dynamic> json) {
    // 1. student_ids_list (JSON array of {studentIdcard, status})
    List<StudentHomeworkEntry> entries = [];
    final rawList = json['student_ids_list'];
    if (rawList is List) {
      entries = rawList.map((e) {
        if (e is Map) {
          return StudentHomeworkEntry.fromJson(
            Map<String, dynamic>.from(e),
          );
        }
        return StudentHomeworkEntry(
          studentIdcard: e.toString(),
          status: false,
        );
      }).toList();
    }

    // 2. full `students` array
    List<StudentListData> studentsList = [];
    final rawStudents = json['students'];
    if (rawStudents is List) {
      for (final s in rawStudents) {
        if (s is Map) {
          try {
            studentsList.add(
              StudentListData.fromJson(Map<String, dynamic>.from(s)),
            );
          } catch (_) {/* skip malformed */}
        }
      }
    }

    // 3. `teacher` object (typed)
    TeacherData? teacherObj;
    final rawTeacher = json['teacher'];
    if (rawTeacher is Map) {
      try {
        teacherObj = TeacherData.fromJson(
          Map<String, dynamic>.from(rawTeacher),
        );
      } catch (_) {}
    }

    return HomeworkModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      schoolType: json['school_type']?.toString(),
      className: json['class_name']?.toString(),
      subjectName: json['subject']?.toString(),
      subjectTopic: json['subject_topic']?.toString(),
      issueDate: json['issue_date']?.toString(),
      endDate: json['end_date']?.toString(),
      studentIdsList: entries,
      students: studentsList,
      image: json['image']?.toString(),
      teacherId: json['teacher_id']?.toString(),
      teacherName: json['teacher_name']?.toString(),
      teacher: teacherObj,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  // ── Helpers ──
  String getStatus() {
    final end = DateTime.tryParse(endDate ?? '');
    if (end == null) return 'Pending';
    final now = DateTime.now();
    if (end.isBefore(DateTime(now.year, now.month, now.day))) {
      return 'Overdue';
    }
    if (end.year == now.year && end.month == now.month && end.day == now.day) {
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

  /// Find full StudentListData by id-card (from `students` array)
  StudentListData? findStudent(String idCard) {
    for (final s in students) {
      if (s.studentIdCard == idCard) return s;
    }
    return null;
  }

  /// Find a specific student's homework status entry
  StudentHomeworkEntry? findEntry(String idCard) {
    for (final e in studentIdsList) {
      if (e.studentIdcard == idCard) return e;
    }
    return null;
  }

  /// Convenience: full teacher name (from typed teacher or fallback)
  String get teacherDisplayName =>
      teacher?.fullName.isNotEmpty == true
          ? teacher!.fullName
          : (teacherName ?? 'Teacher');

  /// Convenience: teacher's profile image url
  String? get teacherProfileImage => teacher?.teacherProfile;

  /// Convenience: teacher's school name
  String? get teacherSchoolName => teacher?.school?.schoolName;
}