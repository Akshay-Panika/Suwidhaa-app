class AuthResponse {
  final bool success;
  final String? message;
  final String? action;
  final UserData? data;
  final String? error;

  AuthResponse({
    required this.success,
    this.message,
    this.action,
    this.data,
    this.error,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'],
      action: json['action'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
      error: json['error'],
    );
  }

  bool get isLoggedIn => success && data != null;
}

class UserData {
  final int id;
  final String name;
  final String phoneNumber;
  final bool isLoggedIn;
  final String createdAt;
  final String updatedAt;

  UserData({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.isLoggedIn,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      isLoggedIn: json['is_logged_in'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'is_logged_in': isLoggedIn,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}