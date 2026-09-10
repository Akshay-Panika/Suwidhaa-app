import 'package:get/get.dart';
import '../../../core/widget/flutter_toast.dart';
import '../model/ott_model.dart';
import '../repository/ott_repository.dart';

class OttController extends GetxController {
  final OttRepository _repository = OttRepository();

  final RxBool isLoading = false.obs;
  final RxList<OttModel> contents = <OttModel>[].obs;

  final RxBool isDetailLoading = false.obs;
  final Rxn<OttModel> selectedContent = Rxn<OttModel>();

  @override
  void onInit() {
    super.onInit();
    fetchAllContents();
  }
  Future<void> fetchAllContents() async {
    try {
      isLoading.value = true;
      final list = await _repository.fetchAllContents();
      contents.assignAll(list);
    } catch (e) {
      FlutterToast.error('Failed to load contents');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchContentDetail({
    required int id,
    required String contentType,
  }) async {
    try {
      isDetailLoading.value = true;
      selectedContent.value = null;

      final content = await _repository.fetchContentDetail(
        id: id,
        contentType: contentType,
      );
      selectedContent.value = content;
    } catch (e) {
      FlutterToast.error('Failed to load details');
    } finally {
      isDetailLoading.value = false;
    }
  }

  List<OttModel> byType(String? type) {
    if (type == null) return contents.toList();
    return contents.where((c) => c.contentType == type).toList();
  }

  List<OttModel> get trending =>
      contents.where((c) => c.isTrending).toList();

  List<OttModel> get recommended =>
      contents.where((c) => c.isRecommended).toList();
}