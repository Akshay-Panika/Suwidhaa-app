import 'dart:async';
import 'package:flutter/material.dart';
import 'package:untitled/core/widget/flutter_toast.dart';

class TeacherCheckinCheckoutScreen extends StatefulWidget {
  const TeacherCheckinCheckoutScreen({super.key});

  @override
  State<TeacherCheckinCheckoutScreen> createState() =>
      _TeacherCheckinCheckoutScreenState();
}

class _TeacherCheckinCheckoutScreenState
    extends State<TeacherCheckinCheckoutScreen> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  DateTime? _checkInTime;
  DateTime? _checkOutTime;

  static const String _teacherName = 'Mrs. Priya Sharma';
  static const String _teacherId = 'TCH-2045';

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // ---------- Helpers ----------

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m:$s $ampm';
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  String _formatClock(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  void _handleCheckIn() {
    setState(() => _checkInTime = DateTime.now());
    FlutterToast.success("Checked in successfully");
  }

  void _handleCheckOut() {
    setState(() => _checkOutTime = DateTime.now());
    FlutterToast.success("Checked out successfully");
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final canCheckIn = _checkInTime == null;
    final canCheckOut = _checkInTime != null && _checkOutTime == null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: () {
          
        }, icon: Icon(Icons.arrow_back_ios)),
        title: const Text(
          'Self Attendance',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Teacher info
            Row(
              children: [
                 CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFE3F2FD),
                  child: Icon(Icons.image, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _teacherId,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      _teacherName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),

                    Text(
                      "Class 11th",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Clock
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    _formatTime(_now),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(_now),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Check-in / Check-out times
            Row(
              children: [
                Expanded(
                  child: _timeBox(
                    label: 'Check-in',
                    time: _checkInTime == null
                        ? '--:--'
                        : _formatClock(_checkInTime!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _timeBox(
                    label: 'Check-out',
                    time: _checkOutTime == null
                        ? '--:--'
                        : _formatClock(_checkOutTime!),
                  ),
                ),
              ],
            ),

            Expanded(child: const SizedBox(height: 24)),

            // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: canCheckIn ? _handleCheckIn : null,
                  icon: const Icon(Icons.login),
                  label: const Text('Check In'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: canCheckOut ? _handleCheckOut : null,
                  icon: const Icon(Icons.logout),
                  label: const Text('Check Out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
            SizedBox(height: 30)
          ],
        ),
      ),
    );
  }

  Widget _timeBox({required String label, required String time}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Text(
            time,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}