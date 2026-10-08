import 'package:get/get.dart';
import '../model/it_service_banner_model.dart';
import '../repository/it_service_banner_repository.dart';

class ItServiceBannerController extends GetxController {
  final ItServiceBannerRepository _repository = ItServiceBannerRepository();

  // Observables
  final RxList<ItServiceBannerData> banners = <ItServiceBannerData>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();   // auto-load on init
  }

  /// GET - Fetch all IT Service banners
  Future<void> fetchBanners() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getItServiceBanners();
      banners.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}