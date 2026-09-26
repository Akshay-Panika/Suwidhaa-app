// lib/feature/school/report/controller/report_card_controller.dart
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/report_card_model.dart';
import '../repository/report_card_repository.dart';

class ReportCardController extends GetxController {
  final ReportCardRepository _repository = ReportCardRepository();

  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final isDeleting = false.obs;
  final isUpdating = false.obs;
  final reportCards = <ReportCardData>[].obs;
  final errorMessage = ''.obs;

  Future<void> loadReportCards(String adminId) async {
    if (adminId.trim().isEmpty) {
      errorMessage.value = 'Admin ID is empty';
      return;
    }
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response =
      await _repository.getReportCardsByAdmin(adminId.trim());
      if (response.status) {
        reportCards.value = response.data;
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      FlutterToast.error('Failed to load report cards: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createReportCard(CreateReportCardRequest req) async {
    try {
      isSubmitting.value = true;
      await _repository.createReportCard(req);
      return true;
    } catch (e) {
      FlutterToast.error('Failed: $e');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Update an existing report card by id.
  /// Replaces it in the local list on success.
  Future<bool> updateReportCard(
      int id,
      CreateReportCardRequest req,
      ) async {
    try {
      isUpdating.value = true;
      final res = await _repository.updateReportCard(id, req);

      // Refresh that one entry in memory
      final data = res['data'];
      if (data is Map<String, dynamic>) {
        try {
          final updated = ReportCardData.fromJson(data);
          final idx = reportCards.indexWhere((r) => r.id == id);
          if (idx >= 0) {
            reportCards[idx] = updated;
          } else {
            reportCards.insert(0, updated);
          }
        } catch (_) {
          // If parsing fails, just reload from server later
        }
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

  Future<BulkCreateResult> createReportCards(
      List<CreateReportCardRequest> requests,
      ) async {
    try {
      isSubmitting.value = true;
      return await _repository.createReportCards(requests);
    } catch (e) {
      FlutterToast.error('Failed to submit: $e');
      return BulkCreateResult(created: [], failures: ['$e']);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteReportCard(int id) async {
    try {
      isDeleting.value = true;
      await _repository.deleteReportCard(id);
      reportCards.removeWhere((r) => r.id == id);
      FlutterToast.success('Report card deleted');
      return true;
    } catch (e) {
      FlutterToast.error('Failed to delete: $e');
      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  List<ReportCardData> getByStudentIdCard(String studentIdCard) {
    if (studentIdCard.isEmpty) return [];
    return reportCards.where((r) => r.studentId == studentIdCard).toList();
  }

  List<String> get uniqueStudentIds {
    final set = <String>{};
    for (final r in reportCards) {
      if (r.studentId.isNotEmpty && r.studentId != 'NA') {
        set.add(r.studentId);
      }
    }
    return set.toList();
  }

  @override
  void onClose() {
    super.onClose();
  }
}