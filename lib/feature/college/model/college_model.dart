// lib/feature/college/model/college_model.dart

class CollegeListResponse {
  final bool success;
  final String? userId;       // ✅ NEW — response top-level se aata hai
  final int count;
  final List<College> data;

  CollegeListResponse({
    required this.success,
    this.userId,
    required this.count,
    required this.data,
  });

  factory CollegeListResponse.fromJson(Map<String, dynamic> json) {
    return CollegeListResponse(
      success: json['success'] ?? false,
      userId: json['user_id']?.toString(),   // ✅ NEW
      count: json['count'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((item) => College.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'user_id': userId,
      'count': count,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}


class College {
  final int id;
  final String name;
  final String address;
  final String website;
  final String? contactNumber;
  final String? category;
  final String? logoUrl;
  final bool isRecommended;
  final String? longitude;    // ✅ NEW
  final String? latitude;     // ✅ NEW
  final bool booking;         // ✅ NEW
  final List<CollegeImage> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  College({
    required this.id,
    required this.name,
    required this.address,
    required this.website,
    this.contactNumber,
    this.category,
    this.logoUrl,
    this.isRecommended = false,
    this.longitude,           // ✅ NEW
    this.latitude,            // ✅ NEW
    this.booking = false,     // ✅ NEW
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory College.fromJson(Map<String, dynamic> json) {
    return College(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      website: json['website'] ?? '',
      contactNumber: json['contact_number'],
      category: json['category'],
      logoUrl: json['logo_url'],
      isRecommended: json['is_recommended'] ?? false,
      longitude: json['longitude']?.toString(),   // ✅ NEW
      latitude: json['latitude']?.toString(),     // ✅ NEW
      booking: json['booking'] ?? false,          // ✅ NEW
      images: (json['images'] as List? ?? [])
          .map((item) => CollegeImage.fromJson(item))
          .toList(),
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'website': website,
      'contact_number': contactNumber,
      'category': category,
      'logo_url': logoUrl,
      'is_recommended': isRecommended,
      'longitude': longitude,   // ✅ NEW
      'latitude': latitude,     // ✅ NEW
      'booking': booking,       // ✅ NEW
      'images': images.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Helper method to get initials for placeholder
  String get initials {
    if (name.isEmpty) return '';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  // Helper method to check if college has logo
  bool get hasLogo => logoUrl != null && logoUrl!.isNotEmpty;

  // ✅ NEW: Helper to check if college has location
  bool get hasLocation => longitude != null && latitude != null;

  // ✅ NEW: Helper to get location as a readable string
  String get locationString {
    if (!hasLocation) return 'Location not available';
    return 'Lat: $latitude, Lng: $longitude';
  }

  // ✅ NEW: Helper — booking status text
  String get bookingStatusText => booking ? 'Booked' : 'Not Booked';
}


class CollegeImage {
  final int id;
  final String url;
  final DateTime createdAt;

  CollegeImage({
    required this.id,
    required this.url,
    required this.createdAt,
  });

  factory CollegeImage.fromJson(Map<String, dynamic> json) {
    return CollegeImage(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
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