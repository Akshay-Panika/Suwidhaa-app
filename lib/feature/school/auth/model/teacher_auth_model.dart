// ============================================================
// SCHOOL INFO (Nested Object)
// ============================================================
class TeacherSchoolInfo {
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

  TeacherSchoolInfo({
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

  factory TeacherSchoolInfo.fromJson(Map<String, dynamic> json) {
    return TeacherSchoolInfo(
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
// TEACHER LOGIN DATA
// ============================================================
class TeacherAuthData {
  final int id;
  final int teacher;
  final String teacherName;
  final String teacherClass;
  final String teacherIdCard;
  final TeacherSchoolInfo? school; // ✅ Naya Field
  final bool isActive;
  final String? lastLogin;
  final String? createdAt;

  TeacherAuthData({
    required this.id,
    required this.teacher,
    required this.teacherName,
    required this.teacherClass,
    required this.teacherIdCard,
    this.school,
    required this.isActive,
    this.lastLogin,
    this.createdAt,
  });

  factory TeacherAuthData.fromJson(Map<String, dynamic> json) {
    // Safe parsing for teacher_class (List -> String)
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
      school: json['school'] is Map
          ? TeacherSchoolInfo.fromJson(Map<String, dynamic>.from(json['school']))
          : null, // ✅ Safe Parse
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
    'school': school?.toJson(), // ✅ Include in JSON
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