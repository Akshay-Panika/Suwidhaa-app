// lib/feature/ecommerce/product/controller/ecommerce_product_controller.dart

import 'dart:io';
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../../../auth/controller/auth_controller.dart';
import '../model/ecommerce_product_model.dart';
import '../repository/ecommerce_product_repository.dart';

class EcommerceProductController extends GetxController {
  final EcommerceProductRepository _repository = EcommerceProductRepository();

  // ---- State ----
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<EcommerceProductModel> products = <EcommerceProductModel>[].obs;

  final RxInt selectedSubcategoryId = 0.obs;
  final RxBool isViewingFavorites = false.obs;

  /// Track if a fetch has ever completed successfully for the CURRENT mode.
  /// Reset to false whenever we start a new fetch so UI shows shimmer.
  final RxBool hasFetchedOnce = false.obs;

  /// Per-product toggle lock so only the tapped card is disabled,
  /// not all cards globally.
  final RxSet<int> togglingIds = <int>{}.obs;
  bool get isTogglingFavorite => togglingIds.isNotEmpty;

  /// Request token to discard stale async responses (race-condition guard)
  int _requestToken = 0;

  final AuthController authController = Get.find<AuthController>();

  // =================================================================
  // ✅ FLASH DEALS — separate state so it doesn't clash with
  // product list screen or favorites screen
  // =================================================================
  final RxBool isFlashDealsLoading = false.obs;
  final RxString flashDealsError = ''.obs;
  final RxList<EcommerceProductModel> flashDeals =
      <EcommerceProductModel>[].obs;

  /// Only show first N deals on home
  static const int maxFlashDealsOnHome = 6;

  List<EcommerceProductModel> get visibleFlashDeals =>
      flashDeals.take(maxFlashDealsOnHome).toList();

  int _flashToken = 0;

  // -----------------------------------------------------------------
  // Helpers
  // -----------------------------------------------------------------
  Future<bool> _ensureUserLoaded() async {
    if (authController.getUserId != 0) return true;
    for (int i = 0; i < 3; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (authController.getUserId != 0) return true;
    }
    return false;
  }

  // -----------------------------------------------------------------
  // Feed (List Screen)
  // -----------------------------------------------------------------
  Future<void> fetchProducts({int? subcategoryId}) async {
    final isUserLoaded = await _ensureUserLoaded();
    if (!isUserLoaded) {
      FlutterToast.error('User not logged in');
      return;
    }

    final token = ++_requestToken;

    try {
      isViewingFavorites.value = false;
      isLoading.value = true;
      hasFetchedOnce.value = false;
      errorMessage.value = '';
      products.clear();

      if (subcategoryId != null) {
        selectedSubcategoryId.value = subcategoryId;
      }

      final response = await _repository.fetchFeed(
        user: authController.getUserId,
        subcategoryId: selectedSubcategoryId.value == 0
            ? null
            : selectedSubcategoryId.value,
      );

      if (token != _requestToken) return;

      if (response.success) {
        products.assignAll(response.data);
      } else {
        errorMessage.value = 'Failed to load products';
      }
    } catch (e) {
      if (token != _requestToken) return;
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      FlutterToast.error(errorMessage.value);
    } finally {
      if (token == _requestToken) {
        isLoading.value = false;
        hasFetchedOnce.value = true;
      }
    }
  }

  // -----------------------------------------------------------------
  // Favorites (Favorite Screen)
  // -----------------------------------------------------------------
  Future<void> fetchFavorites() async {
    final isUserLoaded = await _ensureUserLoaded();
    if (!isUserLoaded) {
      FlutterToast.error('User not logged in');
      return;
    }

    final token = ++_requestToken;

    try {
      isViewingFavorites.value = true;
      isLoading.value = true;
      hasFetchedOnce.value = false;
      errorMessage.value = '';
      products.clear();

      final response =
      await _repository.fetchFavorites(user: authController.getUserId);

      if (token != _requestToken) return;

      if (response.success) {
        products.assignAll(response.data);
      } else {
        errorMessage.value = 'Failed to load favorites';
      }
    } catch (e) {
      if (token != _requestToken) return;
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      FlutterToast.error(errorMessage.value);
    } finally {
      if (token == _requestToken) {
        isLoading.value = false;
        hasFetchedOnce.value = true;
      }
    }
  }

  // -----------------------------------------------------------------
  // Toggle Favorite (index-safe & id-based)
  // -----------------------------------------------------------------
  Future<void> toggleFavorite(int productId) async {
    if (authController.getUserId == 0) {
      FlutterToast.error('User not logged in');
      return;
    }
    if (togglingIds.contains(productId)) return;

    try {
      togglingIds.add(productId);

      final newStatus = await _repository.toggleFavorite(
        id: productId,
        userId: authController.getUserId,
      );

      // Update in main products list
      final idx = products.indexWhere((p) => p.id == productId);
      if (idx != -1) {
        if (isViewingFavorites.value && !newStatus) {
          products.removeAt(idx);
        } else {
          products[idx] = products[idx].copyWith(isFavorite: newStatus);
        }
      }

      // ✅ Also update in flashDeals list (if present)
      final fIdx = flashDeals.indexWhere((p) => p.id == productId);
      if (fIdx != -1) {
        flashDeals[fIdx] = flashDeals[fIdx].copyWith(isFavorite: newStatus);
      }

      FlutterToast.success(
        newStatus ? 'Added to favorites' : 'Removed from favorites',
      );
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      togglingIds.remove(productId);
    }
  }

  // =================================================================
  // ✅ FLASH DEALS — fetch
  // =================================================================
  Future<void> fetchFlashDeals({bool forceRefresh = false}) async {
    // Skip if already loaded (unless explicitly forced)
    if (!forceRefresh && flashDeals.isNotEmpty) return;

    final ok = await _ensureUserLoaded();
    if (!ok) return;

    final token = ++_flashToken;

    try {
      isFlashDealsLoading.value = true;
      flashDealsError.value = '';
      flashDeals.clear();

      final response = await _repository.fetchFeed(
        user: authController.getUserId,
      );

      if (token != _flashToken) return;

      if (response.success) {
        flashDeals.assignAll(response.data);
      } else {
        flashDealsError.value = 'Failed to load flash deals';
      }
    } catch (e) {
      if (token != _flashToken) return;
      flashDealsError.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      if (token == _flashToken) {
        isFlashDealsLoading.value = false;
      }
    }
  }

  // -----------------------------------------------------------------
  // Reset
  // -----------------------------------------------------------------
  void reset() {
    _requestToken++;
    isLoading.value = false;
    hasFetchedOnce.value = false;
    products.clear();
    errorMessage.value = '';
    togglingIds.clear();

    // ✅ Also reset flash deals
    _flashToken++;
    isFlashDealsLoading.value = false;
    flashDeals.clear();
    flashDealsError.value = '';
  }
}