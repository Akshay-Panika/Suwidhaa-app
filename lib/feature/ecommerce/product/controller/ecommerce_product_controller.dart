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
  List<EcommerceProductModel> get visibleFlashDeals =>
      flashDeals.take(maxFlashDealsOnHome).toList();
  int _flashToken = 0;

  // ---- Owner Products ----
  final RxBool isOwnerLoading = false.obs;
  final RxList<EcommerceProductModel> ownerProducts = <EcommerceProductModel>[].obs;
  int _ownerToken = 0;

  // ---- Save/Delete Loading State ----
  final RxBool isSaving = false.obs;

  // ---- Product Detail State ----
  final RxBool isProductDetailLoading = false.obs;
  final RxString productDetailError = ''.obs;
  final Rxn<EcommerceProductModel> selectedProduct = Rxn<EcommerceProductModel>();
  int _detailToken = 0;

  // 🆕 ---- Cart State ----
  final RxBool isCartLoading = false.obs;
  final RxString cartError = ''.obs;
  final RxList<EcommerceCartItemModel> cartItems = <EcommerceCartItemModel>[].obs;
  final RxString cartGrandTotal = '0'.obs;
  final RxSet<int> addingToCartIds = <int>{}.obs;
  int _cartToken = 0;

  int get cartCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

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

  // ✅ CREATE OR UPDATE
  Future<bool> saveProduct({
    int? productId,
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

  // ✅ DELETE
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

  // ---- Helpers ----
  Future<bool> _ensureUserLoaded() async {
    if (authController.getUserId != 0) return true;
    for (int i = 0; i < 3; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (authController.getUserId != 0) return true;
    }
    return false;
  }

  // ---- Feed ----
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
        subcategoryId:
        selectedSubcategoryId.value == 0 ? null : selectedSubcategoryId.value,
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

  // ---- Favorites ----
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

  // ---- Toggle Favorite ----
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

      final idx = products.indexWhere((p) => p.id == productId);
      if (idx != -1) {
        if (isViewingFavorites.value && !newStatus) {
          products.removeAt(idx);
        } else {
          products[idx] = products[idx].copyWith(isFavorite: newStatus);
        }
      }

      final fIdx = flashDeals.indexWhere((p) => p.id == productId);
      if (fIdx != -1) {
        flashDeals[fIdx] = flashDeals[fIdx].copyWith(isFavorite: newStatus);
      }

      final oIdx = ownerProducts.indexWhere((p) => p.id == productId);
      if (oIdx != -1) {
        ownerProducts[oIdx] =
            ownerProducts[oIdx].copyWith(isFavorite: newStatus);
      }

      if (selectedProduct.value?.id == productId) {
        selectedProduct.value =
            selectedProduct.value!.copyWith(isFavorite: newStatus);
      }

      FlutterToast.success(
          newStatus ? 'Added to favorites' : 'Removed from favorites');
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      togglingIds.remove(productId);
    }
  }

  // ---- Flash Deals ----
  Future<void> fetchFlashDeals({bool forceRefresh = false}) async {
    if (!forceRefresh && flashDeals.isNotEmpty) return;
    final ok = await _ensureUserLoaded();
    if (!ok) return;

    final token = ++_flashToken;

    try {
      isFlashDealsLoading.value = true;
      flashDealsError.value = '';
      flashDeals.clear();

      final response =
      await _repository.fetchFeed(user: authController.getUserId);

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

  // ---- Product Detail ----
  Future<EcommerceProductModel?> fetchProductDetail(int id) async {
    final token = ++_detailToken;

    try {
      isProductDetailLoading.value = true;
      productDetailError.value = '';
      selectedProduct.value = null;

      final product = await _repository.fetchProductDetail(id: id);

      if (token != _detailToken) return null;

      selectedProduct.value = product;
      return product;
    } catch (e) {
      if (token != _detailToken) return null;
      productDetailError.value = e.toString().replaceFirst('Exception: ', '');
      FlutterToast.error(productDetailError.value);
      return null;
    } finally {
      if (token == _detailToken) {
        isProductDetailLoading.value = false;
      }
    }
  }

  Future<void> toggleFavoriteFromDetail(int productId) async {
    await toggleFavorite(productId);
  }

  // ============================================================
  // 🆕 CART METHODS
  // ============================================================
  Future<bool> addToCart(int productId, {int quantity = 1}) async {
    if (authController.getUserId == 0) {
      FlutterToast.error('User not logged in');
      return false;
    }
    if (addingToCartIds.contains(productId)) return false;

    try {
      addingToCartIds.add(productId);

      await _repository.addToCart(
        productId: productId,
        userId: authController.getUserId,
        quantity: quantity,
      );

      _setIsCartLocal(productId, true);
      FlutterToast.success('Added to cart');
      return true;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      addingToCartIds.remove(productId);
    }
  }

  Future<void> fetchCart() async {
    if (authController.getUserId == 0) return;

    final token = ++_cartToken;

    try {
      isCartLoading.value = true;
      cartError.value = '';

      final response =
      await _repository.fetchCart(userId: authController.getUserId);

      if (token != _cartToken) return;

      if (response.success) {
        cartItems.assignAll(response.data);
        cartGrandTotal.value = response.grandTotal;
      } else {
        cartError.value = 'Failed to load cart';
      }
    } catch (e) {
      if (token != _cartToken) return;
      cartError.value = e.toString().replaceFirst('Exception: ', '');
      FlutterToast.error(cartError.value);
    } finally {
      if (token == _cartToken) {
        isCartLoading.value = false;
      }
    }
  }

  Future<bool> removeFromCart(int productId, {int? quantity}) async {
    if (authController.getUserId == 0) return false;

    try {
      await _repository.removeFromCart(
        productId: productId,
        userId: authController.getUserId,
        quantity: quantity,
      );

      if (quantity == null) {
        cartItems.removeWhere((item) => item.productId == productId);
        _setIsCartLocal(productId, false);
      } else {
        final idx =
        cartItems.indexWhere((item) => item.productId == productId);
        if (idx != -1) {
          final current = cartItems[idx];
          final newQty = current.quantity - quantity;
          if (newQty <= 0) {
            cartItems.removeAt(idx);
            _setIsCartLocal(productId, false);
          } else {
            cartItems[idx] = current.copyWith(quantity: newQty);
          }
        }
      }

      // Recompute grand total locally
      final total = cartItems.fold<double>(
        0,
            (sum, item) => sum + (double.tryParse(item.price) ?? 0) * item.quantity,
      );
      cartGrandTotal.value = total.toStringAsFixed(2);

      FlutterToast.success(
          quantity == null ? 'Removed from cart' : 'Cart updated');
      return true;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  bool isProductInCart(int productId) =>
      cartItems.any((i) => i.productId == productId);

  void _setIsCartLocal(int productId, bool isCart) {
    final idx = products.indexWhere((p) => p.id == productId);
    if (idx != -1) products[idx] = products[idx].copyWith(isCart: isCart);

    final fIdx = flashDeals.indexWhere((p) => p.id == productId);
    if (fIdx != -1) flashDeals[fIdx] = flashDeals[fIdx].copyWith(isCart: isCart);

    final oIdx = ownerProducts.indexWhere((p) => p.id == productId);
    if (oIdx != -1) {
      ownerProducts[oIdx] = ownerProducts[oIdx].copyWith(isCart: isCart);
    }

    if (selectedProduct.value?.id == productId) {
      selectedProduct.value = selectedProduct.value!.copyWith(isCart: isCart);
    }
  }

  // ---- Reset ----
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

    _detailToken++;
    isProductDetailLoading.value = false;
    productDetailError.value = '';
    selectedProduct.value = null;

    _cartToken++;
    isCartLoading.value = false;
    cartError.value = '';
    cartItems.clear();
    cartGrandTotal.value = '0';
    addingToCartIds.clear();
  }
}