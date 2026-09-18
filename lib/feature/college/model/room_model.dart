import 'package:flutter/material.dart';

class RoomListResponse {
  final bool success;
  final int count;
  final List<Room> data;

  RoomListResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory RoomListResponse.fromJson(Map<String, dynamic> json) {
    return RoomListResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((item) => Room.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class RoomDetailResponse {
  final bool success;
  final Room? data;

  RoomDetailResponse({
    required this.success,
    this.data,
  });

  factory RoomDetailResponse.fromJson(Map<String, dynamic> json) {
    return RoomDetailResponse(
      success: json['success'] ?? false,
      data: json['data'] is Map<String, dynamic>
          ? Room.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class Room {
  final int id;
  final String? userId;
  final String title;
  final String description;
  final String address;
  final String price;
  final String latitude;
  final String longitude;

  final bool isBooking;
  final bool booking;

  final String? roomType;
  final String? contactNumber;
  final bool wifi;
  final bool ac;
  final bool parking;
  final bool security;
  final bool laundry;
  final bool water;
  final String? nearCollege;
  final List<RoomImage> roomImages;
  final DateTime createdAt;
  final DateTime updatedAt;

  Room({
    required this.id,
    this.userId,
    required this.title,
    required this.description,
    required this.address,
    required this.price,
    required this.latitude,
    required this.longitude,
    required this.isBooking,     // ✅ owner/global
    required this.booking,       // ✅ user-wise (NEW)
    this.roomType,
    this.contactNumber,
    required this.wifi,
    required this.ac,
    required this.parking,
    required this.security,
    required this.laundry,
    required this.water,
    this.nearCollege,
    required this.roomImages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? 0,

      // user_id API se String ya null aa sakta hai
      userId: json['user_id']?.toString(),

      title: json['title'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      price: json['price']?.toString() ?? '0',
      latitude: json['latitude']?.toString() ?? '0',
      longitude: json['longitude']?.toString() ?? '0',

      // ✅ is_booking parse
      isBooking: json['is_booking'] ?? false,

      // ✅ booking parse (NEW)
      booking: json['booking'] ?? false,

      roomType: json['room_type'],
      contactNumber: json['contact_number'],

      wifi: json['wifi'] ?? false,
      ac: json['ac'] ?? false,
      parking: json['parking'] ?? false,
      security: json['security'] ?? false,
      laundry: json['laundry'] ?? false,
      water: json['water'] ?? false,

      nearCollege: json['near_college'],

      roomImages: (json['room_images'] as List? ?? [])
          .map((item) => RoomImage.fromJson(item))
          .toList(),

      createdAt: DateTime.tryParse(
        json['created_at'] ?? '',
      ) ??
          DateTime.now(),

      updatedAt: DateTime.tryParse(
        json['updated_at'] ?? '',
      ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'address': address,
      'price': price,
      'latitude': latitude,
      'longitude': longitude,
      'is_booking': isBooking,
      'booking': booking,          // ✅ ADDED
      'room_type': roomType,
      'contact_number': contactNumber,
      'wifi': wifi,
      'ac': ac,
      'parking': parking,
      'security': security,
      'laundry': laundry,
      'water': water,
      'near_college': nearCollege,
      'room_images': roomImages.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // =========================
  // Helper Getters
  // =========================

  String get formattedPrice {
    final priceNum = double.tryParse(price) ?? 0;
    return '₹${priceNum.toStringAsFixed(0)}/month';
  }

  String get roomTypeDisplay {
    if (roomType == null || roomType!.isEmpty) {
      return '';
    }
    return roomType!.toUpperCase();
  }

  String get contactDisplay {
    return contactNumber ?? 'Not Available';
  }

  bool get hasContact {
    return contactNumber != null && contactNumber!.isNotEmpty;
  }

  bool get hasUser {
    return userId != null && userId!.isNotEmpty;
  }

  List<String> get amenities {
    final List<String> list = [];

    if (wifi) list.add('WiFi');
    if (ac) list.add('AC');
    if (parking) list.add('Parking');
    if (security) list.add('Security');
    if (laundry) list.add('Laundry');
    if (water) list.add('Water');

    return list;
  }

  int get amenityCount => amenities.length;

  // ✅ is_booking se availability (owner/global)
  String get availabilityStatus {
    return isBooking ? 'Booked' : 'Available';
  }

  Color get availabilityColor {
    return isBooking ? Colors.red : Colors.green;
  }

  // ✅ NEW: user-wise booking check
  bool get isBookedByMe => booking;

  // ✅ NEW: combined check — button disabled karne ke liye
  bool get isNotBookable => booking || isBooking;
}

class RoomImage {
  final int id;
  final String url;
  final DateTime createdAt;

  RoomImage({
    required this.id,
    required this.url,
    required this.createdAt,
  });

  factory RoomImage.fromJson(Map<String, dynamic> json) {
    return RoomImage(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      createdAt: DateTime.tryParse(
        json['created_at'] ?? '',
      ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class RoomActionResponse {
  final bool success;
  final String message;
  final Room? data;

  RoomActionResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory RoomActionResponse.fromJson(Map<String, dynamic> json) {
    return RoomActionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] is Map<String, dynamic>
          ? Room.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}