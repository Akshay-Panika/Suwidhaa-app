// lib/feature/ecommerce/product/model/ecommerce_product_model.dart

class EcommerceProductResponse {
  final bool success;
  final int count;
  final List<EcommerceProductModel> data;

  EcommerceProductResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory EcommerceProductResponse.fromJson(Map<String, dynamic> json) {
    return EcommerceProductResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => EcommerceProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class EcommerceProductModel {
  final int id;
  final int subcategory;
  final int user;
  final String title;
  final String description;
  final String price;
  final String oldPrice;
  final int stock;
  final bool isFavorite;
  final bool isActive;
  final String? badge;
  final String? primaryImage;
  final List<ProductImageModel> images;
  final String? createdAt;
  final String? updatedAt;

  // detail models
  final CategoryDetail? subcategoryDetail;
  final CategoryDetail? categoryDetail;
  final UserDetail? userDetail;

  EcommerceProductModel({
    required this.id,
    required this.subcategory,
    required this.user,
    required this.title,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.stock,
    this.isFavorite = false,
    this.isActive = true,
    this.badge,
    this.primaryImage,
    this.images = const [],
    this.createdAt,
    this.updatedAt,
    this.subcategoryDetail,
    this.categoryDetail,
    this.userDetail,
  });

  factory EcommerceProductModel.fromJson(Map<String, dynamic> json) {
    return EcommerceProductModel(
      id: json['id'] ?? 0,
      subcategory: json['subcategory'] ?? 0,
      user: json['user'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toString() ?? '0',
      oldPrice: json['old_price']?.toString() ?? '0',
      stock: json['stock'] ?? 0,
      isFavorite: json['is_favorite'] ?? false,
      isActive: json['is_active'] ?? true,
      badge: json['badge'],
      primaryImage: json['primary_image'],
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      subcategoryDetail: json['subcategory_detail'] != null
          ? CategoryDetail.fromJson(json['subcategory_detail'] as Map<String, dynamic>)
          : null,
      categoryDetail: json['category_detail'] != null
          ? CategoryDetail.fromJson(json['category_detail'] as Map<String, dynamic>)
          : null,
      userDetail: json['user_detail'] != null
          ? UserDetail.fromJson(json['user_detail'] as Map<String, dynamic>)
          : null,
    );
  }

  // copyWith useful for optimistic favorite toggle
  EcommerceProductModel copyWith({bool? isFavorite}) {
    return EcommerceProductModel(
      id: id,
      subcategory: subcategory,
      user: user,
      title: title,
      description: description,
      price: price,
      oldPrice: oldPrice,
      stock: stock,
      isFavorite: isFavorite ?? this.isFavorite,
      isActive: isActive,
      badge: badge,
      primaryImage: primaryImage,
      images: images,
      createdAt: createdAt,
      updatedAt: updatedAt,
      subcategoryDetail: subcategoryDetail,
      categoryDetail: categoryDetail,
      userDetail: userDetail,
    );
  }
}

class ProductImageModel {
  final int id;
  final String image;

  ProductImageModel({required this.id, required this.image});

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
    );
  }
}

class CategoryDetail {
  final int id;
  final String title;

  CategoryDetail({required this.id, required this.title});

  factory CategoryDetail.fromJson(Map<String, dynamic> json) {
    return CategoryDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
    );
  }
}

class UserDetail {
  final int id;
  final String name;
  final String phoneNumber;

  UserDetail({required this.id, required this.name, required this.phoneNumber});

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
    );
  }
}