class OttBannerModel {
  final int id;
  final String image;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OttBannerModel({
    required this.id,
    required this.image,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory OttBannerModel.fromJson(Map<String, dynamic> json) {
    return OttBannerModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}