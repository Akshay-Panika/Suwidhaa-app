class ApiUrls {

  // Auth endpoints
  static const String studentLogin = 'v1/school/student-pass/login/';
  static const String teacherLogin = 'v1/school/teacher-pass/login/';
  
  // Student endpoints
  static const String studentList = 'v1/school/student/list/';
  static const String studentCreate = 'v1/school/student/create/';
  static const String studentDetail = 'v1/school/student/';  // + id
  static String studentListBySchoolType(String schoolType) => 'v1/school/student/list/school-type/$schoolType/';

  // Student Leave endpoints
  static const String studentLeaveList = 'v1/school/student-leave/list/';
  static const String studentLeaveApproval = 'v1/school/student-leave/approval/';
  static const String studentLeaveByIdCard = 'v1/school/student-leave/list/';
  static const String studentLeaveCreate = 'v1/school/student-leave/create/';
  static const String studentLeaveDetail = 'v1/school/student-leave/';

  // Teacher endpoints
  static const String teacherList = 'v1/school/teacher/list/';
  static const String teacherCreate = 'v1/school/teacher/create/';
  static const String teacherDetail = 'v1/school/teacher/';
  static const String teacherSalarySummary = 'v1/school/teacher/salary/summary/';

  // Teacher Leave endpoints
  static const String teacherLeaveCreate = 'v1/school/teacher-leave/create/';
  static const String teacherLeaveList   = 'v1/school/teacher-leave/list/';
  static const String teacherLeaveDetail = 'v1/school/teacher-leave/'; // + id
  static const String teacherLeaveByIdCard = 'v1/school/teacher-leave/list/'; // + teacher_id_card

  // In your ApiUrls class, add:
  static const String teacherAttendanceHistory = 'v1/school/teacher-attendance/history/';
  static const String teacherAttendanceCheckIn  = 'v1/school/teacher-attendance/check-in/';
  static const String teacherAttendanceCheckOut = 'v1/school/teacher-attendance/check-out/';
  static const String teacherAttendanceToday    = 'v1/school/teacher-attendance/today/';

  // Student Attendance endpoints
  static const String studentAttendanceCreate = 'v1/school/student-attendance/create/';
  static const String studentAttendanceList   = 'v1/school/student-attendance/list/';
  static const String studentAttendanceDetail = 'v1/school/student-attendance/list/';

  // Class endpoints
  static const String classList = 'v1/school/class/list/';
  static const String classCreate = 'v1/school/class/create/';
  static const String classDetail = 'v1/school/class/';  // + id

  // Subject endpoints
  static const String subjectList = 'v1/school/subject/list/';
  static const String subjectCreate = 'v1/school/subject/create/';
  static const String subjectDetail = 'v1/school/subject/';  // + id

  // Schedule endpoints
  static const String scheduleList = 'v1/school/schedule/list/';
  static const String scheduleCreate = 'v1/school/schedule/create/';
  static const String scheduleDetail = 'v1/school/schedule/';  //

  // Homework endpoints
  static const String homeworkList = 'v1/school/homework/list/';
  static const String homeworkCreate = 'v1/school/homework/create/';
  static const String homeworkDetail = 'v1/school/homework/';

  // Transport endpoints
  static const String transportList = 'v1/school/transport/list/';
  static const String transportDetail = 'v1/school/transport/';
  static const String transportCreate = 'v1/school/transport/create/';
  static const String transportAddStudent = 'v1/school/transport/';
  static const String transportRemoveStudent = 'v1/school/transport/';


  // College Banner endpoints
  static const String collegeBannerList = 'v1/college/college-banner/list/';
  static const String collegeBannerDetail = 'v1/college/college-banner/';

  // College endpoints
  static const String collegeList = 'v1/college/colleges/list/';
  static const String collegeDetail = 'v1/college/colleges/';
  static const String collegeBooking = 'v1/college/college-booking/create/';
  static const String collegeBookingList = 'v1/college/college-booking/list/';

  // Room endpoints
  static const String roomCreate = 'v1/college/rooms/create/';
  static const String roomList = 'v1/college/rooms/list/';
  static const String roomDetail = 'v1/college/rooms/';
  static const String roomAllList = 'v1/college/rooms/';

  // Tiffin endpoints
  static const String tiffinCreate = 'v1/college/tiffins/create/';
  static const String tiffinList = 'v1/college/tiffins/list/';
  static const String tiffinDetail = 'v1/college/tiffins/';
  static const String tiffinAllList = 'v1/college/tiffins/';

  // Ott content
  static const String ottBanner = 'v1/ott/banner/list';
  static const String ottContent = 'v1/ott/content/list';
  static const String ottMovieDetail   = 'v1/ott/movies/';
  static const String ottCartoonDetail = 'v1/ott/cartoons/';
  static const String ottSciFiDetail   = 'v1/ott/sci-fi/';
  static const String ottSportDetail   = 'v1/ott/sports/';
  static const String ottWebSeriesDetail = 'v1/ott/webseries/';
  static const String ottReelList = 'v1/ott/reels/list/';
  static const String ottWebSeriesList = 'v1/ott/webseries/list/';

  static String ottDetailPath(String contentType) {
    switch (contentType) {
      case 'movie':
        return ottMovieDetail;
      case 'cartoon':
        return ottCartoonDetail;
      case 'sci_fi':
        return ottSciFiDetail;
      case 'sport':
        return ottSportDetail;
      case 'webseries':
        return ottWebSeriesDetail;
      default:
        return ottContent;
    }
  }


  static const String reportCardCreate      = 'v1/school/report-cards/create/';
  static const String reportCardList        = 'v1/school/report-cards/list/';
  static const String reportCardDetailBase  = 'v1/school/report-cards/list/';       // + id/
  static const String reportCardByAdminBase = 'v1/school/report-cards/adminid/';
  static const String reportCardByStudentBase = 'v1/school/report-cards/student-list/';

  // Meeting endpoints
  static const String meetingCreate = 'v1/school/meeting/create/';
  static const String meetingList   = 'v1/school/meeting/list/';
  static const String meetingDelete = 'v1/school/meeting/delete/';   // + id/
  static String meetingDetail(int id) => 'v1/school/meeting/$id/';

  // ==================== NOTICE ====================
  static const String noticeList   = 'v1/school/notice/list/';
  static const String noticeCreate = 'v1/school/notice/create/';
  static String noticeDetail(int id)   => 'v1/school/notice/$id/';
  static String noticeTogglePin(int id) => 'v1/school/notice/$id/toggle-pin/';

  // ==================== SCHOOL EVENT ====================
  static const String eventList   = 'v1/school/event/list/';
  static const String eventCreate = 'v1/school/event/create/';
  static String eventDetail(int id)    => 'v1/school/event/$id/';
  static String eventTogglePin(int id) => 'v1/school/event/$id/toggle-pin/';

  // ==================== SCHOOL LIBRARY ====================
  static const String libraryCreate = 'v1/school/library/create/';
  static const String libraryList   = 'v1/school/library/list/';
  static String libraryDetail(int id) => 'v1/school/library/$id/';

  // ==================== EXAM TIMETABLE ====================
  static const String examTimetableCreate = 'v1/school/exam-timetables/create/';
  static const String examTimetableList   = 'v1/school/exam-timetables/list/';
  static String examTimetableDetail(int id) => 'v1/school/exam-timetables/$id/';

  // ==================== NGO BANNER ====================
  static const String ngoBannerCreate = 'v1/ngo/banner/create/';
  static const String ngoBannerList   = 'v1/ngo/banner/list/';

  static const String ngoCategoryList   = 'v1/ngo/category/list/';

  static const String ngoServiceList   = 'v1/ngo/service/list/';
  static const String ngoServiceDetail = 'v1/ngo/service/';

  // ==================== NGO STAFF ====================
  static const String ngoStaffList   = 'v1/ngo/staff/list/';
  static const String ngoStaffCreate = 'v1/ngo/staff/create/';
  static const String ngoStaffDetail = 'v1/ngo/staff/'; // + id/

// ==================== NGO HISTORY ====================
  static const String ngoHistoryCreate = 'v1/ngo/history/create/';
  static const String ngoHistoryList   = 'v1/ngo/history/list/';
  static String ngoHistoryByDonor(int donorId) =>
      'v1/ngo/history/donor/$donorId/';
  static String ngoHistoryDetail(int id) => 'v1/ngo/history/$id/';

  static const String itServiceBannerList = 'v1/it_service/banner/list/';
  static const String itServiceCategoryList = 'v1/it_service/category/list/';

  // ==================== IT SERVICE (PROJECTS) ====================
  static const String itServiceList = 'v1/it_service/service/list/';
  static String itServiceDetail(int id) => 'v1/it_service/service/$id/';
  static String itServiceListByCategory(int categoryId) =>
      'v1/it_service/service/list/?category=$categoryId';

}