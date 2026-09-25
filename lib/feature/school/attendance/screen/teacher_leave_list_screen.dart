import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  // ==================== STATE ====================
  String selectedStatus = 'All';
  DateTime? selectedDate; // null = no date filter

  final List<String> statusOptions = const [
    'All',
    'Pending',
    'Approved',
    'Rejected',
    'Ignored',
  ];

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

  // ==================== HELPERS ====================
  List<TeacherLeaveModel> get _allLeaves => teacherLeaveController.leaves;

  List<TeacherLeaveModel> get _filteredRequests {
    return _allLeaves.where((r) {
      // Status filter
      final statusMatch =
          selectedStatus == 'All' || _status(r) == selectedStatus;

      // Date filter
      final dateMatch = _matchesDateFilter(r);

      return statusMatch && dateMatch;
    }).toList();
  }

  bool _matchesDateFilter(TeacherLeaveModel leave) {
    if (selectedDate == null) return true;

    final dateStr = leave.startDate;
    if (dateStr == null || dateStr.isEmpty) return false;

    try {
      final date = DateTime.parse(dateStr);
      return date.year == selectedDate!.year &&
          date.month == selectedDate!.month &&
          date.day == selectedDate!.day;
    } catch (_) {
      return false;
    }
  }

  int get _pendingCount =>
      _allLeaves.where((r) => _status(r) == 'Pending').length;

  // ==================== STATUS HELPERS ====================
  String _status(TeacherLeaveModel leave) {
    // Example: return leave.status ?? 'Pending';
    return 'Pending';
  }

  String _name(TeacherLeaveModel leave) {
    // Example: return leave.teacherName ?? '';
    return '';
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'ignored':
        return Colors.grey;
      case 'pending':
        return Colors.orange;
      case 'all':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      case 'ignored':
        return Icons.visibility_off_rounded;
      case 'all':
        return Icons.apps_rounded;
      default:
        return Icons.hourglass_top_rounded;
    }
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (teacherLeaveController.isLoading.value &&
            teacherLeaveController.leaves.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final filtered = _filteredRequests;

        return Column(
          children: [
            _buildStatusHeader(), // Status filter
            _buildDateFilterBar(), // Date filter using CalendarDatePicker
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                onRefresh: () => _loadLeaves(force: true),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) =>
                      _buildRequestCard(filtered[i]),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.indigo,
      elevation: 0,
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child:
        const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
      ),
      title: const Text(
        'Leave Requests',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      centerTitle: false,
      actions: [
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
      ],
    );
  }

  // ==================== STATUS HEADER ====================
  Widget _buildStatusHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.filter_alt_rounded,
                  size: 16, color: Colors.indigo),
              const SizedBox(width: 6),
              const Text(
                'Filter by Status',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: statusOptions.map((status) {
                final isSelected = selectedStatus == status;
                final color = _statusColor(status);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => selectedStatus = status);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color
                            : color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? color
                              : color.withOpacity(0.3),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _statusIcon(status),
                            size: 13,
                            color: isSelected ? Colors.white : color,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== DATE FILTER BAR (CalendarDatePicker) ====================
  Widget _buildDateFilterBar() {
    final hasDate = selectedDate != null;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.date_range_rounded,
                  size: 16, color: Colors.indigo),
              const SizedBox(width: 6),
              const Text(
                'Filter by Date',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                  letterSpacing: 0.3,
                ),
              ),
              const Spacer(),
              if (hasDate)
                GestureDetector(
                  onTap: () => setState(() => selectedDate = null),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close_rounded,
                            size: 12, color: Colors.red),
                        SizedBox(width: 3),
                        Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _showCalendarPicker,
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: hasDate
                    ? Colors.indigo.withOpacity(0.08)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: hasDate
                      ? Colors.indigo.withOpacity(0.4)
                      : Colors.grey.shade200,
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: hasDate ? Colors.indigo : Colors.grey[500],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      hasDate
                          ? DateFormat('dd MMM yyyy').format(selectedDate!)
                          : 'Select date',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: hasDate
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: hasDate
                            ? Colors.indigo
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    size: 22,
                    color: hasDate ? Colors.indigo : Colors.grey[500],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCalendarPicker() async {
    final now = DateTime.now();
    DateTime tempPicked = selectedDate ?? now;

    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Header
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded,
                            color: Colors.indigo, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Select Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded, size: 20),
                        ),
                      ],
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 8),

                    // ✅ CalendarDatePicker
                    SizedBox(
                      height: 320,
                      child: CalendarDatePicker(
                        initialDate: tempPicked,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        onDateChanged: (date) {
                          setModalState(() => tempPicked = date);
                        },
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() => selectedDate = null);
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                            child: Text(
                              'Clear',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, tempPicked);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Apply',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  // ==================== REQUEST CARD ====================
  Widget _buildRequestCard(TeacherLeaveModel leave) {
    final isFullDay = leave.applyStatus;
    final typeColor =
    isFullDay ? const Color(0xFF2563EB) : const Color(0xFFEA580C);
    final typeText = isFullDay ? "Full Day" : "Half Day";
    final typeIcon = isFullDay ? Icons.wb_sunny : Icons.brightness_2;

    final status = _status(leave);
    final statusColor = _statusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.25), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: avatar + Leave # + status badge
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _name(leave).isNotEmpty
                        ? _name(leave)[0].toUpperCase()
                        : 'T',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Leave #${leave.id ?? '-'}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.indigo.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              typeText,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status badge (from admin response)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_statusIcon(status),
                          size: 11, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Leave info row
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        typeIcon,
                        size: 14,
                        color: typeColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        typeText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.calendar_today_rounded,
                          size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        '${leave.startDate} → ${leave.endDate}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (leave.reasonMsg != null &&
                      leave.reasonMsg!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.notes_rounded,
                            size: 13, color: Colors.grey[500]),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            leave.reasonMsg!,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (leave.createdDate != null &&
                      leave.createdDate!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          'Applied on: ${_formatCreatedDate(leave.createdDate)}',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

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
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: 150,
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_rounded, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'No leave requests found',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try changing the filters',
            style: TextStyle(fontSize: 12, color: Colors.grey[400]),
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