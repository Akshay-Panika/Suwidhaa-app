class NoticeModel {
  final int id;
  final String title;
  final String description;
  final String priority;        // Normal | Important | Urgent
  final String audience;        // Students | Parents | Both | Staff
  final String assignedClass;
  final String? attachment;     // cloudinary public_id
  final String? attachmentUrl;  // full https URL
  final bool isPinned;
  final String createdBy;
  final String createdAt;
  final String displayDate;

  NoticeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.audience,
    required this.assignedClass,
    this.attachment,
    this.attachmentUrl,
    required this.isPinned,
    required this.createdBy,
    required this.createdAt,
    required this.displayDate,
  });

  // ============ FROM JSON ============
  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      priority: json['priority'] ?? 'Normal',
      audience: json['audience'] ?? 'Students',
      assignedClass: json['assigned_class'] ?? 'All Classes',
      attachment: json['attachment'],
      attachmentUrl: json['attachment_url'],
      isPinned: json['is_pinned'] == true,
      createdBy: json['created_by'] ?? '',
      createdAt: json['created_at'] ?? '',
      displayDate: json['display_date'] ?? '',
    );
  }

  // ============ TO JSON (for create/update) ============
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'priority': priority,
    'audience': audience,
    'assigned_class': assignedClass,
    'is_pinned': isPinned,
    'created_by': createdBy,
  };

  // ============ HELPERS ============
  bool get hasAttachment =>
      attachmentUrl != null && attachmentUrl!.trim().isNotEmpty;

  /// "image" if cloudinary URL ends in image ext, else "pdf"
  String get attachmentType {
    if (!hasAttachment) return '';
    final url = attachmentUrl!.toLowerCase();
    if (url.endsWith('.png') ||
        url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.gif') ||
        url.endsWith('.webp')) {
      return 'image';
    }
    return 'pdf';
  }

  /// File name from the URL (last segment)
  String get attachmentName {
    if (!hasAttachment) return '';
    try {
      return Uri.parse(attachmentUrl!).pathSegments.last;
    } catch (_) {
      return 'attachment';
    }
  }

  // ============ COPY WITH ============
  NoticeModel copyWith({
    int? id,
    String? title,
    String? description,
    String? priority,
    String? audience,
    String? assignedClass,
    String? attachment,
    String? attachmentUrl,
    bool? isPinned,
    String? createdBy,
    String? createdAt,
    String? displayDate,
  }) {
    return NoticeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      audience: audience ?? this.audience,
      assignedClass: assignedClass ?? this.assignedClass,
      attachment: attachment ?? this.attachment,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      isPinned: isPinned ?? this.isPinned,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      displayDate: displayDate ?? this.displayDate,
    );
  }
}