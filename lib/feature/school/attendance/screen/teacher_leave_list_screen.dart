import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:untitled/core/utils/app_color.dart';

import '../../profile/controller/teacher_controller.dart';
import '../controller/teacher_leave_controller.dart';
import '../model/teacher_leave_model.dart';
import 'teacher_leave_form_screen.dart';

class TeacherLeaveListScreen extends StatefulWidget {
  const TeacherLeaveListScreen({super.key});

  @override
  State<TeacherLeaveListScreen> createState() => _TeacherLeaveListScreenState();
}

class _TeacherLeaveListScreenState extends State<TeacherLeaveListScreen> {
  final teacherController = Get.find<TeacherController>();
  final teacherLeaveController = Get.find<TeacherLeaveController>();

  @override
  void initState() {
    super.initState();
    _loadLeaves();
  }

  Future<void> _loadLeaves({bool force = false}) async {
    final idCard = teacherController.teacherIdCard;
    if (idCard.isNotEmpty) {
      await teacherLeaveController.fetchLeavesByTeacherIdCard(
        idCard,
        forceRefresh: force,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          "My Leaves",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          // Apply button (instead of FAB)
          IconButton(
            tooltip: "Apply Leave",
            onPressed: () async {
              final result = await Get.to(
                    () => const TeacherLeaveFormScreen(),
              );
              if (result == true) {
                _loadLeaves(force: true);
              }
            },
            icon: const Icon(Icons.add_circle_outline,
                color: Colors.white, size: 26),
          ),
          IconButton(
            tooltip: "Refresh",
            onPressed: () => _loadLeaves(force: true),
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: Obx(() {
        if (teacherLeaveController.isLoading.value &&
            teacherLeaveController.leaves.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (teacherLeaveController.leaves.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () => _loadLeaves(force: true),
          child: ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: teacherLeaveController.leaves.length,
            itemBuilder: (context, index) {
              final leave = teacherLeaveController.leaves[index];
              return _buildLeaveCard(leave);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            "No leaves applied yet",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await Get.to(
                    () => const TeacherLeaveFormScreen(),
              );
              if (result == true) {
                _loadLeaves(force: true);
              }
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text("Apply Leave"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveCard(TeacherLeaveModel leave) {
    final isFullDay = leave.applyStatus;
    final typeColor =
    isFullDay ? const Color(0xFF2563EB) : const Color(0xFFEA580C);
    final typeBg =
    isFullDay ? const Color(0xFFDBEAFE) : const Color(0xFFFFEDD5);
    final typeText = isFullDay ? "Full Day" : "Half Day";
    final typeIcon = isFullDay ? Icons.wb_sunny : Icons.brightness_2;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top color strip
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: typeColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Leave #${leave.id ?? '-'}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: typeBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(typeIcon, size: 12, color: typeColor),
                          const SizedBox(width: 4),
                          Text(
                            typeText,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: typeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Delete button
                    IconButton(
                      tooltip: "Delete",
                      onPressed: () => _confirmDelete(leave),
                      icon: Icon(Icons.delete_outline,
                          size: 20, color: Colors.red.shade400),
                      padding: EdgeInsets.zero,
                      constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Dates
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 14, color: Colors.blue.shade700),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "${leave.startDate}  →  ${leave.endDate}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),

                // Reason
                if (leave.reasonMsg != null &&
                    leave.reasonMsg!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.notes,
                          size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          leave.reasonMsg!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // Image
                if (leave.image != null && leave.image!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      leave.image!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 150,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.broken_image),
                        ),
                      ),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          height: 150,
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 10),

                // Footer — created date
                if (leave.createdDate != null &&
                    leave.createdDate!.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 12, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        _formatCreatedDate(leave.createdDate),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(TeacherLeaveModel leave) {
    Get.dialog(
      AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text("Delete Leave", style: TextStyle(fontSize: 16)),
          ],
        ),
        content: Text(
          "Are you sure you want to delete Leave #${leave.id}?",
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Get.back();
              final id = leave.id;
              if (id == null) return;
              await teacherLeaveController.deleteLeave(id);
            },
            child: const Text("Delete",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatCreatedDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final d = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(d);
    } catch (_) {
      return dateStr;
    }
  }
}