class NgoStaffModel {
  final int id;
  final String image;
  final String name;
  final String contactNumber;
  final String? email;
  final String address;
  final String role;
  final String roleDisplay;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  NgoStaffModel({
    required this.id,
    required this.image,
    required this.name,
    required this.contactNumber,
    this.email,
    required this.address,
    required this.role,
    required this.roleDisplay,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NgoStaffModel.fromJson(Map<String, dynamic> json) {
    return NgoStaffModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      email: json['email'],
      address: json['address'] ?? '',
      role: json['role'] ?? '',
      roleDisplay: json['role_display'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'contact_number': contactNumber,
      'email': email,
      'address': address,
      'role': role,
      'is_active': isActive,
    };
  }
}