import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:untitled/core/utils/app_color.dart';
import 'package:untitled/core/widget/flutter_toast.dart';
import 'package:untitled/feature/school/library/screen/school_library_screen.dart';
import 'package:untitled/feature/school/event/screen/school_event_screen.dart';
import 'package:untitled/feature/school/result/screen/result_screen.dart';

// ✅ ADD these imports
import '../../../ott/dashboard/screen/ott_dashboard_screen.dart';
import '../../../ott/school/screen/ott_school_screen.dart';
import '../../../ott/school/controller/record_video_controller.dart';
// ⚠️ Adjust this path to your actual file location
import '../../auth/service/school_auth_shared_pref_service.dart';
import '../../event/controller/school_event_controller.dart';
import '../../event/widget/school_current_event_card.dart';
import '../../exams/screen/class_exam_timetable_list_screen.dart';
import '../../homework/screen/student_homework_screen.dart';
import '../../leave/screen/student_leave_list_screen.dart';
import '../../meeting/screen/school_meeting_screen.dart';
import '../../notice/controller/notice_controller.dart';
import '../../notice/screen/teacher_assign_notice_screen.dart';
import '../../notice/widget/notice_pined_card.dart';
import '../../payment/screen/student_fee_screen.dart';
import '../../report/screen/student_report_card_screen.dart';
import '../widget/student_profile_card.dart';

class SchoolStudentHomeScreen extends StatefulWidget {
  final Function(int index)? onNavigate;
  const SchoolStudentHomeScreen({super.key, this.onNavigate});

  @override
  State<SchoolStudentHomeScreen> createState() =>
      _SchoolStudentHomeScreenState();
}

class _SchoolStudentHomeScreenState extends State<SchoolStudentHomeScreen> {
  final _schoolEvent = Get.find<SchoolEventController>();
  final _schoolNotice = Get.find<NoticeController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_schoolEvent.events.isEmpty && !_schoolEvent.isLoading.value) {
        _schoolEvent.fetchEvents(silent: true);
      }
      if (_schoolNotice.notices.isEmpty && !_schoolNotice.isLoading.value) {
        _schoolNotice.fetchNotices(silent: true);
      }
    });
  }

  final List<AcademicItem> _studentManagement = [
    AcademicItem(label: "Profile", icon: Icons.person, color: Colors.indigo),
    AcademicItem(
        label: "My Attendance",
        icon: Icons.calendar_month,
        color: Colors.indigo),
    AcademicItem(
        label: "Leave",
        icon: Icons.event_busy_rounded,
        color: Colors.indigo),
    AcademicItem(label: "Fee", icon: Icons.payment, color: Colors.indigo),
    AcademicItem(
        label: "Homework",
        icon: Icons.assignment_rounded,
        color: Colors.teal),
    AcademicItem(
        label: "Report Card",
        icon: Icons.card_membership_rounded,
        color: Colors.teal),
  ];

  final List<AcademicItem> _schoolFeatures = [
    AcademicItem(label: "Exams", icon: Icons.school, color: Colors.teal),
    AcademicItem(
        label: "Notice",
        icon: Icons.campaign_rounded,
        color: Colors.blueGrey),
    AcademicItem(
        label: "Events", icon: Icons.event_rounded, color: Colors.blueGrey),
    AcademicItem(
        label: "Library",
        icon: Icons.menu_book_rounded,
        color: Colors.blueGrey),
    AcademicItem(label: "Result", icon: Icons.notes, color: Colors.blueGrey),
    AcademicItem(
        label: "Transport",
        icon: Icons.directions_bus_rounded,
        color: Colors.blueGrey),
    AcademicItem(
        label: "Meetings",
        icon: Icons.groups_rounded,
        color: Colors.blueGrey),
    AcademicItem(
        label: "OTT",
        icon: Icons.video_camera_back_outlined,
        color: Colors.blueGrey),
  ];

  void _snack(String msg, {Color? color}) {
    FlutterToast.error(msg);
  }

  void _push(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  // ============================================================
  // ✅ NEW: Open OTT directly into student's class videos
  // ============================================================
  Future<void> _openStudentClassOTT() async {
    try {
      // 1. Get or create controller (same instance used by OttSchoolScreen)
      final videoCtrl = Get.isRegistered<RecordVideoController>()
          ? Get.find<RecordVideoController>()
          : Get.put(RecordVideoController());

      // 2. Wait briefly for classes to load (onInit fetch)
      if (videoCtrl.classes.isEmpty) {
        final deadline = DateTime.now().add(const Duration(seconds: 3));
        while (videoCtrl.classes.isEmpty &&
            DateTime.now().isBefore(deadline)) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }

      // 3. Read student's class from shared prefs
      final studentClass =
      await SchoolAuthSharedPrefService.getStudentClass();

      if (studentClass == null || studentClass.trim().isEmpty) {
        // No class in prefs → fall back to manual selection
        _push(const OttDashboardScreen(currentIndex: 3));
        return;
      }

      // 4. Match against available classes (5 == Class 5 == V == 5th etc.)
      final targetKey = _classKey(studentClass);
      dynamic matched;
      for (final c in videoCtrl.classes) {
        if (_classKey(c.name) == targetKey) {
          matched = c;
          break;
        }
      }

      if (matched == null) {
        FlutterToast.error('Class "$studentClass" not found');
        _push(const OttDashboardScreen(currentIndex: 3));
        return;
      }

      // 5. Select the class + push SchoolVideosScreen
      videoCtrl.selectClass(matched);
      await Get.to(() => const SchoolVideosScreen());
      videoCtrl.clearSelection();
    } catch (e) {
      FlutterToast.error('Could not open class videos');
      _push(const OttDashboardScreen(currentIndex: 3));
    }
  }

  /// Normalize a class name so "5", "Class 5", "V", "5th" all → "5"
  String _classKey(String? input) {
    if (input == null || input.trim().isEmpty) return '';
    final lower = input.toLowerCase().trim();

    // Pre-primary specials
    if (lower.contains('nursery')) return 'nursery';
    if (lower.contains('lkg')) return 'lkg';
    if (lower.contains('ukg')) return 'ukg';

    // Digits first
    final digits = RegExp(r'\d+').firstMatch(lower)?.group(0);
    if (digits != null) return digits;

    // Roman numerals
    const romanMap = {
      'i': '1', 'ii': '2', 'iii': '3', 'iv': '4', 'v': '5',
      'vi': '6', 'vii': '7', 'viii': '8', 'ix': '9', 'x': '10',
      'xi': '11', 'xii': '12',
    };
    final alpha = lower.replaceAll(RegExp(r'[^a-z]'), '');
    return romanMap[alpha] ?? alpha;
  }

  // ============================================================
  // BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 160,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.indigo,
            pinned: false,
            floating: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background:
              StudentProfileCard(onNavigate: widget.onNavigate),
            ),
          ),
          SliverToBoxAdapter(child: SchoolCurrentEventCard()),
          SliverToBoxAdapter(
            child: _buildSection(
              title: "Student Management",
              items: _studentManagement,
              builder: _buildStudentCard,
            ),
          ),
          SliverToBoxAdapter(child: NoticePinedCard()),
          SliverToBoxAdapter(
            child: _buildSection(
              title: "School Features",
              items: _schoolFeatures,
              builder: _buildSchoolCard,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 150)),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<AcademicItem> items,
    required Widget Function(AcademicItem) builder,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.indigo, width: 0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10,
            children: [
              Container(height: 14, width: 3, color: Colors.indigo),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GridView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) => builder(items[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(AcademicItem item) {
    return Column(
      children: [
        Material(
          color: Colors.indigo.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              switch (item.label) {
                case "My Attendance":
                  widget.onNavigate?.call(1);
                  break;
                case "Profile":
                  widget.onNavigate?.call(3);
                  break;
                case "Leave":
                  _push(const StudentLeaveListScreen());
                  break;
                case "Fee":
                  _push(StudentFeeScreen());
                  break;
                case "Homework":
                  _push(const StudentHomeworkScreen());
                  break;
                case "Report Card":
                  _push(const StudentReportCardScreen());
                  break;
                default:
                  _snack('${item.label} tapped');
              }
            },
            child: SizedBox(
              height: 70,
              width: double.infinity,
              child: Icon(item.icon, color: Colors.indigo, size: 28),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          item.label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildSchoolCard(AcademicItem item) {
    return Column(
      children: [
        Material(
          color: Colors.blueGrey.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              switch (item.label) {
                case "Exams":
                  _push(const ClassExamTimetableListScreen());
                  break;
                case "Notice":
                  _push(const TeacherAssignNoticeScreen());
                  break;
                case "Events":
                  _push(const SchoolEventScreen());
                  break;
                case "Library":
                  _push(const SchoolLibraryScreen());
                  break;
                case "Result":
                  _push(const ResultScreen());
                  break;
                case "Transport":
                  widget.onNavigate?.call(2);
                  break;
                case "Meetings":
                  _push(const SchoolMeetingScreen());
                  break;
                case "OTT":
                // ✅ CHANGED — jump straight to student's class videos
                  _openStudentClassOTT();
                  break;
                default:
                  _snack('${item.label} tapped');
              }
            },
            child: SizedBox(
              height: 70,
              width: double.infinity,
              child: Icon(item.icon, color: Colors.blueGrey, size: 26),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          item.label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ==================== MODELS ====================
class AcademicItem {
  final String label;
  final IconData icon;
  final Color color;

  AcademicItem({
    required this.label,
    required this.icon,
    required this.color,
  });
}

class OtherItem {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;

  OtherItem({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}