// lib/feature/college/models/room_model.dart
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

class Room {
  final int id;
  final String title;
  final String description;
  final String address;
  final String price;
  final bool isBooking;
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
    required this.title,
    required this.description,
    required this.address,
    required this.price,
    required this.isBooking,
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
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      price: json['price'] ?? '0',
      isBooking: json['is_booking'] ?? false,
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
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'address': address,
      'price': price,
      'is_booking': isBooking,
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

  // Helper getters for UI
  String get formattedPrice {
    final priceNum = double.tryParse(price) ?? 0;
    return '₹${priceNum.toStringAsFixed(0)}/month';
  }

  String get roomTypeDisplay {
    if (roomType == null || roomType!.isEmpty) return 'Not Specified';
    return roomType!.toUpperCase();
  }

  String get contactDisplay {
    return contactNumber ?? 'Not Available';
  }

  bool get hasContact => contactNumber != null && contactNumber!.isNotEmpty;

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

  String get availabilityStatus {
    return isBooking ? 'Booked' : 'Available';
  }

  Color get availabilityColor {
    return isBooking ? Colors.red : Colors.green;
  }
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
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
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

// Extension for Room
extension RoomExtension on Room {
  String get firstImageUrl {
    return roomImages.isNotEmpty ? roomImages.first.url : '';
  }

  bool get hasImages => roomImages.isNotEmpty;
}