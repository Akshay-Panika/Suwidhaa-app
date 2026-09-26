import 'package:intl/intl.dart';

class MeetingModel {
  final int id;
  final String title;
  final String date;       // "2025-01-20"
  final String time;       // "10:30:00"
  final String forMeeting; // "Student" or "Staff"
  final String? className;
  final String? zoomUrl;
  final String? createdAt;
  final String? updatedAt;

  MeetingModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.forMeeting,
    this.className,
    this.zoomUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return MeetingModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      forMeeting: json['for_meeting'] ?? '',
      className: json['class_name'],
      zoomUrl: json['zoom_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'date': date,
    'time': time,
    'for_meeting': forMeeting,
    'class_name': className,
    'zoom_url': zoomUrl,
  };

  // ---------------- HELPERS ----------------
  DateTime? get dateTime {
    try {
      return DateTime.parse('$date $time');
    } catch (_) {
      return null;
    }
  }

  bool get isPast {
    final dt = dateTime;
    if (dt == null) return false;
    return dt.isBefore(DateTime.now());
  }

  bool get isToday {
    final dt = dateTime;
    if (dt == null) return false;
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  String get statusLabel {
    if (isPast) return 'Past';
    if (isToday) return 'Today';
    return 'Upcoming';
  }

  String get dayPart {
    final dt = dateTime;
    if (dt == null) return '';
    return DateFormat('dd').format(dt);
  }

  String get monthPart {
    final dt = dateTime;
    if (dt == null) return '';
    return DateFormat('MMM').format(dt);
  }

  String get dateShort {
    final dt = dateTime;
    if (dt == null) return date;
    return DateFormat('dd MMM').format(dt);
  }

  String get timePretty {
    final dt = dateTime;
    if (dt == null) return time;
    return DateFormat('hh:mm a').format(dt);
  }

  bool get hasZoom => zoomUrl != null && zoomUrl!.trim().isNotEmpty;
}