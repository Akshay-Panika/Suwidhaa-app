// lib/feature/school/transport/model/transport_model.dart
class TransportModel {
  final int id;
  final String transportType;
  final String schoolType;       // ✅ nested school.school_type se
  final String vehicleNumber;
  final String driverName;
  final String driverNumber;
  final String? driverImage;     // ✅ `driver_image` key
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
    // ✅ school_type backend me nested `school` object ke andar aata hai
    String schoolTypeStr = '';
    final schoolObj = json['school'];
    if (schoolObj is Map<String, dynamic>) {
      schoolTypeStr = (schoolObj['school_type'] ?? '').toString();
    }

    // ✅ backend `driver_image` bhejta hai (not driver_image_url)
    final driverImgRaw = json['driver_image'] ?? json['driver_image_url'];

    // ✅ students list — nested student object parse
    List<StudentData> studentList = [];
    final rawStudents = json['students'];
    if (rawStudents is List) {
      studentList = rawStudents
          .whereType<Map<String, dynamic>>()
          .map(StudentData.fromJson)
          .toList();
    }

    return TransportModel(
      id: json['id'] ?? 0,
      transportType: (json['transport_type'] ?? '').toString(),
      schoolType: schoolTypeStr,
      vehicleNumber: (json['vehicle_number'] ?? '').toString(),
      driverName: (json['driver_name'] ?? '').toString(),
      driverNumber: (json['driver_number'] ?? '').toString(),
      driverImage: driverImgRaw?.toString(),
      capacity: json['capacity']?.toString(),
      routeName: json['route_name']?.toString(),
      students: studentList,
      // ✅ backend student_count authoritative hai
      studentCount: (json['student_count'] is int)
          ? json['student_count'] as int
          : studentList.length,
      createdAt:
      DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt:
      DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'transport_type': transportType,
    'vehicle_number': vehicleNumber,
    'driver_name': driverName,
    'driver_number': driverNumber,
    'driver_image': driverImage,
    'capacity': capacity,
    'route_name': routeName,
    'students': students.map((e) => e.toJson()).toList(),
    'student_count': studentCount,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  TransportModel copyWith({
    int? id,
    String? transportType,
    String? schoolType,
    String? vehicleNumber,
    String? driverName,
    String? driverNumber,
    String? driverImage,
    String? capacity,
    String? routeName,
    List<StudentData>? students,
    int? studentCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransportModel(
      id: id ?? this.id,
      transportType: transportType ?? this.transportType,
      schoolType: schoolType ?? this.schoolType,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      driverName: driverName ?? this.driverName,
      driverNumber: driverNumber ?? this.driverNumber,
      driverImage: driverImage ?? this.driverImage,
      capacity: capacity ?? this.capacity,
      routeName: routeName ?? this.routeName,
      students: students ?? this.students,
      studentCount: studentCount ?? this.studentCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}


// ============================================================
// StudentData
// ============================================================
class StudentData {
  final int id;                 // TransportStudent pk
  final String studentName;     // full name from nested
  final String studentId;       // ✅ Student DB pk (string) — delete ke liye
  final String studentIdCard;   // ✅ "st-student02" — display
  final String studentProfile;  // ✅ profile image URL
  final String studentClass;    // ✅ "9th"
  final String parentPhone;     // ✅ parent contact
  final String? address;
  final String? pickupTime;
  final String? dropTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  StudentData({
    required this.id,
    required this.studentName,
    required this.studentId,
    this.studentIdCard = '',
    this.studentProfile = '',
    this.studentClass = '',
    this.parentPhone = '',
    this.address,
    this.pickupTime,
    this.dropTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    // ✅ Nested student object parse
    final nested = (json['student'] is Map<String, dynamic>)
        ? json['student'] as Map<String, dynamic>
        : const <String, dynamic>{};

    final first = (nested['first_name'] ?? '').toString().trim();
    final middle = (nested['middle_name'] ?? '').toString().trim();
    final last = (nested['last_name'] ?? '').toString().trim();
    final fullName = [first, middle, last]
        .where((p) => p.isNotEmpty)
        .join(' ');

    return StudentData(
      id: json['id'] ?? 0,
      studentName:
      fullName.isNotEmpty ? fullName : 'Unknown Student',
      studentId: (nested['id'] ?? '').toString(),          // DB pk
      studentIdCard:
      (nested['student_id_card'] ?? '').toString(),    // card
      studentProfile:
      (nested['student_profile'] ?? '').toString(),
      studentClass:
      (nested['student_class'] ?? '').toString(),
      parentPhone:
      (nested['parent_phone'] ?? '').toString(),
      address: json['address']?.toString(),
      pickupTime: json['pickup_time']?.toString(),
      dropTime: json['drop_time']?.toString(),
      createdAt:
      DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt:
      DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'student': {
      'id': studentId,
      'student_name': studentName,
      'student_id_card': studentIdCard,
      'student_profile': studentProfile,
      'student_class': studentClass,
      'parent_phone': parentPhone,
    },
    'address': address,
    'pickup_time': pickupTime,
    'drop_time': dropTime,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  StudentData copyWith({
    int? id,
    String? studentName,
    String? studentId,
    String? studentIdCard,
    String? studentProfile,
    String? studentClass,
    String? parentPhone,
    String? address,
    String? pickupTime,
    String? dropTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudentData(
      id: id ?? this.id,
      studentName: studentName ?? this.studentName,
      studentId: studentId ?? this.studentId,
      studentIdCard: studentIdCard ?? this.studentIdCard,
      studentProfile: studentProfile ?? this.studentProfile,
      studentClass: studentClass ?? this.studentClass,
      parentPhone: parentPhone ?? this.parentPhone,
      address: address ?? this.address,
      pickupTime: pickupTime ?? this.pickupTime,
      dropTime: dropTime ?? this.dropTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}


// ============================================================
// Response wrapper
// ============================================================
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
          .whereType<Map<String, dynamic>>()
          .map(TransportModel.fromJson)
          .toList(),
    );
  }
}