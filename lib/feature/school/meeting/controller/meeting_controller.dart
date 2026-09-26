import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/meeting_model.dart';
import '../repository/meeting_repository.dart';

class MeetingController extends GetxController {
  final MeetingRepository _repo = MeetingRepository();

  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isDeleting = false.obs;
  final RxList<MeetingModel> meetings = <MeetingModel>[].obs;
  final Rx<MeetingModel?> selectedMeeting = Rx<MeetingModel?>(null);

  // ---------------- LIST ----------------
  Future<void> fetchMeetings({bool showLoader = true}) async {
    try {
      if (showLoader) isLoading.value = true;
      final list = await _repo.getMeetings();
      meetings.assignAll(list);
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- CREATE ----------------
  Future<bool> createMeeting({
    required String title,
    required String date,
    required String time,
    required String forMeeting,
    String? className,
    String? zoomUrl,
  }) async {
    try {
      isCreating.value = true;
      final created = await _repo.createMeeting({
        'title': title,
        'date': date,
        'time': time,
        'for_meeting': forMeeting,
        'class_name': className,
        'zoom_url': zoomUrl,
      });
      meetings.insert(0, created);
      FlutterToast.success('Meeting created successfully');
      return true;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      isCreating.value = false;
    }
  }

  // ---------------- DETAIL ----------------
  Future<MeetingModel?> fetchMeetingById(int id) async {
    try {
      isLoading.value = true;
      final m = await _repo.getMeetingById(id);
      selectedMeeting.value = m;
      return m;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- UPDATE ----------------
  Future<bool> updateMeeting(
      int id, {
        required String title,
        required String date,
        required String time,
        required String forMeeting,
        String? className,
        String? zoomUrl,
      }) async {
    try {
      isCreating.value = true;
      final updated = await _repo.updateMeeting(id, {
        'title': title,
        'date': date,
        'time': time,
        'for_meeting': forMeeting,
        'class_name': className,
        'zoom_url': zoomUrl,
      });

      final idx = meetings.indexWhere((m) => m.id == id);
      if (idx != -1) meetings[idx] = updated;
      selectedMeeting.value = updated;

      FlutterToast.success('Meeting updated successfully');
      return true;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      isCreating.value = false;
    }
  }

  // ---------------- DELETE ----------------
  Future<bool> deleteMeeting(int id) async {
    try {
      isDeleting.value = true;
      final ok = await _repo.deleteMeeting(id);
      if (ok) {
        meetings.removeWhere((m) => m.id == id);
        FlutterToast.success('Meeting deleted successfully');
      }
      return ok;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      isDeleting.value = false;
    }
  }
}