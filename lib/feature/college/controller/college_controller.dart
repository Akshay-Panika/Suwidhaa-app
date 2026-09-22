// lib/feature/college/controller/college_controller.dart
import 'package:get/get.dart';
import '../../../core/widget/flutter_toast.dart';
import '../model/college_model.dart';
import '../repository/college_repository.dart';

class CollegeController extends GetxController {
  final CollegeRepository _repository = CollegeRepository();

  // ==================== ALL COLLEGES ====================
  final RxList<College> colleges = <College>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<College?> selectedCollege = Rx<College?>(null);

  // ==================== CATEGORY-WISE ====================
  final RxList<College> categoryColleges = <College>[].obs;
  final RxBool isCategoryLoading = false.obs;
  final RxString categoryErrorMessage = ''.obs;
  String _lastCategory = '';

  @override
  void onInit() {
    super.onInit();
    fetchColleges();
  }

  /// Fetch all colleges
  Future<void> fetchColleges() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.getColleges();

      if (response.success) {
        colleges.value = response.data;
      } else {
        errorMessage.value = 'Failed to load colleges';
        FlutterToast.error('Failed to load colleges');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      FlutterToast.error('Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch college by ID
  Future<void> fetchCollegeById(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final college = await _repository.getCollegeById(id);
      selectedCollege.value = college;
    } catch (e) {
      errorMessage.value = e.toString();
      FlutterToast.error('Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch colleges by category
  ///
  /// Tries to call the repository's category endpoint first. If the repository
  /// does not yet support category filtering, falls back to filtering the
  /// already-loaded [colleges] list.
  Future<void> fetchCollegesByCategory(String category) async {
    try {
      isCategoryLoading.value = true;
      categoryErrorMessage.value = '';
      _lastCategory = category;

      // 1) Try repository method if it exists
      // final response = await _repository.getCollegesByCategory(category);
      // if (response.success) {
      //   categoryColleges.value = response.data;
      //   return;
      // }

      // 2) Fallback: if all colleges aren't loaded yet, load them first
      if (colleges.isEmpty) {
        await fetchColleges();
      }

      // 3) Filter locally by category (case-insensitive)
      final filtered = colleges
          .where((c) =>
      (c.category ?? '').toLowerCase() == category.toLowerCase())
          .toList();

      categoryColleges.value = filtered;
    } catch (e) {
      categoryErrorMessage.value = e.toString();
      FlutterToast.error('Error: ${e.toString()}');
    } finally {
      isCategoryLoading.value = false;
    }
  }

  /// Refresh colleges
  Future<void> refreshColleges() async {
    await fetchColleges();
  }

  /// Clear selected college
  void clearSelectedCollege() {
    selectedCollege.value = null;
  }

  /// Clear category results (call on screen dispose if you want)
  void clearCategory() {
    categoryColleges.clear();
    categoryErrorMessage.value = '';
    _lastCategory = '';
  }

  // Get recommended colleges
  List<College> get recommendedColleges {
    return colleges.where((college) => college.isRecommended).toList();
  }
}