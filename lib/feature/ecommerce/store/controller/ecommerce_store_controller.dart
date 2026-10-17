import 'dart:io';
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../../../auth/controller/auth_controller.dart';
import '../model/ecommerce_store_model.dart';
import '../repository/ecommerce_store_repository.dart';

class EcommerceStoreController extends GetxController {
  final EcommerceStoreRepository _repository = EcommerceStoreRepository();
  final AuthController authController = Get.find<AuthController>();

  // State
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final Rx<EcommerceStoreModel?> store = Rx<EcommerceStoreModel?>(null);

  bool get hasStore => store.value != null;

  @override
  void onInit() {
    super.onInit();

    // ✅ Jab tak user ka ID 0 hai (login nahi hai), wait karo.
    // Jaise hi userId 0 se >0 hoga, ye automatically run hoga aur API call karega.
    ever(authController.isLoggedIn, (bool loggedIn) {
      if (loggedIn && authController.getUserId != 0) {
        checkStore();
      } else if (!loggedIn) {
        store.value = null; // Logout hone par data clear
      }
    });

    // Agar user pehle se login hai (saved in shared prefs), toh turant fetch karo
    if (authController.isLoggedIn.value && authController.getUserId != 0) {
      checkStore();
    }
  }

  Future<void> checkStore() async {
    final userId = authController.getUserId;
    if (userId == 0) return;

    try {
      isLoading.value = true;
      final response = await _repository.getStoreByUser(userId);
      if (response.success && response.hasStore) {
        store.value = response.data;
      } else {
        store.value = null;
      }
    } catch (e) {
      store.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createStore({
    required String name,
    required String address,
    required String phone,
    required int categoryId,
    File? logo,
  }) async {
    try {
      isSaving.value = true;
      final ok = await _repository.createStore(
        user: authController.getUserId,
        storeName: name,
        storeAddress: address,
        storePhone: phone,
        storeCategory: categoryId,
        storeLogo: logo,
      );

      if (ok) {
        await checkStore(); // Refetch to get the new store
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

  Future<bool> updateStore({
    required String name,
    required String address,
    required String phone,
    required int categoryId,
    File? logo,
  }) async {
    if (store.value == null) return false;
    try {
      isSaving.value = true;
      final ok = await _repository.updateStore(
        storeId: store.value!.id,
        storeName: name,
        storeAddress: address,
        storePhone: phone,
        storeCategory: categoryId,
        storeLogo: logo,
      );

      if (ok) {
        await checkStore();
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

  Future<bool> deleteStore() async {
    if (store.value == null) return false;
    try {
      isSaving.value = true;
      final ok = await _repository.deleteStore(store.value!.id);
      if (ok) {
        store.value = null;
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
}