import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:fixxa_app/core/services/spotlight_service.dart';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/controller/invoice_manually_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:share_plus/share_plus.dart';

class InvoiceAiGeneratedController extends GetxController {
  var quoteData = <String, dynamic>{}.obs;
  static const String aiAudio = "https://6zpmb4x8-8017.inc1.devtunnels.ms/ProcessAudio";

  // Spotlight variables
  var showSpotlight = true.obs;
  Timer? spotlightTimer;
  SignatureController signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  var hasSignature = false.obs;
  Uint8List? signatureBytes;

  @override
  void onInit() {
    super.onInit();

    // Reset spotlight for testing (comment this out in production)
    // SpotlightService.instance.resetAllSpotlights();

    // Start spotlight effect only if not shown before
    _startSpotlight();

    // Simulated JSON data (in future, this will come from API)
    quoteData.value = {
      "quoteId": "QUO-5233",
      "fromName": "MicoFit",
      "fromAddress": "Some ukrn. City, Postal Code, United Kingdom",
      "toName": "John Smith",
      "toEmail": "samuel@email.com",
      "toAddress": "30 Sweet kid. City, Postal Code, United Kingdom",
      "date": "30/09/2023",
      "quoteNumber": "QUO/5233",
      "items": [
        {
          "description": "Cable",
          "quantity": 1,
          "unitPrice": "£05",
          "amount": "£05",
        },
        {
          "description": "Bolts",
          "quantity": 1,
          "unitPrice": "£05",
          "amount": "£05",
        },
      ],
      "subtotal": "£13.0",
      "vat": "£0.5",
      "total": "£13.5",
      "signature": "John Smith",
    };
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

  void _startSpotlight() {
    debugPrint("Invoice AI Generated: Starting spotlight check...");

    // Debug the spotlight service
    SpotlightService.instance.debugAllSpotlights();

    // Check if spotlight has been shown before
    bool hasShown = SpotlightService.instance
        .hasShownInvoiceAiGeneratedSpotlight();
    debugPrint(
      "Invoice AI Generated: hasShownInvoiceAiGeneratedSpotlight returned: $hasShown",
    );

    if (!hasShown) {
      debugPrint("Invoice AI Generated: First time, showing spotlight!");
      showSpotlight.value = true;

      // Hide spotlight after 5 seconds
      spotlightTimer = Timer(const Duration(seconds: 5), () {
        showSpotlight.value = false;
        // Mark spotlight as shown
        SpotlightService.instance.setInvoiceAiGeneratedSpotlightShown();
        debugPrint("Invoice AI Generated: Spotlight marked as shown");
      });
    } else {
      debugPrint(
        "Invoice AI Generated: Already shown before, hiding spotlight",
      );
      showSpotlight.value = false;
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

    // Navigate back to previous screen immediately
    Get.back();
  }

  // Send invoice via email
  Future<void> sendInvoiceEmail() async {
    try {
      // Get invoice_id from InvoiceManuallyController
      int? invoiceIdValue;
      if (Get.isRegistered<InvoiceManuallyController>()) {
        final invoiceManuallyController = Get.find<InvoiceManuallyController>();
        invoiceIdValue = invoiceManuallyController.invoiceId.value;
      }

      // If invoiceId is still null, try to get it from quoteData
      if (invoiceIdValue == null && quoteData.isNotEmpty) {
        final dataInvoiceId = quoteData['invoice_id'] ?? quoteData['id'];
        if (dataInvoiceId != null) {
          invoiceIdValue = int.tryParse(dataInvoiceId.toString());
        }
      }

      if (invoiceIdValue == null) {
        EasyLoading.showError(
          'Invoice ID not found. Please create an invoice first.',
        );
        debugPrint('❌ Send email failed: Invoice ID is null');
        return;
      }

      // Check if client has email
      String clientEmail = '';

      // Try to get email from InvoiceManuallyController
      if (Get.isRegistered<InvoiceManuallyController>()) {
        final invoiceManuallyController = Get.find<InvoiceManuallyController>();
        clientEmail =
            invoiceManuallyController.selectedClient['email']
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
          'Client email not found. Please add client email to send invoice.',
        );
        debugPrint(
          '❌ Send email failed: Client email is empty or not provided',
        );
        return;
      }

      // Show loading
      EasyLoading.show(status: 'Sending email...');
      debugPrint('📧 Starting email send for invoice ID: $invoiceIdValue');
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
      final url = Urls.sendInvoiceEmail(invoiceIdValue);
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
        EasyLoading.showSuccess('Invoice sent successfully via email!');
        debugPrint('✅ Invoice email sent successfully');
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
      debugPrint('❌ Exception in sendInvoiceEmail: $e');
      EasyLoading.showError('Failed to send email: $e');
    }
  }

  // Send invoice via WhatsApp
  Future<void> sendInvoiceWhatsApp() async {
    try {
      // Get invoice_id from InvoiceManuallyController
      int? invoiceIdValue;
      if (Get.isRegistered<InvoiceManuallyController>()) {
        final invoiceManuallyController = Get.find<InvoiceManuallyController>();
        invoiceIdValue = invoiceManuallyController.invoiceId.value;
      }

      // If invoiceId is still null, try to get it from quoteData
      if (invoiceIdValue == null && quoteData.isNotEmpty) {
        final dataInvoiceId = quoteData['invoice_id'] ?? quoteData['id'];
        if (dataInvoiceId != null) {
          invoiceIdValue = int.tryParse(dataInvoiceId.toString());
        }
      }

      if (invoiceIdValue == null) {
        EasyLoading.showError(
          'Invoice ID not found. Please create an invoice first.',
        );
        debugPrint('❌ Send WhatsApp failed: Invoice ID is null');
        return;
      }

      // Check if client has phone number
      String clientPhone = '';

      // Try to get phone from InvoiceManuallyController
      if (Get.isRegistered<InvoiceManuallyController>()) {
        final invoiceManuallyController = Get.find<InvoiceManuallyController>();
        clientPhone =
            invoiceManuallyController.selectedClient['phone_number']
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

      // Clean phone number (remove spaces, dashes, etc.)
      clientPhone = clientPhone.replaceAll(RegExp(r'[^\d+]'), '');

      // Show loading
      EasyLoading.show(status: 'Preparing WhatsApp...');
      debugPrint('📱 Starting WhatsApp send for invoice ID: $invoiceIdValue');
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
      final url = Urls.expotInvoicePdf(invoiceIdValue);
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
            'invoice_${invoiceIdValue}_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final String filePath = '${tempDir.path}/$fileName';
        final File pdfFile = File(filePath);
        await pdfFile.writeAsBytes(pdfBytes);

        debugPrint('✅ PDF saved to: $filePath');

        EasyLoading.dismiss();

        // Share PDF directly to WhatsApp
        final message = 'Here is your invoice from Fixxa';
        final XFile xFile = XFile(filePath);

        // Share directly to WhatsApp
        final result = await Share.shareXFiles([xFile], text: message);

        if (result.status == ShareResultStatus.success) {
          EasyLoading.showSuccess('Invoice sent to WhatsApp successfully!');
          debugPrint('✅ Invoice shared to WhatsApp successfully');
        } else {
          EasyLoading.showInfo('Please select WhatsApp to send the invoice');
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
      debugPrint('❌ Exception in sendInvoiceWhatsApp: $e');
      EasyLoading.showError('Failed to send via WhatsApp: $e');
    }
  }

  @override
  void onClose() {
    spotlightTimer?.cancel();
    signatureController.dispose();
    super.onClose();
  }

  /// Call the AI audio processing endpoint with `status` either "quote" or "invoice".
  /// On success the endpoint is expected to return a JSON containing `client_data`
  /// which will be applied to `quoteData` so the UI shows generated data.
  Future<void> processAiAudio({required bool isQuote}) async {
    final status = isQuote ? 'quote' : 'invoice';
    try {
      EasyLoading.show(status: 'Processing voice...');
      debugPrint('🔊 processAiAudio: sending request with status: $status');

      final response = await http.post(
        Uri.parse(aiAudio),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': status}),
      );

      debugPrint('🔊 processAiAudio: statusCode=${response.statusCode}');
      debugPrint('🔊 processAiAudio: body=${response.body}');

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);

        // If endpoint returns top-level 'client_data', use it. Otherwise use returned map.
        final clientData = data['client_data'] ?? data;

        if (clientData is Map<String, dynamic>) {
          // Normalize phone number if present
          if (clientData.containsKey('phone')) {
            clientData['phone'] = clientData['phone']
                .toString()
                .replaceAll(RegExp(r'[^\d+]'), '');
          }

          // Update observable so UI updates
          quoteData.value = Map<String, dynamic>.from(clientData);

          EasyLoading.showSuccess('AI generated data applied');
          debugPrint('✅ processAiAudio: quoteData updated with AI data');
        } else {
          EasyLoading.showError('Invalid AI response format');
          debugPrint('❌ processAiAudio: client_data not a map');
        }
      } else {
        // Try to parse an error message
        try {
          final err = json.decode(response.body);
          final msg = err['message'] ?? err['error'] ?? 'AI processing failed';
          EasyLoading.showError(msg.toString());
        } catch (_) {
          EasyLoading.showError('AI processing failed: ${response.statusCode}');
        }
        debugPrint('❌ processAiAudio failed: ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Failed to process voice: $e');
      debugPrint('❌ Exception in processAiAudio: $e');
    }
  }
}
