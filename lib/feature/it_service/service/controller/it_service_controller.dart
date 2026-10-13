import 'package:get/get.dart';
import '../../../auth/controller/auth_controller.dart';
import '../model/it_service_model.dart';
import '../repository/it_service_repository.dart';

class ItServiceController extends GetxController {
  final ItServiceRepository _repository = ItServiceRepository();

  // Observables
  final RxList<ItServiceData> services = <ItServiceData>[].obs;
  final RxList<ItServiceData> bookedServices = <ItServiceData>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isBookedLoading = false.obs;
  final RxString errorMessage = ''.obs;

  int? get _userId {
    try {
      final auth = Get.find<AuthController>();
      final id = auth.currentUser.value?.id;
      return (id == null || id == 0) ? null : id;
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();

    try {
      final auth = Get.find<AuthController>();
      ever(auth.currentUser, (_) => _tryFetch());
    } catch (_) {}

    Future.microtask(_tryFetch);
  }

  void _tryFetch() {
    final id = _userId;
    if (id == null) return;
    if (services.isEmpty) fetchServices();
    if (bookedServices.isEmpty) fetchBookedServices();
  }

  Future<void> fetchServices({int? categoryId}) async {
    final id = _userId;
    if (id == null) {
      errorMessage.value = 'User not logged in';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getServices(
        userId: id,
        categoryId: categoryId,
      );
      services.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  /// 🆕 Create a booking + flip flag locally
  Future<bool> createBooking(int serviceId) async {
    final id = _userId;
    if (id == null) {
      errorMessage.value = 'User not logged in';
      return false;
    }

    // Resolve full name from AuthController
    String fullName = 'User';
    try {
      final auth = Get.find<AuthController>();
      fullName = auth.currentUser.value?.name ?? 'User';
    } catch (_) {}

    try {
      final ok = await _repository.createBooking(
        userId: id,
        serviceId: serviceId,
        fullName: fullName,
      );

      if (ok) {
        // 1. Update the main list
        markServiceAsBooked(serviceId);

        // 2. Refresh booked list (so it appears in "My Bookings")
        await fetchBookedServices();
      }
      return ok;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    }
  }

  /// 🆕 Unbook — removes the booking from backend + local lists
  Future<bool> unbookService(int serviceId) async {
    // Find the booking entry in the local bookedServices list
    final index = bookedServices.indexWhere((s) => s.id == serviceId);
    if (index == -1) {
      errorMessage.value = 'Booking not found';
      return false;
    }

    final bookingId = bookedServices[index].booking?.id;
    if (bookingId == null) {
      errorMessage.value = 'Booking ID not found';
      return false;
    }

    try {
      final ok = await _repository.unbook(bookingId: bookingId);

      if (ok) {
        // 1. Remove from bookedServices list
        bookedServices.removeAt(index);

        // 2. Flip `isBooked` back to false in the main services list
        final sIndex = services.indexWhere((s) => s.id == serviceId);
        if (sIndex != -1) {
          services[sIndex] = services[sIndex].copyWith(isBooked: false);
        }
      }
      return ok;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    }
  }

  /// 🆕 Fetch services booked by the current user
  Future<void> fetchBookedServices({String? status}) async {
    final id = _userId;
    if (id == null) {
      errorMessage.value = 'User not logged in';
      return;
    }

    try {
      isBookedLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getBookedServices(
        userId: id,
        status: status,
      );
      bookedServices.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isBookedLoading.value = false;
    }
  }

  Future<ItServiceData?> getServiceById(int id) async {
    final uid = _userId;
    if (uid == null) return null;

    try {
      return await _repository.getServiceById(id, uid);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return null;
    }
  }

  List<ItServiceData> filteredByCategory(String categoryName) {
    if (categoryName == 'All') return services;
    return services
        .where((s) =>
    (s.category?.name ?? '').toLowerCase() ==
        categoryName.toLowerCase())
        .toList();
  }

  void markServiceAsBooked(int serviceId) {
    final index = services.indexWhere((s) => s.id == serviceId);
    if (index != -1) {
      services[index] = services[index].copyWith(isBooked: true);
    }
  }
}