// ============================================================
// TEACHER LOGIN DATA
// ============================================================
class TeacherAuthData {
  final int id;
  final int teacher;
  final String teacherName;
  final String teacherClass;
  final String teacherIdCard;
  final bool isActive;
  final String? lastLogin;
  final String? createdAt;

  TeacherAuthData({
    required this.id,
    required this.teacher,
    required this.teacherName,
    required this.teacherClass,
    required this.teacherIdCard,
    required this.isActive,
    this.lastLogin,
    this.createdAt,
  });

  factory TeacherAuthData.fromJson(Map<String, dynamic> json) {
    String _parseClass(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is List) return value.map((e) => e.toString()).join(', ');
      return value.toString();
    }

    return TeacherAuthData(
      id: json['id'] as int? ?? 0,
      teacher: json['teacher'] as int? ?? 0,
      teacherName: json['teacher_name']?.toString() ?? '',
      teacherClass: _parseClass(json['teacher_class']),
      teacherIdCard: json['teacher_id_card']?.toString() ?? '',
      isActive: json['is_active'] as bool? ?? true,
      lastLogin: json['last_login']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'teacher': teacher,
    'teacher_name': teacherName,
    'teacher_class': teacherClass,
    'teacher_id_card': teacherIdCard,
    'is_active': isActive,
    'last_login': lastLogin,
    'created_at': createdAt,
  };
}

class TeacherLoginResponse {
  final bool success;
  final String message;
  final TeacherAuthData? data;

  TeacherLoginResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory TeacherLoginResponse.fromJson(Map<String, dynamic> json) {
    return TeacherLoginResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] is Map<String, dynamic>
          ? TeacherAuthData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

// ============================================================
// OTP REQUEST RESPONSE
// ============================================================
class TeacherRequestOtpResponse {
  final bool success;
  final String message;
  final int? expiresInSeconds;

  TeacherRequestOtpResponse({
    required this.success,
    required this.message,
    this.expiresInSeconds,
  });

  factory TeacherRequestOtpResponse.fromJson(Map<String, dynamic> json) {
    return TeacherRequestOtpResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      expiresInSeconds: json['expires_in_seconds'] as int?,
    );
  }
}

// ============================================================
// VERIFY + RESET RESPONSE
// ============================================================
class TeacherVerifyAndResetResponse {
  final bool success;
  final String message;

  TeacherVerifyAndResetResponse({
    required this.success,
    required this.message,
  });

  factory TeacherVerifyAndResetResponse.fromJson(Map<String, dynamic> json) {
    return TeacherVerifyAndResetResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }
}