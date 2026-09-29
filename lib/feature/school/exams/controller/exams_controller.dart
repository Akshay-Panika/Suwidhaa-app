// lib/feature/school/exams/controller/exams_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widget/flutter_toast.dart';
import '../model/exams_table_model.dart';
import '../repository/exams_repository.dart';

class ExamsController extends GetxController {
  final ExamsRepository _repo = ExamsRepository();

  // ==================== STATE ====================
  final RxList<ClassExamTimetable> timetables = <ClassExamTimetable>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;

  // ==================== LIST ====================
  Future<void> fetchTimetables({
    String? className,
    String? examType,
    bool showLoader = true,
  }) async {
    try {
      if (showLoader) isLoading.value = true;
      errorMessage.value = '';

      final data = await _repo.getTimetables(
        className: className,
        examType: examType,
      );
      timetables.assignAll(data);
    } catch (e) {
      errorMessage.value = e.toString();
      FlutterToast.error('Failed to load timetables');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshTimetables() async {
    await fetchTimetables(showLoader: false);
  }

  // ==================== DETAIL ====================
  Future<ClassExamTimetable?> fetchDetail(dynamic id) async {
    try {
      return await _repo.getTimetableDetail(id);
    } catch (e) {
      FlutterToast.error('Failed to load details');
      return null;
    }
  }

  // ==================== CREATE ====================
  /// Returns the newly created timetable (with backend `id`) or null on failure.
  Future<ClassExamTimetable?> createTimetable({
    required ClassExamTimetable timetable,
    String? createdById,
    String? createdByName,
  }) async {
    try {
      isSubmitting.value = true;
      final created = await _repo.createTimetable(
        timetable: timetable,
        createdById: createdById,
        createdByName: createdByName,
      );

      // insert at top
      timetables.insert(0, created);
      FlutterToast.success('Timetable created successfully');
      return created;
    } catch (e) {
      FlutterToast.error(_cleanError(e));
      return null;
    } finally {
      isSubmitting.value = false;
    }
  }

  // ==================== UPDATE ====================
  Future<ClassExamTimetable?> updateTimetable({
    required dynamic id,
    required ClassExamTimetable timetable,
  }) async {
    try {
      isSubmitting.value = true;
      final updated = await _repo.updateTimetable(id: id, timetable: timetable);

      // replace in list
      final idx = timetables.indexWhere((t) => t.id == id);
      if (idx >= 0) {
        timetables[idx] = updated;
      }
      FlutterToast.success('Timetable updated successfully');
      return updated;
    } catch (e) {
      FlutterToast.error(_cleanError(e));
      return null;
    } finally {
      isSubmitting.value = false;
    }
  }

  // ==================== DELETE ====================
  Future<bool> deleteTimetable(dynamic id) async {
    try {
      await _repo.deleteTimetable(id);
      timetables.removeWhere((t) => t.id == id);
      FlutterToast.success('Timetable deleted successfully');
      return true;
    } catch (e) {
      FlutterToast.error(_cleanError(e));
      return false;
    }
  }

  // ==================== HELPERS ====================
  String _cleanError(dynamic e) {
    final msg = e.toString();
    if (msg.startsWith('Exception: ')) {
      return msg.substring('Exception: '.length);
    }
    return msg;
  }
}