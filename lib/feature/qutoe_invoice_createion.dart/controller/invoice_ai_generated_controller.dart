import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

class InvoiceAiGeneratedController extends GetxController{
   var quoteData = <String, dynamic>{}.obs;
  
  // Spotlight variables
  var showSpotlight = false.obs;
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
    // Start spotlight effect
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
        {"description": "Item 1", "quantity": 1, "unitPrice": "£05", "amount": "£05"},
        {"description": "Item 3", "quantity": 1, "unitPrice": "£05", "amount": "£05"}
      ],
      "subtotal": "£13.0",
      "vat": "£0.5",
      "total": "£13.5",
      "signature": "John Smith"
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
    showSpotlight.value = true;
    
    // Hide spotlight after 5 seconds
    spotlightTimer = Timer(const Duration(seconds: 5), () {
      showSpotlight.value = false;
    });
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

  @override
  void onClose() {
    spotlightTimer?.cancel();
    signatureController.dispose();
    super.onClose();
  }
}