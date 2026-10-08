class ItServiceBannerData {
  final int id;
  final String bannerImage;
  final String createdAt;
  final String updatedAt;

  ItServiceBannerData({
    required this.id,
    required this.bannerImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItServiceBannerData.fromJson(Map<String, dynamic> json) {
    return ItServiceBannerData(
      id: json['id'] ?? 0,
      bannerImage: json['banner_image'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}