class NgoCategoryModel {
  final bool success;
  final String message;
  final NgoCategoryData? data;

  NgoCategoryModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory NgoCategoryModel.fromJson(Map<String, dynamic> json) {
    return NgoCategoryModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? NgoCategoryData.fromJson(json['data'])
          : null,
    );
  }
}

class NgoCategoryData {
  final int id;
  final String name;
  final String image;
  final String createdAt;
  final String updatedAt;

  NgoCategoryData({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NgoCategoryData.fromJson(Map<String, dynamic> json) {
    return NgoCategoryData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}