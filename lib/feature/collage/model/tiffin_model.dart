// lib/feature/college/models/tiffin_model.dart
import 'dart:ui';

import 'package:flutter/material.dart';

class TiffinListResponse {
  final bool success;
  final int count;
  final List<Tiffin> data;

  TiffinListResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory TiffinListResponse.fromJson(Map<String, dynamic> json) {
    return TiffinListResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((item) => Tiffin.fromJson(item))
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

class Tiffin {
  final int id;
  final String title;
  final String description;
  final String price;
  final String isVeg;
  final String isNonveg;
  final bool isBooking;
  final String rating;
  final String? contactNumber;
  final String? nearCollege;
  final List<TiffinImage> tiffinImages;
  final DateTime createdAt;
  final DateTime updatedAt;

  Tiffin({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.isVeg,
    required this.isNonveg,
    required this.isBooking,
    required this.rating,
    this.contactNumber,
    this.nearCollege,
    required this.tiffinImages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tiffin.fromJson(Map<String, dynamic> json) {
    return Tiffin(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '0',
      isVeg: json['is_veg'] ?? '',
      isNonveg: json['is_nonveg'] ?? '',
      isBooking: json['is_booking'] ?? false,
      rating: json['rating'] ?? '0.0',
      contactNumber: json['contact_number'],
      nearCollege: json['near_college'],
      tiffinImages: (json['tiffin_images'] as List? ?? [])
          .map((item) => TiffinImage.fromJson(item))
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
      'price': price,
      'is_veg': isVeg,
      'is_nonveg': isNonveg,
      'is_booking': isBooking,
      'rating': rating,
      'contact_number': contactNumber,
      'near_college': nearCollege,
      'tiffin_images': tiffinImages.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Helper getters for UI
  String get formattedPrice {
    final priceNum = double.tryParse(price) ?? 0;
    return '₹${priceNum.toStringAsFixed(0)}/month';
  }

  double get ratingValue {
    return double.tryParse(rating) ?? 0.0;
  }

  String get contactDisplay {
    return contactNumber ?? 'Not Available';
  }

  bool get hasContact => contactNumber != null && contactNumber!.isNotEmpty;

  String get tiffinType {
    if (isVeg.toLowerCase() == 'true' && isNonveg.toLowerCase() == 'true') {
      return 'Veg & Non-Veg';
    } else if (isVeg.toLowerCase() == 'true') {
      return 'Veg';
    } else if (isNonveg.toLowerCase() == 'true') {
      return 'Non-Veg';
    }
    return 'Not Specified';
  }

  String get availabilityStatus {
    return isBooking ? 'Booked' : 'Available';
  }

  Color get availabilityColor {
    return isBooking ? Colors.red : Colors.green;
  }

  String get firstImageUrl {
    return tiffinImages.isNotEmpty ? tiffinImages.first.url : '';
  }

  bool get hasImages => tiffinImages.isNotEmpty;

  bool get isVegOnly => isVeg.toLowerCase() == 'true' && isNonveg.toLowerCase() != 'true';
  bool get isNonVegOnly => isNonveg.toLowerCase() == 'true' && isVeg.toLowerCase() != 'true';
  bool get isBothVegNonVeg => isVeg.toLowerCase() == 'true' && isNonveg.toLowerCase() == 'true';
}

class TiffinImage {
  final int id;
  final String url;
  final DateTime createdAt;

  TiffinImage({
    required this.id,
    required this.url,
    required this.createdAt,
  });

  factory TiffinImage.fromJson(Map<String, dynamic> json) {
    return TiffinImage(
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

// Extension for Tiffin
extension TiffinExtension on Tiffin {
  bool get isAvailable => !isBooking;
  String get availabilityText => isBooking ? 'Booked' : 'Available Now';
  Color get availabilityColor => isBooking ? Colors.red : Colors.green;
}