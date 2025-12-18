class Urls {
  static const String baseUrl =
      "https://6zpmb4x8-8008.inc1.devtunnels.ms/"; //http://10.10.12.14:8000/
  static const String signup = "$baseUrl/auth/signup/";
  static const String verifyOtp = "$baseUrl/auth/verify-otp/";
  static const String resendOtp = "$baseUrl/auth/resend-otp/";
  static const String busineesProfile = "$baseUrl/businessapp/profile/";
  static const String login = "$baseUrl/auth/login/";
  static const String forgotpassword = "$baseUrl/auth/forgot-password/";
  static const String resetpassword = "$baseUrl/auth/reset-password/";
  static const String addclientfromimport =
      "$baseUrl/clientapp/clients/import-from-contact/";
  static const String createnewClient = "$baseUrl/clientapp/clients/";
  static const String getAllClient = "$baseUrl/clientapp/clients/";
  static String updateClient(int id) => "$baseUrl/clientapp/clients/$id/";
  static String deleteClient(int id) => "$baseUrl/clientapp/clients/$id/";
  static const String createquote = "$baseUrl/quoteapp/quotes/";
  static String quoteFinancials(dynamic id) =>
      "$baseUrl/quoteapp/quotes/$id/financials/";
  static String exportQuotePdf(int quoteId) =>
      "$baseUrl/quoteapp/quotes/$quoteId/export/?type=pdf";
  static String exportQuoteCsv(int quoteId) =>
      "$baseUrl/quoteapp/quotes/$quoteId/export/?type=csv";
  static String exportQuoteExcell(int quoteId) =>
      "$baseUrl/quoteapp/quotes/$quoteId/export/?type=excel";
  static String paymentStripe = "$baseUrl/businessapp/stripe/connect/";
  static String createInvoice = "$baseUrl/quoteapp/invoices/";
  static String getStatus = "$baseUrl/businessapp/stripe/status/";
  static String expotInvoicePdf(int quoteId) =>
      "$baseUrl/quoteapp/invoices/$quoteId/export/?type=pdf";
  static String exportInvoiceCsv(int quoteId) =>
      "$baseUrl/quoteapp/invoices/$quoteId/export/?type=csv";
  static String exportInvoiceExcell(int quoteId) =>
      "$baseUrl/quoteapp/invoices/$quoteId/export/?type=excel";
  static String sendQuoteEmail(int quoteId) =>
      "$baseUrl/quoteapp/quotes/$quoteId/send/";
  static String sendInvoiceEmail(int quoteId) =>
      "$baseUrl/quoteapp/invoices/$quoteId/send/";
  static const String getAllFolders = "$baseUrl/quoteapp/folders/";
  static String allQuotesOfSpecificFolder(int folderId) =>
      "$baseUrl/quoteapp/folders/$folderId/quotes/";
  static String allInvoicesOfSpecificFolder(int folderId) =>
      "$baseUrl/quoteapp/folders/$folderId/invoices/";
  static String scannedImages(int folderId) =>
      "$baseUrl/quoteapp/folders/$folderId/scanned-images/";
    static String scannedImageUrl(String? imagePath) {
        if (imagePath == null || imagePath.isEmpty) return "";
        if (imagePath.startsWith('http')) return imagePath;
        final cleaned = imagePath.replaceFirst(RegExp(r'^/+' ), '');
        return "$baseUrl$cleaned";
    }
      static const String scan ="$baseUrl/quoteapp/scan-upload/";

}
