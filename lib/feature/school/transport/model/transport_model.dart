// lib/feature/school/transport/model/transport_model.dart
class TransportModel {
  final int id;
  final String transportType;
  final String schoolType;
  final String vehicleNumber;
  final String driverName;
  final String driverNumber;
  final String? driverImage;
  final String? capacity;
  final String? routeName;
  final List<StudentData> students;
  final int studentCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransportModel({
    required this.id,
    required this.transportType,
    required this.schoolType,
    required this.vehicleNumber,
    required this.driverName,
    required this.driverNumber,
    this.driverImage,
    this.capacity,
    this.routeName,
    required this.students,
    required this.studentCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransportModel.fromJson(Map<String, dynamic> json) {
    // Parse students list
    List<StudentData> studentList = [];
    if (json['students'] != null && json['students'] is List) {
      studentList = (json['students'] as List)
          .map((e) => StudentData.fromJson(e))
          .toList();
    }

    return TransportModel(
      id: json['id'] ?? 0,
      transportType: json['transport_type'] ?? '',
      schoolType: json['school_type'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      driverName: json['driver_name'] ?? '',
      driverNumber: json['driver_number'] ?? '',
      driverImage: json['driver_image_url'],
      capacity: json['capacity']?.toString(),
      routeName: json['route_name'],
      students: studentList,
      studentCount: json['student_count'] ?? studentList.length,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transport_type': transportType,
      'school_type': schoolType,
      'vehicle_number': vehicleNumber,
      'driver_name': driverName,
      'driver_number': driverNumber,
      'driver_image_url': driverImage,
      'capacity': capacity,
      'route_name': routeName,
      'students': students.map((e) => e.toJson()).toList(),
      'student_count': studentCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class StudentData {
  final int id;
  final String studentName;
  final String studentId;
  final String? pickupTime;
  final String? dropTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  StudentData({
    required this.id,
    required this.studentName,
    required this.studentId,
    this.pickupTime,
    this.dropTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    return StudentData(
      id: json['id'] ?? 0,
      studentName: json['student_name'] ?? '',
      studentId: json['student_id'] ?? '',
      pickupTime: json['pickup_time'],
      dropTime: json['drop_time'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_name': studentName,
      'student_id': studentId,
      'pickup_time': pickupTime,
      'drop_time': dropTime,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class TransportListResponse {
  final bool success;
  final int count;
  final List<TransportModel> data;

  TransportListResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory TransportListResponse.fromJson(Map<String, dynamic> json) {
    return TransportListResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((e) => TransportModel.fromJson(e))
          .toList(),
    );
  }
}