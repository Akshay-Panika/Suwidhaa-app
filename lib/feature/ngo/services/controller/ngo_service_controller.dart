import 'package:get/get.dart';
import '../model/ngo_service_model.dart';
import '../repository/ngo_service_repository.dart';

class NgoServiceController extends GetxController {
  final NgoServiceRepository _repository = NgoServiceRepository();

  final RxList<NgoServiceData> services = <NgoServiceData>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final Rxn<NgoServiceData> serviceDetail = Rxn<NgoServiceData>();
  final RxBool isDetailLoading = false.obs;
  final RxString detailErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  /// Fetch all NGO services
  Future<void> fetchServices() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getServices();
      services.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch single NGO service by id
  Future<NgoServiceData?> fetchServiceById(int id) async {
    try {
      isDetailLoading.value = true;
      detailErrorMessage.value = '';
      serviceDetail.value = null;

      final result = await _repository.getServiceById(id);
      serviceDetail.value = result;
      return result;
    } catch (e) {
      detailErrorMessage.value = e.toString().replaceAll('Exception: ', '');
      return null;
    } finally {
      isDetailLoading.value = false;
    }
  }

  /// Manual refresh (list)
  Future<void> refresh() async {
    await fetchServices();
  }
}