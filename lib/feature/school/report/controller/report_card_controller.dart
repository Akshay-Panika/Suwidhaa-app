// lib/feature/school/report/controller/report_card_controller.dart
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/report_card_model.dart';
import '../repository/report_card_repository.dart';

class ReportCardController extends GetxController {
  final ReportCardRepository _repo = ReportCardRepository();

  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final isUpdating = false.obs;
  final isDeleting = false.obs;
  final isLoadingStudent = false.obs;
  final errorMessage = ''.obs;

  final reportCards = <ReportCardData>[].obs;
  final studentReportCards = <ReportCardData>[].obs;

  // ══════════════════════════════════════════════════════
  // TEACHER-WISE LIST
  // ══════════════════════════════════════════════════════
  Future<void> loadReportCards(String teacherId) async {
    if (teacherId.trim().isEmpty) {
      errorMessage.value = 'Teacher ID is empty';
      return;
    }
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final res = await _repo.getReportCardsByTeacher(teacherId.trim());
      if (res.status) {
        reportCards.value = res.data;
      } else {
        reportCards.value = [];
      }
    } catch (e) {
      errorMessage.value = e.toString();
      FlutterToast.error('Failed to load report cards: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ══════════════════════════════════════════════════════
  // STUDENT-WISE LIST  (student DB integer id)
  // ══════════════════════════════════════════════════════
  Future<void> loadReportCardsByStudent(String studentDbId) async {
    if (studentDbId.trim().isEmpty) {
      errorMessage.value = 'Student ID is empty';
      return;
    }
    try {
      isLoadingStudent.value = true;
      errorMessage.value = '';
      final res =
      await _repo.getReportCardsByStudentId(studentDbId.trim());
      if (res.status) {
        studentReportCards.value = res.data;
      } else {
        studentReportCards.value = [];
      }
    } catch (e) {
      studentReportCards.value = [];
      errorMessage.value = e.toString();
      FlutterToast.error('Failed to load report cards: $e');
    } finally {
      isLoadingStudent.value = false;
    }
  }

  // ══════════════════════════════════════════════════════
  // BULK CREATE — multi-student in ONE call
  // ══════════════════════════════════════════════════════
  Future<BulkCreateResult> createReportCards({
    required String teacherId,
    required String className,
    required String subjectName,
    required String examName,
    required int totalMarks,
    required int passingMarks,
    required List<CreateReportCardRequest> rows,
  }) async {
    try {
      isSubmitting.value = true;
      final result = await _repo.bulkCreate(
        teacherId: teacherId,
        className: className,
        subjectName: subjectName,
        examName: examName,
        totalMarks: totalMarks,
        passingMarks: passingMarks,
        rows: rows,
      );
      // Refresh teacher's own list
      await loadReportCards(teacherId);
      return result;
    } catch (e) {
      FlutterToast.error('Failed to submit: $e');
      return BulkCreateResult(created: [], failures: ['$e']);
    } finally {
      isSubmitting.value = false;
    }
  }

  // ══════════════════════════════════════════════════════
  // UPDATE (single)
  // ══════════════════════════════════════════════════════
  Future<bool> updateReportCard(
      int id, CreateReportCardRequest req) async {
    try {
      isUpdating.value = true;
      final res = await _repo.updateReportCard(id, req);
      final data = res['data'];
      if (data is Map<String, dynamic>) {
        try {
          final updated = ReportCardData.fromJson(data);
          final idx = reportCards.indexWhere((r) => r.id == id);
          if (idx >= 0) {
            reportCards[idx] = updated;
            reportCards.refresh();
          }
        } catch (_) {}
      }
      FlutterToast.success('Report card updated');
      return true;
    } catch (e) {
      FlutterToast.error('Failed to update: $e');
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  // ══════════════════════════════════════════════════════
  // DELETE
  // ══════════════════════════════════════════════════════
  Future<bool> deleteReportCard(int id) async {
    try {
      isDeleting.value = true;
      await _repo.deleteReportCard(id);
      reportCards.removeWhere((r) => r.id == id);
      studentReportCards.removeWhere((r) => r.id == id);
      FlutterToast.success('Report card deleted');
      return true;
    } catch (e) {
      FlutterToast.error('Failed to delete: $e');
      return false;
    } finally {
      isDeleting.value = false;
    }
  }
}