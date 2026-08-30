// lib/feature/school/student/model/student_model.dart
class StudentResponse {
  final bool success;
  final StudentData data;

  StudentResponse({
    required this.success,
    required this.data,
  });

  factory StudentResponse.fromJson(Map<String, dynamic> json) {
    return StudentResponse(
      success: json['success'] ?? false,
      data: StudentData.fromJson(json['data'] ?? {}),
    );
  }
}

class StudentData {
  final int id;
  final String studentProfile;
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
  final String schoolType;
  final String studentIdCard;
  final String createdAt;
  final String updatedAt;

  StudentData({
    required this.id,
    required this.studentProfile,
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
    required this.schoolType,
    required this.studentIdCard,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    return StudentData(
      id: json['id'] ?? 0,
      studentProfile: json['student_profile'] ?? '',
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      fatherName: json['father_name'] ?? '',
      motherName: json['mother_name'] ?? '',
      parentPhone: json['parent_phone'] ?? '',
      alternativePhone: json['alternative_phone'] ?? '',
      adharNumber: json['adhar_number'] ?? '',
      sssmid: json['SSSMID'] ?? '',
      studentClass: json['student_class'] ?? '',
      rollNumber: json['roll_number'] ?? '',
      address: json['address'] ?? '',
      casteCategory: json['caste_category'] ?? '',
      feeStatus: json['fee_status'] ?? '',
      feeAmount: json['fee_amount'] ?? '',
      paidAmount: json['paid_amount'] ?? '',
      checkBox: json['check_box'] ?? false,
      schoolType: json['school_type'] ?? '',
      studentIdCard: json['student_id_card'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  // Helper method to get full name
  String get fullName {
    String fullName = firstName;
    if (middleName.isNotEmpty) {
      fullName += ' $middleName';
    }
    if (lastName.isNotEmpty) {
      fullName += ' $lastName';
    }
    return fullName;
  }

  // Helper method to get remaining fee
  double get remainingFee {
    try {
      double total = double.tryParse(feeAmount) ?? 0;
      double paid = double.tryParse(paidAmount) ?? 0;
      return total - paid;
    } catch (e) {
      return 0;
    }
  }
}