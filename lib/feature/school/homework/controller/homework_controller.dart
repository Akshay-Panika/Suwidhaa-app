import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/homework_model.dart';
import '../repository/homework_repository.dart';

class HomeworkController extends GetxController {
  final HomeworkRepository _repository = HomeworkRepository();

  // Observables
  final homeworkList = <HomeworkModel>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final errorMessage = ''.obs;
  final selectedHomework = Rxn<HomeworkModel>();
  final searchQuery = ''.obs;
  final selectedFilter = 'All'.obs;
  final filters = <String>['All', 'Pending', 'Today', 'Overdue'].obs;

  // Class options
  final classOptions = <String>[
    'Nursery', 'LKG', 'UKG',
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'
  ];
  final selectedClass = ''.obs;

  // School type options
  final schoolTypeOptions = <String>['school A', 'school B'];
  final selectedSchoolType = ''.obs;

  // Subject colors mapping
  final Map<String, Color> subjectColors = {
    'Mathematics': Colors.blue,
    'Science': Colors.green,
    'English': Colors.purple,
    'History': Colors.orange,
    'Geography': Colors.teal,
    'Art': Colors.pink,
    'Music': Colors.indigo,
    'Physical Education': Colors.red,
    'Computer Science': Colors.cyan,
    'Biology': Colors.lightGreen,
    'Chemistry': Colors.deepOrange,
    'Physics': Colors.deepPurple,
    'Social Studies': Colors.brown,
    'Math': Colors.blue,
    'Urdu': Colors.teal,
    'Islamiat': Colors.green,
    'Pakistan Studies': Colors.orange,
  };

  final Map<String, IconData> subjectIcons = {
    'Mathematics': Icons.calculate_rounded,
    'Science': Icons.science_rounded,
    'English': Icons.menu_book_rounded,
    'History': Icons.history_edu_rounded,
    'Geography': Icons.public_rounded,
    'Art': Icons.palette_rounded,
    'Music': Icons.music_note_rounded,
    'Physical Education': Icons.sports_rounded,
    'Computer Science': Icons.computer_rounded,
    'Biology': Icons.biotech_rounded,
    'Chemistry': Icons.science_rounded,
    'Physics': Icons.bolt_rounded,
    'Social Studies': Icons.groups_rounded,
    'Math': Icons.calculate_rounded,
    'Urdu': Icons.translate_rounded,
    'Islamiat': Icons.mosque_rounded,
    'Pakistan Studies': Icons.flag_rounded,
  };

  @override
  void onInit() {
    super.onInit();
    fetchHomeworkList();
  }

  // Fetch all homework
  Future<void> fetchHomeworkList() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.getHomeworkList();

      if (response.success && response.data != null) {
        homeworkList.assignAll(response.data!);
      } else {
        errorMessage.value = response.message ?? 'Failed to load homework';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Get single homework
  Future<void> fetchHomeworkById(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.getHomeworkById(id);

      if (response.success && response.homework != null) {
        selectedHomework.value = response.homework;
      } else {
        errorMessage.value = response.message ?? 'Failed to load homework';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Create homework
  Future<bool> createHomework(Map<String, dynamic> data) async {
    try {
      isSubmitting.value = true;
      errorMessage.value = '';

      final response = await _repository.createHomework(
        subjectName: data['subject_name'] ?? '',
        subjectTopic: data['subject_topic'] ?? '',
        issueDate: data['issue_date'] ?? '',
        endDate: data['end_date'] ?? '',
        schoolType: data['school_type'] ?? '',
        className: data['class_name'] ?? '',
        teacherName: data['teacher_name'] ?? '',
        teacherId: data['teacher_id'] ?? '',
        imageFile: data['image'],
      );

      if (response.success && response.homework != null) {
        homeworkList.insert(0, response.homework!);
        return true;
      } else {
        errorMessage.value = response.message ?? 'Failed to create homework';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  // Update homework
  Future<bool> updateHomework(int? id, Map<String, dynamic> data) async {
    if (id == null) return false;

    try {
      isSubmitting.value = true;
      errorMessage.value = '';

      final response = await _repository.updateHomework(
        id: id,
        subjectName: data['subject_name'],
        subjectTopic: data['subject_topic'],
        issueDate: data['issue_date'],
        endDate: data['end_date'],
        schoolType: data['school_type'],
        className: data['class_name'],
        teacherName: data['teacher_name'],
        teacherId: data['teacher_id'],
        imageFile: data['image'],
      );

      if (response.success && response.homework != null) {
        final index = homeworkList.indexWhere((h) => h.id == id);
        if (index != -1) {
          homeworkList[index] = response.homework!;
        }
        if (selectedHomework.value?.id == id) {
          selectedHomework.value = response.homework!;
        }
        return true;
      } else {
        errorMessage.value = response.message ?? 'Failed to update homework';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  // Delete homework
  Future<bool> deleteHomework(int? id) async {
    if (id == null) return false;

    try {
      isSubmitting.value = true;
      errorMessage.value = '';

      final success = await _repository.deleteHomework(id);

      if (success) {
        homeworkList.removeWhere((h) => h.id == id);
        if (selectedHomework.value?.id == id) {
          selectedHomework.value = null;
        }
        return true;
      } else {
        errorMessage.value = 'Failed to delete homework';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  // Filter methods
  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  List<HomeworkModel> getFilteredHomework() {
    final query = searchQuery.value.toLowerCase().trim();
    final filter = selectedFilter.value;

    return homeworkList.where((hw) {
      // Search filter
      if (query.isNotEmpty) {
        final subjectName = hw.subjectName?.toLowerCase() ?? '';
        final subjectTopic = hw.subjectTopic?.toLowerCase() ?? '';
        if (!subjectName.contains(query) && !subjectTopic.contains(query)) {
          return false;
        }
      }

      // Status filter
      if (filter != 'All') {
        final status = hw.getStatus();
        if (status != filter) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // Count methods
  Map<String, int> getStatusCounts() {
    final counts = <String, int>{};
    for (final hw in homeworkList) {
      final status = hw.getStatus();
      counts[status] = (counts[status] ?? 0) + 1;
    }
    return counts;
  }

  int getCompletedCount() {
    return homeworkList.where((hw) => hw.getStatus() == 'Completed').length;
  }

  // Color methods
  Color getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Overdue':
        return Colors.red;
      case 'Today':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'Critical':
        return Colors.red;
      case 'High':
        return Colors.orange;
      case 'Medium':
        return Colors.blue;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color getSubjectColor(String? subjectName) {
    if (subjectName == null) return Colors.grey;
    return subjectColors[subjectName] ?? Colors.blue;
  }

  IconData getSubjectIcon(String? subjectName) {
    if (subjectName == null) return Icons.book_rounded;
    return subjectIcons[subjectName] ?? Icons.book_rounded;
  }

  // Search
  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Refresh
  Future<void> refreshHomework() async {
    await fetchHomeworkList();
  }

  void clearSelectedHomework() {
    selectedHomework.value = null;
  }

  // Set class and school type
  void setSelectedClass(String value) {
    selectedClass.value = value;
  }

  void setSelectedSchoolType(String value) {
    selectedSchoolType.value = value;
  }
}