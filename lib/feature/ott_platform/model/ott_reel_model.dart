// lib/feature/ott_platform/model/ott_reel_model.dart

class OttReelModel {
  final bool status;
  final String message;
  final int count;
  final List<OttReelData> data;

  OttReelModel({
    required this.status,
    required this.message,
    required this.count,
    required this.data,
  });

  factory OttReelModel.fromJson(Map<String, dynamic> json) {
    return OttReelModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OttReelData.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class OttReelData {
  final int id;
  final String title;
  final String youtubeUrl;
  final String createdAt;

  OttReelData({
    required this.id,
    required this.title,
    required this.youtubeUrl,
    required this.createdAt,
  });

  factory OttReelData.fromJson(Map<String, dynamic> json) {
    return OttReelData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      youtubeUrl: json['youtube_url'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}