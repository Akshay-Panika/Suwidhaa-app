
// ============================================================
// LOGIN
// ============================================================
class StudentAuthData {
  final int id;
  final int student;
  final String studentName;
  final String studentClass;
  final String studentIdCard;
  final bool isActive;
  final String? lastLogin;
  final String? createdAt;

  StudentAuthData({
    required this.id,
    required this.student,
    required this.studentName,
    required this.studentClass,
    required this.studentIdCard,
    required this.isActive,
    this.lastLogin,
    this.createdAt,
  });

  factory StudentAuthData.fromJson(Map<String, dynamic> json) {
    return StudentAuthData(
      id: json['id'] as int? ?? 0,
      student: json['student'] as int? ?? 0,
      studentName: json['student_name'] as String? ?? '',
      studentClass: json['student_class'] as String? ?? '',
      studentIdCard: json['student_id_card'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      lastLogin: json['last_login'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'student': student,
    'student_name': studentName,
    'student_class': studentClass,
    'student_id_card': studentIdCard,
    'is_active': isActive,
    'last_login': lastLogin,
    'created_at': createdAt,
  };
}

class StudentLoginResponse {
  final bool success;
  final String message;
  final StudentAuthData? data;

  StudentLoginResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory StudentLoginResponse.fromJson(Map<String, dynamic> json) {
    return StudentLoginResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] is Map<String, dynamic>
          ? StudentAuthData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

// ============================================================
// OTP REQUEST RESPONSE
// ============================================================
class RequestOtpResponse {
  final bool success;
  final String message;
  final int? expiresInSeconds;

  RequestOtpResponse({
    required this.success,
    required this.message,
    this.expiresInSeconds,
  });

  factory RequestOtpResponse.fromJson(Map<String, dynamic> json) {
    return RequestOtpResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      expiresInSeconds: json['expires_in_seconds'] as int?,
    );
  }
}

// ============================================================
// VERIFY + RESET RESPONSE
// ============================================================
class VerifyAndResetResponse {
  final bool success;
  final String message;

  VerifyAndResetResponse({required this.success, required this.message});

  factory VerifyAndResetResponse.fromJson(Map<String, dynamic> json) {
    return VerifyAndResetResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }
}