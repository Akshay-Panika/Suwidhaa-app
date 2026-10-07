import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../model/ngo_staff_model.dart';
import '../repository/ngo_staff_repository.dart';

class NgoStaffController extends GetxController {
  final NgoStaffRepository _repository = NgoStaffRepository();

  final RxBool isLoading = false.obs;
  final RxList<NgoStaffModel> staffList = <NgoStaffModel>[].obs;
  final RxInt count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getNgoStaffList();
  }

  Future<void> getNgoStaffList() async {
    try {
      isLoading.value = true;

      final data = await _repository.getNgoStaffList();

      staffList.assignAll(data);
      count.value = data.length;
    } catch (e) {
      FlutterToast.error(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshStaffList() async {
    await getNgoStaffList();
  }
}