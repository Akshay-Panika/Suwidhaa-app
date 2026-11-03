// lib/feature/school/student_list/model/student_list_model.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ==================== SCHOOL INFO ====================
class StudentListSchoolInfo {
  final int id;
  final String schoolName;
  final String schoolCode;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String phone;
  final String email;
  final String website;
  final String board;
  final String schoolType;

  StudentListSchoolInfo({
    required this.id,
    required this.schoolName,
    required this.schoolCode,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.phone,
    required this.email,
    required this.website,
    required this.board,
    required this.schoolType,
  });

  factory StudentListSchoolInfo.fromJson(Map<String, dynamic> json) {
    return StudentListSchoolInfo(
      id: json['id'] ?? 0,
      schoolName: json['school_name'] ?? '',
      schoolCode: json['school_code'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      board: json['board'] ?? '',
      schoolType: json['school_type'] ?? '',
    );
  }
}

// ==================== LIST RESPONSE ====================
class StudentListResponse {
  final bool success;
  final int count;
  final List<StudentListData> data;

  StudentListResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory StudentListResponse.fromJson(Map<String, dynamic> json) {
    return StudentListResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: json['data'] != null
          ? List<StudentListData>.from(json['data'].map((x) => StudentListData.fromJson(x)))
          : [],
    );
  }
}

// ==================== STUDENT DATA ====================
class StudentListData {
  final int id;
  final String? studentProfile;
  final StudentListSchoolInfo? school; // ✅ Naya nested object
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

  StudentListData({
    required this.id,
    this.studentProfile,
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

  factory StudentListData.fromJson(Map<String, dynamic> json) {
    return StudentListData(
      id: json['id'] ?? 0,
      studentProfile: json['student_profile'],
      school: json['school'] is Map
          ? StudentListSchoolInfo.fromJson(Map<String, dynamic>.from(json['school']))
          : null, // ✅ Safe Parse
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
      studentIdCard: json['student_id_card'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  // Helper Methods
  String get fullName {
    String full = firstName;
    if (middleName.isNotEmpty) full += ' $middleName';
    if (lastName.isNotEmpty) full += ' $lastName';
    return full.trim();
  }

  // Backward compatibility getter (agar UI me pehle use ho raha tha)
  String get schoolType => school?.schoolType ?? '';
  String get schoolName => school?.schoolName ?? '';

  double get remainingFee {
    try {
      double total = double.tryParse(feeAmount) ?? 0;
      double paid = double.tryParse(paidAmount) ?? 0;
      return total - paid;
    } catch (e) {
      return 0;
    }
  }

  Color get genderColor => gender.toLowerCase() == 'male' ? Colors.blue : Colors.pink;
  IconData get genderIcon => gender.toLowerCase() == 'male' ? Icons.male : Icons.female;
  Color get statusColor => feeStatus.toLowerCase() == 'paid' ? Colors.green : Colors.orange;
  IconData get statusIcon => feeStatus.toLowerCase() == 'paid' ? Icons.check_circle : Icons.warning_amber;
  String get displayName => firstName.isNotEmpty ? firstName[0].toUpperCase() : '?';
}