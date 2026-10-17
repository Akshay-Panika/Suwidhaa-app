// lib/feature/ecommerce/category/controller/ecommerce_category_controller.dart

import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/ecommerce_category_model.dart';
import '../repository/ecommerce_category_repository.dart';

class EcommerceCategoryController extends GetxController {
  final EcommerceCategoryRepository _repository =
  EcommerceCategoryRepository();

  // State
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<EcommerceCategoryModel> categories =
      <EcommerceCategoryModel>[].obs;

  int _requestToken = 0;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final token = ++_requestToken;
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.fetchCategories();

      if (token != _requestToken) return;

      if (response.success) {
        categories.assignAll(response.data);
      } else {
        errorMessage.value = 'Failed to load categories';
      }
    } catch (e) {
      if (token != _requestToken) return;
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      FlutterToast.error(errorMessage.value);
    } finally {
      if (token == _requestToken) {
        isLoading.value = false;
      }
    }
  }

  Future<void> refreshCategories() => fetchCategories();
}