class OttCategoryModel {
  final int id;
  final String name;
  final String image;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  OttCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory OttCategoryModel.fromJson(Map<String, dynamic> json) {
    return OttCategoryModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      isActive: json['is_active'] == true,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}