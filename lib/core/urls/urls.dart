class Urls {
  static const String baseUrl =
    "https://6zpmb4x8-8008.inc1.devtunnels.ms/";
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
  static const String createquote = "$baseUrl/quoteapp/quotes/new-create/";
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
  // Returns scanned-images URL only for non-root/non-client folders.
  // Provide `folderType` as 'root', 'client', or other string.
  static String scannedImagesForFolder(int folderId,
          {required String folderType}) =>
      (folderType == 'root' || folderType == 'client')
          ? ""
          : "$baseUrl/quoteapp/folders/$folderId/scanned-images/";

  // Backwards-compatible API: callers that only have `folderId` will
  // continue to get the scanned-images URL (assumes non-root/client).
  static String scannedImages(int folderId) =>
      scannedImagesForFolder(folderId, folderType: 'other');
    static String scannedImageUrl(String? imagePath) {
        if (imagePath == null || imagePath.isEmpty) return "";
        if (imagePath.startsWith('http')) return imagePath;
        final cleaned = imagePath.replaceFirst(RegExp(r'^/+' ), '');
        return "$baseUrl$cleaned";
    }
      static const String scan ="$baseUrl/quoteapp/scan-upload/";
      static const String allstaticquotes = "$baseUrl/quoteapp/quotes/statistics/";
      static const String aiChat = "https://6zpmb4x8-8018.inc1.devtunnels.ms/chat";
      static const String aiAudio = "https://6zpmb4x8-8017.inc1.devtunnels.ms/ProcessAudio";
      static  String getSpecificQUote(int quoteId)=>"$baseUrl/quoteapp/quotes/$quoteId/";

}
