import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/meeting_controller.dart';
import '../model/meeting_model.dart';

class MeetingFormScreen extends StatefulWidget {
  /// If null → Create mode. If provided → Update mode.
  final MeetingModel? meeting;
  const MeetingFormScreen({super.key, this.meeting});

  @override
  State<MeetingFormScreen> createState() => _MeetingFormScreenState();
}

class _MeetingFormScreenState extends State<MeetingFormScreen> {
  final MeetingController controller = Get.find<MeetingController>();

  final _titleCtrl = TextEditingController();
  final _zoomCtrl = TextEditingController();

  String _audience = "Student";
  String _className = "10A";
  DateTime? _date;
  TimeOfDay? _time;

  bool get _isEdit => widget.meeting != null;

  @override
  void initState() {
    super.initState();

    if (_isEdit) {
      final m = widget.meeting!;
      _titleCtrl.text = m.title;
      _zoomCtrl.text = m.zoomUrl ?? '';
      _audience = m.forMeeting == 'Staff' ? 'Staff' : 'Student';
      _className = m.className ?? (_audience == 'Student' ? '10A' : 'All Staff');

      try {
        final dt = DateTime.parse(m.date);
        _date = dt;
        final parts = m.time.split(':');
        _time = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _zoomCtrl.dispose();
    super.dispose();
  }

  List<String> get _classList => _audience == 'Student'
      ? ["10A", "10B", "9A", "9B", "11", "12"]
      : ["All Staff", "Teaching Staff", "HODs"];

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty || _date == null || _time == null) {
      Get.snackbar("Missing", "Please fill title, date and time",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade100);
      return;
    }

    final hh = _time!.hour.toString().padLeft(2, '0');
    final mm = _time!.minute.toString().padLeft(2, '0');
    final timeStr = "$hh:$mm:00";
    final dateStr = DateFormat('yyyy-MM-dd').format(_date!);

    bool ok;

    if (_isEdit) {
      ok = await controller.updateMeeting(
        widget.meeting!.id,
        title: _titleCtrl.text.trim(),
        date: dateStr,
        time: timeStr,
        forMeeting: _audience,
        className: _className,
        zoomUrl: _zoomCtrl.text.trim().isEmpty ? null : _zoomCtrl.text.trim(),
      );
    } else {
      ok = await controller.createMeeting(
        title: _titleCtrl.text.trim(),
        date: dateStr,
        time: timeStr,
        forMeeting: _audience,
        className: _className,
        zoomUrl: _zoomCtrl.text.trim().isEmpty ? null : _zoomCtrl.text.trim(),
      );
    }

    if (ok && mounted) {
      Get.back(result: true);
    }
  }

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
        title: Text(_isEdit ? "Update Meeting" : "New Meeting",
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 17)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Audience toggle
            Row(
              children: ["Student", "Staff"].map((a) {
                final sel = _audience == a;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: a == "Staff" ? 0 : 8),
                    child: InkWell(
                      onTap: () => setState(() {
                        _audience = a;
                        _className =
                        a == "Student" ? "10A" : "All Staff";
                      }),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: sel
                              ? Colors.indigo.withOpacity(0.06)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: sel
                                ? Colors.indigo
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Center(
                          child: Text(a,
                              style: TextStyle(
                                fontSize: 13,
                                color: sel
                                    ? Colors.indigo
                                    : Colors.grey.shade700,
                                fontWeight: sel
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              )),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // Class dropdown
            DropdownButtonFormField<String>(
              value: _classList.contains(_className) ? _className : null,
              decoration: _inputDeco("Class"),
              items: _classList
                  .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e,
                      style: const TextStyle(fontSize: 13))))
                  .toList(),
              onChanged: (v) => setState(() => _className = v!),
            ),
            const SizedBox(height: 12),

            // Title
            TextField(
              controller: _titleCtrl,
              style: const TextStyle(fontSize: 13),
              decoration:
              _inputDeco("Title", hint: "Chapter 5 - Quadratics"),
            ),
            const SizedBox(height: 12),

            // Zoom URL
            TextField(
              controller: _zoomCtrl,
              style: const TextStyle(fontSize: 13),
              decoration: _inputDeco("Zoom URL",
                  hint: "https://zoom.us/j/123456789"),
            ),
            const SizedBox(height: 12),

            // Date + Time
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final p = await showDatePicker(
                        context: context,
                        initialDate: _date ?? DateTime.now(),
                        firstDate: DateTime.now()
                            .subtract(const Duration(days: 365)),
                        lastDate:
                        DateTime.now().add(const Duration(days: 365)),
                      );
                      if (p != null) setState(() => _date = p);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        _date == null
                            ? "Date"
                            : DateFormat('yyyy-MM-dd').format(_date!),
                        style: TextStyle(
                            fontSize: 12.5,
                            color: _date != null
                                ? Colors.black87
                                : Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final p = await showTimePicker(
                        context: context,
                        initialTime: _time ?? TimeOfDay.now(),
                      );
                      if (p != null) setState(() => _time = p);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        _time == null ? "Time" : _time!.format(context),
                        style: TextStyle(
                            fontSize: 12.5,
                            color: _time != null
                                ? Colors.black87
                                : Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Submit button
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                controller.isCreating.value ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: controller.isCreating.value
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Text(_isEdit ? "Update" : "Create",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
              ),
            )),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(fontSize: 12),
      hintStyle: const TextStyle(fontSize: 12.5),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.indigo),
      ),
    );
  }
}