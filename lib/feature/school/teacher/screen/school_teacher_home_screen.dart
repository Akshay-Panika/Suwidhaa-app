import 'package:flutter/material.dart';
import 'package:untitled/core/utils/app_color.dart';
import 'package:untitled/feature/school/library/screen/school_library_screen.dart';
import 'package:untitled/feature/school/attendance/screen/class_attendance_screen.dart';
import 'package:untitled/feature/school/attendance/screen/subject_attendance_screen.dart';
import 'package:untitled/feature/school/event/screen/school_event_screen.dart';
import 'package:untitled/feature/school/homework/screen/teacher_home_work_screen.dart';
import 'package:untitled/feature/school/settings/screen/school_setting_future_manage_screen.dart';
import '../../attendance/screen/teacher_leave_list_screen.dart';
import '../../documets/screen/school_documents_screen.dart';
import '../../exams/screen/exams_schedule_screen.dart';
import '../../meeting/screen/school_meeting_screen.dart';
import '../../messages/screen/student_contact_screen.dart';
import '../../notice/screen/teacher_assign_notice_screen.dart';
import '../../payment/screen/teacher_salary_screen.dart';
import '../../report/screen/teacher_assign_report_screen.dart';
import '../../sports/screen/annual_sports_meet_screen.dart';
import '../widget/teacher_checkin_checkout_button.dart';

class SchoolTeacherHomeScreen extends StatefulWidget {
  final Function(int index)? onNavigate;
  const SchoolTeacherHomeScreen({super.key, this.onNavigate});

  @override
  State<SchoolTeacherHomeScreen> createState() => _SchoolTeacherHomeScreenState();
}

class _SchoolTeacherHomeScreenState extends State<SchoolTeacherHomeScreen> {
  // ==================== DATA ====================
  final List<AcademicItem> _selfManagement = [
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
      label: "Salary",
      icon: Icons.account_balance_wallet_rounded,
      color: Colors.indigo,
    ),
  ];

  final List<AcademicItem> _studentManagement = [
    AcademicItem(
      label: "Attendance",
      icon: Icons.fact_check_rounded,
      color: Colors.teal,
    ),
    AcademicItem(
      label: "Class",
      icon: Icons.grading_rounded,
      color: Colors.teal,
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

  final List<OtherItem> _otherAccess = [
    OtherItem(
      label: "Exams",
      subtitle: "Schedules & results",
      icon: Icons.quiz_rounded,
      color: Colors.blueGrey,
    ),
    OtherItem(
      label: "Messages",
      subtitle: "Chat with parents",
      icon: Icons.chat_bubble_rounded,
      color: Colors.blueGrey,
    ),
    OtherItem(
      label: "Documents",
      subtitle: "Files & resources",
      icon: Icons.folder_rounded,
      color: Colors.blueGrey,
    ),
    OtherItem(
      label: "Settings",
      subtitle: "App preferences",
      icon: Icons.settings_rounded,
      color: Colors.blueGrey,
    ),
  ];

  // ==================== HELPER ====================
  void _snack(String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color ?? Colors.indigo,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _push(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          // ==================== APP BAR ====================
          SliverAppBar(
            toolbarHeight: 160,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.indigo,
            pinned: true,
            floating: false,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              widget.onNavigate?.call(3);
                            },
                            child: CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              child: const Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Good Morning",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Mr. Akshay Panika",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Mathematics • 10th Grade",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Notification screen
                                },
                                icon: const Icon(
                                  Icons.notifications_none_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),

                              Positioned(
                                right: 7,
                                top: 7,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.school_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                "Springfield High School",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "2025-26",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ==================== SELF MANAGEMENT ====================
          SliverToBoxAdapter(
            child: _buildSection(
              title: "Self Management",
              items: _selfManagement,
              builder: _buildSelfCard,
            ),
          ),

          SliverToBoxAdapter(
            child: TeacherCheckinCheckoutButton(),
          ),

          SliverToBoxAdapter(
            child: _buildSection(
              title: "Student Management",
              items: _studentManagement,
              builder: _buildStudentCard,
            ),
          ),

          // ==================== SCHOOL FEATURES ====================
          SliverToBoxAdapter(
            child: _buildSection(
              title: "School Features",
              items: _schoolFeatures,
              builder: _buildSchoolCard,
            ),
          ),

          // ==================== ACTIVITY CARD ====================
          SliverToBoxAdapter(
            child: Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              color: Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.indigo.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.directions_run_rounded,
                              color: Colors.indigo, size: 18),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Annual Sports Meet",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "New activity • Register now",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () =>
                          _push(const AnnualSportsMeetScreen()),
                      child: const Text(
                        "More",
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ==================== OTHER ACCESS ====================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Other Access",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: _otherAccess.length,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.5,
                    ),
                    itemBuilder: (context, index) {
                      return _buildOtherCard(_otherAccess[index]);
                    },
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
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
          Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              return Expanded(
                child: Padding(
                  padding:
                  EdgeInsets.only(right: index == items.length - 1 ? 0 : 8),
                  child: builder(item),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ==================== SELF CARD ====================
  Widget _buildSelfCard(AcademicItem item) {
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
                case "Salary":
                  _push( TeacherSalaryScreen());
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

  // ==================== STUDENT CARD ====================
  Widget _buildStudentCard(AcademicItem item) {
    return Column(
      children: [
        Material(
          color: Colors.teal.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              switch (item.label) {
                case "Attendance":
                  _push(const ClassAttendanceScreen());
                  break;
                case "Class":
                  _push(const SubjectAttendanceScreen());
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
              child: Icon(item.icon, color: Colors.teal, size: 28),
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

  // ==================== OTHER CARD ====================
  Widget _buildOtherCard(OtherItem item) {
    return Material(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          switch (item.label) {
            case "Exams":
              _push(const ExamsScheduleScreen());
              break;
            case "Messages":
              _push(const StudentContactScreen());
              break;
            case "Documents":
              _push(const SchoolDocumentsScreen());
              break;
            case "Settings":
              _push(const SchoolSettingFeatureManageScreen());
              break;
            default:
              _snack('${item.label} tapped');
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.indigo,width: 0.3),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: Colors.blueGrey, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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