// lib/feature/school/transport/controller/transport_controller.dart
import 'package:get/get.dart';
import '../model/transport_model.dart';
import '../repository/transport_repository.dart';

class TransportController extends GetxController {
  final TransportRepository _repository = TransportRepository();

  // Observables
  var isLoading = false.obs;
  var transportList = <TransportModel>[].obs;
  var filteredTransportList = <TransportModel>[].obs;
  var selectedTransport = Rxn<TransportModel>();

  // Filter
  var searchQuery = ''.obs;
  var filterByType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getTransportList();
  }

  Future<void> getTransportList() async {
    try {
      isLoading.value = true;
      final response = await _repository.getTransportList();

      if (response.success) {
        transportList.value = response.data;
        filteredTransportList.value = response.data;
        applyFilters();
      } else {
        Get.snackbar(
          'Error',
          'Failed to load transport data',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshTransportList() async {
    await getTransportList();
  }

  Future<void> getTransportDetail(int id) async {
    try {
      isLoading.value = true;
      final transport = await _repository.getTransportDetail(id);

      if (transport != null) {
        selectedTransport.value = transport;
      } else {
        Get.snackbar(
          'Error',
          'Transport not found',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    var list = transportList.toList();

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      list = list.where((item) {
        final query = searchQuery.value.toLowerCase();
        return item.routeName?.toLowerCase().contains(query) == true ||
            item.vehicleNumber.toLowerCase().contains(query) ||
            item.driverName.toLowerCase().contains(query) ||
            item.transportType.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by type
    if (filterByType.value.isNotEmpty) {
      list = list.where((item) {
        return item.transportType
            .toLowerCase()
            .contains(filterByType.value.toLowerCase());
      }).toList();
    }

    filteredTransportList.value = list;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void updateFilterByType(String type) {
    filterByType.value = type;
    applyFilters();
  }

  void clearFilters() {
    searchQuery.value = '';
    filterByType.value = '';
    applyFilters();
  }

  /// Get total number of routes
  int get totalRoutes {
    return transportList.length;
  }

  /// Get total number of students across all transports
  int get totalStudents {
    int total = 0;
    for (var transport in transportList) {
      total += transport.studentCount;
    }
    return total;
  }

  /// Get list of unique transport types
  List<String> get uniqueTransportTypes {
    final types = <String>{};
    for (var transport in transportList) {
      if (transport.transportType.isNotEmpty) {
        types.add(transport.transportType);
      }
    }
    return types.toList();
  }
}