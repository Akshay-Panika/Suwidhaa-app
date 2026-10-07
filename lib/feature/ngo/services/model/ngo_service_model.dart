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
      id: _asInt(json['id']),
      category: json['category'] != null ? _asInt(json['category']) : null,
      categoryName: json['category_name'],
      name: json['name'] ?? '',
      description: json['description'],
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      progress: NgoProgress.fromJson(
        (json['progress'] as Map<String, dynamic>?) ?? {},
      ),
      keys: (json['keys'] as List<dynamic>?)
          ?.map((e) => NgoKeyItem.fromJson(e))
          .toList() ??
          [],
      chooseAmount: (json['choose_amount'] as List<dynamic>?)
          ?.map((e) => _asInt(e))
          .toList() ??
          [],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class NgoProgress {
  final int targetAmount;
  final double totalAmount; // ✅ FIX: changed from int to double
  final int donor;

  NgoProgress({
    required this.targetAmount,
    required this.totalAmount,
    required this.donor,
  });

  factory NgoProgress.fromJson(Map<String, dynamic> json) {
    return NgoProgress(
      targetAmount: _asInt(json['target_amount']),
      totalAmount: _asDouble(json['total_amount']), // ✅ safe parse
      donor: _asInt(json['donor']),
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

// ═══════════════════════════════════════════════════════════════
// SAFE NUMERIC PARSERS
// Handles int, double, String, and null from JSON
// ═══════════════════════════════════════════════════════════════

int _asInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

double _asDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}