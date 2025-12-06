
class Urls{
  static const String baseUrl = "https://6zpmb4x8-8005.inc1.devtunnels.ms/";//http://10.10.12.14:8000/
  static const String signup = "$baseUrl/auth/signup/";
  static const String verifyOtp = "$baseUrl/auth/verify-otp/";
  static const String resendOtp = "$baseUrl/auth/resend-otp/";
  static const String busineesProfile = "$baseUrl/businessapp/profile/";
  static const String login = "$baseUrl/auth/login/";
  static const String forgotpassword = "$baseUrl/auth/forgot-password/";
  static const String resetpassword = "$baseUrl/auth/reset-password/";
  static const String addclientfromimport = "$baseUrl/clientapp/clients/import-from-contact/";
  static const String createnewClient = "$baseUrl/clientapp/clients/";
  static const String getAllClient = "$baseUrl/clientapp/clients/";
  static String updateClient(int id) => "$baseUrl/clientapp/clients/$id/";
  static String deleteClient(int id) => "$baseUrl/clientapp/clients/$id/";
  static const String createquote = "$baseUrl/quoteapp/quotes/";
  static String quoteFinancials(dynamic id) => "$baseUrl/quoteapp/quotes/$id/financials/";
  static String paymentStripe = "$baseUrl/businessapp/stripe/connect/";
 
}