import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../controller/school_event_controller.dart';
import '../model/school_event_model.dart';
import 'school_event_form_screen.dart';

class SchoolEventDetailsScreen extends StatefulWidget {
  final SchoolEventModel event;
  const SchoolEventDetailsScreen({super.key, required this.event});

  @override
  State<SchoolEventDetailsScreen> createState() => _SchoolEventDetailsScreenState();
}

class _SchoolEventDetailsScreenState extends State<SchoolEventDetailsScreen> {
  final _ctrl = Get.find<SchoolEventController>();
  late SchoolEventModel _e;

  @override
  void initState() {
    super.initState();
    _e = widget.event;
  }

  // ==================== HELPERS ====================
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

  // ==================== ACTIONS ====================
  Future<void> _delete() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Event?"),
        content: Text("Delete \"${_e.title}\"?",
            style: const TextStyle(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Get.back(result: true),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    final ok = await _ctrl.deleteEvent(_e.id);
    if (ok) {
      FlutterToast.success("Event deleted");
      Get.back(result: true);
    } else {
      FlutterToast.error(_ctrl.error.value);
    }
  }

  Future<void> _edit() async {
    await Get.to(() => SchoolEventFormScreen(event: _e));
    final fresh = _ctrl.events.firstWhereOrNull((x) => x.id == _e.id);
    if (fresh != null) setState(() => _e = fresh);
  }

  Future<void> _togglePin() async {
    final ok = await _ctrl.togglePin(_e.id);
    if (ok) {
      final fresh = _ctrl.events.firstWhereOrNull((x) => x.id == _e.id);
      if (fresh != null) setState(() => _e = fresh);
    } else {
      FlutterToast.error(_ctrl.error.value);
    }
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    final cc = _catColor(_e.category);
    final sc = _statusColor(_e.status);

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
        title: const Text("Event Details",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        actions: [
          // IconButton(
          //   onPressed: _togglePin,
          //   icon: Icon(
          //     _e.isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
          //     color: _e.isPinned ? Colors.orange : Colors.white,
          //   ),
          // ),
          // IconButton(onPressed: _edit, icon: const Icon(Icons.edit_rounded)),
          // IconButton(onPressed: _delete, icon: const Icon(Icons.delete_outline_rounded)),

          InkWell(
            onTap: _togglePin,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 0.3),
              ),
              child:Icon(size: 20,
                _e.isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                color: _e.isPinned ? Colors.orange : Colors.white,
              ),
            ),
          ),
          SizedBox(width: 20,),
          InkWell(
            onTap: _edit,
            child:  Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 0.3),
                ),
                child: Icon(Icons.edit_rounded, size: 20,)),
          ),
          SizedBox(width: 20,),
          InkWell(
            onTap: _delete,
            child:  Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 0.3),
                ),
                child: Icon(Icons.delete_outline_rounded, size: 20,)),
          ),
          SizedBox(width: 20,),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _e.hasBanner
                  ? Image.network(
                _e.bannerUrl!,
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
                errorBuilder: (_, __, ___) => _headerPlaceholder(cc),
              )
                  : _headerPlaceholder(cc),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                _chip(_catIcon(_e.category), _e.category, cc),
                const SizedBox(width: 8),
                _chip(Icons.circle, _e.status, sc, small: true),
                const Spacer(),
                if (_e.isPinned)
                  _chip(Icons.push_pin_rounded, "Pinned", Colors.orange),
              ],
            ),
            const SizedBox(height: 14),

            Text(_e.title,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800, height: 1.3)),
            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: _infoTile(
                    icon: Icons.calendar_today_rounded,
                    color: Colors.indigo,
                    label: "Date",
                    value: _e.isMultiDay ? "${_e.startDate} → ${_e.endDate}" : _e.startDate,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _infoTile(
                    icon: Icons.access_time_rounded,
                    color: Colors.deepOrange,
                    label: "Time",
                    value: "${_e.startTime} → ${_e.endTime}",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _infoTile(
                    icon: Icons.location_on_rounded,
                    color: Colors.redAccent,
                    label: "Venue",
                    value: _e.venue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _infoTile(
                    icon: Icons.groups_rounded,
                    color: Colors.teal,
                    label: "Audience",
                    value: _e.audience,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            const Text("About Event",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(_e.description,
                  style: const TextStyle(fontSize: 13, height: 1.5)),
            ),
            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _delete,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: const Text("Delete",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _edit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 18),
                    label: const Text("Edit",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ==================== SMALL WIDGETS ====================
  Widget _headerPlaceholder(Color cc) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cc.withOpacity(0.25), cc.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(child: Icon(_catIcon(_e.category), size: 56, color: cc)),
    );
  }

  Widget _chip(IconData icon, String text, Color color, {bool small = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: small ? 8 : 13, color: color),
          const SizedBox(width: 6),
          Text(text,
              style: TextStyle(
                  fontSize: 11, color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700, height: 1.3)),
        ],
      ),
    );
  }
}