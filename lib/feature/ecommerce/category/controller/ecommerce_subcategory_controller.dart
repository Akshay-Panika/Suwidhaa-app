// lib/feature/ecommerce/subcategory/controller/ecommerce_subcategory_controller.dart

import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/ecommerce_subcategory_model.dart';
import '../repository/ecommerce_subcategory_repository.dart';

class EcommerceSubCategoryController extends GetxController {
  final EcommerceSubCategoryRepository _repository =
  EcommerceSubCategoryRepository();

  // ---- State ----
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<EcommerceSubCategoryModel> subCategories =
      <EcommerceSubCategoryModel>[].obs;

  /// Currently selected category id (0 = all)
  final RxInt selectedCategoryId = 0.obs;

  /// Request token to prevent stale responses from overwriting fresh ones
  int _requestToken = 0;

  @override
  void onInit() {
    super.onInit();
    fetchSubCategories(); // load all initially
  }

  Future<void> fetchSubCategories({int? categoryId}) async {
    // Increment token for this request
    final token = ++_requestToken;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (categoryId != null) {
        selectedCategoryId.value = categoryId;
      }

      // ✅ CLEAR OLD DATA immediately so UI shows shimmer, not stale data
      subCategories.clear();

      final response = await _repository.fetchSubCategories(
        categoryId: selectedCategoryId.value == 0
            ? null
            : selectedCategoryId.value,
      );

      // ✅ Ignore this response if a newer request was fired meanwhile
      if (token != _requestToken) return;

      if (response.success) {
        subCategories.assignAll(response.data);
      } else {
        errorMessage.value = 'Failed to load sub-categories';
      }
    } catch (e) {
      if (token != _requestToken) return;
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      FlutterToast.error(errorMessage.value);
    } finally {
      // Only the latest request should reset the loading flag
      if (token == _requestToken) {
        isLoading.value = false;
      }
    }
  }

  Future<void> filterByCategory(int categoryId) async {
    if (selectedCategoryId.value == categoryId) return;
    selectedCategoryId.value = categoryId;
    await fetchSubCategories(categoryId: categoryId);
  }

  Future<void> refresh() => fetchSubCategories(
    categoryId:
    selectedCategoryId.value == 0 ? null : selectedCategoryId.value,
  );
}