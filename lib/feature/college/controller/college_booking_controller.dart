import 'package:get/get.dart';
import '../../../core/widget/flutter_toast.dart';
import '../../auth/controller/auth_controller.dart';
import '../model/college_booking_model.dart';
import '../repository/college_booking_repository.dart';

class CollegeBookingController extends GetxController {
  final CollegeBookingRepository _repository = CollegeBookingRepository();

  // Existing observables
  final RxBool isLoading = false.obs;
  final Rx<CollegeBookingResponse?> lastBookingResponse =
  Rx<CollegeBookingResponse?>(null);
  final RxBool lastBookingSuccess = false.obs;

  // ✅ NEW: Bookings list observables
  final RxList<CollegeBooking> bookings = <CollegeBooking>[].obs;
  final RxBool isBookingsLoading = false.obs;
  final RxString bookingsError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // ✅ Auto-fetch bookings on init (optional)
    fetchBookings();
  }

  // Existing bookCollege method (no change)
  Future<bool> bookCollege({
    required int collegeId,
    required String message,
  }) async {
    lastBookingSuccess.value = false;
    lastBookingResponse.value = null;

    if (message.trim().isEmpty) {
      FlutterToast.error('Please enter your enquiry message');
      return false;
    }

    final AuthController authController = Get.find<AuthController>();
    final String userId = authController.getUserId.toString();

    if (userId == '0' || userId.isEmpty) {
      FlutterToast.error('User not logged in. Please login first.');
      return false;
    }

    isLoading.value = true;

    try {
      final response = await _repository.createBooking(
        collegeId: collegeId,
        userId: userId,
        message: message.trim(),
      );

      lastBookingResponse.value = response;

      if (response.success && (response.data?.booking ?? false)) {
        lastBookingSuccess.value = true;
        FlutterToast.success(
          response.message.isNotEmpty
              ? response.message
              : 'College booked successfully!',
        );
        // ✅ Refresh bookings list after successful booking
        await fetchBookings();
        return true;
      } else {
        lastBookingSuccess.value = false;
        FlutterToast.error(
          response.message.isNotEmpty
              ? response.message
              : 'Booking failed. Please try again.',
        );
        return false;
      }
    } catch (e) {
      lastBookingSuccess.value = false;
      FlutterToast.error('Something went wrong. Please try again.');
      print('❌ bookCollege error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ NEW: Fetch all bookings for current user
  Future<void> fetchBookings() async {
    try {
      isBookingsLoading.value = true;
      bookingsError.value = '';

      final response = await _repository.getBookings();

      if (response.success) {
        bookings.value = response.data;
      } else {
        bookingsError.value = 'Failed to load bookings';
      }
    } catch (e) {
      bookingsError.value = e.toString();
      print('❌ fetchBookings error: $e');
    } finally {
      isBookingsLoading.value = false;
    }
  }

  /// ✅ NEW: Refresh bookings
  Future<void> refreshBookings() async {
    await fetchBookings();
  }

  void resetState() {
    isLoading.value = false;
    lastBookingSuccess.value = false;
    lastBookingResponse.value = null;
  }
}