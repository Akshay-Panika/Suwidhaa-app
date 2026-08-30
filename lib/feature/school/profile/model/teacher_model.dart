// lib/feature/school/teacher/model/teacher_model.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

class TeacherData {
  final int id;
  final String? teacherProfile;
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
  final String schoolType;
  final String createdAt;
  final String updatedAt;

  TeacherData({
    required this.id,
    this.teacherProfile,
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
    required this.schoolType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TeacherData.fromJson(Map<String, dynamic> json) {
    // Parse subjects - handle both List and null
    List<String> subjectList = [];
    if (json['subjects'] != null && json['subjects'] is List) {
      subjectList = List<String>.from(json['subjects']);
    }

    return TeacherData(
      id: json['id'] ?? 0,
      teacherProfile: json['teacher_profile'],
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
      schoolType: json['school_type'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  // Helper method to get full name
  String get fullName {
    String fullName = firstName;
    if (lastName.isNotEmpty) {
      fullName += ' $lastName';
    }
    return fullName;
  }

  // Helper method to get subjects as comma separated string
  String get subjectsString {
    return subjects.join(', ');
  }

  // Helper method to get subjects count
  int get subjectsCount {
    return subjects.length;
  }

  // Helper method to get experience string
  String get experienceString {
    if (experience == 0) return 'Fresher';
    if (experience == 1) return '1 Year';
    return '$experience Years';
  }

  // Helper method to get gender icon
  IconData get genderIcon {
    return gender.toLowerCase() == 'male' ? Icons.male : Icons.female;
  }

  // Helper method to get gender color
  Color get genderColor {
    return gender.toLowerCase() == 'male' ? Colors.blue : Colors.pink;
  }
}