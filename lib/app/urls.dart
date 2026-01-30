class Urls {
  static const String baseUrl = "http://172.252.13.97:8025";

  static const String login = "$baseUrl/auth/login/";
  static const String Self_Profile = "$baseUrl/auth/me/";
  static const String Self_Profile_Update = "$baseUrl/auth/me/update/";
  static const String Self_Profile_change_password =
      "$baseUrl/auth/me/change-password/";
  static const String Reset_password = "$baseUrl/auth/reset-password/";
  static const String Verify_Email = "$baseUrl/auth/me/verify-email-otp/";
  static const String resend_otp = "$baseUrl/auth/resend-otp/";
  static const String Email_otp = "$baseUrl/auth/me/send-email-otp/";
  static const String forgot_password = "$baseUrl/auth/forgot-password/";
  static const String verify_otp = "$baseUrl/auth/verify-otp/";

  // dashboard Admin
  static const String Admin = "$baseUrl/api/dashboard/admin/";

  // dashboard month
  static const String Month_wise_Filter_admin = "$baseUrl/api/dashboard/admin/?month=202601";
  static const String Month_wise_Filter_manager = "$baseUrl/api/dashboard/manager/?month=202601";
  static const String Month_wise_Filter_creator = "$baseUrl/api/dashboard/creator/?month=202601";
  
  // target - month wise filter with role
  static String monthWiseTargetFilter(String month) => "$baseUrl/api/dashboard/manager/?month=$month";
  static String roleWiseTargetFilter(String month, String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return "$baseUrl/api/dashboard/admin/?month=$month";
      case 'manager':
        return "$baseUrl/api/dashboard/manager/?month=$month";
      case 'creator':
        return "$baseUrl/api/dashboard/creator/?month=$month";
      default:
        return "$baseUrl/api/dashboard/manager/?month=$month&role=$role";
    }
  }
  // Ai Response
  static const String AI_Response_admin_manager_creator = "$baseUrl/api/ai-response/";
}
