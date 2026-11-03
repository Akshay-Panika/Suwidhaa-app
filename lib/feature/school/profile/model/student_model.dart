// lib/feature/school/student/model/student_model.dart

// ==================== SCHOOL INFO ====================
class SchoolInfo {
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

  SchoolInfo({
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

  factory SchoolInfo.fromJson(Map<String, dynamic> json) {
    return SchoolInfo(
      id: json['id'] as int? ?? 0,
      schoolName: json['school_name'] as String? ?? '',
      schoolCode: json['school_code'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      pincode: json['pincode'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      website: json['website'] as String? ?? '',
      board: json['board'] as String? ?? '',
      schoolType: json['school_type'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
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

  // ---------- Helpers ----------
  String get fullAddress {
    final parts = [address, city, state, pincode]
        .where((e) => e.isNotEmpty && e != 'null')
        .toList();
    return parts.join(', ');
  }

  bool get hasLocation => latitude != null && longitude != null;

  String get shortInfo {
    final parts = <String>[];
    if (board.isNotEmpty) parts.add(board);
    if (schoolType.isNotEmpty) parts.add(schoolType);
    return parts.join('  •  ');
  }
}

// ==================== STUDENT RESPONSE ====================
class StudentResponse {
  final bool success;
  final StudentData data;

  StudentResponse({
    required this.success,
    required this.data,
  });

  factory StudentResponse.fromJson(Map<String, dynamic> json) {
    return StudentResponse(
      success: json['success'] as bool? ?? false,
      data: StudentData.fromJson(
        Map<String, dynamic>.from(json['data'] ?? {}),
      ),
    );
  }
}

// ==================== STUDENT DATA ====================
class StudentData {
  final int id;
  final String studentProfile;
  final SchoolInfo? school;
  final String firstName;
  final String middleName;
  final String lastName;
  final String dob;
  final String gender;
  final String fatherName;
  final String motherName;
  final String parentPhone;
  final String alternativePhone;
  final String adharNumber;
  final String sssmid;
  final String studentClass;
  final String rollNumber;
  final String address;
  final String casteCategory;
  final String feeStatus;
  final String feeAmount;
  final String paidAmount;
  final bool checkBox;
  final String studentIdCard;
  final String createdAt;
  final String updatedAt;

  StudentData({
    required this.id,
    required this.studentProfile,
    this.school,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.fatherName,
    required this.motherName,
    required this.parentPhone,
    required this.alternativePhone,
    required this.adharNumber,
    required this.sssmid,
    required this.studentClass,
    required this.rollNumber,
    required this.address,
    required this.casteCategory,
    required this.feeStatus,
    required this.feeAmount,
    required this.paidAmount,
    required this.checkBox,
    required this.studentIdCard,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    return StudentData(
      id: json['id'] as int? ?? 0,
      studentProfile: json['student_profile'] as String? ?? '',
      school: json['school'] is Map
          ? SchoolInfo.fromJson(Map<String, dynamic>.from(json['school']))
          : null,
      firstName: json['first_name'] as String? ?? '',
      middleName: json['middle_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      dob: json['dob'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      fatherName: json['father_name'] as String? ?? '',
      motherName: json['mother_name'] as String? ?? '',
      parentPhone: json['parent_phone'] as String? ?? '',
      alternativePhone: json['alternative_phone'] as String? ?? '',
      adharNumber: json['adhar_number'] as String? ?? '',
      sssmid: json['SSSMID'] as String? ?? '',
      studentClass: json['student_class'] as String? ?? '',
      rollNumber: json['roll_number'] as String? ?? '',
      address: json['address'] as String? ?? '',
      casteCategory: json['caste_category'] as String? ?? '',
      feeStatus: json['fee_status'] as String? ?? '',
      feeAmount: json['fee_amount'] as String? ?? '',
      paidAmount: json['paid_amount'] as String? ?? '',
      checkBox: json['check_box'] as bool? ?? false,
      studentIdCard: json['student_id_card'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'student_profile': studentProfile,
    'school': school?.toJson(),
    'first_name': firstName,
    'middle_name': middleName,
    'last_name': lastName,
    'dob': dob,
    'gender': gender,
    'father_name': fatherName,
    'mother_name': motherName,
    'parent_phone': parentPhone,
    'alternative_phone': alternativePhone,
    'adhar_number': adharNumber,
    'SSSMID': sssmid,
    'student_class': studentClass,
    'roll_number': rollNumber,
    'address': address,
    'caste_category': casteCategory,
    'fee_status': feeStatus,
    'fee_amount': feeAmount,
    'paid_amount': paidAmount,
    'check_box': checkBox,
    'student_id_card': studentIdCard,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };

  // ---------- Helpers ----------
  String get fullName {
    String name = firstName;
    if (middleName.isNotEmpty) name += ' $middleName';
    if (lastName.isNotEmpty) name += ' $lastName';
    return name.trim();
  }

  double get feeAmountValue => double.tryParse(feeAmount) ?? 0;
  double get paidAmountValue => double.tryParse(paidAmount) ?? 0;
  double get remainingFee => feeAmountValue - paidAmountValue;
  bool get isFeePaid => feeStatus.toLowerCase() == 'paid';

  // Backward-compatible getters
  String get schoolName => school?.schoolName ?? '';
  String get schoolType => school?.schoolType ?? '';
}