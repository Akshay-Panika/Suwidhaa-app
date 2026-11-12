// ngo_history_controller.dart (unchanged)
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../../../auth/controller/auth_controller.dart';
import '../model/ngo_history_model.dart';
import '../repository/ngo_history_repository.dart';

class NgoHistoryController extends GetxController {
  final NgoHistoryRepository _repository = NgoHistoryRepository();
  final AuthController _authController = Get.find<AuthController>();

  final RxBool isLoading = false.obs;
  final RxBool isDonating = false.obs;

  final RxList<GroupedServiceDonationModel> groupedHistoryList =
      <GroupedServiceDonationModel>[].obs;

  final RxDouble totalDonated = 0.0.obs;
  final RxInt totalDonations = 0.obs;
  final RxInt uniqueServices = 0.obs;
  final RxString selectedFilter = "all".obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMyHistory();
    });
  }

  Future<void> loadMyHistory({String? from, String? to}) async {
    final raw = _authController.getUserId;
    final int? donorId =
    raw is int ? raw : (raw != null ? int.tryParse(raw.toString()) : null);

    if (donorId == null || donorId <= 0) return;

    try {
      isLoading.value = true;
      final result = await _repository.getHistoryByDonor(donorId,
          from: from, to: to);

      groupedHistoryList.assignAll(result.data);
      totalDonated.value = result.summary.totalDonated;
      totalDonations.value = result.summary.totalDonations;
      uniqueServices.value = result.summary.uniqueServices;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> donate({
    required int serviceId,
    required double amount,
    String? donorName,
    String? donorContact,
  }) async {
    final raw = _authController.getUserId;
    final int? donorId =
    raw is int ? raw : (raw != null ? int.tryParse(raw.toString()) : null);

    if (donorId == null || donorId <= 0) {
      FlutterToast.error("Please login to donate");
      return false;
    }
    if (amount <= 0) {
      FlutterToast.error("Invalid donation amount");
      return false;
    }

    try {
      isDonating.value = true;
      await _repository.createHistory(
        NgoHistoryCreateRequest(
          serviceId: serviceId,
          donorId: donorId,
          donateAmount: amount,
          donorName: donorName ?? _authController.getUserName,
          donorContact: donorContact ?? _authController.getUserPhone,
        ),
      );
      await loadMyHistory();
      return true;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      isDonating.value = false;
    }
  }

  void applyFilter(String filter) {
    selectedFilter.value = filter;
    final now = DateTime.now();
    DateTime? from;

    switch (filter) {
      case 'today':
        from = DateTime(now.year, now.month, now.day);
        break;
      case 'week':
        from = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        from = now.subtract(const Duration(days: 30));
        break;
      default:
        from = null;
    }

    loadMyHistory(
      from: from != null
          ? "${from.year}-${from.month.toString().padLeft(2, '0')}-${from.day.toString().padLeft(2, '0')}"
          : null,
    );
  }
}