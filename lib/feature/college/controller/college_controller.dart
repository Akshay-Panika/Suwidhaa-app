// lib/feature/college/controller/college_controller.dart
import 'package:get/get.dart';
import '../../../core/widget/flutter_toast.dart';
import '../model/college_model.dart';
import '../repository/college_repository.dart';

class CollegeController extends GetxController {
  final CollegeRepository _repository = CollegeRepository();

  // Observable variables
  final RxList<College> colleges = <College>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<College?> selectedCollege = Rx<College?>(null);

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

  /// Refresh colleges
  Future<void> refreshColleges() async {
    await fetchColleges();
  }

  /// Clear selected college
  void clearSelectedCollege() {
    selectedCollege.value = null;
  }

  // Get recommended colleges
  List<College> get recommendedColleges {
    return colleges.where((college) => college.isRecommended).toList();
  }
}