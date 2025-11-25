import 'dart:convert';
import 'package:fixxa_app/core/services/spotlight_service.dart';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/client_details/controller/client_details_controller.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';

class ManuallyQuoteController extends GetxController {
  var subtotal = 0.0.obs;
  var discount = 0.0.obs;
  var tax = 0.0.obs;
  var total = 0.0.obs;

  var selectedContacts = <Map<String, dynamic>>[].obs;
  var selectedClient = <String, dynamic>{}.obs;
  
  var showSpotlight = false.obs;
  var showAddItemSpotlight = false.obs;
  var showPaymentSpotlight = false.obs;
  var showPreviewSpotlight = false.obs;
  var showAddItemScreenSpotlight = false.obs;

  final descriptionController = TextEditingController();
  final estimatedCostController = TextEditingController();
  final quantityController = TextEditingController();
  
  // Manual Client Controllers
  final manualClientNameController = TextEditingController();
  final manualClientPhoneController = TextEditingController();
  final manualClientEmailController = TextEditingController();
  final manualClientAddressController = TextEditingController();
  var manualClientImage = Rx<String?>(null);

  // Additional required fields for manual quote
  var source = "manual".obs;
  var discountAmount = 0.0.obs;
  var discountTypeField = "percentage".obs;
  var vatRate = 0.0.obs;
  var issueDate = RxnString();
  var dueDate = RxnString();

  // Signature support
  SignatureController signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  var hasSignature = false.obs;
  Uint8List? signatureBytes;
  var isSubmitting = false.obs;

  var discountType = "None".obs;
  var dayhour = "Days".obs;
  var payment ="Standard Payment".obs;
  var items = <Map<String, dynamic>>[].obs;
  var services = <Map<String, dynamic>>[].obs;
  var materials = <Map<String, dynamic>>[].obs;
  
  // For editing existing items
  int? editItemIndex;

  var isTaxable = false.obs;

  // Add a new service item (for the Service Table only)
  void addService({required String description, required String service, required double rate, required int duration}){
    services.add({
      'description': description,
      'service': service,
      'rate': rate,
      'quantity': duration,
      'price': rate * duration,
    });
  }

  // Add a material row
  void addMaterial({required String material, required int quantity, required String unitPrice}){
    materials.add({
      'material': material,
      'quantity': quantity,
      'unit_price': unitPrice,
      'amount': unitPrice,
    });
  }

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
    if (SpotlightService.instance.hasShownManuallyQuoteSpotlight()) {
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
      SpotlightService.instance.setManuallyQuoteSpotlightShown();
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
    if (!SpotlightService.instance.hasShownAddItemScreenSpotlight()) {
      showAddItemScreenSpotlight.value = true;
      // Hide spotlight after 4 seconds and mark as shown
      Future.delayed(const Duration(seconds: 4), () {
        showAddItemScreenSpotlight.value = false;
        SpotlightService.instance.setAddItemScreenSpotlightShown();
      });
    }
  }

  Future<void> pickContact() async {
    if (await Permission.contacts.request().isGranted) {
      final contact = await FlutterContactsService.openDeviceContactPicker();
      if (contact != null) {
        final String contactName = contact.displayName ?? "No Name";
        
        // Get phone number from contact
        String? phoneNumber;
        if (contact.phones != null && contact.phones!.isNotEmpty) {
          phoneNumber = contact.phones!.first.value;
        }
        
        // Check for duplicates by name
        if (!selectedContacts.any((c) => c['name'] == contactName)) {
          selectedContacts.add({
            'name': contactName, 
            'photo': contact.avatar,
            'phone_number': phoneNumber,
          });
        } else {
          Get.snackbar("Duplicate", "This contact is already added.");
        }
      }
    } else {
      Get.snackbar("Permission Denied", "Contacts permission is required");
    }
  }

  // Import client from contact using POST API
  Future<bool> importClientFromContact({
    required String name,
    required String phoneNumber,
  }) async {
    try {
      // Show loading
      EasyLoading.show(status: 'Adding client...');

      // Get access token
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        return false;
      }

      // POST request to import client from contact API
      final response = await http.post(
        Uri.parse(Urls.addclientfromimport),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'name': name,
          'phone_number': phoneNumber,
        }),
      );

      // Hide loading
      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Client imported successfully: $responseData');
        
        EasyLoading.showSuccess('Client added successfully!');
        // Refresh global clients list so newly added/imported client appears
        try {
          if (Get.isRegistered<ClientDetailsController>()) {
            final clientCtrl = Get.find<ClientDetailsController>();
            await clientCtrl.fetchClientsFromApi();
          } else {
            final clientCtrl = Get.put(ClientDetailsController());
            await clientCtrl.fetchClientsFromApi();
          }
        } catch (e) {
          debugPrint('⚠️ Could not refresh clients list: $e');
        }
        return true;
      } else if (response.statusCode == 400) {
        // Check if client already exists
        final errorData = jsonDecode(response.body);
        debugPrint('⚠️ Client import response: $errorData');
        
        if (errorData['data'] != null && 
            errorData['data']['phone_number'] != null &&
            errorData['data']['phone_number'].toString().contains('already exists')) {
          // Client already exists - treat as success
          EasyLoading.showSuccess('Client selected successfully!');
          // Also refresh the clients list in case it existed but not yet fetched
          try {
            if (Get.isRegistered<ClientDetailsController>()) {
              final clientCtrl = Get.find<ClientDetailsController>();
              await clientCtrl.fetchClientsFromApi();
            } else {
              final clientCtrl = Get.put(ClientDetailsController());
              await clientCtrl.fetchClientsFromApi();
            }
          } catch (e) {
            debugPrint('⚠️ Could not refresh clients list: $e');
          }
          return true;
        }
        
        EasyLoading.showError(
          errorData['message'] ?? 'Failed to add client. Please try again.',
        );
        return false;
      } else {
        // Other errors
        final errorData = jsonDecode(response.body);
        debugPrint('❌ Error importing client: $errorData');
        
        EasyLoading.showError(
          errorData['message'] ?? 'Failed to add client. Please try again.',
        );
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('❌ Exception importing client: $e');
      EasyLoading.showError('An error occurred: $e');
      return false;
    }
  }

  // Create new client manually using POST API with FormData
  Future<bool> createManualClient({
    required String name,
    required String phoneNumber,
    String? email,
    String? address,
    String? imagePath,
  }) async {
    try {
      // Show loading
      EasyLoading.show(status: 'Adding client...');

      // Get access token
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        return false;
      }

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Urls.createnewClient),
      );

      // Add headers
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Add form fields
      request.fields['name'] = name;
      request.fields['phone_number'] = phoneNumber;
      if (email != null && email.isNotEmpty) {
        request.fields['email'] = email;
      }
      if (address != null && address.isNotEmpty) {
        request.fields['address'] = address;
      }

      // Add image if provided
      if (imagePath != null && imagePath.isNotEmpty) {
        var file = await http.MultipartFile.fromPath(
          'image',
          imagePath,
        );
        request.files.add(file);
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Hide loading
      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Manual client created successfully: $responseData');
        
        EasyLoading.showSuccess('Client added successfully!');
        // Refresh global clients list so newly created client is visible in client list
        try {
          if (Get.isRegistered<ClientDetailsController>()) {
            final clientCtrl = Get.find<ClientDetailsController>();
            await clientCtrl.fetchClientsFromApi();
          } else {
            final clientCtrl = Get.put(ClientDetailsController());
            await clientCtrl.fetchClientsFromApi();
          }
        } catch (e) {
          debugPrint('⚠️ Could not refresh clients list: $e');
        }
        return true;
      } else if (response.statusCode == 400) {
        // Check if client already exists
        final errorData = jsonDecode(response.body);
        debugPrint('⚠️ Manual client creation response: $errorData');
        
        if (errorData['data'] != null && 
            errorData['data']['phone_number'] != null &&
            errorData['data']['phone_number'].toString().contains('already exists')) {
          // Client already exists - treat as success
          EasyLoading.showSuccess('Client selected successfully!');
          // Refresh clients list in case server already had the client
          try {
            if (Get.isRegistered<ClientDetailsController>()) {
              final clientCtrl = Get.find<ClientDetailsController>();
              await clientCtrl.fetchClientsFromApi();
            } else {
              final clientCtrl = Get.put(ClientDetailsController());
              await clientCtrl.fetchClientsFromApi();
            }
          } catch (e) {
            debugPrint('⚠️ Could not refresh clients list: $e');
          }
          return true;
        }
        
        EasyLoading.showError(
          errorData['message'] ?? 'Failed to add client. Please try again.',
        );
        return false;
      } else {
        // Other errors
        final errorData = jsonDecode(response.body);
        debugPrint('❌ Error creating manual client: $errorData');
        
        EasyLoading.showError(
          errorData['message'] ?? 'Failed to add client. Please try again.',
        );
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('❌ Exception creating manual client: $e');
      EasyLoading.showError('An error occurred: $e');
      return false;
    }
  }

  void setClientData(Map<String, dynamic> clientData) {
    selectedClient.value = clientData;
  }

  // Signature methods (simple subset)
  void clearSignature() {
    signatureController.clear();
    hasSignature.value = false;
    signatureBytes = null;
    update();
  }

  Future<void> saveSignature() async {
    if (signatureController.isNotEmpty) {
      signatureBytes = await signatureController.toPngBytes();
      hasSignature.value = true;
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

  // Build and submit quote
  Future<bool> createQuote() async {
    // Basic validation
    final missing = <String>[];
    if (selectedClient.isEmpty) missing.add('client');
    if (items.isEmpty) missing.add('items');
    if (discountAmount.value == 0.0) missing.add('discount_amount');
    if (discountTypeField.value.isEmpty) missing.add('discount_type');
    if (vatRate.value == 0.0) missing.add('vat_rate');
    if (issueDate.value == null || issueDate.value!.isEmpty) missing.add('issue_date');
    if (dueDate.value == null || dueDate.value!.isEmpty) missing.add('due_date');
    if (!hasSignature.value || signatureBytes == null) missing.add('signature');

    if (missing.isNotEmpty) {
      Get.snackbar(
        'Missing fields',
        'Please provide: ${missing.join(', ')}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      isSubmitting.value = true;
      EasyLoading.show(status: 'Sending quote...');

      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        isSubmitting.value = false;
        return false;
      }

      var request = http.MultipartRequest('POST', Uri.parse(Urls.createquote));
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Attach fields
      final clientField = selectedClient['id']?.toString() ?? selectedClient['phone_number'] ?? selectedClient['name'] ?? '';
      request.fields['client'] = clientField;
      request.fields['source'] = source.value;
      request.fields['discount_amount'] = discountAmount.value.toString();
      request.fields['discount_type'] = discountTypeField.value;
      request.fields['vat_rate'] = vatRate.value.toString();
      request.fields['issue_date'] = issueDate.value!;
      request.fields['due_date'] = dueDate.value!;

      // Items as JSON
      final itemsList = items.map((it) {
        return {
          'quote_description': it['description'] ?? '',
          'service_type': it['dayhour'] ?? '',
          'material_name': it['description'] ?? '',
          'rate': it['rate']?.toString() ?? '0',
          'quantity': it['quantity']?.toString() ?? '1',
        };
      }).toList();
      request.fields['items'] = jsonEncode(itemsList);

      // Attach signature file
      if (signatureBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'signature',
            signatureBytes!,
            filename: 'signature.png',
            contentType: MediaType('image', 'png'),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      EasyLoading.dismiss();
      isSubmitting.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('Quote sent successfully');
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        EasyLoading.showError(errorData['message'] ?? 'Failed to send quote');
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      isSubmitting.value = false;
      EasyLoading.showError('An error occurred: $e');
      return false;
    }
  }

  void addServiceItem(String serviceName, double rate) {
    items.add({
      'description': serviceName,
      'rate': rate,
      'quantity': 1,
      'discountType': 'None',
      'isTaxable': false,
      'dayhour': 'Days',
      'price': rate * 1, // rate * quantity
    });
    // Recalculate totals
    calculateTotals();
  }

  void calculateTotals() {
    double newSubtotal = 0.0;
    for (var item in items) {
      newSubtotal += (item['price'] ?? 0.0);
    }
    subtotal.value = newSubtotal;
    total.value = subtotal.value - discount.value + tax.value;
  }

  void clearManualClientForm() {
    manualClientNameController.clear();
    manualClientPhoneController.clear();
    manualClientEmailController.clear();
    manualClientAddressController.clear();
    manualClientImage.value = null;
  }

  @override
  void onClose() {
    descriptionController.dispose();
    estimatedCostController.dispose();
    quantityController.dispose();
    manualClientNameController.dispose();
    manualClientPhoneController.dispose();
    manualClientEmailController.dispose();
    manualClientAddressController.dispose();
    super.onClose();
  }
}
