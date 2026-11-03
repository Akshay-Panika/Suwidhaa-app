// ============================================================
// SCHOOL INFO (Nested Object)
// ============================================================
class StudentSchoolInfo {
  final int id;
  final String schoolName;
  final String schoolCode;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final double? latitude;
  final double? longitude;
  final String phone;
  final String email;
  final String website;
  final String board;
  final String schoolType;
  final String createdAt;
  final String updatedAt;

  StudentSchoolInfo({
    required this.id,
    required this.schoolName,
    required this.schoolCode,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.latitude,
    this.longitude,
    required this.phone,
    required this.email,
    required this.website,
    required this.board,
    required this.schoolType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentSchoolInfo.fromJson(Map<String, dynamic> json) {
    return StudentSchoolInfo(
      id: json['id'] as int? ?? 0,
      schoolName: json['school_name']?.toString() ?? '',
      schoolCode: json['school_code']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      website: json['website']?.toString() ?? '',
      board: json['board']?.toString() ?? '',
      schoolType: json['school_type']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'school_name': schoolName,
    'school_code': schoolCode,
    'address': address,
    'city': city,
    'state': state,
    'pincode': pincode,
    'latitude': latitude,
    'longitude': longitude,
    'phone': phone,
    'email': email,
    'website': website,
    'board': board,
    'school_type': schoolType,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

// ============================================================
// LOGIN DATA
// ============================================================
class StudentAuthData {
  final int id;
  final int student;
  final String studentName;
  final String studentClass;
  final String studentIdCard;
  final StudentSchoolInfo? school; // ✅ Naya Field
  final bool isActive;
  final String? lastLogin;
  final String? createdAt;

  StudentAuthData({
    required this.id,
    required this.student,
    required this.studentName,
    required this.studentClass,
    required this.studentIdCard,
    this.school,
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
      school: json['school'] is Map
          ? StudentSchoolInfo.fromJson(Map<String, dynamic>.from(json['school']))
          : null, // ✅ Safe Parse
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
    'school': school?.toJson(), // ✅ Include in JSON
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