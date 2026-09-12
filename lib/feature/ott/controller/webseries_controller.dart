// lib/feature/ott_platform/controller/webseries_controller.dart

import 'package:get/get.dart';
import '../../../core/widget/flutter_toast.dart';
import '../model/webseries_model.dart';
import '../repository/webseries_repository.dart';

class WebseriesController extends GetxController {
  final WebseriesRepository _repository = WebseriesRepository();

  // State
  final RxBool isLoading = false.obs;
  final RxList<Webseries> webseriesList = <Webseries>[].obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchWebseries();
  }

  /// Fetch all webseries
  Future<void> fetchWebseries() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final response = await _repository.getWebseriesList();

      webseriesList.assignAll(response.data);
    } catch (e) {
      errorMessage.value = e.toString();
      FlutterToast.error('Failed to load webseries');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh
  Future<void> refresh() async {
    await fetchWebseries();
  }

  /// Get webseries by id (from local list)
  Webseries? getById(int id) {
    try {
      return webseriesList.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Filter trending
  List<Webseries> get trendingList =>
      webseriesList.where((w) => w.isTrending).toList();

  /// Filter recommended
  List<Webseries> get recommendedList =>
      webseriesList.where((w) => w.isRecommended).toList();
}