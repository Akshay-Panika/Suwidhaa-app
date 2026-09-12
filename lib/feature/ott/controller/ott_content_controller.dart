import 'package:get/get.dart';

import '../../../core/widget/flutter_toast.dart';
import '../model/ott_content_model.dart';
import '../repository/ott_content_repository.dart';

class OttContentController extends GetxController {
  final OttContentRepository _repository =
  OttContentRepository();

  final RxList<OttContentModel> contents =
      <OttContentModel>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getContents();
  }

  Future<void> getContents() async {
    try {
      isLoading.value = true;

      final result = await _repository.getContents();

      contents.assignAll(result);
    } catch (e) {
      FlutterToast.error(
        e.toString().replaceFirst(
          'Exception: ',
          '',
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshContents() async {
    await getContents();
  }
}