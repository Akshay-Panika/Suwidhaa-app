import 'package:flutter/material.dart';

class TeacherAssignNoticeScreen extends StatefulWidget {
  const TeacherAssignNoticeScreen({super.key});

  @override
  State<TeacherAssignNoticeScreen> createState() =>
      _TeacherAssignNoticeScreenState();
}

class _TeacherAssignNoticeScreenState extends State<TeacherAssignNoticeScreen>
    with SingleTickerProviderStateMixin {
  // ==================== TAB ====================
  late TabController _tabController;

  // ==================== FORM STATE ====================
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _customAudienceCtrl = TextEditingController();

  String _priority = "Normal"; // Normal | Important | Urgent
  String _selectedClass = "All Classes";
  String _selectedAudience = "Students"; // Students | Parents | Both | Staff
  bool _scheduleLater = false;
  DateTime? _scheduleDate;
  TimeOfDay? _scheduleTime;
  String? _attachName;
  bool _pinNotice = false;
  bool _sendPush = true;

  // ==================== DATA ====================
  final List<String> _classes = [
    "All Classes",
    "Class 10 - A",
    "Class 10 - B",
    "Class 9 - A",
    "Class 9 - B",
    "Class 8 - A",
  ];

  final List<String> _audiences = ["Students", "Parents", "Both", "Staff"];

  final List<Map<String, dynamic>> _noticeHistory = [
    {
      "title": "Annual Sports Meet",
      "desc": "Sports meet on 15th Oct. All students must report by 8 AM.",
      "priority": "Important",
      "audience": "Both",
      "class": "All Classes",
      "date": "22 Sep 2025",
      "status": "Active",
      "pinned": true,
    },
    {
      "title": "Maths Unit Test",
      "desc": "Unit test on Chapter 5-7 scheduled for 28th Sep.",
      "priority": "Urgent",
      "audience": "Students",
      "class": "Class 10 - A",
      "date": "20 Sep 2025",
      "status": "Active",
      "pinned": false,
    },
    {
      "title": "Parent-Teacher Meeting",
      "desc": "PTM on 5th Oct from 10 AM to 1 PM.",
      "priority": "Normal",
      "audience": "Parents",
      "class": "Class 10 - A",
      "date": "18 Sep 2025",
      "status": "Expired",
      "pinned": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _customAudienceCtrl.dispose();
    super.dispose();
  }

  // ==================== HELPERS ====================
  Color _priorityColor(String p) {
    switch (p) {
      case "Urgent":
        return Colors.red;
      case "Important":
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _priorityIcon(String p) {
    switch (p) {
      case "Urgent":
        return Icons.priority_high_rounded;
      case "Important":
        return Icons.star_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  Color _audienceColor(String a) {
    switch (a) {
      case "Parents":
        return Colors.purple;
      case "Both":
        return Colors.teal;
      case "Staff":
        return Colors.blueGrey;
      default:
        return Colors.indigo;
    }
  }

  void _snack(String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color ?? Colors.red.shade400,
      ),
    );
  }

  // ==================== DATE / TIME PICKER ====================
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _scheduleDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.indigo),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _scheduleDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _scheduleTime ?? TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.indigo),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _scheduleTime = picked);
  }

  String _formatDate(DateTime d) {
    const m = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return "${d.day} ${m[d.month - 1]} ${d.year}";
  }

  // ==================== SUBMIT ====================
  void _submitNotice() {
    if (_titleCtrl.text.trim().isEmpty) {
      _snack("Please enter a notice title");
      return;
    }
    if (_descCtrl.text.trim().isEmpty) {
      _snack("Please enter notice description");
      return;
    }
    if (_scheduleLater && (_scheduleDate == null || _scheduleTime == null)) {
      _snack("Please select schedule date & time");
      return;
    }

    final now = DateTime.now();
    final newNotice = {
      "title": _titleCtrl.text.trim(),
      "desc": _descCtrl.text.trim(),
      "priority": _priority,
      "audience": _selectedAudience,
      "class": _selectedClass,
      "date": _formatDate(now),
      "status": _scheduleLater ? "Scheduled" : "Active",
      "pinned": _pinNotice,
    };

    setState(() {
      _noticeHistory.insert(0, newNotice);
    });

    _showSuccessSheet(newNotice);

    // reset form
    _titleCtrl.clear();
    _descCtrl.clear();
    _customAudienceCtrl.clear();
    setState(() {
      _priority = "Normal";
      _selectedClass = "All Classes";
      _selectedAudience = "Students";
      _scheduleLater = false;
      _scheduleDate = null;
      _scheduleTime = null;
      _attachName = null;
      _pinNotice = false;
      _sendPush = true;
    });
  }

  void _showSuccessSheet(Map<String, dynamic> n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: Colors.green, size: 44),
            ),
            const SizedBox(height: 16),
            const Text("Notice Published!",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(
              "\"${n['title']}\" has been sent to ${n['audience']} of ${n['class']}.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _tabController.animateTo(1);
                },
                child: const Text("View in History",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== DELETE ====================
  void _deleteNotice(int index) {
    final n = _noticeHistory[index];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Notice?"),
        content: Text("Delete \"${n['title']}\"?",
            style: const TextStyle(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              setState(() => _noticeHistory.removeAt(index));
              _snack("Notice deleted", color: Colors.orange);
            },
            child: const Text("Delete",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Assign Notice",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 13),
          tabs: const [
            Tab(text: "Create"),
            Tab(text: "History"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCreateTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  // ==================== CREATE TAB ====================
  Widget _buildCreateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.campaign_rounded,
                    color: Colors.blue, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Create a notice and assign it to specific classes, students, or parents. Use priority to highlight important updates.",
                    style:
                    TextStyle(fontSize: 12, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ===== Priority Picker =====
          _sectionTitle("Priority"),
          const SizedBox(height: 8),
          Row(
            children: ["Normal", "Important", "Urgent"].map((p) {
              final sel = _priority == p;
              final c = _priorityColor(p);
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: p == "Urgent" ? 0 : 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _priority = p),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: sel
                            ? c.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: sel ? c : Colors.grey.shade200,
                          width: sel ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(_priorityIcon(p),
                              color: sel ? c : Colors.grey, size: 20),
                          const SizedBox(height: 4),
                          Text(p,
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                sel ? c : Colors.grey.shade700,
                                fontWeight: sel
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 18),

          // ===== Title =====
          _sectionTitle("Notice Title"),
          const SizedBox(height: 8),
          _inputField(
            controller: _titleCtrl,
            hint: "e.g. Annual Sports Meet 2025",
            icon: Icons.title_rounded,
            maxLength: 80,
          ),

          const SizedBox(height: 18),

          // ===== Description =====
          _sectionTitle("Description"),
          const SizedBox(height: 8),
          _inputField(
            controller: _descCtrl,
            hint: "Write detailed notice here...",
            icon: Icons.notes_rounded,
            maxLines: 5,
            maxLength: 500,
          ),

          const SizedBox(height: 18),

          // ===== Class =====
          _sectionTitle("Assign to Class"),
          const SizedBox(height: 8),
          _dropdown(
            value: _selectedClass,
            items: _classes,
            icon: Icons.class_rounded,
            onChanged: (v) => setState(() => _selectedClass = v!),
          ),

          const SizedBox(height: 18),

          // ===== Audience =====
          _sectionTitle("Audience"),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _audiences.map((a) {
              final sel = _selectedAudience == a;
              final c = _audienceColor(a);
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      a == "Students"
                          ? Icons.school_rounded
                          : a == "Parents"
                          ? Icons.family_restroom_rounded
                          : a == "Both"
                          ? Icons.groups_rounded
                          : Icons.badge_rounded,
                      size: 15,
                      color: sel ? Colors.white : c,
                    ),
                    const SizedBox(width: 6),
                    Text(a),
                  ],
                ),
                selected: sel,
                onSelected: (_) =>
                    setState(() => _selectedAudience = a),
                selectedColor: c,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: sel ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                side: BorderSide(
                    color: sel ? c : Colors.grey.shade300),
              );
            }).toList(),
          ),

          const SizedBox(height: 18),

          // ===== Attachment =====
          _sectionTitle("Attachment (optional)"),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              setState(() {
                _attachName =
                "attachment_${DateTime.now().millisecondsSinceEpoch}.pdf";
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
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
                    child: const Icon(Icons.attach_file_rounded,
                        color: Colors.indigo, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _attachName ?? "Attach file (PDF, Image)",
                      style: TextStyle(
                        fontSize: 13,
                        color: _attachName != null
                            ? Colors.black87
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  if (_attachName != null)
                    IconButton(
                      onPressed: () =>
                          setState(() => _attachName = null),
                      icon: const Icon(Icons.close_rounded,
                          size: 18, color: Colors.red),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ===== Schedule =====
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.schedule_rounded,
                          color: Colors.indigo, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text("Schedule for later",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ),
                    Switch(
                      value: _scheduleLater,
                      activeColor: Colors.indigo,
                      onChanged: (v) =>
                          setState(() => _scheduleLater = v),
                    ),
                  ],
                ),
                if (_scheduleLater) ...[
                  const Divider(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _dateTimeButton(
                          icon: Icons.calendar_today_rounded,
                          label: _scheduleDate == null
                              ? "Select Date"
                              : _formatDate(_scheduleDate!),
                          isSet: _scheduleDate != null,
                          onTap: _pickDate,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _dateTimeButton(
                          icon: Icons.access_time_rounded,
                          label: _scheduleTime == null
                              ? "Select Time"
                              : _scheduleTime!.format(context),
                          isSet: _scheduleTime != null,
                          onTap: _pickTime,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ===== Toggles =====
          _toggleTile(
            icon: Icons.push_pin_rounded,
            title: "Pin to top",
            subtitle: "Keep notice at top of list",
            value: _pinNotice,
            onChanged: (v) => setState(() => _pinNotice = v),
          ),
          const SizedBox(height: 10),
          _toggleTile(
            icon: Icons.notifications_active_rounded,
            title: "Send push notification",
            subtitle: "Alert audience instantly",
            value: _sendPush,
            onChanged: (v) => setState(() => _sendPush = v),
          ),

          const SizedBox(height: 24),

          // ===== Submit =====
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _submitNotice,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 18),
              label: const Text("Publish Notice",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // ==================== HISTORY TAB ====================
  Widget _buildHistoryTab() {
    if (_noticeHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded,
                size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 10),
            Text("No notices yet",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    // Sort pinned first
    final list = [..._noticeHistory];
    list.sort((a, b) {
      final pa = a['pinned'] == true ? 0 : 1;
      final pb = b['pinned'] == true ? 0 : 1;
      return pa.compareTo(pb);
    });

    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final n = list[index];
        final realIndex = _noticeHistory.indexOf(n);
        return _buildNoticeCard(n, realIndex);
      },
    );
  }

  Widget _buildNoticeCard(Map<String, dynamic> n, int index) {
    final pc = _priorityColor(n['priority'] as String);
    final ac = _audienceColor(n['audience'] as String);
    final isActive = n['status'] == "Active";

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: pc.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_priorityIcon(n['priority'] as String),
                    color: pc, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (n['pinned'] == true) ...[
                          const Icon(Icons.push_pin_rounded,
                              size: 14, color: Colors.orange),
                          const SizedBox(width: 4),
                        ],
                        Flexible(
                          child: Text(
                            n['title'] as String,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(n['date'] as String,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded,
                    color: Colors.grey, size: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onSelected: (v) {
                  if (v == "delete") _deleteNotice(index);
                  if (v == "pin") {
                    setState(() =>
                    n['pinned'] = !(n['pinned'] as bool));
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: "pin",
                    child: Row(
                      children: [
                        Icon(
                          n['pinned'] == true
                              ? Icons.push_pin_outlined
                              : Icons.push_pin_rounded,
                          size: 18,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 10),
                        Text(n['pinned'] == true
                            ? "Unpin"
                            : "Pin to top"),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: "delete",
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded,
                            size: 18, color: Colors.red),
                        SizedBox(width: 10),
                        Text("Delete",
                            style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            n['desc'] as String,
            style: TextStyle(fontSize: 12, color: Colors.grey[800]),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _tag(n['priority'] as String, pc),
              _tag(n['audience'] as String, ac,
                  icon: Icons.groups_rounded),
              _tag(n['class'] as String, Colors.grey.shade600,
                  icon: Icons.class_rounded),
              _tag(
                n['status'] as String,
                isActive ? Colors.green : Colors.grey,
              ),
            ],
          ),
        ],
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

  // ==================== SMALL WIDGETS ====================
  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700));
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13),
        prefixIcon:
        Icon(icon, color: Colors.indigo, size: 18),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 14),
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
          borderSide:
          const BorderSide(color: Colors.indigo, width: 1.4),
        ),
      ),
    );
  }

  Widget _dropdown<T>({
    required T value,
    required List<T> items,
    required IconData icon,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.indigo),
          style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 13),
          items: items
              .map((e) => DropdownMenuItem<T>(
            value: e,
            child: Row(
              children: [
                Icon(icon, color: Colors.indigo, size: 18),
                const SizedBox(width: 10),
                Text(e.toString()),
              ],
            ),
          ))
              .toList(),
          onChanged: onChanged,
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
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSet
              ? Colors.indigo.withOpacity(0.08)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSet
                ? Colors.indigo.withOpacity(0.4)
                : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSet ? Colors.indigo : Colors.grey, size: 16),
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
                Text(title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey[600])),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: Colors.indigo,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}