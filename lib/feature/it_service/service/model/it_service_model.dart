class ItServiceCategoryMini {
  final int id;
  final String name;
  final String image;

  ItServiceCategoryMini({
    required this.id,
    required this.name,
    required this.image,
  });

  factory ItServiceCategoryMini.fromJson(Map<String, dynamic> json) {
    return ItServiceCategoryMini(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class ItServiceData {
  final int id;
  final String image;
  final String title;
  final String description;
  final String price;
  final String oldPrice;
  final List<String> techStack;
  final ItServiceCategoryMini? category;

  ItServiceData({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.techStack,
    required this.category,
  });

  factory ItServiceData.fromJson(Map<String, dynamic> json) {
    return ItServiceData(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      oldPrice: json['old_price'] ?? '',
      techStack: (json['tech_stack'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      category: json['category_detail'] != null
          ? ItServiceCategoryMini.fromJson(
        json['category_detail'] as Map<String, dynamic>,
      )
          : null,
    );
  }
}