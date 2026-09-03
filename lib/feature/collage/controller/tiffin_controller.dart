// lib/feature/college/controllers/tiffin_controller.dart
import 'package:get/get.dart';
import '../../../core/widget/flutter_toast.dart';
import '../model/tiffin_model.dart';
import '../repository/tiffin_repository.dart';

class TiffinController extends GetxController {
  final TiffinRepository _repository = TiffinRepository();

  // Observable variables
  final RxList<Tiffin> tiffins = <Tiffin>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<Tiffin?> selectedTiffin = Rx<Tiffin?>(null);
  final RxString selectedFilter = 'All'.obs;

  // Available tiffin types for filter
  final List<String> tiffinTypes = [
    'All',
    'Veg',
    'Non-Veg',
    'Both',
  ];

  // Get filtered tiffins based on selected type
  List<Tiffin> get filteredTiffins {
    if (selectedFilter.value == 'All') {
      return tiffins;
    }

    if (selectedFilter.value == 'Veg') {
      return tiffins.where((tiffin) => tiffin.isVegOnly).toList();
    } else if (selectedFilter.value == 'Non-Veg') {
      return tiffins.where((tiffin) => tiffin.isNonVegOnly).toList();
    } else if (selectedFilter.value == 'Both') {
      return tiffins.where((tiffin) => tiffin.isBothVegNonVeg).toList();
    }

    return tiffins;
  }

  // Get available tiffins
  List<Tiffin> get availableTiffins {
    return tiffins.where((tiffin) => !tiffin.isBooking).toList();
  }

  // Get booked tiffins
  List<Tiffin> get bookedTiffins {
    return tiffins.where((tiffin) => tiffin.isBooking).toList();
  }

  @override
  void onInit() {
    super.onInit();
    if (tiffins.isEmpty) {
      fetchTiffins();
    }
  }

  /// Fetch all tiffins
  Future<void> fetchTiffins() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.getTiffins();

      if (response.success) {
        tiffins.value = response.data;
        print('✅ All tiffins loaded: ${tiffins.length}');
      } else {
        errorMessage.value = 'Failed to load tiffins';
        FlutterToast.error('Failed to load tiffins');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      FlutterToast.error('Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch tiffins by college name - Filter using near_college
  Future<void> fetchTiffinsByCollege(String collegeName) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔍 Fetching tiffins for college: $collegeName');

      // Get all tiffins from API
      final response = await _repository.getTiffins();

      if (response.success) {
        // Filter tiffins where near_college matches the college name (case insensitive)
        final filteredTiffins = response.data.where((tiffin) {
          if (tiffin.nearCollege == null || tiffin.nearCollege!.isEmpty) {
            return false;
          }
          // Match near_college with college name (case insensitive)
          return tiffin.nearCollege!.toLowerCase() == collegeName.toLowerCase();
        }).toList();

        tiffins.value = filteredTiffins;
        print('✅ Tiffins filtered by near_college: ${tiffins.length}');
      } else {
        errorMessage.value = 'Failed to load tiffins';
        FlutterToast.error('Failed to load tiffins');
      }
    } catch (e) {
      print('❌ Error fetching tiffins: $e');
      errorMessage.value = e.toString();
      FlutterToast.error('Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch tiffin by ID
  Future<void> fetchTiffinById(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final tiffin = await _repository.getTiffinById(id);
      selectedTiffin.value = tiffin;
    } catch (e) {
      errorMessage.value = e.toString();
      FlutterToast.error('Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch tiffins by type
  Future<void> fetchTiffinsByType(String type) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.getTiffinsByType(type);

      if (response.success) {
        tiffins.value = response.data;
      } else {
        errorMessage.value = 'Failed to load tiffins';
        FlutterToast.error('Failed to load tiffins');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      FlutterToast.error('Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Set filter
  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  /// Refresh tiffins
  Future<void> refreshTiffins() async {
    await fetchTiffins();
  }

  /// Clear selected tiffin
  void clearSelectedTiffin() {
    selectedTiffin.value = null;
  }
}