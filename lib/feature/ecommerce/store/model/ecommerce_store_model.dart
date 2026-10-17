// lib/feature/ecommerce/store/model/ecommerce_store_model.dart

class EcommerceStoreResponse {
  final bool success;
  final bool hasStore;
  final EcommerceStoreModel? data;

  EcommerceStoreResponse({
    required this.success,
    required this.hasStore,
    this.data,
  });

  factory EcommerceStoreResponse.fromJson(Map<String, dynamic> json) {
    return EcommerceStoreResponse(
      success: json['success'] ?? false,
      hasStore: json['has_store'] ?? false,
      data: json['data'] != null
          ? EcommerceStoreModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class EcommerceStoreModel {
  final int id;
  final String? storeLogo;
  final int user;
  final int storeCategory;
  final String storeName;
  final String storeAddress;
  final String storePhone;
  final StoreCategoryDetail? storeCategoryDetail;

  EcommerceStoreModel({
    required this.id,
    this.storeLogo,
    required this.user,
    required this.storeCategory,
    required this.storeName,
    required this.storeAddress,
    required this.storePhone,
    this.storeCategoryDetail,
  });

  factory EcommerceStoreModel.fromJson(Map<String, dynamic> json) {
    return EcommerceStoreModel(
      id: json['id'] ?? 0,
      storeLogo: json['store_logo'],
      user: json['user'] ?? 0,
      storeCategory: json['store_category'] ?? 0,
      storeName: json['store_name'] ?? '',
      storeAddress: json['store_address'] ?? '',
      storePhone: json['store_phone'] ?? '',
      storeCategoryDetail: json['store_category_detail'] != null
          ? StoreCategoryDetail.fromJson(json['store_category_detail'] as Map<String, dynamic>)
          : null,
    );
  }
}

class StoreCategoryDetail {
  final int id;
  final String title;
  final String image;

  StoreCategoryDetail({
    required this.id,
    required this.title,
    required this.image,
  });

  factory StoreCategoryDetail.fromJson(Map<String, dynamic> json) {
    return StoreCategoryDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
    );
  }
}