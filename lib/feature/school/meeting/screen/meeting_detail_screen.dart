import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/meeting_controller.dart';
import '../model/meeting_model.dart';
import 'meeting_form_screen.dart';

class MeetingDetailScreen extends StatefulWidget {
  final MeetingModel meeting;
  const MeetingDetailScreen({super.key, required this.meeting});

  @override
  State<MeetingDetailScreen> createState() => _MeetingDetailScreenState();
}

class _MeetingDetailScreenState extends State<MeetingDetailScreen> {
  final MeetingController controller = Get.find<MeetingController>();
  late MeetingModel _m;

  @override
  void initState() {
    super.initState();
    _m = widget.meeting;
  }

  Color get _statusColor {
    if (_m.isPast) return Colors.grey;
    if (_m.isToday) return Colors.red;
    return Colors.indigo;
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.indigo,
      ),
    );
  }

  void _copy(String link) {
    Clipboard.setData(ClipboardData(text: link));
    _snack("Link copied!");
  }

  Future<void> _openZoom() async {
    if (!_m.hasZoom) {
      _snack("No Zoom link available");
      return;
    }
    try {
      final uri = Uri.parse(_m.zoomUrl!);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        _snack("Could not open link");
      }
    } catch (_) {
      _snack("Invalid link");
    }
  }

  Future<void> _edit() async {
    final result = await Get.to(() => MeetingFormScreen(meeting: _m));
    if (result == true) {
      // Refresh detail from controller list
      final updated =
      controller.meetings.firstWhereOrNull((x) => x.id == _m.id);
      if (updated != null) {
        setState(() => _m = updated);
      }
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Meeting"),
        content: const Text("Are you sure you want to delete this meeting?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final ok = await controller.deleteMeeting(_m.id);
      if (ok && mounted) {
        Get.back(result: true);
      }
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
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: Colors.white),
        ),
        title: const Text("Meeting Details",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 17)),
        actions: [
          IconButton(
            onPressed: _edit,
            icon: const Icon(Icons.edit_rounded, color: Colors.white),
          ),
          IconButton(
            onPressed: _delete,
            icon: const Icon(Icons.delete_outline_rounded,
                color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_m.title,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              "${_m.className ?? '-'} • ${_m.dateShort} • ${_m.timePretty}",
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _pill(_m.statusLabel, color: _statusColor),
                const SizedBox(width: 6),
                _pill(_m.forMeeting, color: Colors.indigo),
              ],
            ),
            const SizedBox(height: 28),
            _infoRow(Icons.videocam_rounded, "Zoom Link",
                _m.zoomUrl ?? "Not provided"),
            const SizedBox(height: 12),
            _infoRow(Icons.calendar_today_rounded, "Date", _m.date),
            const SizedBox(height: 12),
            _infoRow(Icons.access_time_rounded, "Time", _m.time),
            const SizedBox(height: 12),
            _infoRow(Icons.class_rounded, "Class", _m.className ?? '-'),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _openZoom,
                    icon: const Icon(Icons.videocam_rounded,
                        color: Colors.white, size: 18),
                    label: const Text("Join",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                    _m.hasZoom ? _copy(_m.zoomUrl!) : _snack("No link"),
                    icon: Icon(Icons.copy_rounded,
                        size: 16, color: Colors.grey.shade800),
                    label: Text("Copy",
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
  }

  Widget _pill(String text, {required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.indigo),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey[600])),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}