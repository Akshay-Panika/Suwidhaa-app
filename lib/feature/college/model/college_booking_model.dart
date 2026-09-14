// lib/feature/college/model/college_booking_model.dart

class CollegeBookingResponse {
  final bool success;
  final String message;
  final CollegeBookingData? data;
  final WhatsAppResult? whatsapp;

  CollegeBookingResponse({
    required this.success,
    required this.message,
    this.data,
    this.whatsapp,
  });

  factory CollegeBookingResponse.fromJson(Map<String, dynamic> json) {
    return CollegeBookingResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? CollegeBookingData.fromJson(json['data'])
          : null,
      whatsapp: json['whatsapp'] != null
          ? WhatsAppResult.fromJson(json['whatsapp'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'whatsapp': whatsapp?.toJson(),
    };
  }
}


class CollegeBookingData {
  final int id;
  final int collegeId;
  final String userId;
  final bool booking;
  final String? message;
  final String? whatsappStatus;
  final String? whatsappSid;
  final String? whatsappError;
  final DateTime createdAt;
  final DateTime updatedAt;

  CollegeBookingData({
    required this.id,
    required this.collegeId,
    required this.userId,
    required this.booking,
    this.message,
    this.whatsappStatus,
    this.whatsappSid,
    this.whatsappError,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CollegeBookingData.fromJson(Map<String, dynamic> json) {
    return CollegeBookingData(
      id: json['id'] ?? 0,
      collegeId: json['college_id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      booking: json['booking'] ?? false,
      message: json['message'],
      whatsappStatus: json['whatsapp_status'],
      whatsappSid: json['whatsapp_sid'],
      whatsappError: json['whatsapp_error'],
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'college_id': collegeId,
      'user_id': userId,
      'booking': booking,
      'message': message,
      'whatsapp_status': whatsappStatus,
      'whatsapp_sid': whatsappSid,
      'whatsapp_error': whatsappError,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}


class WhatsAppResult {
  final bool success;
  final String? messageSid;
  final String? status;
  final String? to;
  final String? from;
  final String? error;

  WhatsAppResult({
    required this.success,
    this.messageSid,
    this.status,
    this.to,
    this.from,
    this.error,
  });

  factory WhatsAppResult.fromJson(Map<String, dynamic> json) {
    return WhatsAppResult(
      success: json['success'] ?? false,
      messageSid: json['message_sid'],
      status: json['status'],
      to: json['to'],
      from: json['from'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message_sid': messageSid,
      'status': status,
      'to': to,
      'from': from,
      'error': error,
    };
  }
}

/// -------------
class CollegeBookingListResponse {
  final bool success;
  final int count;
  final List<CollegeBooking> data;

  CollegeBookingListResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory CollegeBookingListResponse.fromJson(Map<String, dynamic> json) {
    return CollegeBookingListResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((item) => CollegeBooking.fromJson(item))
          .toList(),
    );
  }
}

class CollegeBooking {
  final int id;
  final int collegeId;
  final String userId;
  final bool booking;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;

  CollegeBooking({
    required this.id,
    required this.collegeId,
    required this.userId,
    required this.booking,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CollegeBooking.fromJson(Map<String, dynamic> json) {
    return CollegeBooking(
      id: json['id'] ?? 0,
      collegeId: json['college_id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      booking: json['booking'] ?? false,
      message: json['message'] ?? '',
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Helper: formatted date
  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${createdAt.day} ${months[createdAt.month - 1]} ${createdAt.year}';
  }

  // Helper: booking status text
  String get bookingStatusText => booking ? 'Booked' : 'Not Booked';
}