class OttContentModel {
  final int id;
  final int categoryId;
  final String title;
  final String thumbnailHorizontal;
  final String thumbnailVertical;
  final String contentType;
  final String releaseDate;
  final String rating;
  final bool isTrending;
  final bool isRecommended;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? movie;
  final int? cartoon;
  final int? sport;
  final int? sciFi;
  final int? webseries;   // ⬅️ NEW

  OttContentModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.thumbnailHorizontal,
    required this.thumbnailVertical,
    required this.contentType,
    required this.releaseDate,
    required this.rating,
    required this.isTrending,
    required this.isRecommended,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.movie,
    this.cartoon,
    this.sport,
    this.sciFi,
    this.webseries,       // ⬅️ NEW
  });

  factory OttContentModel.fromJson(Map<String, dynamic> json) {
    final contentType = json['content_type'] ?? '';

    // 🔹 Read category-specific IDs
    final movieId     = json['movie']     as int?;
    final cartoonId   = json['cartoon']   as int?;
    final sportId     = json['sport']     as int?;
    final sciFiId     = json['sci_fi']    as int?;
    final webseriesId = json['webseries'] as int?;   // ⬅️ NEW

    // 🔹 Pick the categoryId based on content_type
    int categoryId = 0;
    switch (contentType) {
      case 'movie':
        categoryId = movieId ?? 0;
        break;
      case 'cartoon':
        categoryId = cartoonId ?? 0;
        break;
      case 'sport':
        categoryId = sportId ?? 0;
        break;
      case 'sci_fi':
        categoryId = sciFiId ?? 0;
        break;
      case 'webseries':                    // ⬅️ NEW case
        categoryId = webseriesId ?? 0;
        break;
      default:
        categoryId = json['id'] ?? 0;
    }

    return OttContentModel(
      id: json['id'] ?? 0,
      categoryId: categoryId,
      title: json['title'] ?? '',
      thumbnailHorizontal: json['thumbnail_horizontal'] ?? '',
      thumbnailVertical: json['thumbnail_vertical'] ?? '',
      contentType: contentType,
      releaseDate: json['release_date'] ?? '',
      rating: json['rating']?.toString() ?? '0.0',
      isTrending: json['is_trending'] ?? false,
      isRecommended: json['is_recommended'] ?? false,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      movie: movieId,
      cartoon: cartoonId,
      sport: sportId,
      sciFi: sciFiId,
      webseries: webseriesId,
    );
  }
}