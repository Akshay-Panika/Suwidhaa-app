import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../../profile/controller/teacher_controller.dart';
import '../controller/school_event_controller.dart';
import '../model/school_event_model.dart';

class SchoolEventFormScreen extends StatefulWidget {
  final SchoolEventModel? event;
  const SchoolEventFormScreen({super.key, this.event});

  @override
  State<SchoolEventFormScreen> createState() => _SchoolEventFormScreenState();
}

class _SchoolEventFormScreenState extends State<SchoolEventFormScreen> {
  final _ctrl = Get.find<SchoolEventController>();
  final teacherController = Get.find<TeacherController>();

  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();

  String _category = "Sports";
  String _audience = "Both";
  String _status = "Upcoming";

  DateTime? _startDate, _endDate;
  TimeOfDay? _startTime, _endTime;

  bool _pinEvent = false;

  // Banner state
  PlatformFile? _pickedBanner;
  String? _existingBannerUrl;
  bool _removeExisting = false;

  final List<String> _categories = [
    "Sports", "Cultural", "Academic", "Holiday", "Meeting", "Other",
  ];
  final List<String> _audiences = ["Students", "Parents", "Both", "Staff", "All"];
  final List<String> _statuses = ["Upcoming", "Ongoing", "Completed", "Cancelled"];

  bool get isEdit => widget.event != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final e = widget.event!;
      _titleCtrl.text = e.title;
      _descCtrl.text = e.description;
      _venueCtrl.text = e.venue;
      _category = e.category;
      _audience = e.audience;
      _status = e.status;
      _pinEvent = e.isPinned;
      _existingBannerUrl = e.bannerUrl;
      _startDate = _parseDate(e.startDate);
      _endDate = _parseDate(e.endDate);
      _startTime = _parseTime(e.startTime);
      _endTime = _parseTime(e.endTime);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _venueCtrl.dispose();
    super.dispose();
  }

  // ==================== HELPERS ====================
  DateTime? _parseDate(String s) {
    try {
      final parts = s.split(' ');
      const months = {
        "Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6,
        "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12,
      };
      if (parts.length == 3) {
        return DateTime(int.parse(parts[2]), months[parts[1]]!, int.parse(parts[0]));
      }
    } catch (_) {}
    return null;
  }

  TimeOfDay? _parseTime(String s) {
    try {
      final match = RegExp(r'(\d+):(\d+)\s*(AM|PM)').firstMatch(s.toUpperCase());
      if (match != null) {
        int hour = int.parse(match.group(1)!);
        final min = int.parse(match.group(2)!);
        final period = match.group(3);
        if (period == "PM" && hour != 12) hour += 12;
        if (period == "AM" && hour == 12) hour = 0;
        return TimeOfDay(hour: hour, minute: min);
      }
    } catch (_) {}
    return null;
  }

  String _formatDate(DateTime d) {
    const m = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    return "${d.day} ${m[d.month - 1]} ${d.year}";
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.period == DayPeriod.am ? "AM" : "PM";
    return "${h.toString().padLeft(2, '0')}:$m $p";
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? _startDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 730)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.indigo),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate == null || _endDate!.isBefore(picked)) _endDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (isStart ? _startTime : _endTime) ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.indigo),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startTime = picked; else _endTime = picked;
      });
    }
  }

  // ==================== BANNER PICKER ====================
  Future<void> _pickBanner() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.image, allowMultiple: false);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _pickedBanner = result.files.single;
        _removeExisting = false;
      });
    }
  }

  void _removeBanner() {
    setState(() {
      if (_pickedBanner != null) {
        _pickedBanner = null;
      } else if (_existingBannerUrl != null) {
        _removeExisting = true;
      }
    });
  }

  // ==================== SUBMIT ====================
  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty) return FlutterToast.warning("Please enter event title");
    if (_descCtrl.text.trim().isEmpty) return FlutterToast.warning("Please enter description");
    if (_venueCtrl.text.trim().isEmpty) return FlutterToast.warning("Please enter venue");
    if (_startDate == null || _endDate == null) return FlutterToast.warning("Please select start and end date");
    if (_startTime == null || _endTime == null) return FlutterToast.warning("Please select start and end time");

    final organizer = teacherController.teacherIdCard;

    bool ok;

    if (isEdit) {
      ok = await _ctrl.updateEvent(
        id: widget.event!.id,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        category: _category,
        venue: _venueCtrl.text.trim(),
        startDate: _formatDate(_startDate!),
        endDate: _formatDate(_endDate!),
        startTime: _formatTime(_startTime!),
        endTime: _formatTime(_endTime!),
        audience: _audience,
        status: _status,
        isPinned: _pinEvent,
        organizer: widget.event!.organizer.isEmpty ? organizer : widget.event!.organizer,
        banner: _pickedBanner,
        removeBanner: _removeExisting,
      );
    } else {
      ok = await _ctrl.createEvent(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        category: _category,
        venue: _venueCtrl.text.trim(),
        startDate: _formatDate(_startDate!),
        endDate: _formatDate(_endDate!),
        startTime: _formatTime(_startTime!),
        endTime: _formatTime(_endTime!),
        audience: _audience,
        status: _status,
        isPinned: _pinEvent,
        organizer: organizer,
        banner: _pickedBanner,
      );
    }

    if (ok) {
      FlutterToast.success(isEdit ? "Event updated" : "Event hosted successfully");
      Get.back(result: true);
    } else {
      FlutterToast.error(_ctrl.error.value);
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
        title: Text(isEdit ? "Edit Event" : "Host Event",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBannerPicker(),
            const SizedBox(height: 18),

            _label("Event Title"),
            const SizedBox(height: 8),
            _input(_titleCtrl, "e.g. Annual Sports Meet 2026",
                Icons.event_rounded, maxLength: 100),
            const SizedBox(height: 18),

            _label("Category"),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _categories.map((c) {
                final sel = _category == c;
                final color = _catColor(c);
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_catIcon(c), size: 15, color: sel ? Colors.white : color),
                      const SizedBox(width: 6),
                      Text(c),
                    ],
                  ),
                  selected: sel,
                  onSelected: (_) => setState(() => _category = c),
                  selectedColor: color,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: sel ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  side: BorderSide(color: sel ? color : Colors.grey.shade300),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            _label("Description"),
            const SizedBox(height: 8),
            _input(_descCtrl, "Describe the event...", null,
                maxLines: 4, maxLength: 500),
            const SizedBox(height: 18),

            _label("Venue"),
            const SizedBox(height: 8),
            _input(_venueCtrl, "e.g. Main Ground / Auditorium",
                Icons.location_on_rounded, maxLength: 80),
            const SizedBox(height: 18),

            _label("Event Date"),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _dateTimeButton(
                    icon: Icons.calendar_today_rounded,
                    label: _startDate == null ? "Start Date" : _formatDate(_startDate!),
                    isSet: _startDate != null,
                    onTap: () => _pickDate(isStart: true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _dateTimeButton(
                    icon: Icons.event_available_rounded,
                    label: _endDate == null ? "End Date" : _formatDate(_endDate!),
                    isSet: _endDate != null,
                    onTap: () => _pickDate(isStart: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            _label("Event Time"),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _dateTimeButton(
                    icon: Icons.access_time_rounded,
                    label: _startTime == null ? "Start Time" : _formatTime(_startTime!),
                    isSet: _startTime != null,
                    onTap: () => _pickTime(isStart: true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _dateTimeButton(
                    icon: Icons.timer_off_rounded,
                    label: _endTime == null ? "End Time" : _formatTime(_endTime!),
                    isSet: _endTime != null,
                    onTap: () => _pickTime(isStart: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            _label("Audience"),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _audiences.map((a) {
                final sel = _audience == a;
                return ChoiceChip(
                  label: Text(a),
                  selected: sel,
                  onSelected: (_) => setState(() => _audience = a),
                  selectedColor: Colors.indigo,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: sel ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  side: BorderSide(color: sel ? Colors.indigo : Colors.grey.shade300),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            _label("Status"),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _statuses.map((s) {
                final sel = _status == s;
                final color = _statusColor(s);
                return ChoiceChip(
                  label: Text(s),
                  selected: sel,
                  onSelected: (_) => setState(() => _status = s),
                  selectedColor: color,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: sel ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  side: BorderSide(color: sel ? color : Colors.grey.shade300),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            _toggleTile(
              icon: Icons.push_pin_rounded,
              title: "Pin to top",
              subtitle: "Highlight this event at the top of the list",
              value: _pinEvent,
              onChanged: (v) => setState(() => _pinEvent = v),
            ),
            const SizedBox(height: 24),

            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _ctrl.isSubmitting.value ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _ctrl.isSubmitting.value
                    ? const SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : Icon(isEdit ? Icons.save_rounded : Icons.celebration_rounded,
                    color: Colors.white, size: 18),
                label: Text(
                  isEdit ? "Update Event" : "Host Event",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            )),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ==================== BANNER PICKER UI ====================
  Widget _buildBannerPicker() {
    final hasNew = _pickedBanner != null;
    final hasExisting = _existingBannerUrl != null && !_removeExisting;

    // No banner at all
    if (!hasNew && !hasExisting) {
      return InkWell(
        onTap: _pickBanner,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.indigo.withOpacity(0.3), width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add_photo_alternate_rounded,
                    color: Colors.indigo, size: 26),
              ),
              const SizedBox(height: 8),
              const Text("Add Event Banner",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.indigo,
                  )),
              const SizedBox(height: 2),
              Text("JPG, PNG (optional)",
                  style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ],
          ),
        ),
      );
    }

    // New picked file
    if (hasNew) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              File(_pickedBanner!.path!),
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: Colors.grey.shade200,
                child: const Center(child: Icon(Icons.broken_image_rounded, size: 40)),
              ),
            ),
          ),
          Positioned(
            top: 8, right: 8,
            child: Row(
              children: [
                _circleBtn(icon: Icons.edit_rounded, onTap: _pickBanner),
                const SizedBox(width: 8),
                _circleBtn(
                  icon: Icons.close_rounded,
                  color: Colors.red,
                  onTap: _removeBanner,
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Existing (from server)
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            _existingBannerUrl!,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Container(
                height: 180,
                color: Colors.grey.shade100,
                child: const Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (_, __, ___) => Container(
              height: 180,
              color: Colors.grey.shade200,
              child: const Center(child: Icon(Icons.broken_image_rounded, size: 40)),
            ),
          ),
        ),
        Positioned(
          top: 8, right: 8,
          child: Row(
            children: [
              _circleBtn(icon: Icons.edit_rounded, onTap: _pickBanner),
              const SizedBox(width: 8),
              _circleBtn(
                icon: Icons.close_rounded,
                color: Colors.red,
                onTap: _removeBanner,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circleBtn({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.indigo,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6),
          ],
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  // ==================== SMALL WIDGETS ====================
  Widget _label(String t) => Text(t,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700));

  Widget _input(TextEditingController c, String hint, IconData? icon,
      {int maxLines = 1, int? maxLength}) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      maxLength: maxLength,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13),
        prefixIcon: icon != null ? Icon(icon, color: Colors.indigo, size: 18) : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        counterStyle: const TextStyle(fontSize: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.indigo, width: 1.4),
        ),
      ),
    );
  }

  Widget _dateTimeButton({
    required IconData icon,
    required String label,
    required bool isSet,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSet ? Colors.indigo.withOpacity(0.08) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSet ? Colors.indigo.withOpacity(0.4) : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSet ? Colors.indigo : Colors.grey, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSet ? Colors.indigo : Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.indigo, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
              ],
            ),
          ),
          Switch(value: value, activeColor: Colors.indigo, onChanged: onChanged),
        ],
      ),
    );
  }

  // ==================== COLOR HELPERS ====================
  Color _catColor(String c) {
    switch (c) {
      case "Sports": return Colors.green;
      case "Cultural": return Colors.purple;
      case "Academic": return Colors.blue;
      case "Holiday": return Colors.teal;
      case "Meeting": return Colors.orange;
      default: return Colors.grey;
    }
  }

  IconData _catIcon(String c) {
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
}