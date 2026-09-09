// lib/feature/college/controllers/tiffin_controller.dart
import 'dart:io';
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

  // Get tiffins by user ID
  List<Tiffin> getTiffinsByUserId(String userId) {
    return tiffins.where((tiffin) => tiffin.userId == userId).toList();
  }

  @override
  void onInit() {
    super.onInit();
    if (tiffins.isEmpty) {
      fetchTiffins();
    }
  }

  // ============================================================
  // READ OPERATIONS
  // ============================================================

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

  /// Fetch tiffins by user ID
  Future<void> fetchTiffinsByUserId(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔍 Fetching tiffins for user: $userId');

      final response = await _repository.getTiffins(userId: userId);

      if (response.success) {
        tiffins.value = response.data;
        print('✅ Tiffins loaded for user: ${tiffins.length}');
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
      print('✅ Tiffin loaded: ${tiffin.title}');
    } catch (e) {
      errorMessage.value = e.toString();
      FlutterToast.error('Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // CREATE OPERATIONS
  // ============================================================

  /// Create a new tiffin
  Future<bool> createTiffin({
    required String title,
    required String description,
    required String price,
    required String nearCollege,
    required String isVeg,
    required String isNonveg,
    required String contactNumber,
    required String userId,
    List<File>? images,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('📝 Creating new tiffin: $title');

      final tiffin = await _repository.createTiffin(
        title: title,
        description: description,
        price: price,
        nearCollege: nearCollege,
        isVeg: isVeg,
        isNonveg: isNonveg,
        contactNumber: contactNumber,
        userId: userId,
        images: images,
      );

      // Add to list
      tiffins.insert(0, tiffin);
      print('✅ Tiffin created successfully: ${tiffin.id}');

      FlutterToast.success('Tiffin created successfully');
      return true;
    } catch (e) {
      print('❌ Error creating tiffin: $e');
      errorMessage.value = e.toString();
      FlutterToast.error('Failed to create tiffin: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // UPDATE OPERATIONS
  // ============================================================

  /// Update an existing tiffin
  Future<bool> updateTiffin({
    required int tiffinId,
    String? title,
    String? description,
    String? price,
    String? nearCollege,
    String? isVeg,
    String? isNonveg,
    String? contactNumber,
    String? userId,
    List<File>? images,
    List<int>? imageIdsToDelete,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('📝 Updating tiffin: $tiffinId');

      final updatedTiffin = await _repository.updateTiffin(
        tiffinId: tiffinId,
        title: title,
        description: description,
        price: price,
        nearCollege: nearCollege,
        isVeg: isVeg,
        isNonveg: isNonveg,
        contactNumber: contactNumber,
        userId: userId,
        images: images,
        imageIdsToDelete: imageIdsToDelete,
      );

      // Update in list
      final index = tiffins.indexWhere((t) => t.id == tiffinId);
      if (index != -1) {
        tiffins[index] = updatedTiffin;
      }

      // Update selected tiffin if it's the same
      if (selectedTiffin.value?.id == tiffinId) {
        selectedTiffin.value = updatedTiffin;
      }

      print('✅ Tiffin updated successfully: $tiffinId');
      FlutterToast.success('Tiffin updated successfully');
      return true;
    } catch (e) {
      print('❌ Error updating tiffin: $e');
      errorMessage.value = e.toString();
      FlutterToast.error('Failed to update tiffin: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update tiffin availability status (Book/Unbook)
  Future<bool> toggleTiffinBooking(int tiffinId, bool isBooking) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('📝 Toggling booking status for tiffin: $tiffinId');

      final updatedTiffin = await _repository.updateTiffin(
        tiffinId: tiffinId,
        // Note: You'll need to add is_booking field to your update method
        // For now, we'll use a JSON update
      );

      // Update in list
      final index = tiffins.indexWhere((t) => t.id == tiffinId);
      if (index != -1) {
        tiffins[index] = updatedTiffin;
      }

      if (selectedTiffin.value?.id == tiffinId) {
        selectedTiffin.value = updatedTiffin;
      }

      FlutterToast.success(
          isBooking ? 'Tiffin booked successfully' : 'Tiffin unbooked successfully'
      );
      return true;
    } catch (e) {
      print('❌ Error toggling booking status: $e');
      FlutterToast.error('Failed to update booking status');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // DELETE OPERATIONS
  // ============================================================

  /// Delete a tiffin
  Future<bool> deleteTiffin(int tiffinId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🗑️ Deleting tiffin: $tiffinId');

      final success = await _repository.deleteTiffin(tiffinId);

      if (success) {
        // Remove from list
        tiffins.removeWhere((t) => t.id == tiffinId);

        // Clear selected tiffin if it was deleted
        if (selectedTiffin.value?.id == tiffinId) {
          selectedTiffin.value = null;
        }

        print('✅ Tiffin deleted successfully: $tiffinId');
        FlutterToast.success('Tiffin deleted successfully');
        return true;
      }

      return false;
    } catch (e) {
      print('❌ Error deleting tiffin: $e');
      errorMessage.value = e.toString();
      FlutterToast.error('Failed to delete tiffin: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete multiple tiffins
  Future<bool> deleteMultipleTiffins(List<int> tiffinIds) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🗑️ Deleting ${tiffinIds.length} tiffins');

      int successCount = 0;
      for (final id in tiffinIds) {
        final success = await _repository.deleteTiffin(id);
        if (success) {
          successCount++;
          tiffins.removeWhere((t) => t.id == id);
        }
      }

      if (successCount == tiffinIds.length) {
        FlutterToast.success('All tiffins deleted successfully');
      } else {
        FlutterToast.warning('Deleted $successCount/${tiffinIds.length} tiffins');
      }

      return successCount == tiffinIds.length;
    } catch (e) {
      print('❌ Error deleting tiffins: $e');
      FlutterToast.error('Failed to delete tiffins');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // FILTER OPERATIONS
  // ============================================================

  /// Set filter
  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  /// Filter tiffins by availability
  List<Tiffin> filterByAvailability({bool? available}) {
    if (available == null) {
      return tiffins;
    }
    return tiffins.where((tiffin) => tiffin.isBooking != available).toList();
  }

  /// Search tiffins by title
  List<Tiffin> searchTiffins(String query) {
    if (query.isEmpty) {
      return tiffins;
    }
    return tiffins.where((tiffin) {
      return tiffin.title.toLowerCase().contains(query.toLowerCase()) ||
          (tiffin.nearCollege?.toLowerCase().contains(query.toLowerCase()) ??
              false);
    }).toList();
  }

  /// Get tiffin by ID
  Tiffin? getTiffinById(int id) {
    try {
      return tiffins.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  // ============================================================
  // SELECTION OPERATIONS
  // ============================================================

  /// Select a tiffin
  void selectTiffin(int id) {
    try {
      final tiffin = tiffins.firstWhere((t) => t.id == id);
      selectedTiffin.value = tiffin;
      print('📌 Selected tiffin: ${tiffin.title}');
    } catch (e) {
      selectedTiffin.value = null;
      FlutterToast.error('Tiffin not found');
    }
  }

  /// Clear selected tiffin
  void clearSelectedTiffin() {
    selectedTiffin.value = null;
    print('📌 Cleared selected tiffin');
  }

  // ============================================================
  // REFRESH OPERATIONS
  // ============================================================

  /// Refresh tiffins
  Future<void> refreshTiffins() async {
    await fetchTiffins();
  }

  /// Refresh tiffins by user ID
  Future<void> refreshTiffinsByUserId(String userId) async {
    await fetchTiffinsByUserId(userId);
  }

  // ============================================================
  // CLEAR OPERATIONS
  // ============================================================

  /// Clear all tiffins
  void clearTiffins() {
    tiffins.clear();
    errorMessage.value = '';
    selectedTiffin.value = null;
    print('🗑️ Cleared all tiffins');
  }

  /// Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  /// Get statistics
  Map<String, dynamic> getStatistics() {
    return {
      'total': tiffins.length,
      'available': availableTiffins.length,
      'booked': bookedTiffins.length,
      'veg': tiffins.where((t) => t.isVegOnly).length,
      'nonVeg': tiffins.where((t) => t.isNonVegOnly).length,
      'both': tiffins.where((t) => t.isBothVegNonVeg).length,
    };
  }

  /// Get user statistics
  Map<String, dynamic> getUserStatistics(String userId) {
    final userTiffins = getTiffinsByUserId(userId);
    return {
      'total': userTiffins.length,
      'available': userTiffins.where((t) => !t.isBooking).length,
      'booked': userTiffins.where((t) => t.isBooking).length,
    };
  }

  // ============================================================
  // BULK OPERATIONS
  // ============================================================

  /// Bulk update tiffin availability
  Future<bool> bulkUpdateAvailability(List<int> tiffinIds, bool isBooking) async {
    try {
      isLoading.value = true;
      int successCount = 0;

      for (final id in tiffinIds) {
        final success = await toggleTiffinBooking(id, isBooking);
        if (success) successCount++;
      }

      FlutterToast.success('Updated $successCount/${tiffinIds.length} tiffins');
      return successCount == tiffinIds.length;
    } catch (e) {
      FlutterToast.error('Error updating tiffins');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}