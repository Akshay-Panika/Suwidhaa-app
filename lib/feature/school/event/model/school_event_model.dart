class SchoolEventModel {
  final int? id;
  final String? bannerImage;
  final String? pdfFile;
  final String? title;
  final String? description;
  final String? type;
  final String? startDate;
  final String? endDate;
  final String? schoolType;
  final String? time;
  final String? location;
  final String? status;
  final List<String>? assignedClasses;
  final List<String>? assignedTeachers;
  final EventDetails? eventDetails;
  final bool? checkBox;
  final String? createdAt;
  final String? updatedAt;

  SchoolEventModel({
    this.id,
    this.bannerImage,
    this.pdfFile,
    this.title,
    this.description,
    this.type,
    this.startDate,
    this.endDate,
    this.schoolType,
    this.time,
    this.location,
    this.status,
    this.assignedClasses,
    this.assignedTeachers,
    this.eventDetails,
    this.checkBox,
    this.createdAt,
    this.updatedAt,
  });

  factory SchoolEventModel.fromJson(Map<String, dynamic> json) {
    return SchoolEventModel(
      id: json['id'],
      bannerImage: json['banner_image']?.toString(),
      pdfFile: json['pdf_file']?.toString(),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      type: json['type']?.toString(),
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      schoolType: json['school_type']?.toString(),
      time: json['time']?.toString(),
      location: json['location']?.toString(),
      status: json['status']?.toString(),
      assignedClasses: json['assigned_classes'] != null
          ? List<String>.from(json['assigned_classes'])
          : [],
      assignedTeachers: json['assigned_teachers'] != null
          ? List<String>.from(json['assigned_teachers'])
          : [],
      eventDetails: json['event_details'] != null
          ? EventDetails.fromJson(json['event_details'])
          : null,
      checkBox: json['check_box'] ?? false,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'start_date': startDate,
      'end_date': endDate,
      'school_type': schoolType,
      'time': time,
      'location': location,
      'status': status,
      'assigned_classes': assignedClasses,
      'assigned_teachers': assignedTeachers,
      'event_details': eventDetails?.toJson(),
    };
  }

  SchoolEventModel copyWith({
    int? id,
    String? bannerImage,
    String? pdfFile,
    String? title,
    String? description,
    String? type,
    String? startDate,
    String? endDate,
    String? schoolType,
    String? time,
    String? location,
    String? status,
    List<String>? assignedClasses,
    List<String>? assignedTeachers,
    EventDetails? eventDetails,
    bool? checkBox,
    String? createdAt,
    String? updatedAt,
  }) {
    return SchoolEventModel(
      id: id ?? this.id,
      bannerImage: bannerImage ?? this.bannerImage,
      pdfFile: pdfFile ?? this.pdfFile,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      schoolType: schoolType ?? this.schoolType,
      time: time ?? this.time,
      location: location ?? this.location,
      status: status ?? this.status,
      assignedClasses: assignedClasses ?? this.assignedClasses,
      assignedTeachers: assignedTeachers ?? this.assignedTeachers,
      eventDetails: eventDetails ?? this.eventDetails,
      checkBox: checkBox ?? this.checkBox,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String getStatusColor() {
    switch (status?.toLowerCase()) {
      case 'upcoming':
        return 'blue';
      case 'ongoing':
        return 'green';
      case 'completed':
        return 'grey';
      case 'cancelled':
        return 'red';
      default:
        return 'grey';
    }
  }

  String getFormattedDate() {
    if (startDate == null) return '';
    try {
      final date = DateTime.parse(startDate!);
      return '${date.day}-${date.month}-${date.year}';
    } catch (e) {
      return startDate ?? '';
    }
  }
}

class EventDetails {
  final String? eventType;
  final String? guestSpeaker;
  final String? eventDescription;
  final String? expectedAttendees;

  EventDetails({
    this.eventType,
    this.guestSpeaker,
    this.eventDescription,
    this.expectedAttendees,
  });

  factory EventDetails.fromJson(Map<String, dynamic> json) {
    return EventDetails(
      eventType: json['event_type']?.toString(),
      guestSpeaker: json['guest_speaker']?.toString(),
      eventDescription: json['event_description']?.toString(),
      expectedAttendees: json['expected_attendees']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_type': eventType,
      'guest_speaker': guestSpeaker,
      'event_description': eventDescription,
      'expected_attendees': expectedAttendees,
    };
  }
}

class SchoolEventListResponse {
  final bool success;
  final int count;
  final List<SchoolEventModel> data;

  SchoolEventListResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory SchoolEventListResponse.fromJson(Map<String, dynamic> json) {
    return SchoolEventListResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((item) => SchoolEventModel.fromJson(item))
          .toList(),
    );
  }
}