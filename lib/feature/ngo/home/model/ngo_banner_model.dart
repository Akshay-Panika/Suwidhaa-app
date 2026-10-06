class NgoBannerModel {
  final bool success;
  final String message;
  final NgoBannerData? data;

  NgoBannerModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory NgoBannerModel.fromJson(Map<String, dynamic> json) {
    return NgoBannerModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? NgoBannerData.fromJson(json['data']) : null,
    );
  }
}

class NgoBannerData {
  final int id;
  final String bannerImage;
  final String createdAt;
  final String updatedAt;

  NgoBannerData({
    required this.id,
    required this.bannerImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NgoBannerData.fromJson(Map<String, dynamic> json) {
    return NgoBannerData(
      id: json['id'] ?? 0,
      bannerImage: json['banner_image'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}