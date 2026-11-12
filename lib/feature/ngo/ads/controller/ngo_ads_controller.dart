import 'dart:math';
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/ngo_ads_model.dart';
import '../repository/ngo_ads_repository.dart';

class NgoAdsController extends GetxController {
  final NgoAdsRepository _repo = NgoAdsRepository();

  final RxList<NgoAdsModel> ads = <NgoAdsModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAds();
  }

  Future<void> fetchAds({bool? isHome}) async {
    try {
      isLoading.value = true;
      final list = await _repo.getAds(isHome: isHome);
      ads.assignAll(list);
    } catch (e) {
      FlutterToast.error('Failed to load ads');
    } finally {
      isLoading.value = false;
    }
  }

  /// Only ads tagged `is_home = true`
  List<NgoAdsModel> get homeAds => ads.where((a) => a.isHome).toList();

  /// Only ads tagged `is_home = false`
  List<NgoAdsModel> get nonHomeAds => ads.where((a) => !a.isHome).toList();

  /// Random single `is_home = false` ad
  NgoAdsModel? pickRandomNonHomeAd() {
    final list = nonHomeAds;
    if (list.isEmpty) return null;
    return list[Random().nextInt(list.length)];
  }
}