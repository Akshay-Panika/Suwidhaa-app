import 'package:get/get.dart';
import '../model/it_service_category_model.dart';
import '../repository/it_service_category_repository.dart';

class ItServiceCategoryController extends GetxController {
  final ItServiceCategoryRepository _repository = ItServiceCategoryRepository();

  // Observables
  final RxList<ItServiceCategoryData> categories =
      <ItServiceCategoryData>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();   // auto-load on init
  }

  /// GET - Fetch all IT Service categories
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getItServiceCategories();
      categories.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}