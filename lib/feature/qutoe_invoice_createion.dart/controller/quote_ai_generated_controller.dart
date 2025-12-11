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
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
        {"description": "Cable", "quantity": 1, "unitPrice": "£05", "amount": "£05"},
        {"description": "Bolts", "quantity": 1, "unitPrice": "£05", "amount": "£05"}
      ],
      "subtotal": "£13.0",
      "vat": "£0.5",
      "total": "£13.5",
      "signature": "John Smith"//
    };
  }

  void _startSpotlight() {
    debugPrint("Quote AI Generated: Starting spotlight check...");
    
    // Debug the spotlight service
    SpotlightService.instance.debugAllSpotlights();
    
    // Check if spotlight has been shown before
    bool hasShown = SpotlightService.instance.hasShownQuoteAiGeneratedSpotlight();
    debugPrint("Quote AI Generated: hasShownQuoteAiGeneratedSpotlight returned: $hasShown");
    
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
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
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
                    child: const Text('Save', style: TextStyle(color: Colors.white)),
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
        EasyLoading.showError('Quote ID not found. Please create a quote first.');
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
        final String fileName = 'quote_${quoteId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
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

  @override
  void onClose() {
    spotlightTimer?.cancel();
    signatureController.dispose();
    super.onClose();
  }
}