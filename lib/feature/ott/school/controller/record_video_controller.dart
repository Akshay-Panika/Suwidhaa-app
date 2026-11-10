import 'package:get/get.dart';
import '../model/record_class_model.dart';
import '../model/record_subject_model.dart';
import '../model/record_video_model.dart';
import '../repository/record_video_repository.dart';

class RecordVideoController extends GetxController {
  final RecordVideoRepository _repository = RecordVideoRepository();

  // Loading States
  var isLoadingClasses = true.obs;
  var isLoadingSubjects = false.obs;
  var isLoadingVideos = false.obs;

  // Data Lists
  var classes = <RecordClassModel>[].obs;
  var subjects = <RecordSubjectModel>[].obs;
  var videos = <RecordVideoModel>[].obs;

  // Selection States
  var selectedClass = Rxn<RecordClassModel>();
  var selectedSubjectId = RxnInt(); // null = 'All' videos

  @override
  void onInit() {
    super.onInit();
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    try {
      isLoadingClasses.value = true;
      final result = await _repository.getClasses();
      classes.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load classes. Check your connection.');
    } finally {
      isLoadingClasses.value = false;
    }
  }

  Future<void> selectClass(RecordClassModel classItem) async {
    selectedClass.value = classItem;
    selectedSubjectId.value = null; // Reset subject to 'All'
    videos.clear();
    subjects.clear();

    // Fetch subjects and all videos for this class
    fetchSubjects(classItem.id);
    fetchVideos(classItem.id);
  }

  void clearSelection() {
    selectedClass.value = null;
    selectedSubjectId.value = null;
    subjects.clear();
    videos.clear();
  }

  Future<void> fetchSubjects(int classId) async {
    try {
      isLoadingSubjects.value = true;
      final result = await _repository.getSubjects(classId);
      subjects.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load subjects.');
    } finally {
      isLoadingSubjects.value = false;
    }
  }

  Future<void> selectSubject(int? subjectId) async {
    if (selectedClass.value == null) return;

    selectedSubjectId.value = subjectId;
    fetchVideos(selectedClass.value!.id, subjectId: subjectId);
  }

  Future<void> fetchVideos(int classId, {int? subjectId}) async {
    try {
      isLoadingVideos.value = true;
      final result = await _repository.getVideos(classId, subjectId: subjectId);
      videos.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load videos.');
    } finally {
      isLoadingVideos.value = false;
    }
  }
}