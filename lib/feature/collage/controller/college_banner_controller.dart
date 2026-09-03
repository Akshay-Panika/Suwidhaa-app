import 'package:get/get.dart';
import '../../../core/widget/flutter_toast.dart';
import '../model/college_banner_model.dart';
import '../repository/college_banner_repository.dart';

class CollegeBannerController extends GetxController {
  final CollegeBannerRepository _repository = CollegeBannerRepository();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxList<BannerData> banners = <BannerData>[].obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.getBanners();

      if (response.success && response.data.isNotEmpty) {
        banners.assignAll(response.data);
        FlutterToast.success('${response.count} banners loaded successfully');
      } else {
        errorMessage.value = 'No banners available';
        FlutterToast.warning('No banners available');
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      FlutterToast.error('Failed to load banners');
    } finally {
      isLoading.value = false;
    }
  }

  void refreshBanners() {
    fetchBanners();
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }
}