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
      errorMessage.value = e.toString();
      FlutterToast.error('Failed to load students: $e');
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
    return studentList.where((student) => student.studentClass == className).toList();
  }

  // Get student count
  int get totalStudents => studentList.length;

  // Get paid students count
  int get paidStudents => studentList.where((s) => s.feeStatus.toLowerCase() == 'paid').length;

  // Get pending students count
  int get pendingStudents => totalStudents - paidStudents;

  // Get attendance percentage
  String get attendancePercentage {
    if (totalStudents == 0) return '0%';
    return '${((paidStudents / totalStudents) * 100).toStringAsFixed(0)}%';
  }

  // Refresh student list
  Future<void> refreshStudents() async {
    await loadStudentList();
  }

  @override
  void onClose() {
    super.onClose();
  }
}