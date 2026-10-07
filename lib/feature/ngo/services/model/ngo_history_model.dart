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
      donateAmount:
      double.tryParse(json['donate_amount'].toString()) ?? 0.0,
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
      totalAmount:
      double.tryParse(json['total_amount'].toString()) ?? 0.0,
      targetAmount: json['target_amount'] ?? 0,
    );
  }
}

/// ─── Wrapper for donor-wise response ───
class NgoDonorHistoryResponse {
  final int donorId;
  final NgoDonorSummary summary;
  final int count;
  final List<NgoHistoryModel> data;

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
          .map((e) => NgoHistoryModel.fromJson(e))
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
      totalDonated:
      double.tryParse(json['total_donated'].toString()) ?? 0.0,
      totalDonations: json['total_donations'] ?? 0,
      uniqueServices: json['unique_services'] ?? 0,
    );
  }
}

/// ─── Create request body ───
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