import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/ott_content_model.dart';
import '../repository/ott_content_repository.dart';

class OttContentController extends GetxController {
  final OttContentRepository _repository = OttContentRepository();

  final RxList<OttContentModel> contents = <OttContentModel>[].obs;
  final RxBool isLoading = false.obs;

  // Current selected category (0 = All Content)
  final RxInt selectedCategoryId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getContents();
  }

  Future<void> getContents({int? categoryId}) async {
    try {
      isLoading.value = true;

      // Agar naya category ID pass hua hai to update karein
      if (categoryId != null) {
        selectedCategoryId.value = categoryId;
      }

      // Repo ko current category ID pass karein
      final result = await _repository.getContents(
        categoryId: selectedCategoryId.value,
      );

      contents.assignAll(result);
    } catch (e) {
      FlutterToast.error(
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh button ya pull-to-refresh ke liye
  Future<void> refreshContents() async {
    await getContents(categoryId: selectedCategoryId.value);
  }

  // Widget se category select karne ke liye
  void selectCategory(int categoryId) {
    if (selectedCategoryId.value == categoryId) return; // Same category pe re-call na ho
    selectedCategoryId.value = categoryId;
    getContents();
  }
}