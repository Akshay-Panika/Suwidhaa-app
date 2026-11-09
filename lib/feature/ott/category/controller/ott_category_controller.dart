import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/ott_category_model.dart';
import '../repository/ott_category_repository.dart';

class OttCategoryController extends GetxController {
  final OttCategoryRepository _repo = OttCategoryRepository();

  final RxList<OttCategoryModel> categories = <OttCategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ✅ Selection state (Default: 0 = Home/All)
  final RxInt selectedCategoryId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      update();
      final data = await _repo.getCategories();
      categories.assignAll(data);
      update();
    } catch (e) {
      errorMessage.value = e.toString();
      update();
      FlutterToast.error('Failed to load categories');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> refreshCategories() => fetchCategories();

  // ✅ SELECT — sets id + notifies all listeners
  void selectCategory(OttCategoryModel cat) {
    if (selectedCategoryId.value == cat.id) return;
    selectedCategoryId.value = cat.id;
    update(); // ✅ force rebuild for GetBuilder
    print('🎯 Category Selected: ${cat.name} (id=${cat.id})');
  }

  bool isSelected(int id) => selectedCategoryId.value == id;
}