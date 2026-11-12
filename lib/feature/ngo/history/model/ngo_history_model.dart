// ngo_history_model.dart

class NgoHistoryModel {
  final int id;
  final int? service;
  final String? serviceName;
  final String? categoryName;
  final String? serviceImage;
  final NgoServiceProgress? serviceProgress;
  final int? donorId;
  final String? donorName;
  final String? donorContact;
  final double donateAmount;
  final String createdAt;
  final String updatedAt;

  NgoHistoryModel({
    required this.id,
    this.service,
    this.serviceName,
    this.categoryName,
    this.serviceImage,
    this.serviceProgress,
    this.donorId,
    this.donorName,
    this.donorContact,
    required this.donateAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NgoHistoryModel.fromJson(Map<String, dynamic> json) {
    return NgoHistoryModel(
      id: json['id'] ?? 0,
      service: json['service'],
      serviceName: json['service_name'],
      categoryName: json['category_name'],
      serviceImage: json['service_image'],
      serviceProgress: json['service_progress'] != null
          ? NgoServiceProgress.fromJson(json['service_progress'])
          : null,
      donorId: json['donor_id'],
      donorName: json['donor_name'],
      donorContact: json['donor_contact'],
      donateAmount: double.tryParse(json['donate_amount'].toString()) ?? 0.0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class NgoServiceProgress {
  final int donor;
  final double totalAmount;
  final int targetAmount;

  NgoServiceProgress({
    required this.donor,
    required this.totalAmount,
    required this.targetAmount,
  });

  factory NgoServiceProgress.fromJson(Map<String, dynamic> json) {
    return NgoServiceProgress(
      donor: json['donor'] ?? 0,
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      targetAmount: json['target_amount'] ?? 0,
    );
  }
}

// ✅ UPDATED: Donation item model (for the nested `donations` array)
class DonationItem {
  final int id;
  final double amount;
  final String createdAt;

  DonationItem({
    required this.id,
    required this.amount,
    required this.createdAt,
  });

  factory DonationItem.fromJson(Map<String, dynamic> json) {
    return DonationItem(
      id: json['id'] ?? 0,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      createdAt: json['created_at'] ?? '',
    );
  }
}

// ✅ UPDATED: GroupedDonorInfo now parses `donations` array correctly
class GroupedDonorInfo {
  final int? donorId;
  final String donorName;
  final String donorContact;
  final List<DonationItem> donations; // 👈 Ab DonationItem ki list hai

  GroupedDonorInfo({
    this.donorId,
    required this.donorName,
    required this.donorContact,
    required this.donations,
  });

  factory GroupedDonorInfo.fromJson(Map<String, dynamic> json) {
    return GroupedDonorInfo(
      donorId: json['donor_id'],
      donorName: json['donor_name'] ?? '',
      donorContact: json['donor_contact'] ?? '',
      donations: (json['donations'] as List<dynamic>?)
          ?.map((e) => DonationItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

// ✅ UPDATED: Added helper methods for count and total amount
class GroupedServiceDonationModel {
  final GroupedServiceInfo service;
  final List<GroupedDonorInfo> donor;

  GroupedServiceDonationModel({
    required this.service,
    required this.donor,
  });

  /// Returns the first donor's info (since the API returns only the current user).
  GroupedDonorInfo? get myDonorInfo =>
      donor.isNotEmpty ? donor.first : null;

  /// Total number of donations made by the user for this service.
  int get myDonationCount => myDonorInfo?.donations.length ?? 0;

  /// List of individual donation amounts for this service.
  List<double> get myDonationAmounts =>
      myDonorInfo?.donations.map((d) => d.amount).toList() ?? [];

  /// Sum of all donation amounts for this service.
  double get myTotalDonated =>
      myDonationAmounts.fold(0.0, (sum, amount) => sum + amount);

  factory GroupedServiceDonationModel.fromJson(Map<String, dynamic> json) {
    return GroupedServiceDonationModel(
      service: GroupedServiceInfo.fromJson(json['service'] ?? {}),
      donor: (json['donor'] as List<dynamic>?)
          ?.map((e) => GroupedDonorInfo.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class GroupedServiceInfo {
  final int id;
  final String serviceName;
  final String categoryName;
  final String serviceImage;
  final NgoServiceProgress serviceProgress;

  GroupedServiceInfo({
    required this.id,
    required this.serviceName,
    required this.categoryName,
    required this.serviceImage,
    required this.serviceProgress,
  });

  factory GroupedServiceInfo.fromJson(Map<String, dynamic> json) {
    return GroupedServiceInfo(
      id: json['id'] ?? 0,
      serviceName: json['service_name'] ?? '',
      categoryName: json['category_name'] ?? '',
      serviceImage: json['service_image'] ?? '',
      serviceProgress:
      NgoServiceProgress.fromJson(json['service_progress'] ?? {}),
    );
  }
}

// ✅ Response Wrapper (unchanged)
class NgoDonorHistoryResponse {
  final int donorId;
  final NgoDonorSummary summary;
  final int count;
  final List<GroupedServiceDonationModel> data;

  NgoDonorHistoryResponse({
    required this.donorId,
    required this.summary,
    required this.count,
    required this.data,
  });

  factory NgoDonorHistoryResponse.fromJson(Map<String, dynamic> json) {
    return NgoDonorHistoryResponse(
      donorId: json['donor_id'] ?? 0,
      summary: NgoDonorSummary.fromJson(json['summary'] ?? {}),
      count: json['count'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((e) => GroupedServiceDonationModel.fromJson(e))
          .toList(),
    );
  }
}

class NgoDonorSummary {
  final double totalDonated;
  final int totalDonations;
  final int uniqueServices;

  NgoDonorSummary({
    required this.totalDonated,
    required this.totalDonations,
    required this.uniqueServices,
  });

  factory NgoDonorSummary.fromJson(Map<String, dynamic> json) {
    return NgoDonorSummary(
      totalDonated: double.tryParse(json['total_donated'].toString()) ?? 0.0,
      totalDonations: json['total_donations'] ?? 0,
      uniqueServices: json['unique_services'] ?? 0,
    );
  }
}

// ✅ Create Request (unchanged)
class NgoHistoryCreateRequest {
  final int serviceId;
  final int donorId;
  final double donateAmount;
  final String? donorName;
  final String? donorContact;

  NgoHistoryCreateRequest({
    required this.serviceId,
    required this.donorId,
    required this.donateAmount,
    this.donorName,
    this.donorContact,
  });

  Map<String, dynamic> toJson() {
    return {
      "service_id": serviceId,
      "donor_id": donorId,
      "donate_amount": donateAmount,
      if (donorName != null) "donor_name": donorName,
      if (donorContact != null) "donor_contact": donorContact,
    };
  }
}