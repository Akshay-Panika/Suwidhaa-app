// lib/feature/ecommerce/subcategory/model/ecommerce_subcategory_model.dart

class EcommerceSubCategoryResponse {
  final bool success;
  final int count;
  final List<EcommerceSubCategoryModel> data;

  EcommerceSubCategoryResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory EcommerceSubCategoryResponse.fromJson(Map<String, dynamic> json) {
    return EcommerceSubCategoryResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) =>
          EcommerceSubCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class EcommerceSubCategoryModel {
  final int id;
  final String image;
  final int category;
  final String title;
  final String? createdAt;
  final String? updatedAt;
  final SubCategoryDetail? categoryDetail;

  EcommerceSubCategoryModel({
    required this.id,
    required this.image,
    required this.category,
    required this.title,
    this.createdAt,
    this.updatedAt,
    this.categoryDetail,
  });

  factory EcommerceSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return EcommerceSubCategoryModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      category: json['category'] ?? 0,
      title: json['title'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      categoryDetail: json['category_detail'] != null
          ? SubCategoryDetail.fromJson(
          json['category_detail'] as Map<String, dynamic>)
          : null,
    );
  }
}

class SubCategoryDetail {
  final int id;
  final String title;

  SubCategoryDetail({required this.id, required this.title});

  factory SubCategoryDetail.fromJson(Map<String, dynamic> json) {
    return SubCategoryDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
    );
  }
}