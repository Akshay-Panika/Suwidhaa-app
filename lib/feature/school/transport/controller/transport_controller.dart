// lib/feature/school/transport/controller/transport_controller.dart
import 'dart:io';
import 'package:get/get.dart';
import 'package:untitled/core/widget/flutter_toast.dart';
import '../model/transport_model.dart';
import '../repository/transport_repository.dart';

class TransportController extends GetxController {
  final TransportRepository _repository = TransportRepository();

  // Observables
  var isLoading = false.obs;
  var isCreating = false.obs;
  var isAddingStudent = false.obs;
  var isDeleting = false.obs;
  var removingStudentIds = <String>{}.obs;

  bool isRemovingStudent(String studentId) => removingStudentIds.contains(studentId);

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

  // ==================== GET LIST ====================
  Future<void> getTransportList() async {
    try {
      isLoading.value = true;
      final response = await _repository.getTransportList();

      if (response.success) {
        transportList.value = response.data;
        filteredTransportList.value = response.data;
        applyFilters();
      } else {
        FlutterToast.error('Failed to load transport data');
      }
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshTransportList() async {
    await getTransportList();
  }

  // ==================== GET DETAIL ====================
  Future<void> getTransportDetail(int id) async {
    try {
      isLoading.value = true;
      final transport = await _repository.getTransportDetail(id);

      if (transport != null) {
        selectedTransport.value = transport;
      } else {
        FlutterToast.error('Transport not found');
      }
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== CREATE TRANSPORT ====================
  Future<bool> createTransport({
    required String transportType,
    required String schoolType,
    required String vehicleNumber,
    required String driverName,
    required String driverNumber,
    String? capacity,
    String? routeName,
    File? driverImage,
  })
  async {
    try {
      isCreating.value = true;

      final newTransport = await _repository.createTransport(
        transportType: transportType,
        schoolType: schoolType,
        vehicleNumber: vehicleNumber,
        driverName: driverName,
        driverNumber: driverNumber,
        capacity: capacity,
        routeName: routeName,
        driverImage: driverImage,
      );

      // Add to local list (optimistic update)
      transportList.insert(0, newTransport);
      applyFilters();

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return false;
    } finally {
      isCreating.value = false;
    }
  }
// ==================== ADD STUDENT TO TRANSPORT ====================
  Future<bool> addStudentToTransport({
    required int transportId,
    required String studentName,
    required String studentId,
    required String pickupTime,
    required String dropTime,
    required String address,
  }) async {
    try {
      isAddingStudent.value = true;

      final success = await _repository.addStudentToTransport(
        transportId: transportId,
        studentName: studentName,
        studentId: studentId,
        pickupTime: pickupTime,
        dropTime: dropTime,
        address: address,
      );

      if (success) {
        // Refresh the transport list so student count updates
        await getTransportList();
      }
      return success;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      isAddingStudent.value = false;
    }
  }

  // ==================== FILTERS ====================
  void applyFilters() {
    var list = transportList.toList();

    if (searchQuery.value.isNotEmpty) {
      list = list.where((item) {
        final query = searchQuery.value.toLowerCase();
        return item.routeName?.toLowerCase().contains(query) == true ||
            item.vehicleNumber.toLowerCase().contains(query) ||
            item.driverName.toLowerCase().contains(query) ||
            item.transportType.toLowerCase().contains(query);
      }).toList();
    }

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

  // ==================== GETTERS ====================
  int get totalRoutes => transportList.length;

  int get totalStudents {
    int total = 0;
    for (var transport in transportList) {
      total += transport.studentCount;
    }
    return total;
  }

  List<String> get uniqueTransportTypes {
    final types = <String>{};
    for (var transport in transportList) {
      if (transport.transportType.isNotEmpty) {
        types.add(transport.transportType);
      }
    }
    return types.toList();
  }


  // ==================== DELETE TRANSPORT ====================
  Future<bool> deleteTransport(int id) async {
    try {
      isDeleting.value = true;

      final success = await _repository.deleteTransport(id);

      if (success) {
        // Remove from local lists
        transportList.removeWhere((t) => t.id == id);
        filteredTransportList.removeWhere((t) => t.id == id);
        applyFilters();

        FlutterToast.success('Transport deleted successfully');
      }
      return success;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  Future<bool> removeStudentFromTransport({
    required int transportId,
    required String studentId,
  }) async {
    try {
      removingStudentIds.add(studentId);   // ✅ add only this ID

      final success = await _repository.removeStudentFromTransport(
        transportId: transportId,
        studentId: studentId,
      );

      if (success) {
        await getTransportList();
        FlutterToast.success('Student removed successfully');
      }
      return success;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      removingStudentIds.remove(studentId);   // ✅ remove from set
    }
  }
}