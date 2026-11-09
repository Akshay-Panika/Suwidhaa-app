class ApiUrls {

  // Auth endpoints
  static const String studentLogin = 'v1/school/student-pass/login/';
  // ==================== STUDENT PASS AUTH (NEW) ====================
  static const String studentPassLogin =
      'v1/school/student-pass/login/';
  static const String studentPassRequestOtp =
      'v1/school/student-pass/forgot-password/request-otp/';
  static const String studentPassVerifyAndReset =
      'v1/school/student-pass/forgot-password/verify-and-reset/';
  static const String studentPassLogout =
      'v1/school/student-pass/logout/';

  static const String teacherLogin = 'v1/school/teacher-pass/login/';
  // ==================== TEACHER PASS AUTH (NEW) ====================
  static const String teacherPassLogin =
      'v1/school/teacher-pass/login/';
  static const String teacherPassRequestOtp =
      'v1/school/teacher-pass/forgot-password/request-otp/';
  static const String teacherPassVerifyAndReset =
      'v1/school/teacher-pass/forgot-password/verify-and-reset/';
  static const String teacherPassLogout =
      'v1/school/teacher-pass/logout/';
  
  // Student endpoints
  static const String studentList = 'v1/school/student/list/';
  static const String studentCreate = 'v1/school/student/create/';
  static const String studentDetail = 'v1/school/student/';  // + id
  static String studentListBySchoolId(int schoolId) =>
      'v1/school/student/list/school/$schoolId/';

  // Student Leave endpoints
  static const String studentLeaveList = 'v1/school/student-leave/list/';
  static const String studentLeaveApproval = 'v1/school/student-leave/approval/';
  static const String studentLeaveCreate = 'v1/school/student-leave/create/';
  static const String studentLeaveDetail = 'v1/school/student-leave/';
  static const String studentLeaveByIdCard = 'v1/school/student-leave/list/';
  static String studentLeaveByClass(String className) =>
      'v1/school/student-leave/list/class/${Uri.encodeComponent(className)}/';

  // ===== Student Fee =====
  static const String studentFeeList = 'v1/school/student/fee/list/';
  static String studentFeeListBySchool(int schoolId) => 'v1/school/student/fee/list/school/$schoolId/';
  static const String studentFeeTransactionCreate = 'v1/school/student/fee/transaction/create/';
  static String studentFeeTransactionHistory(int studentId) => 'v1/school/student/fee/transaction/history/$studentId/';
  static String studentFeeTransactionDetail(int studentId, int transactionId) => 'v1/school/student/fee/transaction/$studentId/$transactionId/';

  // ==================== TEACHER SALARY ====================
  static const String teacherSalaryList = 'v1/school/teacher/salary/list/';
  static String teacherSalaryListBySchool(int schoolId) =>
      'v1/school/teacher/salary/list/school/$schoolId/';

  static const String teacherSalaryTransactionCreate =
      'v1/school/teacher/salary/transaction/create/';

  static String teacherSalaryTransactionDetail(
      int teacherId, int transactionId) =>
      'v1/school/teacher/salary/transaction/$teacherId/$transactionId/';

  static String teacherSalaryTransactionHistory(int teacherId) =>
      'v1/school/teacher/salary/transaction/history/$teacherId/';

  // Teacher endpoints
  static const String teacherList = 'v1/school/teacher/list/';
  static const String teacherCreate = 'v1/school/teacher/create/';
  static const String teacherDetail = 'v1/school/teacher/';
  static const String teacherSalarySummary = 'v1/school/teacher/salary/summary/';

  // ==================== TEACHER LEAVE ====================
  static const String teacherLeaveCreate = 'v1/school/teacher-leave/create/';
  static const String teacherLeaveList = 'v1/school/teacher-leave/list/';
  static const String teacherLeaveDetail = 'v1/school/teacher-leave/'; // + id/
  static const String teacherLeaveByIdCard = 'v1/school/teacher-leave/list/';

  // ✅ NEW: teacher DB-int-id wise
  static String teacherLeaveByTeacherId(int teacherId) =>
      'v1/school/teacher-leave/teacher/$teacherId/';

  // ✅ NEW: school-wise
  static String teacherLeaveBySchool(int schoolId) =>
      'v1/school/teacher-leave/school/$schoolId/';

  // ✅ NEW: status-only update
  static String teacherLeaveStatusUpdate(int id) =>
      'v1/school/teacher-leave/$id/status/';

  // ==================== TEACHER ATTENDANCE ====================
  static const String teacherAttendanceHistory = 'v1/school/teacher-attendance/history/';
  static const String teacherAttendanceCheckIn = 'v1/school/teacher-attendance/check-in/';
  static const String teacherAttendanceCheckOut = 'v1/school/teacher-attendance/check-out/';
  static const String teacherAttendanceList = 'v1/school/teacher-attendance/list/';
  static const String teacherAttendanceUpdate = 'v1/school/teacher-attendance/update/';
  static String teacherAttendanceDelete(int pk) =>
      'v1/school/teacher-attendance/delete/$pk/';


  // Student Attendance endpoints
  static const String studentAttendanceCreate = 'v1/school/student-attendance/create/';
  static const String studentAttendanceList   = 'v1/school/student-attendance/list/';
  static String studentAttendanceDetail(int studentId) =>
      'v1/school/student-attendance/list/$studentId/';
  static String studentAttendanceToday(int studentId) =>
      'v1/school/student-attendance/today/$studentId/';

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

  // ==================== TRANSPORT ====================
  // ✅ School-wise list
  static String transportListBySchool(int schoolId) =>
      'v1/school/transport/list/school/$schoolId/';

  static const String transportCreate = 'v1/school/transport/create/';
  static const String transportDetail = 'v1/school/transport/'; // + id/
  static String transportDetailById(int id) =>
      'v1/school/transport/$id/';

  // ✅ Helper URLs (student add / remove)
  static String transportAddStudent(int transportId) =>
      'v1/school/transport/$transportId/students/add/';

  static String transportRemoveStudent(int transportId, String studentId) =>
      'v1/school/transport/$transportId/students/$studentId/delete/';


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
  // ==================== OTT CATEGORY ====================
  static const String ottCategory = 'v1/ott/category/list/';
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


  // ==================== REPORT CARD ====================
  static const String reportCardCreate     = 'v1/school/report-cards/create/';
  static const String reportCardBulkCreate = 'v1/school/report-cards/bulk-create/';   // ✅ NEW
  static const String reportCardList       = 'v1/school/report-cards/list/';
  static const String reportCardDetailBase = 'v1/school/report-cards/list/';          // + id/

  // ✅ Teacher-wise (replaces old adminid path)
  static const String reportCardByTeacherBase = 'v1/school/report-cards/teacher/';

  // ✅ Student-wise (student DB int id)
  static const String reportCardByStudentBase = 'v1/school/report-cards/student-list/';

  // Meeting endpoints
  // ==================== MEETING (school_id based) ====================
  static String meetingCreate(int schoolId) =>
      'v1/school/$schoolId/meeting/create/';

  static String meetingList(int schoolId) =>
      'v1/school/$schoolId/meeting/list/';

  static String meetingDetail(int schoolId, int id) =>
      'v1/school/$schoolId/meeting/$id/';

  static String meetingDelete(int schoolId, int id) =>
      'v1/school/$schoolId/meeting/delete/$id/';


  // ==================== NOTICE ====================
  static const String noticeList   = 'v1/school/notice/list/';
  static const String noticeCreate = 'v1/school/notice/create/';
  static String noticeDetail(int id)   => 'v1/school/notice/$id/';
  static String noticeTogglePin(int id) => 'v1/school/notice/$id/toggle-pin/';

  // ==================== SCHOOL EVENT ====================
  // ✅ school_id based (backend: <int:school_id>/event/...)
  static String eventList(int schoolId) =>
      'v1/school/$schoolId/event/list/';

  static String eventCreate(int schoolId) =>
      'v1/school/$schoolId/event/create/';

  static String eventDetail(int schoolId, int id) =>
      'v1/school/$schoolId/event/$id/';

  static String eventTogglePin(int schoolId, int id) =>
      'v1/school/$schoolId/event/$id/toggle-pin/';

  // ==================== SCHOOL LIBRARY ====================
  static const String libraryCreate = 'v1/school/library/create/';
  static const String libraryList   = 'v1/school/library/list/';
  static String libraryDetail(int id) => 'v1/school/library/$id/';

  // ==================== EXAM TIMETABLE (school_id based) ====================
  static String examTimetableCreate(int schoolId) =>
      'v1/school/$schoolId/exam-timetables/create/';

  static String examTimetableList(int schoolId) =>
      'v1/school/$schoolId/exam-timetables/list/';

  static String examTimetableDetail(int schoolId, int id) =>
      'v1/school/$schoolId/exam-timetables/$id/';

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
  // ==================== IT SERVICE (PROJECTS) ====================
  /// 🆕 POST — create booking
  static const String itServiceBookingCreate =
      'v1/it_service/booking/create/';

  /// LIST — user_id required for `is_booked` flag
  static String itServiceList(int userId) {
    return 'v1/it_service/service/list/?user_id=$userId';
  }

  /// LIST by category — user_id required for `is_booked` flag
  static String itServiceListByCategory(int categoryId, int userId) {
    return 'v1/it_service/service/list/?category=$categoryId&user_id=$userId';
  }

  /// DETAIL — user_id required for `is_booked` flag
  static String itServiceDetail(int id, int userId) {
    return 'v1/it_service/service/$id/?user_id=$userId';
  }

  static String itServiceBookedList(int userId, {String? status}) {
    final base = 'v1/it_service/service/booked/list/?user_id=$userId';
    if (status != null && status.isNotEmpty) {
      return '$base&status=$status';
    }
    return base;
  }

  /// 🆕 DELETE — unbook (hard delete) a booking
  static String itServiceBookingDelete(int bookingId) {
    return 'v1/it_service/booking/$bookingId/';
  }


  // ==================== ECOMMERCE BANNER ====================
  static const String ecommerceBannerList = 'v1/ecommerce/banner/list/';
  static const String ecommerceCategoryList = 'v1/ecommerce/category/list/';
  static const String ecommerceSubCategoryList = 'v1/ecommerce/subcategory/list/';
  static String ecommerceSubCategoryByCategory(int categoryId) =>
      'v1/ecommerce/subcategory/list/?category=$categoryId';

  // ==================== ECOMMERCE PRODUCT ====================
  static const String ecommerceProductCreate = 'v1/ecommerce/product/create/';
  static String ecommerceProductOwner(int userId) => 'v1/ecommerce/product/owner/$userId/';
  // 1. Feed / List API (Now supports subcategory filter)
  static String ecommerceProductFeed(int userId, {int? subcategoryId}) {
    final base = 'v1/ecommerce/product/feed/$userId/';
    if (subcategoryId != null && subcategoryId > 0) {
      return '$base?subcategory=$subcategoryId';
    }
    return base;
  }
  static String ecommerceProductDetail(int id) => 'v1/ecommerce/product/$id/';


  static String ecommerceProductFavorites(int userId) => 'v1/ecommerce/product/favorites/$userId/';
  static String ecommerceProductToggleFavorite(int id, int userId) => 'v1/ecommerce/product/$id/favorite/toggle/?user=$userId';

  // ==================== ECOMMERCE STORE ====================
  static const String ecommerceStoreCreate = 'v1/ecommerce/store/create/';
  static String ecommerceStoreGetByUser(int userId) => 'v1/ecommerce/store/user/$userId/';
  static String ecommerceStoreDetail(int storeId) => 'v1/ecommerce/store/$storeId/';

  // ==================== ECOMMERCE CART ====================
  static String ecommerceCartAdd(int productId) =>
      'v1/ecommerce/product/$productId/cart/add/';
  static String ecommerceCartList(int userId) =>
      'v1/ecommerce/product/cart/$userId/';
  static String ecommerceCartRemove(int productId, int userId, {int? quantity}) {
    final base = 'v1/ecommerce/product/$productId/cart/remove/?user=$userId';
    if (quantity != null && quantity > 0) return '$base&quantity=$quantity';
    return base;
  }


  // ---------- Ads ----------
  static const String ottAdsList   = 'v1/ott/ads/list/';
  static const String ottAdsDetail = 'v1/ott/ads/'; // + id/

}