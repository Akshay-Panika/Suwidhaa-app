import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import '../model/notice_model.dart';
import '../repository/notice_repository.dart';

class NoticeController extends GetxController {
  final NoticeRepository _repo = NoticeRepository();

  // ==================== STATE ====================
  final RxList<NoticeModel> notices = <NoticeModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString error = ''.obs;

  // Filter state (optional)
  final RxString filterPriority = ''.obs;
  final RxString filterAudience = ''.obs;
  final RxString filterClass = ''.obs;

  // ==================== SORTED LIST (pinned first) ====================
  List<NoticeModel> get sortedNotices {
    final list = [...notices];
    list.sort((a, b) {
      final pa = a.isPinned ? 0 : 1;
      final pb = b.isPinned ? 0 : 1;
      if (pa != pb) return pa.compareTo(pb);
      return b.id.compareTo(a.id); // latest first
    });
    return list;
  }

  // ==================== FETCH ====================
  Future<void> fetchNotices({bool silent = false}) async {
    if (!silent) {
      isLoading.value = true;
      error.value = '';
    }
    try {
      final result = await _repo.getNotices(
        priority: filterPriority.value,
        audience: filterAudience.value,
        assignedClass: filterClass.value,
      );
      notices.assignAll(result);
    } catch (e) {
      error.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== CREATE ====================
  Future<bool> createNotice({
    required String title,
    required String description,
    required String priority,
    required String audience,
    required String assignedClass,
    required bool isPinned,
    String createdBy = 'teacher_101',
    PlatformFile? attachment,
  }) async {
    isSubmitting.value = true;
    try {
      final created = await _repo.createNotice(
        title: title,
        description: description,
        priority: priority,
        audience: audience,
        assignedClass: assignedClass,
        isPinned: isPinned,
        createdBy: createdBy,
        attachment: attachment,
      );
      notices.insert(0, created);
      return true;
    } catch (e) {
      error.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  // ==================== UPDATE ====================
  Future<bool> updateNotice({
    required int id,
    required String title,
    required String description,
    required String priority,
    required String audience,
    required String assignedClass,
    required bool isPinned,
    String createdBy = 'teacher_101',
    PlatformFile? attachment,
    bool removeAttachment = false,
  }) async {
    isSubmitting.value = true;
    try {
      final updated = await _repo.updateNotice(
        id: id,
        title: title,
        description: description,
        priority: priority,
        audience: audience,
        assignedClass: assignedClass,
        isPinned: isPinned,
        createdBy: createdBy,
        attachment: attachment,
        removeAttachment: removeAttachment,
      );
      final i = notices.indexWhere((n) => n.id == id);
      if (i != -1) notices[i] = updated;
      return true;
    } catch (e) {
      error.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  // ==================== DELETE ====================
  Future<bool> deleteNotice(int id) async {
    try {
      await _repo.deleteNotice(id);
      notices.removeWhere((n) => n.id == id);
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
      final i = notices.indexWhere((n) => n.id == id);
      if (i != -1) notices[i] = updated;
      return true;
    } catch (e) {
      error.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    }
  }

  // ==================== FILTER SETTERS ====================
  void setFilterPriority(String v) {
    filterPriority.value = v;
    fetchNotices();
  }

  void setFilterAudience(String v) {
    filterAudience.value = v;
    fetchNotices();
  }

  void setFilterClass(String v) {
    filterClass.value = v;
    fetchNotices();
  }

  void clearFilters() {
    filterPriority.value = '';
    filterAudience.value = '';
    filterClass.value = '';
    fetchNotices();
  }
}