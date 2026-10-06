import 'package:get/get.dart';
import '../model/ngo_category_model.dart';
import '../repository/ngo_category_repository.dart';

class NgoCategoryController extends GetxController {
  final NgoCategoryRepository _repository = NgoCategoryRepository();

  // Observables
  final RxList<NgoCategoryData> categories = <NgoCategoryData>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  /// Fetch all NGO categories
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getCategories();
      categories.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

}