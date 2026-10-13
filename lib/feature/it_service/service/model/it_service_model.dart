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

/// 🆕 Booking info returned by the booked-list endpoint
class BookingInfo {
  final int id;
  final String status;
  final String fullName;
  final String createdAt;
  final String updatedAt;

  BookingInfo({
    required this.id,
    required this.status,
    required this.fullName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    return BookingInfo(
      id: json['id'] ?? 0,
      status: json['status'] ?? 'pending',
      fullName: json['full_name'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
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
  final bool isBooked;

  /// 🆕 Present only when returned from booked-list endpoint
  final BookingInfo? booking;

  ItServiceData({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.techStack,
    required this.category,
    required this.isBooked,
    this.booking,
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
      isBooked: json['is_booked'] ?? false,
      booking: json['booking'] != null
          ? BookingInfo.fromJson(json['booking'] as Map<String, dynamic>)
          : null,
    );
  }

  ItServiceData copyWith({bool? isBooked}) {
    return ItServiceData(
      id: id,
      image: image,
      title: title,
      description: description,
      price: price,
      oldPrice: oldPrice,
      techStack: techStack,
      category: category,
      isBooked: isBooked ?? this.isBooked,
      booking: booking,
    );
  }
}