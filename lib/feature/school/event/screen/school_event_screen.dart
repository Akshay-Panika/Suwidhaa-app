import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../auth/controller/school_auth_controller.dart';
import '../controller/school_event_controller.dart';
import '../model/school_event_model.dart';
import 'school_event_details_screen.dart';
import 'school_event_form_screen.dart';

class SchoolEventScreen extends StatefulWidget {
  const SchoolEventScreen({super.key});

  @override
  State<SchoolEventScreen> createState() => _SchoolEventScreenState();
}

class _SchoolEventScreenState extends State<SchoolEventScreen> {
  final authController = Get.find<SchoolAuthController>();
  // if(authController.userType!='student')
  final _ctrl = Get.find<SchoolEventController>();

  // ==================== FILTERS ====================
  String _statusFilter = "All";
  String _categoryFilter = "All";
  DateTime? _selectedDate;

  final List<String> _statusFilters = [
    "All", "Upcoming", "Ongoing", "Completed", "Cancelled",
  ];

  List<String> get _categoryOptions {
    final set = <String>{"All"};
    for (final e in _ctrl.events) {
      if (e.category.isNotEmpty) set.add(e.category);
    }
    final list = set.toList()..sort();
    list.remove("All");
    return ["All", ...list];
  }

  bool get _hasActiveFilters =>
      _statusFilter != "All" ||
          _categoryFilter != "All" ||
          _selectedDate != null;

  void _clearFilters() {
    setState(() {
      _statusFilter = "All";
      _categoryFilter = "All";
      _selectedDate = null;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_ctrl.events.isEmpty && !_ctrl.isLoading.value) {
        _ctrl.fetchEvents();
      }
    });
  }

  // ==================== COLORS ====================
  Color _categoryColor(String c) {
    switch (c) {
      case "Sports": return Colors.green;
      case "Cultural": return Colors.purple;
      case "Academic": return Colors.blue;
      case "Holiday": return Colors.teal;
      case "Meeting": return Colors.orange;
      default: return Colors.grey;
    }
  }

  IconData _categoryIcon(String c) {
    switch (c) {
      case "Sports": return Icons.sports_soccer_rounded;
      case "Cultural": return Icons.theater_comedy_rounded;
      case "Academic": return Icons.school_rounded;
      case "Holiday": return Icons.beach_access_rounded;
      case "Meeting": return Icons.groups_rounded;
      default: return Icons.event_rounded;
    }
  }

  Color _statusColor(String s) {
    switch (s) {
      case "Upcoming": return Colors.blue;
      case "Ongoing": return Colors.green;
      case "Completed": return Colors.grey;
      case "Cancelled": return Colors.red;
      default: return Colors.grey;
    }
  }

  // ==================== FILTERING (created_at based) ====================
  List<SchoolEventModel> _applyLocalFilters(List<SchoolEventModel> list) {
    // var result = list;
    var result = List<SchoolEventModel>.from(list);

    // Status filter
    if (_statusFilter != "All") {
      result = result.where((e) => e.status == _statusFilter).toList();
    }

    // Category filter
    if (_categoryFilter != "All") {
      result = result.where((e) => e.category == _categoryFilter).toList();
    }

    // ✅ Date filter → on created_at only
    if (_selectedDate != null) {
      final selYear = _selectedDate!.year;
      final selMonth = _selectedDate!.month;
      final selDay = _selectedDate!.day;

      result = result.where((e) {
        final target = _parseCreatedAt(e.createdAt);
        if (target == null) return false;
        return target.year == selYear &&
            target.month == selMonth &&
            target.day == selDay;
      }).toList();
    }

    // Sort: pinned first, then latest created_at
    result.sort((a, b) {
      final pa = a.isPinned ? 0 : 1;
      final pb = b.isPinned ? 0 : 1;
      if (pa != pb) return pa.compareTo(pb);

      final da = _parseCreatedAt(a.createdAt);
      final db = _parseCreatedAt(b.createdAt);
      if (da != null && db != null) return db.compareTo(da);
      if (da != null) return -1;
      if (db != null) return 1;
      return b.id.compareTo(a.id);
    });

    return result;
  }

  /// Parse `created_at` ISO-8601: "2026-09-27T18:14:53.376989+05:30"
  DateTime? _parseCreatedAt(String s) {
    if (s.trim().isEmpty) return null;
    try {
      return DateTime.parse(s);
    } catch (_) {
      return _parseEventDate(s); // fallback
    }
  }

  /// Robust date parser — supports multiple formats
  DateTime? _parseEventDate(String s) {
    if (s.trim().isEmpty) return null;
    s = s.trim();

    const monthsShort = {
      "jan": 1, "feb": 2, "mar": 3, "apr": 4, "may": 5, "jun": 6,
      "jul": 7, "aug": 8, "sep": 9, "oct": 10, "nov": 11, "dec": 12,
    };
    const monthsLong = {
      "january": 1, "february": 2, "march": 3, "april": 4,
      "may": 5, "june": 6, "july": 7, "august": 8,
      "september": 9, "october": 10, "november": 11, "december": 12,
    };

    final parts = s.split(RegExp(r'\s+'));
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final monthKey = parts[1].toLowerCase();
      final year = int.tryParse(parts[2]);
      final month = monthsShort[monthKey] ?? monthsLong[monthKey];
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    final iso = DateTime.tryParse(s);
    if (iso != null) return iso;

    final slashed =
    RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$').firstMatch(s);
    if (slashed != null) {
      return DateTime(
        int.parse(slashed.group(3)!),
        int.parse(slashed.group(2)!),
        int.parse(slashed.group(1)!),
      );
    }

    return null;
  }

  // ==================== NAVIGATION ====================
  Future<void> _openCreate() async {
    await Get.to(() => const SchoolEventFormScreen());
    _ctrl.fetchEvents(silent: true);
  }

  Future<void> _openDetail(SchoolEventModel e) async {
    await Get.to(() => SchoolEventDetailsScreen(event: e));
    _ctrl.fetchEvents(silent: true);
  }

  // ==================== FILTER SHEETS ====================
  void _showCategoryFilterSheet() {
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
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Select Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _categoryOptions.map((opt) {
                final isSelected = _categoryFilter == opt;
                return ChoiceChip(
                  label: Text(opt),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _categoryFilter = opt);
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

  // ==================== ✅ SIMPLE CALENDAR PICKER (no mode toggle) ====================
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
                      width: 40, height: 4,
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
                    const SizedBox(height: 12),

                    // Calendar
                    SizedBox(
                      height: 320,
                      child: CalendarDatePicker(
                        initialDate: tempPicked,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        onDateChanged: (date) =>
                            setModalState(() => tempPicked = date),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Actions
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

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("School Events",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        actions: [
          if(authController.userType!='student')
          InkWell(
            onTap: _openCreate,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 0.3),
              ),
              child: const Icon(Icons.add,size: 20,),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value && _ctrl.events.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_ctrl.error.value.isNotEmpty && _ctrl.events.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded,
                    size: 60, color: Colors.red.shade300),
                const SizedBox(height: 10),
                Text(_ctrl.error.value, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _ctrl.fetchEvents(),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        final all = _ctrl.events;
        final filtered = _applyLocalFilters(all);

        return Column(
          children: [
            _buildFilterHeader(),
            _buildStatusStrip(),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.event_busy_rounded,
                        size: 60, color: Colors.grey.shade400),
                    const SizedBox(height: 10),
                    Text("No events found",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text("Try changing the filters",
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade400)),
                  ],
                ),
              )
                  : RefreshIndicator(
                onRefresh: () => _ctrl.fetchEvents(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(14),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildEventCard(filtered[index]);
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ==================== FILTER HEADER ====================
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
              const Icon(Icons.tune_rounded, size: 16, color: Colors.indigo),
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
                                color: Colors.red)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Category picker
              GestureDetector(
                onTap: _showCategoryFilterSheet,
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: _categoryFilter == 'All'
                        ? Colors.grey.shade50
                        : Colors.indigo.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _categoryFilter == 'All'
                          ? Colors.grey.shade200
                          : Colors.indigo.withOpacity(0.4),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.category_rounded,
                          size: 16,
                          color: _categoryFilter == 'All'
                              ? Colors.grey[500]
                              : Colors.indigo),
                      const SizedBox(width: 6),
                      Text(
                        _categoryFilter == 'All'
                            ? 'Category'
                            : _categoryFilter,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: _categoryFilter == 'All'
                              ? FontWeight.w500
                              : FontWeight.w600,
                          color: _categoryFilter == 'All'
                              ? Colors.grey[600]
                              : Colors.indigo,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(Icons.arrow_drop_down_rounded,
                          size: 20,
                          color: _categoryFilter == 'All'
                              ? Colors.grey[500]
                              : Colors.indigo),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Date picker
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
                                : 'Created Date',
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

  // ==================== STATUS STRIP ====================
  Widget _buildStatusStrip() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _statusFilters.map((f) {
            final sel = _statusFilter == f;
            final color = f == "All" ? Colors.indigo : _statusColor(f);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(f),
                selected: sel,
                onSelected: (_) => setState(() => _statusFilter = f),
                selectedColor: color,
                backgroundColor: Colors.grey.shade100,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: sel ? Colors.white : Colors.black87,
                ),
                side: BorderSide(
                    color: sel ? color : Colors.grey.shade300),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ==================== EVENT CARD ====================
  Widget _buildEventCard(SchoolEventModel e) {
    final cc = _categoryColor(e.category);
    final sc = _statusColor(e.status);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _openDetail(e),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            if (e.hasBanner)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14)),
                child: Image.network(
                  e.bannerUrl!,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: 130,
                      color: Colors.grey.shade100,
                      child: const Center(
                          child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: 130,
                    color: cc.withOpacity(0.15),
                    child: Center(
                      child: Icon(_categoryIcon(e.category),
                          size: 40, color: cc),
                    ),
                  ),
                ),
              )
            else
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: cc.withOpacity(0.08),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14)),
                ),
                child: Center(
                  child: Icon(_categoryIcon(e.category),
                      size: 30, color: cc),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (e.isPinned) ...[
                        const Icon(Icons.push_pin_rounded,
                            size: 14, color: Colors.orange),
                        const SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Text(
                          e.title,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Event date row (when event happens)
                  Row(
                    children: [
                      const Icon(Icons.event_rounded,
                          size: 13, color: Colors.deepOrange),
                      const SizedBox(width: 4),
                      Text(
                        "Event: ",
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                        child: Text(
                          e.isMultiDay
                              ? "${e.startDate} → ${e.endDate}"
                              : e.startDate,
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[800]),
                        ),
                      ),
                      const Icon(Icons.access_time_rounded,
                          size: 13, color: Colors.indigo),
                      const SizedBox(width: 4),
                      Text("${e.startTime} - ${e.endTime}",
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[700])),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // // Created date row
                  // Row(
                  //   children: [
                  //     const Icon(Icons.fiber_new_rounded,
                  //         size: 13, color: Colors.teal),
                  //     const SizedBox(width: 4),
                  //     Text(
                  //       "Created: ${e.displayDate}",
                  //       style: TextStyle(
                  //           fontSize: 11,
                  //           color: Colors.teal[700],
                  //           fontWeight: FontWeight.w600),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 6),

                  // Venue row
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 13, color: Colors.redAccent),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          e.venue,
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[700]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6, runSpacing: 6,
                    children: [
                      _tag(e.category, cc,
                          icon: _categoryIcon(e.category)),
                      _tag(e.status, sc),
                      _tag(e.audience, Colors.indigo,
                          icon: Icons.groups_rounded),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 4),
          ],
          Text(text,
              style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}