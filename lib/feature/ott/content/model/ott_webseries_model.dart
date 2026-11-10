class OttWebSeriesModel {
  final int id;
  final String title;
  final String description;

  final int? categoryId;
  final String categoryName;
  final String? categoryImage;

  final String? thumbnailHorizontal;
  final String? thumbnailVertical;
  final String videoUrl;
  final String videoDuration;
  final String releaseDate;

  final bool isFamily;
  final bool isRecommended;
  final bool isTrending;
  final bool isSomethingNew;
  final bool isLock;

  final List<OttWebSeriesSeasonModel> seasons;
  final String? createdAt;
  final String? updatedAt;

  OttWebSeriesModel({
    required this.id,
    required this.title,
    required this.description,
    this.categoryId,
    this.categoryName = '',
    this.categoryImage,
    this.thumbnailHorizontal,
    this.thumbnailVertical,
    required this.videoUrl,
    required this.videoDuration,
    required this.releaseDate,
    required this.isFamily,
    required this.isRecommended,
    required this.isTrending,
    required this.isSomethingNew,
    required this.isLock,
    required this.seasons,
    this.createdAt,
    this.updatedAt,
  });

  String get displayImage =>
      (thumbnailHorizontal?.isNotEmpty == true)
          ? thumbnailHorizontal!
          : (thumbnailVertical?.isNotEmpty == true ? thumbnailVertical! : '');

  int get totalEpisodes =>
      seasons.fold(0, (sum, s) => sum + s.episodes.length);

  int get releaseYear {
    if (releaseDate.isEmpty) return 0;
    final parts = releaseDate.split('-');
    return parts.isNotEmpty ? int.tryParse(parts.first) ?? 0 : 0;
  }

  factory OttWebSeriesModel.fromJson(Map<String, dynamic> json) {
    int? catId;
    String catName = '';
    String? catImage;
    final rawCat = json['category'];
    if (rawCat is Map) {
      catId = (rawCat['id'] as num?)?.toInt();
      catName = rawCat['name'] as String? ?? '';
      catImage = rawCat['image'] as String?;
    }

    final rawSeasons = json['seasons'] as List<dynamic>? ?? const [];
    final parsedSeasons = rawSeasons
        .whereType<Map<String, dynamic>>()
        .map((e) => OttWebSeriesSeasonModel.fromJson(e))
        .toList()
      ..sort((a, b) => a.seasonNumber.compareTo(b.seasonNumber));

    return OttWebSeriesModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      categoryId: catId,
      categoryName: catName,
      categoryImage: catImage,
      thumbnailHorizontal: json['thumbnail_horizontal'] as String?,
      thumbnailVertical: json['thumbnail_vertical'] as String?,
      videoUrl: json['video_url'] as String? ?? '',
      videoDuration: (json['video_duration'] ?? '').toString(),
      releaseDate: json['release_date'] as String? ?? '',
      isFamily: json['is_family'] as bool? ?? false,
      isRecommended: json['is_recommended'] as bool? ?? false,
      isTrending: json['is_trending'] as bool? ?? false,
      isSomethingNew: json['is_something_new'] as bool? ?? false,
      isLock: json['is_lock'] as bool? ?? false,
      seasons: parsedSeasons,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}

class OttWebSeriesSeasonModel {
  final int seasonNumber;
  final List<OttWebSeriesEpisodeModel> episodes;

  OttWebSeriesSeasonModel({
    required this.seasonNumber,
    required this.episodes,
  });

  factory OttWebSeriesSeasonModel.fromJson(Map<String, dynamic> json) {
    final rawEps = json['episodes'] as List<dynamic>? ?? const [];
    final parsedEps = rawEps
        .whereType<Map<String, dynamic>>()
        .map((e) => OttWebSeriesEpisodeModel.fromJson(e))
        .toList()
      ..sort((a, b) => a.episodeNumber.compareTo(b.episodeNumber));

    return OttWebSeriesSeasonModel(
      seasonNumber: (json['season_number'] as num?)?.toInt() ?? 1,
      episodes: parsedEps,
    );
  }
}

class OttWebSeriesEpisodeModel {
  final int id;
  final int webseriesId;
  final int seasonNumber;
  final int episodeNumber;
  final String title;
  final String description;
  final String videoUrl;
  final String duration;
  final String? thumbnail;

  OttWebSeriesEpisodeModel({
    required this.id,
    required this.webseriesId,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.duration,
    this.thumbnail,
  });

  factory OttWebSeriesEpisodeModel.fromJson(Map<String, dynamic> json) {
    return OttWebSeriesEpisodeModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      webseriesId: (json['webseries'] as num?)?.toInt() ?? 0,
      seasonNumber: (json['season_number'] as num?)?.toInt() ?? 1,
      episodeNumber: (json['episode_number'] as num?)?.toInt() ?? 1,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      videoUrl: json['video_url'] as String? ?? '',
      duration: (json['duration'] ?? '').toString(),
      thumbnail: json['thumbnail'] as String?,
    );
  }
}