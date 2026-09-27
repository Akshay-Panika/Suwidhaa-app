import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import '../model/school_event_model.dart';
import '../repository/school_event_repository.dart';

class SchoolEventController extends GetxController {
  final SchoolEventRepository _repo = SchoolEventRepository();

  // ==================== STATE ====================
  final RxList<SchoolEventModel> events = <SchoolEventModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString error = ''.obs;

  // ==================== SORTED (pinned first) ====================
  List<SchoolEventModel> get sortedEvents {
    final list = [...events];
    list.sort((a, b) {
      final pa = a.isPinned ? 0 : 1;
      final pb = b.isPinned ? 0 : 1;
      if (pa != pb) return pa.compareTo(pb);
      return b.id.compareTo(a.id);
    });
    return list;
  }

  // ==================== FETCH ====================
  Future<void> fetchEvents({bool silent = false}) async {
    if (!silent) {
      isLoading.value = true;
      error.value = '';
    }
    try {
      final result = await _repo.getEvents();
      events.assignAll(result);
    } catch (e) {
      error.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== CREATE ====================
  Future<bool> createEvent({
    required String title,
    required String description,
    required String category,
    required String venue,
    required String startDate,
    required String endDate,
    required String startTime,
    required String endTime,
    required String audience,
    required String status,
    required bool isPinned,
    String organizer = 'teacher_101',
    PlatformFile? banner,
  }) async {
    isSubmitting.value = true;
    try {
      final created = await _repo.createEvent(
        title: title,
        description: description,
        category: category,
        venue: venue,
        startDate: startDate,
        endDate: endDate,
        startTime: startTime,
        endTime: endTime,
        audience: audience,
        status: status,
        isPinned: isPinned,
        organizer: organizer,
        banner: banner,
      );
      events.insert(0, created);
      return true;
    } catch (e) {
      error.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  // ==================== UPDATE ====================
  Future<bool> updateEvent({
    required int id,
    required String title,
    required String description,
    required String category,
    required String venue,
    required String startDate,
    required String endDate,
    required String startTime,
    required String endTime,
    required String audience,
    required String status,
    required bool isPinned,
    String organizer = 'teacher_101',
    PlatformFile? banner,
    bool removeBanner = false,
  }) async {
    isSubmitting.value = true;
    try {
      final updated = await _repo.updateEvent(
        id: id,
        title: title,
        description: description,
        category: category,
        venue: venue,
        startDate: startDate,
        endDate: endDate,
        startTime: startTime,
        endTime: endTime,
        audience: audience,
        status: status,
        isPinned: isPinned,
        organizer: organizer,
        banner: banner,
        removeBanner: removeBanner,
      );
      final i = events.indexWhere((e) => e.id == id);
      if (i != -1) events[i] = updated;
      return true;
    } catch (e) {
      error.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  // ==================== DELETE ====================
  Future<bool> deleteEvent(int id) async {
    try {
      await _repo.deleteEvent(id);
      events.removeWhere((e) => e.id == id);
      return true;
    } catch (e) {
      error.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    }
  }

  // ==================== TOGGLE PIN ====================
  Future<bool> togglePin(int id) async {
    try {
      final updated = await _repo.togglePin(id);
      final i = events.indexWhere((e) => e.id == id);
      if (i != -1) events[i] = updated;
      return true;
    } catch (e) {
      error.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    }
  }
}