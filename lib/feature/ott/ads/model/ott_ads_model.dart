
class OttAdsModel {
  final int id;
  final String title;
  final String? image;
  final String? videoUrl;
  final String? navigateScreen;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  OttAdsModel({
    required this.id,
    required this.title,
    this.image,
    this.videoUrl,
    this.navigateScreen,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory OttAdsModel.fromJson(Map<String, dynamic> json) {
    return OttAdsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'] as String?,
      videoUrl: json['video_url'] as String?,
      navigateScreen: json['navigate_screen'] as String?,
      isActive: json['is_active'] == true,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}