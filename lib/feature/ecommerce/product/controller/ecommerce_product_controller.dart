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
  final RxBool hasFetchedOnce = false.obs;
  final RxSet<int> togglingIds = <int>{}.obs;
  bool get isTogglingFavorite => togglingIds.isNotEmpty;
  int _requestToken = 0;

  final AuthController authController = Get.find<AuthController>();

  // ---- Flash Deals ----
  final RxBool isFlashDealsLoading = false.obs;
  final RxString flashDealsError = ''.obs;
  final RxList<EcommerceProductModel> flashDeals = <EcommerceProductModel>[].obs;
  static const int maxFlashDealsOnHome = 6;
  List<EcommerceProductModel> get visibleFlashDeals => flashDeals.take(maxFlashDealsOnHome).toList();
  int _flashToken = 0;

  // ---- Owner Products ----
  final RxBool isOwnerLoading = false.obs;
  final RxList<EcommerceProductModel> ownerProducts = <EcommerceProductModel>[].obs;
  int _ownerToken = 0;

  // ✅ Save/Delete Loading State
  final RxBool isSaving = false.obs;

  // ✅ FETCH OWNER PRODUCTS
  Future<void> fetchOwnerProducts() async {
    final userId = authController.getUserId;
    if (userId == 0) return;

    final token = ++_ownerToken;
    try {
      isOwnerLoading.value = true;
      final response = await _repository.fetchOwnerProducts(userId: userId);
      if (token != _ownerToken) return;

      if (response.success) {
        ownerProducts.assignAll(response.data);
      } else {
        FlutterToast.error('Failed to load store products');
      }
    } catch (e) {
      if (token != _ownerToken) return;
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (token == _ownerToken) {
        isOwnerLoading.value = false;
      }
    }
  }

  // ✅ CREATE OR UPDATE PRODUCT
  Future<bool> saveProduct({
    int? productId, // Agar null hai, to Create hoga. Warna Update.
    required int subcategoryId,
    required String title,
    required String description,
    required String price,
    required String oldPrice,
    required int stock,
    required String badge,
    required bool isActive,
    required List<File> images,
  }) async {
    if (authController.getUserId == 0) return false;

    try {
      isSaving.value = true;
      bool ok = false;

      if (productId == null) {
        // CREATE
        ok = await _repository.createProduct(
          subcategory: subcategoryId,
          user: authController.getUserId,
          title: title,
          description: description,
          price: price,
          oldPrice: oldPrice,
          stock: stock,
          badge: badge,
          isActive: isActive,
          images: images,
        );
      } else {
        // UPDATE
        ok = await _repository.updateProduct(
          id: productId,
          subcategory: subcategoryId,
          user: authController.getUserId,
          title: title,
          description: description,
          price: price,
          oldPrice: oldPrice,
          stock: stock,
          badge: badge,
          isActive: isActive,
          images: images,
        );
      }

      if (ok) {
        await fetchOwnerProducts(); // Refresh list
        return true;
      }
      return false;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // ✅ DELETE PRODUCT
  Future<bool> deleteProduct(int productId) async {
    try {
      isSaving.value = true;
      final ok = await _repository.deleteProduct(productId);
      if (ok) {
        await fetchOwnerProducts();
        return true;
      }
      return false;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      isSaving.value = false;
    }
  }

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
        subcategoryId: selectedSubcategoryId.value == 0 ? null : selectedSubcategoryId.value,
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

      final response = await _repository.fetchFavorites(user: authController.getUserId);

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
  // Toggle Favorite
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

      // Main list update
      final idx = products.indexWhere((p) => p.id == productId);
      if (idx != -1) {
        if (isViewingFavorites.value && !newStatus) {
          products.removeAt(idx);
        } else {
          products[idx] = products[idx].copyWith(isFavorite: newStatus);
        }
      }

      // Flash deals update
      final fIdx = flashDeals.indexWhere((p) => p.id == productId);
      if (fIdx != -1) {
        flashDeals[fIdx] = flashDeals[fIdx].copyWith(isFavorite: newStatus);
      }

      // Owner list update
      final oIdx = ownerProducts.indexWhere((p) => p.id == productId);
      if (oIdx != -1) {
        ownerProducts[oIdx] = ownerProducts[oIdx].copyWith(isFavorite: newStatus);
      }

      FlutterToast.success(newStatus ? 'Added to favorites' : 'Removed from favorites');
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      togglingIds.remove(productId);
    }
  }

  // -----------------------------------------------------------------
  // Flash Deals
  // -----------------------------------------------------------------
  Future<void> fetchFlashDeals({bool forceRefresh = false}) async {
    if (!forceRefresh && flashDeals.isNotEmpty) return;
    final ok = await _ensureUserLoaded();
    if (!ok) return;

    final token = ++_flashToken;

    try {
      isFlashDealsLoading.value = true;
      flashDealsError.value = '';
      flashDeals.clear();

      final response = await _repository.fetchFeed(user: authController.getUserId);

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

    _flashToken++;
    isFlashDealsLoading.value = false;
    flashDeals.clear();
    flashDealsError.value = '';

    _ownerToken++;
    isOwnerLoading.value = false;
    ownerProducts.clear();
    isSaving.value = false;
  }
}