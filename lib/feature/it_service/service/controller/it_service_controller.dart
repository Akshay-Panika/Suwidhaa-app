import 'package:get/get.dart';

import '../model/it_service_model.dart';
import '../repository/it_service_repository.dart';

class ItServiceController extends GetxController {
  final ItServiceRepository _repository = ItServiceRepository();

  // Observables
  final RxList<ItServiceData> services = <ItServiceData>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  /// GET — fetch all services (optional category filter)
  Future<void> fetchServices({int? categoryId}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result =
      await _repository.getServices(categoryId: categoryId);
      services.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  /// Filter locally by category name (for the category screen)
  List<ItServiceData> filteredByCategory(String categoryName) {
    if (categoryName == 'All') return services;
    return services
        .where((s) =>
    (s.category?.name ?? '').toLowerCase() ==
        categoryName.toLowerCase())
        .toList();
  }
}