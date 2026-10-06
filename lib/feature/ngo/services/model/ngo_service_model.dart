
class NgoServiceModel {
  final bool success;
  final String message;
  final NgoServiceData? data;

  NgoServiceModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory NgoServiceModel.fromJson(Map<String, dynamic> json) {
    return NgoServiceModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? NgoServiceData.fromJson(json['data'])
          : null,
    );
  }
}

class NgoServiceData {
  final int id;
  final int? category;
  final String? categoryName;
  final String name;
  final String? description;
  final List<String> images;
  final NgoProgress progress;
  final List<NgoKeyItem> keys;
  final List<int> chooseAmount;
  final String createdAt;
  final String updatedAt;

  NgoServiceData({
    required this.id,
    this.category,
    this.categoryName,
    required this.name,
    this.description,
    required this.images,
    required this.progress,
    required this.keys,
    required this.chooseAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NgoServiceData.fromJson(Map<String, dynamic> json) {
    return NgoServiceData(
      id: json['id'] ?? 0,
      category: json['category'],
      categoryName: json['category_name'],
      name: json['name'] ?? '',
      description: json['description'],
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      progress: NgoProgress.fromJson(
        json['progress'] ?? {},
      ),
      keys: (json['keys'] as List<dynamic>?)
          ?.map((e) => NgoKeyItem.fromJson(e))
          .toList() ??
          [],
      chooseAmount: (json['choose_amount'] as List<dynamic>?)
          ?.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
          .toList() ??
          [],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class NgoProgress {
  final int targetAmount;
  final int totalAmount;
  final int donor;

  NgoProgress({
    required this.targetAmount,
    required this.totalAmount,
    required this.donor,
  });

  factory NgoProgress.fromJson(Map<String, dynamic> json) {
    return NgoProgress(
      targetAmount: json['target_amount'] ?? 0,
      totalAmount: json['total_amount'] ?? 0,
      donor: json['donor'] ?? 0,
    );
  }

  double get progressRatio {
    if (targetAmount == 0) return 0.0;
    return (totalAmount / targetAmount).clamp(0.0, 1.0);
  }
}

class NgoKeyItem {
  final String key;
  final String icon;
  final String value;

  NgoKeyItem({
    required this.key,
    required this.icon,
    required this.value,
  });

  factory NgoKeyItem.fromJson(Map<String, dynamic> json) {
    return NgoKeyItem(
      key: json['key'] ?? '',
      icon: json['icon'] ?? '',
      value: json['value'] ?? '',
    );
  }
}