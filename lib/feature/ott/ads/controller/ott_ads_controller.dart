import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/ott_ads_model.dart';
import '../repository/ott_ads_repository.dart';

class OttAdsController extends GetxController {
  final OttAdsRepository _repo = OttAdsRepository();

  final RxList<OttAdsModel> ads = <OttAdsModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAds();
  }

  Future<void> fetchAds() async {
    try {
      isLoading.value = true;
      final list = await _repo.getAds();
      ads.assignAll(list);
    } catch (e) {
      FlutterToast.error('Failed to load ads');
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Sirf Update rahega (Create hata diya gaya hai)
  Future<bool> updateAd({
    required int id,
    required String title,
    required String videoUrl,
    required String navigateScreen,
    required bool isActive,
    PlatformFile? imageFile,
  }) async {
    isSaving.value = true;
    try {
      final updated = await _repo.updateAd(
        id: id,
        title: title,
        videoUrl: videoUrl,
        navigateScreen: navigateScreen,
        isActive: isActive,
        imageFile: imageFile,
      );
      final idx = ads.indexWhere((a) => a.id == id);
      if (idx != -1) ads[idx] = updated;
      FlutterToast.success('Ad updated successfully');
      return true;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteAd(int id) async {
    try {
      await _repo.deleteAd(id);
      ads.removeWhere((a) => a.id == id);
      FlutterToast.success('Ad deleted');
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<PlatformFile?> pickAdImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    return result?.files.first;
  }
}