// lib/feature/auth/model/school_auth_model.dart
class SchoolAuthLoginResponse {
  final bool success;
  final String message;
  final SchoolAuthLoginData? data;

  SchoolAuthLoginResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SchoolAuthLoginResponse.fromJson(Map<String, dynamic> json) {
    return SchoolAuthLoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] != null ? SchoolAuthLoginData.fromJson(json['data']) : null,
    );
  }
}

class SchoolAuthLoginData {
  final int id;
  final int student;
  final int teacher;
  final String studentName;
  final String teacherName;
  final String studentClass;
  final String studentIdCard;
  final String teacherIdCard;
  final bool isActive;
  final String lastLogin;
  final String createdAt;
  final String userType;

  SchoolAuthLoginData({
    this.id = 0,
    this.student = 0,
    this.teacher = 0,
    this.studentName = '',
    this.teacherName = '',
    this.studentClass = '',
    this.studentIdCard = '',
    this.teacherIdCard = '',
    this.isActive = false,
    this.lastLogin = '',
    this.createdAt = '',
    this.userType = 'student',
  });

  factory SchoolAuthLoginData.fromJson(Map<String, dynamic> json) {
    String userType = 'student';
    if (json.containsKey('teacher') && json['teacher'] != null && json['teacher'] != 0) {
      userType = 'teacher';
    }

    return SchoolAuthLoginData(
      id: json['id'] ?? 0,
      student: json['student'] ?? 0,
      teacher: json['teacher'] ?? 0,
      studentName: json['student_name'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      studentClass: json['student_class'] ?? '',
      studentIdCard: json['student_id_card'] ?? '',
      teacherIdCard: json['teacher_id_card'] ?? '',
      isActive: json['is_active'] ?? false,
      lastLogin: json['last_login'] ?? '',
      createdAt: json['created_at'] ?? '',
      userType: userType,
    );
  }
}

class SchoolAuthLoginRequest {
  final String idCard;
  final String password;

  SchoolAuthLoginRequest({
    required this.idCard,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id_card': idCard,
      'password': password,
    };
  }
}

class SchoolAuthTeacherLoginRequest {
  final String idCard;
  final String password;

  SchoolAuthTeacherLoginRequest({
    required this.idCard,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'teacher_id_card': idCard,
      'password': password,
    };
  }
}