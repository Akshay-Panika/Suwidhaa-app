// lib/feature/ott_platform/model/webseries_model.dart

class WebseriesResponse {
  final bool success;
  final int count;
  final List<Webseries> data;

  WebseriesResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory WebseriesResponse.fromJson(Map<String, dynamic> json) {
    return WebseriesResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => Webseries.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Webseries {
  final int id;
  final String contentType;
  final String? thumbnailHorizontal;
  final String? thumbnailVertical;
  final String title;
  final String description;
  final String releaseDate;
  final String language;
  final String duration;
  final String rating;
  final bool isTrending;
  final bool isRecommended;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final List<Season> seasons;

  Webseries({
    required this.id,
    required this.contentType,
    this.thumbnailHorizontal,
    this.thumbnailVertical,
    required this.title,
    required this.description,
    required this.releaseDate,
    required this.language,
    required this.duration,
    required this.rating,
    required this.isTrending,
    required this.isRecommended,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.seasons,
  });

  factory Webseries.fromJson(Map<String, dynamic> json) {
    return Webseries(
      id: json['id'] ?? 0,
      contentType: json['content_type'] ?? 'webseries',
      thumbnailHorizontal: json['thumbnail_horizontal'],
      thumbnailVertical: json['thumbnail_vertical'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      releaseDate: json['release_date'] ?? '',
      language: json['language'] ?? '',
      duration: json['duration'] ?? '',
      rating: json['rating']?.toString() ?? '0.0',
      isTrending: json['is_trending'] ?? false,
      isRecommended: json['is_recommended'] ?? false,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      seasons: (json['seasons'] as List<dynamic>? ?? [])
          .map((e) => Season.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Season {
  final int id;
  final int webseries;
  final int seasonNumber;
  final String? title;
  final String? description;
  final String? releaseDate;
  final String createdAt;
  final String updatedAt;
  final List<Episode> episodes;

  Season({
    required this.id,
    required this.webseries,
    required this.seasonNumber,
    this.title,
    this.description,
    this.releaseDate,
    required this.createdAt,
    required this.updatedAt,
    required this.episodes,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'] ?? 0,
      webseries: json['webseries'] ?? 0,
      seasonNumber: json['season_number'] ?? 0,
      title: json['title'],
      description: json['description'],
      releaseDate: json['release_date'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      episodes: (json['episodes'] as List<dynamic>? ?? [])
          .map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Episode {
  final int id;
  final int? webseries;
  final int season;
  final int episodeNumber;
  final String title;
  final String? description;
  final String duration;
  final String videoUrl;
  final String? releaseDate;
  final String createdAt;
  final String updatedAt;

  Episode({
    required this.id,
    this.webseries,
    required this.season,
    required this.episodeNumber,
    required this.title,
    this.description,
    required this.duration,
    required this.videoUrl,
    this.releaseDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] ?? 0,
      webseries: json['webseries'],
      season: json['season'] ?? 0,
      episodeNumber: json['episode_number'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      duration: json['duration'] ?? '',
      videoUrl: json['video_url'] ?? '',
      releaseDate: json['release_date'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}