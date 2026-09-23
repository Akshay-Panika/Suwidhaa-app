class ApiUrls {

  // Auth endpoints
  static const String studentLogin = 'v1/school/student-pass/login/';
  static const String teacherLogin = 'v1/school/teacher-pass/login/';
  
  // Student endpoints
  static const String studentList = 'v1/school/student/list/';
  static const String studentCreate = 'v1/school/student/create/';
  static const String studentDetail = 'v1/school/student/';  // + id

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


}