class OttContentModel {
  final int id;
  final int categoryId;
  final String categoryName;
  final String title;
  final String description;
  final String thumbnailHorizontal;
  final String thumbnailVertical;
  final String videoUrl;
  final String videoDuration;
  final String releaseDate;
  final bool isFamily;
  final bool isRecommended;
  final bool isTrending;
  final bool isSomethingNew;
  final bool isLock;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OttContentModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.title,
    required this.description,
    required this.thumbnailHorizontal,
    required this.thumbnailVertical,
    required this.videoUrl,
    required this.videoDuration,
    required this.releaseDate,
    required this.isFamily,
    required this.isRecommended,
    required this.isTrending,
    required this.isSomethingNew,
    required this.isLock,
    this.createdAt,
    this.updatedAt,
  });

  factory OttContentModel.fromJson(Map<String, dynamic> json) {
    // Category object extract kar rahe hain
    final category = json['category'] as Map<String, dynamic>?;

    return OttContentModel(
      id: json['id'] ?? 0,
      categoryId: category?['id'] ?? 0,
      categoryName: category?['name'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnailHorizontal: json['thumbnail_horizontal'] ?? '',
      thumbnailVertical: json['thumbnail_vertical'] ?? '',
      videoUrl: json['video_url'] ?? '',
      videoDuration: json['video_duration'] ?? '',
      releaseDate: json['release_date'] ?? '',
      isFamily: json['is_family'] ?? false,
      isRecommended: json['is_recommended'] ?? false,
      isTrending: json['is_trending'] ?? false,
      isSomethingNew: json['is_something_new'] ?? false,
      isLock: json['is_lock'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}