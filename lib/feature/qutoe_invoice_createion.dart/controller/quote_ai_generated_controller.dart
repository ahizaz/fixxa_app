import 'package:fixxa_app/core/services/spotlight_service.dart';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/controller/manually_quote_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuoteAiGeneratedController extends GetxController {
  var quoteData = <String, dynamic>{}.obs;
  SignatureController signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  var hasSignature = false.obs;
  Uint8List? signatureBytes;

  // Spotlight variables
  var showSpotlight = true.obs;
  Timer? spotlightTimer;

  @override
  void onInit() {
    super.onInit();

    // Reset spotlight for testing (comment this out in production)
    // SpotlightService.instance.resetAllSpotlights();

    // Start spotlight effect only if not shown before
    _startSpotlight();

    // Try to restore cached quote data from previous session
    _restoreCachedQuote();

    // If no cached data, initialize with empty structure so UI shows blank fields
    if (quoteData.isEmpty) {
      quoteData.value = {
      'quoteId': '',
      'fromName': '',
      'fromAddress': '',
      'toName': '',
      'toEmail': '',
      'toPhone': '',
      'toAddress': '',
      'date': '',
      'quoteNumber': '',
      'items': [
        {
          'quote_description': 'Web Development Services',
          'description': 'Web Development Services',
          'quantity': 10,
          'unit_price': 150.00,
          'amount': 1500.00,
        }
      ],
      'services': <Map<String, dynamic>>[],
      'subtotal': '',
      'vat': '',
      'total': '',
      'signature': null,
      };
    }
  }

  static const String _cacheKey = 'quote_ai_generated_cache_v1';

  Future<void> _restoreCachedQuote() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_cacheKey);
      if (stored != null && stored.isNotEmpty) {
        final Map<String, dynamic> data = json.decode(stored);
        quoteData.value = data;
        debugPrint('✅ Restored cached quoteData from SharedPreferences');
        update();
      }
    } catch (e) {
      debugPrint('⚠️ Failed to restore cached quoteData: $e');
    }
  }

  void _startSpotlight() {
    debugPrint("Quote AI Generated: Starting spotlight check...");

    // Debug the spotlight service
    SpotlightService.instance.debugAllSpotlights();

    // Check if spotlight has been shown before
    bool hasShown = SpotlightService.instance
        .hasShownQuoteAiGeneratedSpotlight();
    debugPrint(
      "Quote AI Generated: hasShownQuoteAiGeneratedSpotlight returned: $hasShown",
    );

    if (!hasShown) {
      debugPrint("Quote AI Generated: First time, showing spotlight!");
      showSpotlight.value = true;

      // Hide after 5 seconds
      spotlightTimer = Timer(const Duration(seconds: 5), () {
        showSpotlight.value = false;
        // Mark spotlight as shown
        SpotlightService.instance.setQuoteAiGeneratedSpotlightShown();
        debugPrint("Quote AI Generated: Spotlight marked as shown");
      });
    } else {
      debugPrint("Quote AI Generated: Already shown before, hiding spotlight");
      showSpotlight.value = false;
    }
  }

  /// Normalize API response from Quote AI and update `quoteData` used by UI.
  Future<void> updateFromApi(Map<String, dynamic> api) async {
    try {
      // top-level ids and dates
      final quoteId = api['quote_id'] ?? api['id'] ?? api['quoteId'] ?? '';
      final quoteNumber = api['quote_number'] ?? api['quoteNumber'] ?? '';
      final issueDate = api['issue_date'] ?? api['issued'] ?? api['date'] ?? '';
      final dueDate = api['due_date'] ?? api['due'] ?? '';

      // from details
      final fromDetails = api['from_details'] ?? api['from'] ?? {};
      final fromName = (fromDetails is Map && fromDetails['business_name'] != null)
          ? fromDetails['business_name'].toString()
          : (api['fromName']?.toString() ?? '');
      final fromAddress = (fromDetails is Map && fromDetails['email'] != null)
          ? fromDetails['email'].toString()
          : (api['fromAddress']?.toString() ?? '');

      // bill/to/client
      final billTo = api['bill_to'] ?? api['from_details'] ?? {};
      final clientDetails = api['client_details'] ?? api['client'] ?? {};
      final toName = (api['toName'] ?? api['to_name'] ?? clientDetails['name'] ?? billTo['name'] ?? '').toString();
      final toEmail = (api['toEmail'] ?? api['to_email'] ?? clientDetails['email'] ?? billTo['email'] ?? '').toString();
      final toPhone = (api['toPhone'] ?? api['to_phone'] ?? clientDetails['phone'] ?? billTo['phone'] ?? '').toString();
      final toAddress = (api['toAddress'] ?? api['to_address'] ?? clientDetails['address'] ?? billTo['address'] ?? '').toString();

      // items: normalize keys to description, quantity, unit_price, amount
      List items = [];
      if (api['items'] is List) {
        items = (api['items'] as List).map((raw) {
          if (raw is Map<String, dynamic>) {
            final desc = raw['quote_description'] ?? raw['description'] ?? '';
            final qty = raw['quantity'] ?? raw['qty'] ?? raw['quantity'] ?? 0;
            final unit = raw['unit_price'] ?? raw['unit'] ?? raw['price'] ?? raw['unit_price'] ?? 0;
            final amt = raw['amount'] ?? raw['total'] ?? raw['sum'] ?? raw['total_amount'] ?? 0;
            return {
              'quote_description': desc,
              'description': desc,
              'quantity': qty,
              'unit_price': unit,
              'amount': amt,
            };
          }
          return raw;
        }).toList();
      }

      // totals
      final subtotal = api['subtotal'] ?? api['sub_total'] ?? api['subTotal'] ?? '';
      final vatRate = api['vat_rate'] ?? api['vat'] ?? '';
      final vatAmount = api['vat_amount'] ?? api['vatAmount'] ?? '';
      final total = api['total'] ?? api['total_amount'] ?? api['grand_total'] ?? '';

      // Build normalized map
      final Map<String, dynamic> normalized = {
        'quote_id': quoteId,
        'quoteId': quoteId,
        'quote_number': quoteNumber,
        'quoteNumber': quoteNumber,
        'date': issueDate,
        'issued': issueDate,
        'due': dueDate,
        'fromName': fromName,
        'fromAddress': fromAddress,
        'toName': toName,
        'toEmail': toEmail,
        'toPhone': toPhone,
        'toAddress': toAddress,
        'items': items,
        'subtotal': subtotal,
        'vat_rate': vatRate,
        'vat': vatRate,
        'vat_amount': vatAmount,
        'total': total,
        'accept_link': api['accept_link'] ?? api['acceptLink'] ?? '',
        'client': api['client'] ?? api['client_id'] ?? api['clientId'] ?? null,
      };

      // Merge other useful fields from API
      if (api.containsKey('transcription')) normalized['transcription'] = api['transcription'];

      quoteData.value = normalized;
      // Persist normalized result to local storage so it survives backgrounding
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_cacheKey, json.encode(normalized));
        debugPrint('✅ Cached quoteData to SharedPreferences');
      } catch (e) {
        debugPrint('⚠️ Failed to cache quoteData: $e');
      }
      update();
    } catch (e) {
      debugPrint('❌ updateFromApi failed: $e');
    }
  }

  // Signature methods
  void clearSignature() {
    signatureController.clear();
    hasSignature.value = false;
    signatureBytes = null;
    update(); // Force UI update
  }

  Future<void> saveSignature() async {
    if (signatureController.isNotEmpty) {
      signatureBytes = await signatureController.toPngBytes();
      hasSignature.value = true;
    }
  }

  Future<void> importSignatureFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final File imageFile = File(image.path);
        signatureBytes = await imageFile.readAsBytes();
        hasSignature.value = true;

        // Clear the signature pad since we're using imported image
        signatureController.clear();

        // Force UI update
        update();

        // Close dialog if it's open
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        Get.snackbar(
          'Success',
          'Signature imported successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to import signature: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showSignatureDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please Sign Here',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 200,
                  width: double.infinity,
                  child: Signature(
                    controller: signatureController,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Import from gallery button
              TextButton.icon(
                onPressed: () => importSignatureFromGallery(),
                icon: const Icon(Icons.photo_library, size: 18),
                label: const Text('Import from Gallery'),
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => clearSignature(),
                    child: const Text('Clear'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await saveSignature();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Delete quote method
  void deleteQuote() {
    // Clear the quote data
    quoteData.clear();

    // Clear cached quote data
    try {
      SharedPreferences.getInstance().then((prefs) {
        prefs.remove(_cacheKey);
        debugPrint('✅ Cleared cached quoteData');
      });
    } catch (e) {
      debugPrint('⚠️ Failed to clear cached quoteData: $e');
    }

    // Navigate back to previous screen immediately
    Get.back();
  }

  // Export quote as PDF
  Future<void> exportQuoteAsPdf() async {
    try {
      // Get quote_id from ManuallyQuoteController
      int? quoteId;
      if (Get.isRegistered<ManuallyQuoteController>()) {
        final manuallyQuoteController = Get.find<ManuallyQuoteController>();
        quoteId = manuallyQuoteController.quoteId.value;
      }

      // If quoteId is still null, try to get it from quoteData
      if (quoteId == null && quoteData.isNotEmpty) {
        // Try to extract quote_id from quoteData if available
        final dataQuoteId = quoteData['quote_id'] ?? quoteData['id'];
        if (dataQuoteId != null) {
          quoteId = int.tryParse(dataQuoteId.toString());
        }
      }

      if (quoteId == null) {
        EasyLoading.showError(
          'Quote ID not found. Please create a quote first.',
        );
        return;
      }

      // Show loading
      EasyLoading.show(status: 'Exporting PDF...');

      // Get access token
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        return;
      }

      // Make GET request to export PDF endpoint
      final url = Urls.exportQuotePdf(quoteId);
      debugPrint('📤 Exporting PDF from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        // Get PDF bytes from response
        final pdfBytes = response.bodyBytes;

        // Save PDF to device
        Directory? appDirectory;
        if (Platform.isAndroid) {
          appDirectory = await getExternalStorageDirectory();
        } else if (Platform.isIOS) {
          appDirectory = await getApplicationDocumentsDirectory();
        }

        if (appDirectory == null) {
          EasyLoading.showError('Could not get storage directory.');
          return;
        }

        // Create a custom directory for PDFs
        final String customPath = '${appDirectory.path}/FixxaPDFs';
        final Directory customDirectory = Directory(customPath);
        if (!await customDirectory.exists()) {
          await customDirectory.create(recursive: true);
        }

        // Save PDF file
        final String fileName =
            'quote_${quoteId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final String filePath = '${customDirectory.path}/$fileName';
        final File pdfFile = File(filePath);
        await pdfFile.writeAsBytes(pdfBytes);

        // Show success message and open PDF
        EasyLoading.showSuccess('PDF exported successfully');

        // Open the PDF file
        await OpenFilex.open(filePath);
      } else {
        debugPrint('❌ Export PDF failed: ${response.statusCode}');
        debugPrint('❌ Response body: ${response.body}');
        EasyLoading.showError('Failed to export PDF: ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('❌ Exception in exportQuoteAsPdf: $e');
      EasyLoading.showError('Failed to export PDF: $e');
    }
  }

  // Export quote as CSV
  Future<void> exportQuoteAsCsv() async {
    try {
      // Get quote_id from ManuallyQuoteController
      int? quoteId;
      if (Get.isRegistered<ManuallyQuoteController>()) {
        final manuallyQuoteController = Get.find<ManuallyQuoteController>();
        quoteId = manuallyQuoteController.quoteId.value;
      }

      // If quoteId is still null, try to get it from quoteData
      if (quoteId == null && quoteData.isNotEmpty) {
        // Try to extract quote_id from quoteData if available
        final dataQuoteId = quoteData['quote_id'] ?? quoteData['id'];
        if (dataQuoteId != null) {
          quoteId = int.tryParse(dataQuoteId.toString());
        }
      }

      if (quoteId == null) {
        EasyLoading.showError(
          'Quote ID not found. Please create a quote first.',
        );
        return;
      }

      // Show loading
      EasyLoading.show(status: 'Exporting CSV...');

      // Get access token
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        return;
      }

      // Make GET request to export CSV endpoint
      final url = Urls.exportQuoteCsv(quoteId);
      debugPrint('📤 Exporting CSV from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        // Get CSV bytes from response
        final csvBytes = response.bodyBytes;

        // Save CSV to device
        Directory? appDirectory;
        if (Platform.isAndroid) {
          appDirectory = await getExternalStorageDirectory();
        } else if (Platform.isIOS) {
          appDirectory = await getApplicationDocumentsDirectory();
        }

        if (appDirectory == null) {
          EasyLoading.showError('Could not get storage directory.');
          return;
        }

        // Create a custom directory for CSVs
        final String customPath = '${appDirectory.path}/FixxaCSVs';
        final Directory customDirectory = Directory(customPath);
        if (!await customDirectory.exists()) {
          await customDirectory.create(recursive: true);
        }

        // Save CSV file
        final String fileName =
            'quote_${quoteId}_${DateTime.now().millisecondsSinceEpoch}.csv';
        final String filePath = '${customDirectory.path}/$fileName';
        final File csvFile = File(filePath);
        await csvFile.writeAsBytes(csvBytes);

        // Show success message and open CSV
        EasyLoading.showSuccess('CSV exported successfully');

        // Open the CSV file
        await OpenFilex.open(filePath);
      } else {
        debugPrint('❌ Export CSV failed: ${response.statusCode}');
        debugPrint('❌ Response body: ${response.body}');
        EasyLoading.showError('Failed to export CSV: ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('❌ Exception in exportQuoteAsCsv: $e');
      EasyLoading.showError('Failed to export CSV: $e');
    }
  }

  // Send quote via email
  Future<void> sendQuoteEmail() async {
    try {
      // Get quote_id from ManuallyQuoteController
      int? quoteIdValue;
      if (Get.isRegistered<ManuallyQuoteController>()) {
        final manuallyQuoteController = Get.find<ManuallyQuoteController>();
        quoteIdValue = manuallyQuoteController.quoteId.value;
      }

      // If quoteId is still null, try to get it from quoteData
      if (quoteIdValue == null && quoteData.isNotEmpty) {
        // Try to extract quote_id from quoteData if available
        final dataQuoteId = quoteData['quote_id'] ?? quoteData['id'];
        if (dataQuoteId != null) {
          quoteIdValue = int.tryParse(dataQuoteId.toString());
        }
      }

      if (quoteIdValue == null) {
        EasyLoading.showError(
          'Quote ID not found. Please create a quote first.',
        );
        debugPrint('❌ Send email failed: Quote ID is null');
        return;
      }

      // Check if client has email from quoteData or ManuallyQuoteController
      String clientEmail = '';

      // Try to get email from ManuallyQuoteController
      if (Get.isRegistered<ManuallyQuoteController>()) {
        final manuallyQuoteController = Get.find<ManuallyQuoteController>();
        clientEmail =
            manuallyQuoteController.selectedClient['email']
                ?.toString()
                .trim() ??
            '';
      }

      // If not found, try from quoteData
      if (clientEmail.isEmpty && quoteData.isNotEmpty) {
        clientEmail =
            quoteData['toEmail']?.toString().trim() ??
            quoteData['client_email']?.toString().trim() ??
            '';
      }

      if (clientEmail.isEmpty) {
        EasyLoading.showError(
          'Client email not found. Please add client email to send quote.',
        );
        debugPrint(
          '❌ Send email failed: Client email is empty or not provided',
        );
        return;
      }

      // Show loading
      EasyLoading.show(status: 'Sending email...');
      debugPrint('📧 Starting email send for quote ID: $quoteIdValue');
      debugPrint('📧 Client email: $clientEmail');

      // Get access token
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        debugPrint('❌ Send email failed: Access token is null or empty');
        return;
      }

      // Make POST request to send email endpoint
      final url = Urls.sendQuoteEmail(quoteIdValue);
      debugPrint('📧 Sending request to: $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('📧 Response status: ${response.statusCode}');
      debugPrint('📧 Response body: ${response.body}');

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('Quote sent successfully via email!');
        debugPrint('✅ Quote email sent successfully');
      } else {
        debugPrint('❌ Send email failed: ${response.statusCode}');
        debugPrint('❌ Response body: ${response.body}');

        // Try to parse error message from response
        try {
          final errorData = json.decode(response.body);
          final errorMessage =
              errorData['message'] ??
              errorData['error'] ??
              'Failed to send email';
          EasyLoading.showError(errorMessage);
        } catch (e) {
          EasyLoading.showError('Failed to send email: ${response.statusCode}');
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('❌ Exception in sendQuoteEmail: $e');
      EasyLoading.showError('Failed to send email: $e');
    }
  }

  // Send quote via WhatsApp
  Future<void> sendQuoteWhatsApp({String? acceptLink, Map<String, dynamic>? previewData}) async {
    try {
      // Get quote_id from ManuallyQuoteController
      int? quoteIdValue;
      if (Get.isRegistered<ManuallyQuoteController>()) {
        final manuallyQuoteController = Get.find<ManuallyQuoteController>();
        quoteIdValue = manuallyQuoteController.quoteId.value;
      }

      // If quoteId is still null, try to get it from quoteData
      if (quoteIdValue == null && quoteData.isNotEmpty) {
        final dataQuoteId = quoteData['quote_id'] ?? quoteData['id'];
        if (dataQuoteId != null) {
          quoteIdValue = int.tryParse(dataQuoteId.toString());
        }
      }

      if (quoteIdValue == null) {
        EasyLoading.showError(
          'Quote ID not found. Please create a quote first.',
        );
        debugPrint('❌ Send WhatsApp failed: Quote ID is null');
        return;
      }

      // Check if client has phone number
      String clientPhone = '';

      // Try to get phone from ManuallyQuoteController
      if (Get.isRegistered<ManuallyQuoteController>()) {
        final manuallyQuoteController = Get.find<ManuallyQuoteController>();
        clientPhone =
            manuallyQuoteController.selectedClient['phone_number']
                ?.toString()
                .trim() ??
            '';
      }

      // If not found, try from quoteData
      if (clientPhone.isEmpty && quoteData.isNotEmpty) {
        clientPhone =
            quoteData['phone_number']?.toString().trim() ??
            quoteData['client_phone']?.toString().trim() ??
            '';
      }

      if (clientPhone.isEmpty) {
        EasyLoading.showError(
          'Client phone number not found. Please add client phone number to send via WhatsApp.',
        );
        debugPrint(
          '❌ Send WhatsApp failed: Client phone is empty or not provided',
        );
        return;
      }

      // Clean phone number (remove spaces, dashes, parentheses, etc.)
      clientPhone = clientPhone.replaceAll(RegExp(r'[^\d+]'), '');

      // Ensure phone number has country code for international format
      if (!clientPhone.startsWith('+')) {
        // If number starts with 00, replace with +
        if (clientPhone.startsWith('00')) {
          clientPhone = '+${clientPhone.substring(2)}';
        }
        // If number starts with 0 and is long enough (likely a local number)
        else if (clientPhone.startsWith('0') && clientPhone.length >= 10) {
          // User needs to provide number with country code
          EasyLoading.showError(
            'Please include country code (e.g., +8801712345678 for Bangladesh, +12025551234 for US)',
          );
          debugPrint(
            '❌ Send WhatsApp failed: No country code detected. Number: $clientPhone',
          );
          return;
        }
        // If number doesn't start with + or 0, assume it already has country code digits
        else if (clientPhone.length >= 10) {
          clientPhone = '+$clientPhone';
        } else {
          EasyLoading.showError(
            'Invalid phone number. Please include country code (e.g., +8801712345678)',
          );
          debugPrint('❌ Send WhatsApp failed: Number too short: $clientPhone');
          return;
        }
      }

      // Validate that we have a proper international number format
      if (!clientPhone.startsWith('+') || clientPhone.length < 8) {
        EasyLoading.showError(
          'Invalid phone number format. Please include country code (e.g., +8801712345678 for Bangladesh, +442071234567 for UK)',
        );
        debugPrint(
          '❌ Send WhatsApp failed: Invalid phone format: $clientPhone',
        );
        return;
      }

      // Show loading
      EasyLoading.show(status: 'Preparing WhatsApp...');
      debugPrint('📱 Starting WhatsApp send for quote ID: $quoteIdValue');
      debugPrint('📱 Client phone: $clientPhone');

      // Get access token
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        debugPrint('❌ Send WhatsApp failed: Access token is null or empty');
        return;
      }

      // Make GET request to export PDF endpoint
      final url = Urls.exportQuotePdf(quoteIdValue);
      debugPrint('📱 Downloading PDF from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Get PDF bytes from response
        final pdfBytes = response.bodyBytes;
        debugPrint('✅ PDF received, size: ${pdfBytes.length} bytes');

        // Save PDF to temporary directory
        final Directory tempDir = await getTemporaryDirectory();
        final String fileName =
            'quote_${quoteIdValue}_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final String filePath = '${tempDir.path}/$fileName';
        final File pdfFile = File(filePath);
        await pdfFile.writeAsBytes(pdfBytes);

        debugPrint('✅ PDF saved to: $filePath');

        EasyLoading.dismiss();

        // Share PDF directly to WhatsApp
        String message = 'Here is your quote from Fixxa';
        if (acceptLink != null && acceptLink.isNotEmpty) {
          message += '\n\nTo view and approve your quote online, click the link below:\n$acceptLink';
        }
        final XFile xFile = XFile(filePath);

        // Share directly to WhatsApp
        final result = await Share.shareXFiles([xFile], text: message);

        if (result.status == ShareResultStatus.success) {
          EasyLoading.showSuccess('Quote sent to WhatsApp successfully!');
          debugPrint('✅ Quote shared to WhatsApp successfully');
        } else {
          EasyLoading.showInfo('Please select WhatsApp to send the quote');
          debugPrint('📱 Share dialog opened');
        }
      } else {
        EasyLoading.dismiss();
        debugPrint('❌ Download PDF failed: ${response.statusCode}');
        debugPrint('❌ Response body: ${response.body}');
        EasyLoading.showError('Failed to download PDF: ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('❌ Exception in sendQuoteWhatsApp: $e');
      EasyLoading.showError('Failed to send via WhatsApp: $e');
    }
  }

  @override
  void onClose() {
    spotlightTimer?.cancel();
    signatureController.dispose();
    super.onClose();
  }
}
