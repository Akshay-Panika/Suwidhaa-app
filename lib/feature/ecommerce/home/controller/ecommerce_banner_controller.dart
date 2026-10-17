// lib/feature/ecommerce/banner/controller/ecommerce_banner_controller.dart

import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/ecommerce_banner_model.dart';
import '../repository/ecommerce_banner_repository.dart';

class EcommerceBannerController extends GetxController {
  final EcommerceBannerRepository _repository = EcommerceBannerRepository();

  // State
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<EcommerceBannerModel> banners = <EcommerceBannerModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.fetchBanners();

      if (response.success) {
        banners.assignAll(response.data);
      } else {
        errorMessage.value = 'Failed to load banners';
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      FlutterToast.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshBanners() => fetchBanners();
}