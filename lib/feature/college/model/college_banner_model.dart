class CollegeBannerModel {
  final bool success;
  final int count;
  final List<BannerData> data;

  CollegeBannerModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory CollegeBannerModel.fromJson(Map<String, dynamic> json) {
    return CollegeBannerModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List?)
          ?.map((item) => BannerData.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class BannerData {
  final int id;
  final String bannerImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  BannerData({
    required this.id,
    required this.bannerImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      id: json['id'] ?? 0,
      bannerImage: json['banner_image'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}