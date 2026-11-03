// lib/feature/school/student_list/controller/student_list_controller.dart
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/student_list_model.dart';
import '../repository/student_list_repository.dart';

class StudentListController extends GetxController {
  final StudentListRepository _repository = StudentListRepository();

  // Observable variables
  final isLoading = false.obs;
  final studentList = <StudentListData>[].obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadStudentList();
  }

  Future<void> loadStudentList() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.getStudentList();

      if (response.success) {
        studentList.value = response.data;
      } else {
        errorMessage.value = 'Failed to load student list';
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      FlutterToast.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Get unique classes from student list
  List<String> getUniqueClasses() {
    final classes = <String>{};
    for (var student in studentList) {
      if (student.studentClass.isNotEmpty) {
        classes.add(student.studentClass);
      }
    }
    return classes.toList()..sort();
  }

  // Get students by class
  List<StudentListData> getStudentsByClass(String className) {
    return studentList
        .where((student) => student.studentClass == className)
        .toList();
  }

  // Get student count
  int get totalStudents => studentList.length;

  // Refresh student list
  Future<void> refreshStudents() async {
    await loadStudentList();
  }

  @override
  void onClose() {
    super.onClose();
  }
}