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

  // Filter state
  final RxString filterPriority = ''.obs;
  final RxString filterAudience = ''.obs;
  final RxString filterClass = ''.obs;

  // ✅ NEW: class + date filter (client-side)
  final RxString selectedClass = 'All'.obs;
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();

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

  // ==================== FILTERED LIST (class + date) ====================
  List<NoticeModel> get filteredNotices {
    final cls = selectedClass.value;
    final date = selectedDate.value;

    return sortedNotices.where((n) {
      // ---- Class filter ----
      if (cls != 'All') {
        final nc = n.assignedClass.trim();
        if (nc != cls && nc != 'All Classes') return false;
      }

      // ---- Date filter (match same calendar day) ----
      if (date != null) {
        final parsed = _parseDate(n.createdAt);
        if (parsed == null) return false;
        if (parsed.year != date.year ||
            parsed.month != date.month ||
            parsed.day != date.day) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// All unique classes from loaded notices + 'All Classes' + 'All'
  List<String> getUniqueClasses() {
    final set = <String>{};
    for (final n in notices) {
      final c = n.assignedClass.trim();
      if (c.isNotEmpty && c != 'All Classes') set.add(c);
    }
    final sorted = set.toList()..sort();
    return ['All', 'All Classes', ...sorted];
  }

  bool get hasActiveFilters =>
      selectedClass.value != 'All' || selectedDate.value != null;

  // ==================== FILTER SETTERS ====================
  void setClassFilter(String v) {
    selectedClass.value = v;
  }

  void setDateFilter(DateTime? v) {
    selectedDate.value = v;
  }

  void clearFilters() {
    selectedClass.value = 'All';
    selectedDate.value = null;
  }

  // Existing server-side filters (keep them)
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

  void clearServerFilters() {
    filterPriority.value = '';
    filterAudience.value = '';
    filterClass.value = '';
    fetchNotices();
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

  // ==================== CREATE / UPDATE / DELETE / TOGGLE ====================
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

  // ==================== HELPERS ====================
  DateTime? _parseDate(String raw) {
    if (raw.trim().isEmpty) return null;
    // Try ISO first
    final iso = DateTime.tryParse(raw);
    if (iso != null) return iso.toLocal();

    // Try common formats
    try {
      return DateTime.parse(raw).toLocal();
    } catch (_) {
      return null;
    }
  }
}