class OttBannerModel {
  final int id;
  final String image;
  final String? videoUrl; // null when no video
  final bool isPlay;      // true → this banner is playable
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OttBannerModel({
    required this.id,
    required this.image,
    this.videoUrl,
    required this.isPlay,
    this.createdAt,
    this.updatedAt,
  });

  factory OttBannerModel.fromJson(Map<String, dynamic> json) {
    return OttBannerModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      videoUrl: json['video_url'] as String?, // may be null
      isPlay: json['is_play'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}