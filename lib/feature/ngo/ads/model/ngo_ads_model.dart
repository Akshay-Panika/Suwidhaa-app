class NgoAdsModel {
  final int id;
  final String title;
  final String? image;
  final String? videoUrl;
  final String? navigateScreen;
  final bool isHome;
  final String? createdAt;
  final String? updatedAt;

  NgoAdsModel({
    required this.id,
    required this.title,
    this.image,
    this.videoUrl,
    this.navigateScreen,
    this.isHome = false,
    this.createdAt,
    this.updatedAt,
  });

  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
  bool get hasImage => image != null && image!.isNotEmpty;

  factory NgoAdsModel.fromJson(Map<String, dynamic> json) {
    return NgoAdsModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? '').toString(),
      image: json['image'] as String?,
      videoUrl: json['video_url'] as String?,
      navigateScreen: json['navigate_screen'] as String?,
      isHome: json['is_home'] == true,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}