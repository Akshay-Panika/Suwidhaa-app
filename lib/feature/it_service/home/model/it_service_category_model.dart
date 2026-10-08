class ItServiceCategoryData {
  final int id;
  final String name;
  final String image;
  final String createdAt;
  final String updatedAt;

  ItServiceCategoryData({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItServiceCategoryData.fromJson(Map<String, dynamic> json) {
    return ItServiceCategoryData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}