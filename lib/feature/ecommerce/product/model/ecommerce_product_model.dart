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
  final bool isCart; // 🆕
  final bool isActive;
  final String? badge;
  final String? primaryImage;
  final List<ProductImageModel> images;
  final String? createdAt;
  final String? updatedAt;

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
    this.isCart = false,
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
      isCart: json['is_cart'] ?? false,
      isActive: json['is_active'] ?? true,
      badge: json['badge'],
      primaryImage: json['primary_image'],
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      subcategoryDetail: json['subcategory_detail'] != null
          ? CategoryDetail.fromJson(
          json['subcategory_detail'] as Map<String, dynamic>)
          : null,
      categoryDetail: json['category_detail'] != null
          ? CategoryDetail.fromJson(
          json['category_detail'] as Map<String, dynamic>)
          : null,
      userDetail: json['user_detail'] != null
          ? UserDetail.fromJson(json['user_detail'] as Map<String, dynamic>)
          : null,
    );
  }

  EcommerceProductModel copyWith({bool? isFavorite, bool? isCart}) {
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
      isCart: isCart ?? this.isCart,
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

// ============================================================
// 🆕 CART MODELS
// ============================================================

class EcommerceCartItemModel {
  final int id;
  final int productId;
  final int quantity;
  final String price;
  final String total;
  final EcommerceProductModel product;

  EcommerceCartItemModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.total,
    required this.product,
  });

  factory EcommerceCartItemModel.fromJson(Map<String, dynamic> json) {
    return EcommerceCartItemModel(
      id: json['id'] ?? 0,
      productId: json['product'] ?? 0,
      quantity: json['quantity'] ?? 1,
      price: json['price']?.toString() ?? '0',
      total: json['total']?.toString() ?? '0',
      product: EcommerceProductModel.fromJson(
        json['product_detail'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  EcommerceCartItemModel copyWith({int? quantity}) {
    return EcommerceCartItemModel(
      id: id,
      productId: productId,
      quantity: quantity ?? this.quantity,
      price: price,
      total: total,
      product: product,
    );
  }
}

class EcommerceCartResponse {
  final bool success;
  final int count;
  final String grandTotal;
  final List<EcommerceCartItemModel> data;

  EcommerceCartResponse({
    required this.success,
    required this.count,
    required this.grandTotal,
    required this.data,
  });

  factory EcommerceCartResponse.fromJson(Map<String, dynamic> json) {
    return EcommerceCartResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      grandTotal: json['grand_total']?.toString() ?? '0',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) =>
          EcommerceCartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

