// lib/feature/ott_platform/controller/ott_reel_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widget/flutter_toast.dart';
import '../model/ott_reel_model.dart';
import '../repository/ott_reel_repository.dart';

class OttReelController extends GetxController {
  final OttReelRepository _repository = OttReelRepository();

  final RxBool isLoading = false.obs;
  final RxList<OttReelData> reels = <OttReelData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReels();
  }

  Future<void> fetchReels({bool showLoader = true}) async {
    try {
      if (showLoader) isLoading.value = true;

      final response = await _repository.getReels();

      if (response.status) {
        reels.assignAll(response.data);
      } else {
        FlutterToast.error(response.message);
      }
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      debugPrint('OttReelController.fetchReels error: $e');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> refreshReels() async {
    await fetchReels(showLoader: false);
  }
}