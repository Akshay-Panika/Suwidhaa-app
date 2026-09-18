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

// ============================================================
// CollegeBookingData
// ============================================================
class CollegeBookingData {
  final int id;
  final int collegeId;
  final String userId;
  final bool booking;
  final String? message;

  final BookingRoom? room;
  final BookingTiffin? tiffin;

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
    this.room,
    this.tiffin,
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

      room: json['room'] != null
          ? BookingRoom.fromJson(json['room'])
          : null,

      tiffin: json['tiffin'] != null
          ? BookingTiffin.fromJson(json['tiffin'])
          : null,

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
      'room': room?.toJson(),
      'tiffin': tiffin?.toJson(),
      'whatsapp_status': whatsappStatus,
      'whatsapp_sid': whatsappSid,
      'whatsapp_error': whatsappError,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// ============================================================
// WhatsAppResult
// ============================================================
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

// ============================================================
// CollegeBookingListResponse
// ============================================================
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

// ============================================================
// CollegeBooking (list item)
// ============================================================
class CollegeBooking {
  final int id;
  final int collegeId;
  final String userId;
  final bool booking;
  final String message;

  final BookingRoom? room;
  final BookingTiffin? tiffin;

  // ✅ ADDED: whatsapp fields (backend response me hain ya nahi, dono handle)
  final String? whatsappStatus;
  final String? whatsappSid;
  final String? whatsappError;

  final DateTime createdAt;
  final DateTime updatedAt;

  CollegeBooking({
    required this.id,
    required this.collegeId,
    required this.userId,
    required this.booking,
    required this.message,
    required this.room,
    required this.tiffin,
    this.whatsappStatus,     // ✅ ADDED
    this.whatsappSid,        // ✅ ADDED
    this.whatsappError,      // ✅ ADDED
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

      room: json['room'] != null
          ? BookingRoom.fromJson(json['room'])
          : null,

      tiffin: json['tiffin'] != null
          ? BookingTiffin.fromJson(json['tiffin'])
          : null,

      // ✅ ADDED: parse whatsapp fields
      whatsappStatus: json['whatsapp_status'],
      whatsappSid: json['whatsapp_sid'],
      whatsappError: json['whatsapp_error'],

      createdAt: DateTime.tryParse(
        json['created_at']?.toString() ?? '',
      ) ??
          DateTime.now(),

      updatedAt: DateTime.tryParse(
        json['updated_at']?.toString() ?? '',
      ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'college_id': collegeId,
      'user_id': userId,
      'booking': booking,
      'message': message,
      'room': room?.toJson(),
      'tiffin': tiffin?.toJson(),
      'whatsapp_status': whatsappStatus,    // ✅ ADDED
      'whatsapp_sid': whatsappSid,          // ✅ ADDED
      'whatsapp_error': whatsappError,      // ✅ ADDED
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // ============================================================
  // Helper Getters (bonus — UI me kaam aayenge)
  // ============================================================

  /// Room booking hai kya?
  bool get isRoomBooking => room != null;

  /// Tiffin booking hai kya?
  bool get isTiffinBooking => tiffin != null;

  /// Sirf college booking hai kya?
  bool get isCollegeOnly => room == null && tiffin == null;

  /// Booking type label
  String get bookingTypeLabel {
    if (isRoomBooking && isTiffinBooking) return 'Room + Tiffin';
    if (isRoomBooking) return 'Room';
    if (isTiffinBooking) return 'Tiffin';
    return 'College Enquiry';
  }
}

// ============================================================
// BookingRoom
// ============================================================
class BookingRoom {
  final int roomId;
  final String roomName;
  final String roomType;
  final String roomAmount;

  BookingRoom({
    required this.roomId,
    required this.roomName,
    required this.roomType,
    required this.roomAmount,
  });

  factory BookingRoom.fromJson(Map<String, dynamic> json) {
    return BookingRoom(
      roomId: json['room_id'] ?? 0,
      roomName: json['room_name']?.toString() ?? '',
      roomType: json['room_type']?.toString() ?? '',
      roomAmount: json['room_amount']?.toString() ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room_id': roomId,
      'room_name': roomName,
      'room_type': roomType,
      'room_amount': roomAmount,
    };
  }
}

// ============================================================
// BookingTiffin
// ============================================================
class BookingTiffin {
  final int tiffinId;
  final String tiffinName;
  final String tiffinType;
  final String tiffinAmount;

  BookingTiffin({
    required this.tiffinId,
    required this.tiffinName,
    required this.tiffinType,
    required this.tiffinAmount,
  });

  factory BookingTiffin.fromJson(Map<String, dynamic> json) {
    return BookingTiffin(
      tiffinId: json['tiffin_id'] ?? 0,
      tiffinName: json['tiffin_name']?.toString() ?? '',
      tiffinType: json['tiffin_type']?.toString() ?? '',
      tiffinAmount: json['tiffin_amount']?.toString() ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tiffin_id': tiffinId,
      'tiffin_name': tiffinName,
      'tiffin_type': tiffinType,
      'tiffin_amount': tiffinAmount,
    };
  }
}