class Urls {
  static const String baseUrl = "http://172.252.13.97:8025";


  // update
  static const String Self_Profile_Update = "$baseUrl/auth/me/update/";
  static const String Self_Profile_change_password =
      "$baseUrl/auth/me/change-password/";

  // auth
  static const String login = "$baseUrl/auth/login/";
  static const String Self_Profile = "$baseUrl/auth/me/";
  static const String Reset_password = "$baseUrl/auth/reset-password/";
  static const String Verify_Email = "$baseUrl/auth/me/verify-email-otp/";
  static const String resend_otp = "$baseUrl/auth/resend-otp/";
  static const String Email_otp = "$baseUrl/auth/me/send-email-otp/";
  static const String forgot_password = "$baseUrl/auth/forgot-password/";
  static const String verify_otp = "$baseUrl/auth/verify-otp/";
  
  // Token Management
  static const String token_refresh = "$baseUrl/auth/token-refresh/";

  // dashboard Admin
  static const String Admin = "$baseUrl/api/dashboard/admin/?month=202601";

  //Admin all manager
  static const String Manager_Dashboard_Score = "$baseUrl/api/dashboard/manager/";

  // single manager
  static String singleManagerDashboardScore(int managerId) {
    return "$baseUrl/api/dashboard/manager/?manager_id=$managerId";
  }
  // admin get creator by manager
  static String getCreatorByManagerId(int managerId) {
    return "$baseUrl/api/dashboard/creator/?manager_id=$managerId";
  }
  //single creator
  static String singleCreatorDashboardScore(int creatorId) {
    return "$baseUrl/api/dashboard/creator/?creator_id=$creatorId";
  }

  static const String AI_Response_manager = "$baseUrl/api/ai-response/admin-overview/";

  // dashboard month
  static const String Month_wise_Filter_admin = "$baseUrl/api/dashboard/admin/?month=202601";
  static const String Month_wise_Filter_manager = "$baseUrl/api/dashboard/manager/?month=202601";
  static const String Month_wise_Filter_creator = "$baseUrl/api/dashboard/creator/?month=202601";
  
  // target - month wise filter with role
  static String monthWiseTargetFilterAdmin(String month) => "$baseUrl/api/dashboard/admin/?month=$month";
  static String monthWiseTargetFilterManager(String month) => "$baseUrl/api/dashboard/manager/?month=$month";
  static String monthWiseTargetFilterCreator(String month) => "$baseUrl/api/dashboard/creator/?month=$month";

  // Ai Response
  static const String AI_Response_admin_manager_creator = "$baseUrl/api/ai-response/";

  // AI alerts
  static const String AI_Response_alertproblem = "$baseUrl/api/ai-response/alerts";
}
