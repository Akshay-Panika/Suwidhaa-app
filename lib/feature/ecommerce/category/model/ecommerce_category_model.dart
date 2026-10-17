// lib/feature/ecommerce/category/model/ecommerce_category_model.dart

class EcommerceCategoryResponse {
  final bool success;
  final int count;
  final List<EcommerceCategoryModel> data;

  EcommerceCategoryResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory EcommerceCategoryResponse.fromJson(Map<String, dynamic> json) {
    return EcommerceCategoryResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) =>
          EcommerceCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class EcommerceCategoryModel {
  final int id;
  final String image;
  final String title;
  final String? createdAt;
  final String? updatedAt;

  EcommerceCategoryModel({
    required this.id,
    required this.image,
    required this.title,
    this.createdAt,
    this.updatedAt,
  });

  factory EcommerceCategoryModel.fromJson(Map<String, dynamic> json) {
    return EcommerceCategoryModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
    'title': title,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}