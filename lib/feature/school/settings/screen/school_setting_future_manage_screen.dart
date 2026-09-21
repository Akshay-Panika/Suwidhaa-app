import 'package:flutter/material.dart';

class SchoolSettingFeatureManageScreen extends StatefulWidget {
  const SchoolSettingFeatureManageScreen({super.key});

  @override
  State<SchoolSettingFeatureManageScreen> createState() =>
      _SchoolSettingFeatureManageScreenState();
}

class _SchoolSettingFeatureManageScreenState
    extends State<SchoolSettingFeatureManageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ============================================================
  // TEACHER FEATURES (Admin controls)
  // ============================================================
  final Map<String, Map<String, dynamic>> _teacherFeatures = {
    "attendance": {
      "title": "Mark Attendance",
      "desc": "Take student attendance",
      "icon": Icons.fact_check_rounded,
      "color": Colors.green,
      "enabled": true,
      "limit": "Unlimited",
    },
    "homework": {
      "title": "Assign Homework",
      "desc": "Create & assign homework",
      "icon": Icons.assignment_rounded,
      "color": Colors.teal,
      "enabled": true,
      "limit": "Unlimited",
    },
    "marks_entry": {
      "title": "Enter Marks",
      "desc": "Enter student exam marks",
      "icon": Icons.grading_rounded,
      "color": Colors.indigo,
      "enabled": true,
      "limit": "Unlimited",
    },
    "notice": {
      "title": "Create Notice",
      "desc": "Publish notices",
      "icon": Icons.campaign_rounded,
      "color": Colors.orange,
      "enabled": true,
      "limit": "5 per day",
    },
    "report_card": {
      "title": "Report Card",
      "desc": "Generate report cards",
      "icon": Icons.card_membership_rounded,
      "color": Colors.deepPurple,
      "enabled": true,
      "limit": "Unlimited",
    },
    "meeting": {
      "title": "Schedule Meeting",
      "desc": "Create PTM & staff meetings",
      "icon": Icons.groups_rounded,
      "color": Colors.blueGrey,
      "enabled": true,
      "limit": "3 per week",
    },
    "documents": {
      "title": "Upload Documents",
      "desc": "Upload & verify docs",
      "icon": Icons.folder_rounded,
      "color": Colors.blue,
      "enabled": true,
      "limit": "10 per day",
    },
    "exam_schedule": {
      "title": "Manage Exams",
      "desc": "Create & edit exam schedules",
      "icon": Icons.event_note_rounded,
      "color": Colors.red,
      "enabled": true,
      "limit": "Unlimited",
    },
    "contact_whatsapp": {
      "title": "WhatsApp Contact",
      "desc": "Message parents on WhatsApp",
      "icon": Icons.chat_rounded,
      "color": const Color(0xFF25D366),
      "enabled": true,
      "limit": "50 per day",
    },
    "salary_view": {
      "title": "View Own Salary",
      "desc": "View salary & payslips",
      "icon": Icons.account_balance_wallet_rounded,
      "color": Colors.cyan,
      "enabled": false,
      "limit": "Unlimited",
    },
    "leave_approve": {
      "title": "Approve Leave",
      "desc": "Approve student leave",
      "icon": Icons.event_busy_rounded,
      "color": Colors.deepOrange,
      "enabled": false,
      "limit": "Unlimited",
    },
    "timetable_edit": {
      "title": "Edit Timetable",
      "desc": "Modify class timetable",
      "icon": Icons.schedule_rounded,
      "color": Colors.purple,
      "enabled": false,
      "limit": "Unlimited",
    },
  };

  // ============================================================
  // STUDENT FEATURES (Admin controls)
  // ============================================================
  final Map<String, Map<String, dynamic>> _studentFeatures = {
    "view_attendance": {
      "title": "View Attendance",
      "desc": "See own attendance",
      "icon": Icons.fact_check_rounded,
      "color": Colors.green,
      "enabled": true,
      "limit": "Unlimited",
    },
    "view_homework": {
      "title": "View Homework",
      "desc": "See assigned homework",
      "icon": Icons.assignment_rounded,
      "color": Colors.teal,
      "enabled": true,
      "limit": "Unlimited",
    },
    "submit_homework": {
      "title": "Submit Homework",
      "desc": "Upload completed homework",
      "icon": Icons.upload_file_rounded,
      "color": Colors.teal,
      "enabled": true,
      "limit": "3 per day",
    },
    "view_marks": {
      "title": "View Marks",
      "desc": "See exam marks",
      "icon": Icons.grading_rounded,
      "color": Colors.indigo,
      "enabled": true,
      "limit": "Unlimited",
    },
    "view_report_card": {
      "title": "View Report Card",
      "desc": "Download report card",
      "icon": Icons.card_membership_rounded,
      "color": Colors.deepPurple,
      "enabled": true,
      "limit": "2 per month",
    },
    "view_timetable": {
      "title": "View Timetable",
      "desc": "See class schedule",
      "icon": Icons.schedule_rounded,
      "color": Colors.purple,
      "enabled": true,
      "limit": "Unlimited",
    },
    "view_notices": {
      "title": "View Notices",
      "desc": "Read school notices",
      "icon": Icons.campaign_rounded,
      "color": Colors.orange,
      "enabled": true,
      "limit": "Unlimited",
    },
    "library": {
      "title": "Library Access",
      "desc": "Browse & issue books",
      "icon": Icons.menu_book_rounded,
      "color": Colors.brown,
      "enabled": true,
      "limit": "2 books per week",
    },
    "library_donate": {
      "title": "Donate Book",
      "desc": "Donate books to library",
      "icon": Icons.volunteer_activism_rounded,
      "color": Colors.teal,
      "enabled": false,
      "limit": "5 per month",
    },
    "view_exams": {
      "title": "View Exam Schedule",
      "desc": "See upcoming exams",
      "icon": Icons.event_note_rounded,
      "color": Colors.red,
      "enabled": true,
      "limit": "Unlimited",
    },
    "leave_request": {
      "title": "Request Leave",
      "desc": "Apply for leave",
      "icon": Icons.event_busy_rounded,
      "color": Colors.deepOrange,
      "enabled": true,
      "limit": "5 per month",
    },
    "transport_track": {
      "title": "Track Bus",
      "desc": "Live bus tracking",
      "icon": Icons.directions_bus_rounded,
      "color": Colors.amber,
      "enabled": false,
      "limit": "Unlimited",
    },
    "fee_view": {
      "title": "View Fees",
      "desc": "See fee details & pay",
      "icon": Icons.payments_rounded,
      "color": Colors.lightGreen,
      "enabled": true,
      "limit": "Unlimited",
    },
    "chat_teacher": {
      "title": "Chat with Teacher",
      "desc": "In-app messaging",
      "icon": Icons.chat_bubble_rounded,
      "color": Colors.greenAccent,
      "enabled": false,
      "limit": "20 per day",
    },
  };

  // ============================================================
  // GLOBAL LIMITS (Rate limits configurable)
  // ============================================================
  final List<String> _limitOptions = [
    "Unlimited",
    "1 per day",
    "2 per day",
    "3 per day",
    "5 per day",
    "10 per day",
    "20 per day",
    "50 per day",
    "2 per week",
    "3 per week",
    "5 per week",
    "2 per month",
    "5 per month",
    "10 per month",
  ];

  // ============================================================
  // STATS
  // ============================================================
  int get _teacherEnabled =>
      _teacherFeatures.values.where((f) => f['enabled'] == true).length;
  int get _teacherTotal => _teacherFeatures.length;

  int get _studentEnabled =>
      _studentFeatures.values.where((f) => f['enabled'] == true).length;
  int get _studentTotal => _studentFeatures.length;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _snack(String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color ?? Colors.indigo,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // TOGGLE FEATURE
  // ============================================================
  void _toggleFeature(
      Map<String, Map<String, dynamic>> target,
      String key,
      bool value,
      ) {
    setState(() => target[key]!['enabled'] = value);
    final title = target[key]!['title'] as String;
    _snack(
      "$title ${value ? 'enabled' : 'disabled'}",
      color: value ? Colors.green : Colors.orange,
    );
  }

  // ============================================================
  // CHANGE LIMIT
  // ============================================================
  void _changeLimit(
      Map<String, Map<String, dynamic>> target,
      String key,
      ) {
    final feature = target[key]!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        constraints:
        BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 45,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (feature['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(feature['icon'] as IconData,
                      color: feature['color'] as Color, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(feature['title'] as String,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text("Set usage limit",
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView.builder(
                itemCount: _limitOptions.length,
                itemBuilder: (context, index) {
                  final option = _limitOptions[index];
                  final selected = feature['limit'] == option;
                  return InkWell(
                    onTap: () {
                      setState(() => feature['limit'] = option);
                      Navigator.pop(ctx);
                      _snack("Limit set: $option", color: Colors.indigo);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.indigo.withOpacity(0.08)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? Colors.indigo
                              : Colors.grey.shade200,
                          width: selected ? 1.4 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            option == "Unlimited"
                                ? Icons.all_inclusive_rounded
                                : Icons.timer_rounded,
                            color:
                            selected ? Colors.indigo : Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(option,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: selected
                                      ? Colors.indigo
                                      : Colors.black87,
                                )),
                          ),
                          if (selected)
                            const Icon(Icons.check_circle_rounded,
                                color: Colors.indigo, size: 18),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BULK ACTIONS
  // ============================================================
  void _bulkEnable(Map<String, Map<String, dynamic>> target) {
    setState(() {
      for (final key in target.keys) {
        target[key]!['enabled'] = true;
      }
    });
    _snack("All features enabled", color: Colors.green);
  }

  void _bulkDisable(Map<String, Map<String, dynamic>> target) {
    setState(() {
      for (final key in target.keys) {
        target[key]!['enabled'] = false;
      }
    });
    _snack("All features disabled", color: Colors.orange);
  }

  // ============================================================
  // BUILD
  // ============================================================
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
        title: const Text("Feature Manager",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        actions: [
          IconButton(
            tooltip: "Save All",
            onPressed: () {
              _snack("All settings saved successfully!",
                  color: Colors.green);
            },
            icon: const Icon(Icons.save_rounded),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle:
          const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: const [
            Tab(text: "Teacher Features"),
            Tab(text: "Student Features"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeatureTab(
            features: _teacherFeatures,
            enabledCount: _teacherEnabled,
            totalCount: _teacherTotal,
            headerColor: Colors.teal,
            headerIcon: Icons.school_rounded,
            headerTitle: "Teacher Access Control",
            headerSubtitle:
            "Control what teachers can do in their app",
            emptyWarning:
            "Disabling all features will make the teacher app empty.",
          ),
          _buildFeatureTab(
            features: _studentFeatures,
            enabledCount: _studentEnabled,
            totalCount: _studentTotal,
            headerColor: Colors.purple,
            headerIcon: Icons.face_rounded,
            headerTitle: "Student Access Control",
            headerSubtitle:
            "Control what students can access in their app",
            emptyWarning:
            "Disabling all features will make the student app empty.",
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FEATURE TAB (Reusable)
  // ============================================================
  Widget _buildFeatureTab({
    required Map<String, Map<String, dynamic>> features,
    required int enabledCount,
    required int totalCount,
    required Color headerColor,
    required IconData headerIcon,
    required String headerTitle,
    required String headerSubtitle,
    required String emptyWarning,
  }) {
    return CustomScrollView(
      slivers: [
        // ===== HEADER CARD =====
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [headerColor, headerColor.withOpacity(0.75)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: headerColor.withOpacity(0.28),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(headerIcon,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(headerTitle,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(headerSubtitle,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 11)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "$enabledCount / $totalCount enabled",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ===== WARNING IF ALL DISABLED =====
        if (enabledCount == 0)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border:
                  Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.red, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(emptyWarning,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // ===== BULK ACTIONS =====
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: _quickAction(
                    icon: Icons.done_all_rounded,
                    label: "Enable All",
                    color: Colors.green,
                    onTap: () => _bulkEnable(features),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _quickAction(
                    icon: Icons.remove_done_rounded,
                    label: "Disable All",
                    color: Colors.orange,
                    onTap: () => _bulkDisable(features),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ===== FEATURE LIST =====
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final key = features.keys.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildFeatureTile(features, key),
                );
              },
              childCount: features.length,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile(
      Map<String, Map<String, dynamic>> target, String key) {
    final f = target[key]!;
    final enabled = f['enabled'] == true;
    final color = f['color'] as Color;
    final limit = f['limit'] as String;
    final isUnlimited = limit == "Unlimited";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: enabled ? color.withOpacity(0.3) : Colors.grey.shade200,
          width: enabled ? 1.2 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: enabled
                      ? color.withOpacity(0.12)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  f['icon'] as IconData,
                  color: enabled ? color : Colors.grey,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Title & desc
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      f['title'] as String,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: enabled
                            ? Colors.black87
                            : Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      f['desc'] as String,
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Toggle
              Switch(
                value: enabled,
                activeColor: color,
                onChanged: (v) => _toggleFeature(target, key, v),
              ),
            ],
          ),

          // ===== LIMIT ROW (only if enabled) =====
          if (enabled) ...[
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _changeLimit(target, key),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isUnlimited
                      ? Colors.green.withOpacity(0.06)
                      : Colors.orange.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isUnlimited
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isUnlimited
                          ? Icons.all_inclusive_rounded
                          : Icons.timer_rounded,
                      color:
                      isUnlimited ? Colors.green : Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text("Usage Limit",
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: isUnlimited
                            ? Colors.green.withOpacity(0.15)
                            : Colors.orange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        limit,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: isUnlimited
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.edit_rounded,
                        size: 13, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}