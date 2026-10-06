import 'package:get/get.dart';
import '../model/ngo_banner_model.dart';
import '../repository/ngo_banner_repository.dart';

class NgoBannerController extends GetxController {
  final NgoBannerRepository _repository = NgoBannerRepository();

  // Observables
  final RxList<NgoBannerData> banners = <NgoBannerData>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  /// Fetch all NGO banners
  Future<void> fetchBanners() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getNgoBanners();
      banners.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}