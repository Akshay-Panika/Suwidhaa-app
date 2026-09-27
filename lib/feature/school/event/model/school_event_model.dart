class SchoolEventModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final String venue;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String organizer;
  final String audience;
  final String status;
  final String? banner;      // cloudinary public_id
  final String? bannerUrl;   // full https URL
  final bool isPinned;
  final String createdAt;
  final String displayDate;

  SchoolEventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.venue,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.organizer,
    required this.audience,
    required this.status,
    this.banner,
    this.bannerUrl,
    required this.isPinned,
    required this.createdAt,
    required this.displayDate,
  });

  // ============ FROM JSON ============
  factory SchoolEventModel.fromJson(Map<String, dynamic> json) {
    return SchoolEventModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Sports',
      venue: json['venue'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      organizer: json['organizer'] ?? '',
      audience: json['audience'] ?? 'Both',
      status: json['status'] ?? 'Upcoming',
      banner: json['banner'],
      bannerUrl: json['banner_url'],
      isPinned: json['is_pinned'] == true,
      createdAt: json['created_at'] ?? '',
      displayDate: json['display_date'] ?? '',
    );
  }

  // ============ TO JSON ============
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'category': category,
    'venue': venue,
    'start_date': startDate,
    'end_date': endDate,
    'start_time': startTime,
    'end_time': endTime,
    'organizer': organizer,
    'audience': audience,
    'status': status,
    'is_pinned': isPinned,
  };

  // ============ HELPERS ============
  bool get hasBanner => bannerUrl != null && bannerUrl!.trim().isNotEmpty;

  /// True when start_date != end_date
  bool get isMultiDay => startDate.trim() != endDate.trim();

  // ============ COPY WITH ============
  SchoolEventModel copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    String? venue,
    String? startDate,
    String? endDate,
    String? startTime,
    String? endTime,
    String? organizer,
    String? audience,
    String? status,
    String? banner,
    String? bannerUrl,
    bool? isPinned,
    String? createdAt,
    String? displayDate,
  }) {
    return SchoolEventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      venue: venue ?? this.venue,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      organizer: organizer ?? this.organizer,
      audience: audience ?? this.audience,
      status: status ?? this.status,
      banner: banner ?? this.banner,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      displayDate: displayDate ?? this.displayDate,
    );
  }
}