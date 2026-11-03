// lib/feature/school/teacher/model/teacher_model.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  String get fullAddress {
    final parts = [address, city, state, pincode]
        .where((e) => e.isNotEmpty && e != 'null')
        .toList();
    return parts.join(', ');
  }
}

// ==================== SINGLE TEACHER RESPONSE ====================
class TeacherResponse {
  final bool success;
  final TeacherData data;

  TeacherResponse({
    required this.success,
    required this.data,
  });

  factory TeacherResponse.fromJson(Map<String, dynamic> json) {
    return TeacherResponse(
      success: json['success'] ?? false,
      data: TeacherData.fromJson(json['data'] ?? {}),
    );
  }
}

// ==================== TEACHER LIST RESPONSE ====================
class TeacherListResponse {
  final bool success;
  final int count;
  final List<TeacherData> data;

  TeacherListResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory TeacherListResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>? ?? [])
        .map((e) => TeacherData.fromJson(e as Map<String, dynamic>))
        .toList();

    return TeacherListResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? list.length,
      data: list,
    );
  }
}

// ==================== TEACHER DATA ====================
class TeacherData {
  final int id;
  final String? teacherProfile;
  final SchoolInfo? school; // ✅ Naya nested object
  final String firstName;
  final String lastName;
  final String gender;
  final String dob;
  final String phone;
  final String altPhone;
  final String email;
  final String teacherIdCard;
  final String address;
  final String qualification;
  final int experience;
  final String salary;
  final String joinDate;
  final bool checkBox;
  final List<String> subjects;
  final String createdAt;
  final String updatedAt;

  TeacherData({
    required this.id,
    this.teacherProfile,
    this.school,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dob,
    required this.phone,
    required this.altPhone,
    required this.email,
    required this.teacherIdCard,
    required this.address,
    required this.qualification,
    required this.experience,
    required this.salary,
    required this.joinDate,
    required this.checkBox,
    required this.subjects,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TeacherData.fromJson(Map<String, dynamic> json) {
    // Safe parsing for subjects
    List<String> subjectList = [];
    if (json['subjects'] != null && json['subjects'] is List) {
      subjectList = List<String>.from(json['subjects']);
    }

    return TeacherData(
      id: json['id'] ?? 0,
      teacherProfile: json['teacher_profile'],
      school: json['school'] is Map
          ? SchoolInfo.fromJson(Map<String, dynamic>.from(json['school']))
          : null,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] ?? '',
      phone: json['phone'] ?? '',
      altPhone: json['alt_phone'] ?? '',
      email: json['email'] ?? '',
      teacherIdCard: json['teacher_id_card'] ?? '',
      address: json['address'] ?? '',
      qualification: json['qualification'] ?? '',
      experience: json['experience'] ?? 0,
      salary: json['salary'] ?? '0.00',
      joinDate: json['join_date'] ?? '',
      checkBox: json['check_box'] ?? false,
      subjects: subjectList,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  String get fullName => '$firstName $lastName'.trim();
  String get subjectsString => subjects.join(', ');
  int get subjectsCount => subjects.length;
  String get experienceString {
    if (experience == 0) return 'Fresher';
    if (experience == 1) return '1 Year';
    return '$experience Years';
  }
  IconData get genderIcon {
    return gender.toLowerCase() == 'male' ? Icons.male : Icons.female;
  }
  Color get genderColor {
    return gender.toLowerCase() == 'male' ? Colors.blue : Colors.pink;
  }
}