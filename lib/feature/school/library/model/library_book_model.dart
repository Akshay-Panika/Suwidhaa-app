class LibraryBookModel {
  final int? id;
  final String author;
  final String bookClass;
  final String subject;
  final int quantity;
  final String? frontImage;
  final String? backImage;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  LibraryBookModel({
    this.id,
    required this.author,
    required this.bookClass,
    required this.subject,
    required this.quantity,
    this.frontImage,
    this.backImage,
    this.status = "Available",
    this.createdAt,
    this.updatedAt,
  });

  factory LibraryBookModel.fromJson(Map<String, dynamic> json) {
    return LibraryBookModel(
      id: json['id'] as int?,
      author: (json['author'] ?? '') as String,
      bookClass: (json['book_class'] ?? '') as String,
      subject: (json['subject'] ?? '') as String,
      quantity: (json['quantity'] ?? 0) as int,
      frontImage: json['front_image'] as String?,
      backImage: json['back_image'] as String?,
      status: (json['status'] ?? 'Available') as String,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'author': author,
    'book_class': bookClass,
    'subject': subject,
    'quantity': quantity,
    'front_image': frontImage,
    'back_image': backImage,
  };

  LibraryBookModel copyWith({
    int? id,
    String? author,
    String? bookClass,
    String? subject,
    int? quantity,
    String? frontImage,
    String? backImage,
    String? status,
  }) {
    return LibraryBookModel(
      id: id ?? this.id,
      author: author ?? this.author,
      bookClass: bookClass ?? this.bookClass,
      subject: subject ?? this.subject,
      quantity: quantity ?? this.quantity,
      frontImage: frontImage ?? this.frontImage,
      backImage: backImage ?? this.backImage,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}