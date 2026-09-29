import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:untitled/core/utils/app_color.dart';
import 'package:untitled/core/widget/flutter_toast.dart';
import 'package:untitled/feature/school/library/screen/school_library_screen.dart';
import 'package:untitled/feature/school/attendance/screen/class_attendance_screen.dart';
import 'package:untitled/feature/school/event/screen/school_event_screen.dart';
import 'package:untitled/feature/school/homework/screen/teacher_home_work_screen.dart';
import '../../../ott/dashboard/screen/ott_dashboard_screen.dart';
import '../../admission/screen/admission_inquiry_screen.dart';
import '../../event/controller/school_event_controller.dart';
import '../../event/widget/school_current_event_card.dart';
import '../../leave/screen/student_leave_request_screen.dart';
import '../../attendance/screen/teacher_leave_list_screen.dart';
import '../../exams/screen/class_exam_timetable_list_screen.dart';
import '../../meeting/screen/school_meeting_screen.dart';
import '../../messages/screen/student_contact_screen.dart';
import '../../notice/controller/notice_controller.dart';
import '../../notice/screen/teacher_assign_notice_screen.dart';
import '../../notice/widget/notice_pined_card.dart';
import '../../payment/screen/teacher_salary_screen.dart';
import '../../report/screen/teacher_assign_report_screen.dart';
import '../../teacher/widget/teacher_checkin_checkout_button.dart';
import '../widget/student_profile_card.dart';

class SchoolStudentHomeScreen extends StatefulWidget {
  final Function(int index)? onNavigate;
  const SchoolStudentHomeScreen({super.key, this.onNavigate});

  @override
  State<SchoolStudentHomeScreen> createState() => _SchoolStudentHomeScreenState();
}

class _SchoolStudentHomeScreenState extends State<SchoolStudentHomeScreen> {

  final _schoolEvent = Get.find<SchoolEventController>();
  final _schoolNotice = Get.find<NoticeController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ Fetch Events (silently)
      if (_schoolEvent.events.isEmpty && !_schoolEvent.isLoading.value) {
        _schoolEvent.fetchEvents(silent: true);
      }

      // ✅ Fetch Notices (silently) — NoticePinedCard ke liye
      if (_schoolNotice.notices.isEmpty && !_schoolNotice.isLoading.value) {
        _schoolNotice.fetchNotices(silent: true);
      }
    });
  }

  final List<AcademicItem> _studentManagement = [
    AcademicItem(
      label: "Profile",
      icon: Icons.person,
      color: Colors.indigo,
    ),
    AcademicItem(
      label: "My Attendance",
      icon: Icons.calendar_month,
      color: Colors.indigo,
    ),
    AcademicItem(
      label: "Leave",
      icon: Icons.event_busy_rounded,
      color: Colors.indigo,
    ),
    AcademicItem(
      label: "Fee",
      icon: Icons.payment,
      color: Colors.indigo,
    ),
    AcademicItem(
      label: "Homework",
      icon: Icons.assignment_rounded,
      color: Colors.teal,
    ),
    AcademicItem(
      label: "Report Card",
      icon: Icons.card_membership_rounded,
      color: Colors.teal,
    ),
  ];

  final List<AcademicItem> _schoolFeatures = [
    AcademicItem(
      label: "Notice",
      icon: Icons.campaign_rounded,
      color: Colors.blueGrey,
    ),
    AcademicItem(
      label: "Events",
      icon: Icons.event_rounded,
      color: Colors.blueGrey,
    ),
    AcademicItem(
      label: "Library",
      icon: Icons.menu_book_rounded,
      color: Colors.blueGrey,
    ),
    AcademicItem(
      label: "Transport",
      icon: Icons.directions_bus_rounded,
      color: Colors.blueGrey,
    ),
    AcademicItem(
      label: "Meetings",
      icon: Icons.groups_rounded,
      color: Colors.blueGrey,
    ),
  ];

  // ==================== HELPER ====================
  void _snack(String msg, {Color? color}) {
    FlutterToast.error(msg);
  }

  void _push(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(backgroundColor: Colors.indigo,automaticallyImplyLeading: false,toolbarHeight: 0,),
      body: CustomScrollView(
        slivers: [
          // ==================== APP BAR ====================
          SliverAppBar(
            toolbarHeight: 160,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.indigo,
            pinned: false,
            floating: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: StudentProfileCard(onNavigate:widget.onNavigate,),
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

          SliverToBoxAdapter(
            child: NoticePinedCard(),
          ),

          // ==================== SCHOOL FEATURES ====================
          SliverToBoxAdapter(
            child: _buildSection(
              title: "School Features",
              items: _schoolFeatures,
              builder: _buildSchoolCard,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 150,),)

        ],
      ),
    );
  }

  // ==================== SECTION BUILDER ====================
  Widget _buildSection({
    required String title,
    required List<AcademicItem> items,
    required Widget Function(AcademicItem) builder,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
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
                childAspectRatio: 0.9
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return builder(item);
              },),
        ],
      ),
    );
  }

  // ==================== STUDENT CARD ====================
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
                  _push(const TeacherLeaveListScreen());
                  break;
                case "Fee":
                  _push(TeacherSalaryScreen());
                  break;
                case "Homework":
                  _push(const TeacherHomeworkScreen());
                  break;
                case "Report Card":
                  _push(const TeacherAssignReportScreen());
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

  // ==================== SCHOOL CARD ====================
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
                case "Notice":
                  _push(const TeacherAssignNoticeScreen());
                  break;
                case "Events":
                  _push(const SchoolEventScreen());
                  break;
                case "Library":
                  _push(const SchoolLibraryScreen());
                  break;
                case "Transport":
                  widget.onNavigate?.call(2);
                  break;
                case "Meetings":
                  _push(const SchoolMeetingScreen());
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