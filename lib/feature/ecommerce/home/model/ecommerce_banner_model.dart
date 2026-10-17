// lib/feature/ecommerce/banner/model/ecommerce_banner_model.dart

class EcommerceBannerResponse {
  final bool success;
  final int count;
  final List<EcommerceBannerModel> data;

  EcommerceBannerResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory EcommerceBannerResponse.fromJson(Map<String, dynamic> json) {
    return EcommerceBannerResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => EcommerceBannerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class EcommerceBannerModel {
  final int id;
  final String bannerImage;
  final String? title;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  EcommerceBannerModel({
    required this.id,
    required this.bannerImage,
    this.title,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory EcommerceBannerModel.fromJson(Map<String, dynamic> json) {
    return EcommerceBannerModel(
      id: json['id'] ?? 0,
      bannerImage: json['banner_image'] ?? '',
      title: json['title'],
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'banner_image': bannerImage,
    'title': title,
    'is_active': isActive,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}