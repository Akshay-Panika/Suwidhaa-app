import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/meeting_controller.dart';
import '../model/meeting_model.dart';
import 'meeting_detail_screen.dart';
import 'meeting_form_screen.dart';

class SchoolMeetingScreen extends StatefulWidget {
  const SchoolMeetingScreen({super.key});

  @override
  State<SchoolMeetingScreen> createState() => _SchoolMeetingScreenState();
}

class _SchoolMeetingScreenState extends State<SchoolMeetingScreen> {
  final MeetingController controller = Get.find<MeetingController>();

  String _classFilter = "All";
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchMeetings();
    });
  }

  // ---------------- FILTERS ----------------
  List<String> get _classOptions {
    final set = <String>{"All"};
    for (final m in controller.meetings) {
      if (m.className != null && m.className!.isNotEmpty) {
        set.add(m.className!);
      }
    }
    final list = set.toList();
    list.sort();
    list.remove("All");
    return ["All", ...list];
  }

  bool get _hasActiveFilters =>
      _classFilter != "All" || _selectedDate != null;

  void _clearFilters() {
    setState(() {
      _classFilter = "All";
      _selectedDate = null;
    });
  }

  List<MeetingModel> _applyLocalFilters(List<MeetingModel> list) {
    var result = list;
    if (_classFilter != "All") {
      result = result.where((m) => m.className == _classFilter).toList();
    }
    if (_selectedDate != null) {
      result = result.where((m) {
        final dt = m.dateTime;
        if (dt == null) return false;
        return dt.year == _selectedDate!.year &&
            dt.month == _selectedDate!.month &&
            dt.day == _selectedDate!.day;
      }).toList();
    }
    return result;
  }

  List<MeetingModel> get _allFiltered {
    final all = _applyLocalFilters(controller.meetings.toList());
    final upcoming = all.where((m) => !m.isPast).toList();
    final past = all.where((m) => m.isPast).toList();
    return [...upcoming, ...past];
  }

  int get _upcomingCount => _applyLocalFilters(controller.meetings.toList())
      .where((m) => !m.isPast)
      .length;

  int get _pastCount => _applyLocalFilters(controller.meetings.toList())
      .where((m) => m.isPast)
      .length;

  Color _statusColor(MeetingModel m) {
    if (m.isPast) return Colors.grey;
    if (m.isToday) return Colors.red;
    return Colors.indigo;
  }

  // ---------------- NAVIGATION ----------------
  Future<void> _openCreate() async {
    final result = await Get.to(() => const MeetingFormScreen());
    if (result == true) {
      controller.fetchMeetings();
    }
  }

  Future<void> _openDetail(MeetingModel m) async {
    final result = await Get.to(() => MeetingDetailScreen(meeting: m));
    if (result == true) {
      controller.fetchMeetings();
    }
  }

  // ---------------- CLASS FILTER SHEET ----------------
  void _showClassFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Select Class',
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _classOptions.map((opt) {
                final isSelected = _classFilter == opt;
                return ChoiceChip(
                  label: Text(opt),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _classFilter = opt);
                    Navigator.pop(context);
                  },
                  selectedColor: Colors.indigo,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  backgroundColor: Colors.grey.shade100,
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // ---------------- DATE PICKER ----------------
  Future<void> _showCalendarPicker() async {
    final now = DateTime.now();
    DateTime tempPicked = _selectedDate ?? now;

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
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded,
                            color: Colors.indigo, size: 20),
                        const SizedBox(width: 8),
                        const Text('Select Date',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded, size: 20),
                        ),
                      ],
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
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
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() => _selectedDate = null);
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
                            child: Text('Clear',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () =>
                                Navigator.pop(context, tempPicked),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Apply',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600)),
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
      setState(() => _selectedDate = picked);
    }
  }

  // ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: Colors.white),
        ),
        title: const Text("Meetings",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 17)),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.meetings.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final list = _allFiltered;
        final upcomingCount = _upcomingCount;
        final pastCount = _pastCount;

        return Column(
          children: [
            _buildFilterHeader(),
            _buildSummaryStrip(upcomingCount, pastCount),
            Expanded(
              child: list.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                onRefresh: () => controller.fetchMeetings(),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (upcomingCount > 0) ...[
                      _sectionHeader(
                          'Upcoming', upcomingCount, Colors.indigo),
                      ...list
                          .where((m) => !m.isPast)
                          .map((m) => _card(m))
                          .toList(),
                    ],
                    if (pastCount > 0) ...[
                      _sectionHeader('Past', pastCount, Colors.grey),
                      ...list
                          .where((m) => m.isPast)
                          .map((m) => _card(m))
                          .toList(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreate,
        backgroundColor: Colors.indigo,
        elevation: 2,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  // ---------------- FILTER HEADER ----------------
  Widget _buildFilterHeader() {
    final hasDate = _selectedDate != null;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune_rounded,
                  size: 16, color: Colors.indigo),
              const SizedBox(width: 6),
              const Text('Filters',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                    letterSpacing: 0.3,
                  )),
              const Spacer(),
              if (_hasActiveFilters)
                GestureDetector(
                  onTap: _clearFilters,
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
                        Text('Clear',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            )),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: _showClassFilterSheet,
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: _classFilter == 'All'
                        ? Colors.grey.shade50
                        : Colors.indigo.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _classFilter == 'All'
                          ? Colors.grey.shade200
                          : Colors.indigo.withOpacity(0.4),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.class_rounded,
                          size: 16,
                          color: _classFilter == 'All'
                              ? Colors.grey[500]
                              : Colors.indigo),
                      const SizedBox(width: 6),
                      Text(
                        _classFilter == 'All' ? 'Class' : _classFilter,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: _classFilter == 'All'
                              ? FontWeight.w500
                              : FontWeight.w600,
                          color: _classFilter == 'All'
                              ? Colors.grey[600]
                              : Colors.indigo,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(Icons.arrow_drop_down_rounded,
                          size: 20,
                          color: _classFilter == 'All'
                              ? Colors.grey[500]
                              : Colors.indigo),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
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
                        Icon(Icons.calendar_today_rounded,
                            size: 16,
                            color: hasDate
                                ? Colors.indigo
                                : Colors.grey[500]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            hasDate
                                ? DateFormat('dd MMM yyyy')
                                .format(_selectedDate!)
                                : 'Date',
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
                        Icon(Icons.arrow_drop_down_rounded,
                            size: 20,
                            color: hasDate
                                ? Colors.indigo
                                : Colors.grey[500]),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStrip(int upcoming, int past) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        children: [
          _summaryChip(
              'Upcoming', upcoming, Colors.indigo, Icons.videocam_rounded),
          const SizedBox(width: 8),
          _summaryChip('Past', past, Colors.grey, Icons.history_rounded),
        ],
      ),
    );
  }

  Widget _summaryChip(
      String label, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text('$label: $count',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color)),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(title,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color)),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('$count',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.videocam_off_outlined,
              size: 50, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          Text("No meetings",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          const SizedBox(height: 4),
          Text("Try changing the filters",
              style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
        ],
      ),
    );
  }

  Widget _card(MeetingModel m) {
    final sc = _statusColor(m);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openDetail(m),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(m.dayPart,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1,
                        color: Colors.indigo,
                      )),
                  const SizedBox(height: 2),
                  Text(m.monthPart,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
              const SizedBox(width: 16),
              Container(width: 1, height: 42, color: Colors.grey.shade200),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.title,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(
                      "${m.className ?? '-'} • ${m.timePretty} • ${m.forMeeting}",
                      style:
                      TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 8,
                height: 8,
                decoration:
                BoxDecoration(color: sc, shape: BoxShape.circle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}