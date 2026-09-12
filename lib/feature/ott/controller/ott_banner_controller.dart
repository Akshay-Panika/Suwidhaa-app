import 'package:get/get.dart';

import '../../../core/widget/flutter_toast.dart';
import '../model/ott_banner_model.dart';
import '../repository/ott_banner_repository.dart';

class OttBannerController extends GetxController {
  final OttBannerRepository _repository = OttBannerRepository();

  final RxList<OttBannerModel> banners = <OttBannerModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getBanners();
  }

  Future<void> getBanners() async {
    try {
      isLoading.value = true;

      final result = await _repository.getBanners();

      banners.assignAll(result);
    } catch (e) {
      FlutterToast.error(
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshBanners() async {
    await getBanners();
  }
}