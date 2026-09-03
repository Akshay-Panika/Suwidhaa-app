// lib/models/college/college_model.dart
class CollegeListResponse {
  final bool success;
  final int count;
  final List<College> data;

  CollegeListResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory CollegeListResponse.fromJson(Map<String, dynamic> json) {
    return CollegeListResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((item) => College.fromJson(item))
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

class College {
  final int id;
  final String name;
  final String address;
  final String website;
  final String? category;
  final List<CollegeImage> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  College({
    required this.id,
    required this.name,
    required this.address,
    required this.website,
    this.category,
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
      category: json['category'],
      images: (json['images'] as List? ?? [])
          .map((item) => CollegeImage.fromJson(item))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'website': website,
      'category': category,
      'images': images.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
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