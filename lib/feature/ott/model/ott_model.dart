class OttModel {
  final int id;
  final int categoryId;
  final String contentType;
  final String thumbnailHorizontal;
  final String thumbnailVertical;
  final String title;
  final String? description;
  final String? releaseDate;
  final String? language;
  final String? duration;
  final String? videoUrl;
  final String rating;
  final bool isTrending;
  final bool isRecommended;
  final bool isActive;

  OttModel({
    required this.id,
    required this.categoryId,
    required this.contentType,
    required this.thumbnailHorizontal,
    required this.thumbnailVertical,
    required this.title,
    this.description,
    this.releaseDate,
    this.language,
    this.duration,
    this.videoUrl,
    required this.rating,
    required this.isTrending,
    required this.isRecommended,
    required this.isActive,
  });

  factory OttModel.fromJson(Map<String, dynamic> json) {
    final contentType = json['content_type'] ?? '';

    // 🔹 Pick category-specific id based on content_type
    int categoryId = 0;
    switch (contentType) {
      case 'movie':
        categoryId = json['movie'] ?? 0;
        break;
      case 'cartoon':
        categoryId = json['cartoon'] ?? 0;
        break;
      case 'sport':
        categoryId = json['sport'] ?? 0;
        break;
      case 'sci_fi':
        categoryId = json['sci_fi'] ?? 0;
        break;
      default:
        categoryId = json['id'] ?? 0;
    }

    return OttModel(
      id: json['id'] ?? 0,
      categoryId: categoryId,
      contentType: contentType,
      thumbnailHorizontal: json['thumbnail_horizontal'] ?? '',
      thumbnailVertical: json['thumbnail_vertical'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      releaseDate: json['release_date'],
      language: json['language'],
      duration: json['duration'],
      videoUrl: json['video_url'],
      rating: (json['rating'] ?? '0.0').toString(),
      isTrending: json['is_trending'] ?? false,
      isRecommended: json['is_recommended'] ?? false,
      isActive: json['is_active'] ?? false,
    );
  }
}