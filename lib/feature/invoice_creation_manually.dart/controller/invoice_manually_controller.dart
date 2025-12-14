import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:fixxa_app/core/services/spotlight_service.dart';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:signature/signature.dart';

class InvoiceManuallyController extends GetxController {
  var subtotal = 0.0.obs;
  var discount = 0.0.obs;
  var tax = 0.0.obs;
  var total = 0.0.obs;
  var payment = "Standard Payment".obs;

  // Spotlight variables
  var showSpotlight = false.obs;
  var showAddItemSpotlight = false.obs;
  var showPaymentSpotlight = false.obs;
  var showPreviewSpotlight = false.obs;
  var showAddItemScreenSpotlight = false.obs;
  Timer? spotlightTimer;
  @override
  void onInit() {
    super.onInit();
    subtotal.value = 100.0;
    discount.value = 10.0;
    tax.value = 9.0;
    total.value = subtotal.value - discount.value + tax.value;

    _initializeSpotlights();
  }

  void _initializeSpotlights() {
    // Check if ALL spotlights have been shown before using a single key
    if (SpotlightService.instance.hasShownInvoiceManuallySpotlight()) {
      // Already shown, don't show any spotlights
      return;
    }

    // First time: Show all spotlights in sequence
    showSpotlight.value = true;

    // Hide first spotlight after 4 seconds and show next
    Future.delayed(const Duration(seconds: 4), () {
      showSpotlight.value = false;
      showAddItemSpotlight.value = true;
    });

    // Hide second spotlight after 8 seconds and show next
    Future.delayed(const Duration(seconds: 8), () {
      showAddItemSpotlight.value = false;
      showPaymentSpotlight.value = true;
    });

    // Hide third spotlight after 12 seconds and show next
    Future.delayed(const Duration(seconds: 12), () {
      showPaymentSpotlight.value = false;
      showPreviewSpotlight.value = true;
    });

    // Hide final spotlight after 16 seconds and mark as shown
    Future.delayed(const Duration(seconds: 16), () {
      showPreviewSpotlight.value = false;
      // Mark ALL spotlights as shown so they never appear again
      SpotlightService.instance.setInvoiceManuallySpotlightShown();
    });
  }

  void updateValues({double? sub, double? disc, double? tx}) {
    if (sub != null) subtotal.value = sub;
    if (disc != null) discount.value = disc;
    if (tx != null) tax.value = tx;
    total.value = subtotal.value - discount.value + tax.value;
  }

  void startAddItemScreenSpotlight() {
    // Check if this spotlight has been shown before
    if (!SpotlightService.instance.hasShownInvoiceAddItemScreenSpotlight()) {
      showAddItemScreenSpotlight.value = true;
      // Hide spotlight after 4 seconds and mark as shown
      Future.delayed(const Duration(seconds: 4), () {
        showAddItemScreenSpotlight.value = false;
        SpotlightService.instance.setInvoiceAddItemScreenSpotlightShown();
      });
    }
  }

  var selectedContacts = <Map<String, dynamic>>[].obs;
  var selectedClient = <String, dynamic>{}.obs;
  var recentlyAddedClient = Rx<Map<String, dynamic>?>(
    null,
  ); // Recently added client (manual or contact)

  final descriptionController = TextEditingController();
  final estimatedCostController = TextEditingController();
  final quantityController = TextEditingController();

  var discountType = "None".obs;
  var dayhour = "Days".obs;
  var items = <Map<String, dynamic>>[].obs;
  var services = <Map<String, dynamic>>[].obs;
  var materials = <Map<String, dynamic>>[].obs;

  // For editing existing items
  int? editItemIndex;

  var isTaxable = true.obs;

  // Date fields
  var issueDate = Rx<DateTime?>(null);
  var dueDate = Rx<DateTime?>(null);

  // Discount and VAT
  var discountAmount = 0.0.obs;
  var vatRate = 0.0.obs;

  // Signature
  var hasSignature = false.obs;
  var signatureBytes = Rx<Uint8List?>(null);

  void addService({
    required String description,
    required String service,
    required double rate,
    required int duration,
  }) {
    services.add({
      'description': description,
      'service': service,
      'rate': rate,
      'quantity': duration,
      'price': rate * duration,
    });
  }

  void addMaterial({
    required String material,
    required int quantity,
    required String unitPrice,
  }) {
    materials.add({
      'material': material,
      'quantity': quantity,
      'unit_price': unitPrice,
      'amount': unitPrice,
    });
  }

  // Controllers for add dialogs to keep UI stateless
  final serviceDescriptionController = TextEditingController();
  final serviceNameController = TextEditingController();
  final serviceRateController = TextEditingController();
  final serviceDurationController = TextEditingController();

  final materialNameController = TextEditingController();
  final materialQtyController = TextEditingController();
  final materialUnitPriceController = TextEditingController();

  // Add a combined item with both service and material data
  void addItem({
    String? description,
    String? service,
    double? rate,
    int? duration,
    String? material,
    int? quantity,
    double? unitPrice,
  }) {
    items.add({
      'quote_description': description ?? '',
      'service_type': service ?? '',
      'service_rate': rate ?? 0.0,
      'service_duration': duration?.toDouble() ?? 0.0,
      'material_name': material ?? '',
      'quantity': quantity ?? 0,
      'unit_price': unitPrice ?? 0.0,
      'duration_unit': dayhour.value.toLowerCase(),
    });
    items.refresh();
  }

  // Show dialog for adding combined items (services/materials)
  void showAddCombinedItemDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Add Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Service Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: serviceDescriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: serviceNameController,
                decoration: const InputDecoration(labelText: 'Service'),
              ),
              TextField(
                controller: serviceRateController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Rate'),
              ),
              TextField(
                controller: serviceDurationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Duration'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Material Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: materialNameController,
                decoration: const InputDecoration(labelText: 'Material'),
              ),
              TextField(
                controller: materialQtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              TextField(
                controller: materialUnitPriceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Unit Price'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final desc = serviceDescriptionController.text.trim();
              final service = serviceNameController.text.trim();
              final rate = double.tryParse(serviceRateController.text) ?? 0.0;
              final duration =
                  int.tryParse(serviceDurationController.text) ?? 0;
              final material = materialNameController.text.trim();
              final qty = int.tryParse(materialQtyController.text) ?? 0;
              final unitPrice =
                  double.tryParse(materialUnitPriceController.text) ?? 0.0;

              // Add item with both service and material data
              addItem(
                description: desc,
                service: service,
                rate: rate,
                duration: duration,
                material: material,
                quantity: qty,
                unitPrice: unitPrice,
              );

              // Clear all controllers
              serviceDescriptionController.clear();
              serviceNameController.clear();
              serviceRateController.clear();
              serviceDurationController.clear();
              materialNameController.clear();
              materialQtyController.clear();
              materialUnitPriceController.clear();

              Get.back();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // Show signature dialog
  SignatureController? _signatureController;

  void showSignatureDialog(BuildContext context) {
    _signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Add Signature',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Signature(
            controller: _signatureController!,
            backgroundColor: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _signatureController?.clear();
            },
            child: Text('Clear'),
          ),
          TextButton(
            onPressed: () {
              _signatureController?.dispose();
              Navigator.pop(ctx);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_signatureController!.isNotEmpty) {
                final signature = await _signatureController!.toPngBytes();
                if (signature != null) {
                  signatureBytes.value = signature;
                  hasSignature.value = true;
                }
              }
              _signatureController?.dispose();
              Navigator.pop(ctx);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> pickContact() async {
    if (await Permission.contacts.request().isGranted) {
      final contact = await FlutterContactsService.openDeviceContactPicker();
      if (contact != null) {
        final String contactName = contact.displayName ?? "No Name";
        // Check for duplicates by name
        if (!selectedContacts.any((c) => c['name'] == contactName)) {
          selectedContacts.add({'name': contactName, 'photo': contact.avatar});
        } else {
          Get.snackbar("Duplicate", "This contact is already added.");
        }
      }
    } else {
      Get.snackbar("Permission Denied", "Contacts permission is required");
    }
  }

  // Connect with Stripe API call
  Future<void> connectWithStripe() async {
    try {
      // Show loading
      EasyLoading.show(status: 'Connecting with Stripe...');

      // Get access token
      final token = await LoginController.getAccessToken();
      if (token == null) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login again');
        return;
      }

      debugPrint('🔗 Connecting with Stripe...');
      debugPrint('🔗 URL: ${Urls.paymentStripe}');

      // Make POST request with Bearer token, no body
      final response = await http.post(
        Uri.parse(Urls.paymentStripe),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('📥 Response Status: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      // Hide loading
      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          // Parse response to get onboarding_url
          final responseData = jsonDecode(response.body);
          final onboardingUrl = responseData['onboarding_url'] as String?;
          final accountId = responseData['account_id'] as String?;

          debugPrint('✅ Successfully connected with Stripe');
          debugPrint('🔗 Onboarding URL: $onboardingUrl');
          debugPrint('🆔 Account ID: $accountId');

          if (onboardingUrl != null && onboardingUrl.isNotEmpty) {
            // Launch the onboarding URL in browser
            final uri = Uri.parse(onboardingUrl);
            try {
              // Try launching with external application mode (opens in browser)
              final launched = await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              );

              if (launched) {
                EasyLoading.showSuccess('Opening Stripe setup...');
                debugPrint('✅ Successfully launched URL: $onboardingUrl');
              } else {
                // Fallback: try platform default
                final launched2 = await launchUrl(
                  uri,
                  mode: LaunchMode.platformDefault,
                );
                if (launched2) {
                  EasyLoading.showSuccess('Opening Stripe setup...');
                } else {
                  EasyLoading.showError('Could not open the Stripe setup URL');
                  debugPrint('❌ Could not launch URL: $onboardingUrl');
                }
              }
            } catch (e) {
              EasyLoading.showError('Error opening URL: $e');
              debugPrint('❌ Exception launching URL: $e');
            }
          } else {
            EasyLoading.showSuccess('Successfully connected with Stripe!');
          }
        } catch (e) {
          debugPrint('❌ Error parsing response: $e');
          EasyLoading.showSuccess('Successfully connected with Stripe!');
        }
      } else {
        final errorData = response.body;
        debugPrint('❌ Error: $errorData');
        EasyLoading.showError(
          'Failed to connect with Stripe. Please try again.',
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('An error occurred: $e');
      debugPrint('❌ Exception: $e');
    }
  }

  // Clear client data when dialog is closed
  void clearClientData() {
    selectedClient.clear();
    recentlyAddedClient.value = null;
  }

  @override
  void onClose() {
    descriptionController.dispose();
    estimatedCostController.dispose();
    quantityController.dispose();
    super.onClose();
  }
}
