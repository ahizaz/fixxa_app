import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fixxa_app/core/services/spotlight_service.dart';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:fixxa_app/feature/client_details/controller/client_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:signature/signature.dart';
import 'package:share_plus/share_plus.dart';

class InvoiceManuallyController extends GetxController {
  var subtotal = 0.0.obs;
  var discount = 0.0.obs;
  var tax = 0.0.obs;
  var total = 0.0.obs;
  var payment = "Standard Payment".obs;
  var invoiceId = RxnInt();
  var isSubmitting = false.obs;

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
    subtotal.value = 0.0;
    discount.value = 0.0;
    tax.value = 0.0;
    total.value = 0.0;

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

  // Bank detail controllers (used by AddInvoiceItem screen)
  final bankNameController = TextEditingController();
  final accountNameController = TextEditingController();
  final sortCodeController = TextEditingController();
  final accountNoController = TextEditingController();

  // Manual Client Controllers
  final manualClientNameController = TextEditingController();
  final manualClientBusinessNameController = TextEditingController();
  final manualClientPhoneController = TextEditingController();
  final manualClientEmailController = TextEditingController();
  final manualClientAddressController = TextEditingController();
  var manualClientImage = Rx<String?>(null);

  var discountType = "None".obs;
  var discountTypeField = "percentage".obs;
  var dayhour = "Days".obs;

  void setDiscountType(String type) {
    discountType.value = type;
    // Map UI discount type to API field
    if (type == "Percentage (%)") {
      discountTypeField.value = "percentage";
    } else if (type == "Fixed") {
      discountTypeField.value = "fixed";
    } else {
      discountTypeField.value = "percentage"; // default
    }
  }

  var items = <Map<String, dynamic>>[].obs;
  var services = <Map<String, dynamic>>[].obs;
  var materials = <Map<String, dynamic>>[].obs;
  var invoiceData = <String, dynamic>{}.obs;

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

  Future<void> pickContactAndImport() async {
    if (await Permission.contacts.request().isGranted) {
      final contact = await FlutterContactsService.openDeviceContactPicker();
      if (contact != null) {
        final String contactName = contact.displayName ?? "No Name";

        // Get phone number from contact
        String? phoneNumber;
        if (contact.phones != null && contact.phones!.isNotEmpty) {
          phoneNumber = contact.phones!.first.value;
        }

        // Check if phone number exists
        if (phoneNumber == null || phoneNumber.isEmpty) {
          Get.snackbar(
            "No Phone Number",
            "This contact doesn't have a phone number",
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        // Get contact avatar/photo
        Uint8List? avatarBytes = contact.avatar;

        // Call API to import client from contact immediately
        final success = await importClientFromContact(
          name: contactName,
          phoneNumber: phoneNumber,
          avatarBytes: avatarBytes,
        );

        if (success) {
          // Refresh client list to show newly added client
          try {
            final clientCtrl = Get.isRegistered<ClientDetailsController>()
                ? Get.find<ClientDetailsController>()
                : Get.put(ClientDetailsController());
            await clientCtrl.fetchClientsFromApi();

            // Small delay to ensure API response is processed
            await Future.delayed(const Duration(milliseconds: 100));

            // Force UI update by triggering observable
            clientCtrl.clients.refresh();

            // Set as recently added client
            // selectedClient is already set by importClientFromContact
            recentlyAddedClient.value = Map<String, dynamic>.from(
              selectedClient,
            );

            // Force update to trigger UI rebuild
            recentlyAddedClient.refresh();

            debugPrint('✅ Contact imported as client successfully');
            debugPrint(
              '📋 Recently added client: ${recentlyAddedClient.value?['name']}',
            );
            debugPrint('📋 Total clients: ${clientCtrl.clients.length}');
          } catch (e) {
            debugPrint('⚠️ Error refreshing client list: $e');
          }
        } else {
          debugPrint('❌ Failed to import contact as client');
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
    Uint8List? avatarBytes,
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

      // Prepare request body
      final Map<String, dynamic> requestBody = {
        'name': name,
        'phone_number': phoneNumber,
      };

      // Add avatar as base64 if available
      if (avatarBytes != null && avatarBytes.isNotEmpty) {
        final base64Image = base64Encode(avatarBytes);
        requestBody['image'] = base64Image;
        debugPrint('📸 Contact avatar captured (${avatarBytes.length} bytes)');
      }

      // Debug print request body
      debugPrint('🔵 POST Request to: ${Urls.addclientfromimport}');
      debugPrint('🔵 Request Body: ${jsonEncode(requestBody)}');

      // POST request to import client from contact API
      final response = await http.post(
        Uri.parse(Urls.addclientfromimport),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(requestBody),
      );

      // Hide loading
      EasyLoading.dismiss();

      // Debug print response
      debugPrint('🔵 Response Status Code: ${response.statusCode}');
      debugPrint('🔵 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Client imported successfully: $responseData');

        EasyLoading.showSuccess('Client added successfully!');
        // If server returned the created client data, set it as the selected client
        try {
          if (responseData != null && responseData['data'] != null) {
            final data = responseData['data'];
            selectedClient.value = {
              'id': data['id'],
              'name': data['name'] ?? name,
              'business_name': data['business_name'] ?? '',
              'email': data['email'] ?? '',
              'phone_number': data['phone_number'] ?? phoneNumber,
              'image': data['image'],
            };
          }
        } catch (e) {
          debugPrint(
            '⚠️ Could not set selected client from import response: $e',
          );
        }
        // Refresh global clients list so newly added/imported client appears
        try {
          // Refresh clients list and try to resolve the created client to get its id
          final clientCtrl = Get.isRegistered<ClientDetailsController>()
              ? Get.find<ClientDetailsController>()
              : Get.put(ClientDetailsController());
          await clientCtrl.fetchClientsFromApi();

          // If we didn't get the id from response, try to find the client by phone or name
          if ((selectedClient['id'] == null || selectedClient['id'] == '') &&
              phoneNumber.isNotEmpty) {
            Map<String, dynamic>? match;
            for (var c in clientCtrl.clients) {
              if ((c['phone_number'] ?? '').toString() ==
                      phoneNumber.toString() ||
                  (c['name'] ?? '').toString() == name) {
                match = c as Map<String, dynamic>?;
                break;
              }
            }
            if (match != null) {
              selectedClient.value = {
                'id': match['id'],
                'name': match['name'] ?? name,
                'business_name': match['business_name'] ?? '',
                'email': match['email'] ?? '',
                'phone_number': match['phone_number'] ?? phoneNumber,
                'image': match['image'] ?? match['avatar'],
              };
            }
          }
        } catch (e) {
          debugPrint('⚠️ Could not refresh clients list: $e');
        }
        return true;
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
    String? businessName,
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
      if (businessName != null && businessName.isNotEmpty) {
        request.fields['business_name'] = businessName;
      }
      request.fields['phone_number'] = phoneNumber;
      if (email != null && email.isNotEmpty) {
        request.fields['email'] = email;
      }
      if (address != null && address.isNotEmpty) {
        request.fields['address'] = address;
      }

      // Debug print request body
      debugPrint('🟢 POST Request to: ${Urls.createnewClient}');
      debugPrint('🟢 Request Fields: ${request.fields}');

      // Add image if provided
      if (imagePath != null && imagePath.isNotEmpty) {
        var file = await http.MultipartFile.fromPath('image', imagePath);
        request.files.add(file);
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Hide loading
      EasyLoading.dismiss();

      // Debug print response
      debugPrint('🟢 Response Status Code: ${response.statusCode}');
      debugPrint('🟢 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Manual client created successfully: $responseData');

        EasyLoading.showSuccess('Client added successfully!');
        // If server returned the created client data, set it as the selected client
        try {
          if (responseData != null && responseData['data'] != null) {
            final data = responseData['data'];
            selectedClient.value = {
              'id': data['id'],
              'name': data['name'] ?? name,
              'business_name': data['business_name'] ?? businessName ?? '',
              'email': data['email'] ?? email ?? '',
              'phone_number': data['phone_number'] ?? phoneNumber,
              'image':
                  imagePath, // include local image path so UI (dialog) shows it immediately
            };
          }
        } catch (e) {
          debugPrint(
            '⚠️ Could not set selected client from create response: $e',
          );
        }

        // Refresh global clients list so newly created client is visible in client list
        try {
          final clientCtrl = Get.isRegistered<ClientDetailsController>()
              ? Get.find<ClientDetailsController>()
              : Get.put(ClientDetailsController());
          await clientCtrl.fetchClientsFromApi();

          // If we didn't get the id from response, try to find the client by phone or name
          if ((selectedClient['id'] == null || selectedClient['id'] == '') &&
              phoneNumber.isNotEmpty) {
            Map<String, dynamic>? match;
            for (var c in clientCtrl.clients) {
              if ((c['phone_number'] ?? '').toString() ==
                      phoneNumber.toString() ||
                  (c['name'] ?? '').toString() == name) {
                match = c as Map<String, dynamic>?;
                break;
              }
            }
            if (match != null) {
              selectedClient.value = {
                'id': match['id'],
                'name': match['name'] ?? name,
                'business_name': match['business_name'] ?? businessName ?? '',
                'email': match['email'] ?? email ?? '',
                'phone_number': match['phone_number'] ?? phoneNumber,
                'image':
                    imagePath, // preserve locally selected image when resolving server match
              };
            }
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
            errorData['data']['phone_number'].toString().contains(
              'already exists',
            )) {
          // Client already exists - treat as success
          EasyLoading.showSuccess('Client selected successfully!');
          // Refresh clients list and attempt to select the existing client
          try {
            final clientCtrl = Get.isRegistered<ClientDetailsController>()
                ? Get.find<ClientDetailsController>()
                : Get.put(ClientDetailsController());
            await clientCtrl.fetchClientsFromApi();

            Map<String, dynamic>? match;
            for (var c in clientCtrl.clients) {
              if ((c['phone_number'] ?? '').toString() ==
                      phoneNumber.toString() ||
                  (c['name'] ?? '').toString() == name) {
                match = c as Map<String, dynamic>?;
                break;
              }
            }
            if (match != null) {
              selectedClient.value = {
                'id': match['id'],
                'name': match['name'] ?? name,
                'business_name': match['business_name'] ?? businessName ?? '',
                'email': match['email'] ?? email ?? '',
                'phone_number': match['phone_number'] ?? phoneNumber,
              };
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

  // Create invoice and send to API
  Future<bool> createInvoice() async {
    debugPrint('🚀 Starting invoice creation...');

    // Validation
    if (selectedClient.isEmpty || selectedClient['id'] == null) {
      EasyLoading.showError('Please select a client');
      return false;
    }

    if (items.isEmpty) {
      EasyLoading.showError('Please add at least one item');
      return false;
    }

    if (issueDate.value == null) {
      EasyLoading.showError('Please select issue date');
      return false;
    }

    if (dueDate.value == null) {
      EasyLoading.showError('Please select due date');
      return false;
    }

    try {
      isSubmitting.value = true;
      EasyLoading.show(status: 'Creating invoice...');

      // Get access token
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null) {
        EasyLoading.dismiss();
        isSubmitting.value = false;
        EasyLoading.showError('Please login again');
        return false;
      }

      final clientField = selectedClient['id'].toString();

      // Build multipart request
      var req = http.MultipartRequest('POST', Uri.parse(Urls.createInvoice));
      req.headers['Authorization'] = 'Bearer $accessToken';

      // Attach fields
      req.fields['client'] = clientField;
      req.fields['discount_amount'] = discountAmount.value.toString();
      req.fields['discount_type'] = discountTypeField.value;
      req.fields['vat_rate'] = vatRate.value.toString();
      req.fields['issue_date'] =
          '${issueDate.value!.year}-${issueDate.value!.month.toString().padLeft(2, '0')}-${issueDate.value!.day.toString().padLeft(2, '0')}';
      req.fields['due_date'] =
          '${dueDate.value!.year}-${dueDate.value!.month.toString().padLeft(2, '0')}-${dueDate.value!.day.toString().padLeft(2, '0')}';
      req.fields['duration_unit'] = dayhour.value.toLowerCase();

      // Filter out empty items
      final validItems = items.where((it) {
        final desc = (it['quote_description'] ?? it['description'] ?? '')
            .toString()
            .trim();
        final material = (it['material_name'] ?? it['material'] ?? '')
            .toString()
            .trim();
        final service = (it['service_type'] ?? it['service'] ?? '')
            .toString()
            .trim();
        return desc.isNotEmpty || material.isNotEmpty || service.isNotEmpty;
      }).toList();

      debugPrint('🔴 Total items to send: ${validItems.length}');

      final itemsList = validItems.map((it) {
        final qty = (it['quantity'] is int)
            ? it['quantity'] as int
            : int.tryParse((it['quantity'] ?? '').toString()) ?? 1;
        final unitPrice = (it['unit_price'] is num)
            ? (it['unit_price'] as num).toDouble()
            : double.tryParse((it['unit_price'] ?? '0').toString()) ?? 0.0;
        final serviceRate = (it['service_rate'] is num)
            ? (it['service_rate'] as num).toDouble()
            : double.tryParse((it['service_rate'] ?? '0').toString()) ?? 0.0;
        final serviceDuration = (it['service_duration'] is num)
            ? (it['service_duration'] as num).toDouble()
            : double.tryParse((it['service_duration'] ?? '0').toString()) ??
                  qty.toDouble();
        final durationUnit = (it['duration_unit'] ?? dayhour.value)
            .toString()
            .toLowerCase();

        return {
          'quote_description':
              (it['quote_description'] ?? it['description'] ?? '').toString(),
          'service_type': (it['service_type'] ?? it['service'] ?? '')
              .toString(),
          'material_name': (it['material_name'] ?? it['material'] ?? '')
              .toString(),
          'quantity': qty,
          'unit_price': unitPrice,
          'service_duration': serviceDuration,
          'service_rate': serviceRate,
        };
      }).toList();

      req.fields['items'] = jsonEncode(itemsList);
      debugPrint('🔵 Items field: ${req.fields['items']}');

      // Attach signature if exists
      if (signatureBytes.value != null) {
        req.files.add(
          http.MultipartFile.fromBytes(
            'signature',
            signatureBytes.value!,
            filename: 'signature.png',
            contentType: MediaType('image', 'png'),
          ),
        );
      }

      debugPrint('📤 Sending request to: ${Urls.createInvoice}');
      final streamedResponse = await req.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.dismiss();
        isSubmitting.value = false;

        // Parse response
        try {
          final responseData = jsonDecode(response.body);
          final data = (responseData is Map && responseData['data'] != null)
              ? responseData['data']
              : responseData;

          // Store invoice data
          if (data != null && data is Map) {
            invoiceData.value = Map<String, dynamic>.from(data);
          }

          // Store invoice ID
          if (data != null &&
              (data['id'] != null || data['invoice_id'] != null)) {
            final dynamic idVal = data['id'] ?? data['invoice_id'];
            if (idVal != null) {
              final parsed = int.tryParse(idVal.toString());
              if (parsed != null) {
                invoiceId.value = parsed;
                debugPrint('✅ Invoice ID set to: ${invoiceId.value}');
              }
            }
          }

          // Parse financial values
          double? parseNum(dynamic v) {
            if (v == null) return null;
            if (v is num) return v.toDouble();
            var s = v.toString().trim();
            // Remove common currency symbols and thousands separators
            s = s.replaceAll(RegExp(r'[£$€, ]'), '');
            return double.tryParse(s);
          }

          final sub = parseNum(
            data['subtotal'] ?? data['sub_total'] ?? data['subTotal'],
          );
          final disc = parseNum(
            data['discount_amount'] ??
                data['discount'] ??
                data['discountAmount'],
          );
          final vatRateValue = parseNum(data['vat_rate'] ?? data['vatRate']);

          // Calculate VAT amount if not provided
          double? tx = parseNum(
            data['vat_amount'] ?? data['tax'] ?? data['tax_amount'],
          );
          if ((tx == null || tx == 0.0) &&
              sub != null &&
              vatRateValue != null &&
              vatRateValue > 0) {
            // Calculate discount value first
            final discountType = data['discount_type'] ?? 'percentage';
            double discValue = 0.0;
            if (disc != null && disc > 0) {
              if (discountType == 'percentage') {
                discValue = sub * (disc / 100.0);
              } else {
                discValue = disc;
              }
            }
            // Apply VAT on subtotal after discount
            final subtotalAfterDiscount = sub - discValue;
            tx = subtotalAfterDiscount * (vatRateValue / 100.0);
          }

          final tot = parseNum(data['total'] ?? data['grand_total']);

          debugPrint('═══════════════════════════════════════════════════════');
          debugPrint('📊 FINANCIAL DETAILS FROM INVOICE RESPONSE:');
          debugPrint('   Invoice ID: ${invoiceId.value}');
          debugPrint('   Subtotal: £${sub?.toStringAsFixed(2) ?? '0.00'}');
          debugPrint('   Discount: £${disc?.toStringAsFixed(2) ?? '0.00'}');
          debugPrint(
            '   VAT Rate: ${vatRateValue?.toStringAsFixed(2) ?? '0.00'}%',
          );
          debugPrint('   VAT Amount: £${tx?.toStringAsFixed(2) ?? '0.00'}');
          debugPrint('   Total: £${tot?.toStringAsFixed(2) ?? '0.00'}');
          debugPrint('═══════════════════════════════════════════════════════');

          // Update UI values
          subtotal.value = sub ?? 0.0;
          discount.value = disc ?? 0.0;
          vatRate.value = vatRateValue ?? 0.0; // Store VAT rate
          tax.value = tx ?? 0.0;
          total.value = tot ?? 0.0;
        } catch (e) {
          debugPrint('⚠️ Could not parse totals from response: $e');
          total.value = subtotal.value - discount.value + tax.value;
        }

        EasyLoading.showSuccess('Invoice created successfully');
        return true;
      } else {
        EasyLoading.dismiss();
        isSubmitting.value = false;

        try {
          final errorData = jsonDecode(response.body);
          final msg = errorData['message'] ?? 'Failed to create invoice';
          EasyLoading.showError(msg);
        } catch (e) {
          EasyLoading.showError(
            'Failed to create invoice (status ${response.statusCode})',
          );
        }
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      isSubmitting.value = false;
      EasyLoading.showError('An error occurred: $e');
      debugPrint('❌ Exception: $e');
      return false;
    }
  }

  // Fetch invoice financial details from API
  Future<bool> fetchFinancials({
    int? id,
    String? accessToken,
    bool showLoading = false,
  }) async {
    try {
      final invoiceIdToFetch = id ?? invoiceId.value;
      if (invoiceIdToFetch == null) {
        debugPrint('⚠️ No invoice ID provided for fetchFinancials');
        return false;
      }

      if (showLoading) {
        EasyLoading.show(status: 'Loading financial details...');
      }

      String? token = accessToken;
      if (token == null) {
        token = await LoginController.getAccessToken();
        if (token == null) {
          if (showLoading) EasyLoading.dismiss();
          EasyLoading.showError('Please login again');
          return false;
        }
      }

      // Note: You may need to create an invoice financials endpoint similar to quotes
      // For now, we'll assume the financial data comes in the create response
      // If there's a separate endpoint, uncomment and modify below:
      /*
      final url = '${Urls.baseUrl}/quoteapp/invoices/$invoiceIdToFetch/financials/';
      debugPrint('📥 Fetching invoice financials from: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (showLoading) EasyLoading.dismiss();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Parse and update financial values
        double? parseNum(dynamic v) {
          if (v == null) return null;
          if (v is num) return v.toDouble();
          return double.tryParse(v.toString());
        }

        final sub = parseNum(data['subtotal']);
        final disc = parseNum(data['discount_amount']);
        final tx = parseNum(data['vat_amount']);
        final tot = parseNum(data['total']);

        subtotal.value = sub ?? 0.0;
        discount.value = disc ?? 0.0;
        tax.value = tx ?? 0.0;
        total.value = tot ?? 0.0;

        debugPrint('✅ Financial details fetched successfully');
        return true;
      }
      */

      return true;
    } catch (e) {
      if (showLoading) EasyLoading.dismiss();
      debugPrint('❌ Error fetching invoice financials: $e');
      return false;
    }
  }

  // Country list for Stripe
  static const Map<String, String> stripeCountries = {
    'AU': 'Australia',
    'AT': 'Austria',
    'BE': 'Belgium',
    'BR': 'Brazil',
    'BG': 'Bulgaria',
    'CA': 'Canada',
    'CI': 'Côte d\'Ivoire (Ivory Coast)',
    'HR': 'Croatia',
    'CY': 'Cyprus',
    'CZ': 'Czechia (Czech Republic)',
    'DK': 'Denmark',
    'EE': 'Estonia',
    'FI': 'Finland',
    'FR': 'France',
    'DE': 'Germany',
    'GH': 'Ghana',
    'GI': 'Gibraltar (British Overseas Territory)',
    'GR': 'Greece',
    'HK': 'Hong Kong (Special Administrative Region of China)',
    'HU': 'Hungary',
    'IN': 'India',
    'ID': 'Indonesia',
    'IE': 'Ireland',
    'IT': 'Italy',
    'JP': 'Japan',
    'KE': 'Kenya',
    'LV': 'Latvia',
    'LI': 'Liechtenstein',
    'LT': 'Lithuania',
    'LU': 'Luxembourg',
    'MY': 'Malaysia',
    'MT': 'Malta',
    'MX': 'Mexico',
    'NL': 'Netherlands',
    'NZ': 'New Zealand',
    'NG': 'Nigeria',
    'NO': 'Norway',
    'PL': 'Poland',
    'PT': 'Portugal',
    'RO': 'Romania',
    'SG': 'Singapore',
    'SK': 'Slovakia',
    'SI': 'Slovenia',
    'ES': 'Spain',
    'SE': 'Sweden',
    'CH': 'Switzerland',
    'TH': 'Thailand',
    'AE': 'United Arab Emirates',
    'GB': 'United Kingdom',
    'US': 'United States',
    'ZA': 'South Africa',
  };

  // Show country picker dialog
  Future<void> showCountryPicker(BuildContext context) async {
    final selectedCountryCode = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Country',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: stripeCountries.length,
                    itemBuilder: (context, index) {
                      final code = stripeCountries.keys.elementAt(index);
                      final name = stripeCountries[code]!;
                      return ListTile(
                        title: Text(name),
                        onTap: () {
                          Navigator.pop(context, code);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedCountryCode != null) {
      // Country selected, now connect with Stripe
      await connectWithStripeAPI(selectedCountryCode);
    }
  }

  // Connect with Stripe API call
  Future<void> connectWithStripe() async {
    // Get context from Get
    final context = Get.context;
    if (context == null) {
      EasyLoading.showError('Context not available');
      return;
    }

    // Show country picker first
    await showCountryPicker(context);
  }

  // Actual API call to connect with Stripe
  Future<void> connectWithStripeAPI(String countryCode) async {
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
      debugPrint('🔗 Country Code: $countryCode');

      // Make POST request with Bearer token and country in body
      final response = await http.post(
        Uri.parse(Urls.paymentStripe),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'country': countryCode}),
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

  // Check Stripe connection status
  Future<bool> checkStripeStatus() async {
    try {
      EasyLoading.show(status: 'Checking Stripe connection...');

      // Get access token
      final token = await LoginController.getAccessToken();
      if (token == null) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login again');
        return false;
      }

      debugPrint('🔗 Checking Stripe status...');
      debugPrint('🔗 URL: ${Urls.getStatus}');

      // Make GET request with Bearer token
      final response = await http.get(
        Uri.parse(Urls.getStatus),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('📥 Response Status: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      // Hide loading
      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Debug print all response data
        debugPrint('✅ Stripe Status Response:');
        debugPrint('   success: ${responseData['success']}');
        debugPrint('   stripe_connected: ${responseData['stripe_connected']}');
        debugPrint(
          '   stripe_connection_status: ${responseData['stripe_connection_status']}',
        );
        debugPrint(
          '   stripe_account_id: ${responseData['stripe_account_id']}',
        );

        final stripeConnectionStatus = responseData['stripe_connection_status'];

        if (stripeConnectionStatus == 'connected') {
          debugPrint('✅ Stripe is connected! User can proceed.');
          return true;
        } else {
          debugPrint(
            '❌ Stripe is not connected. Status: $stripeConnectionStatus',
          );
          EasyLoading.showError('Please connect your Stripe account first');
          return false;
        }
      } else {
        final errorData = response.body;
        debugPrint('❌ Error: $errorData');
        EasyLoading.showError('Failed to check Stripe status');
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('An error occurred: $e');
      debugPrint('❌ Exception: $e');
      return false;
    }
  }

  // Clear all invoice data when dialog is closed
  void clearClientData() {
    // Clear client data
    selectedClient.clear();
    recentlyAddedClient.value = null;

    // Clear items
    items.clear();
    services.clear();
    materials.clear();
    invoiceData.clear();

    // Clear form controllers
    descriptionController.clear();
    estimatedCostController.clear();
    quantityController.clear();

    // Clear manual client controllers
    manualClientNameController.clear();
    manualClientBusinessNameController.clear();
    manualClientPhoneController.clear();
    manualClientEmailController.clear();
    manualClientAddressController.clear();
    manualClientImage.value = null;

    // Reset financial values
    subtotal.value = 0.0;
    discount.value = 0.0;
    tax.value = 0.0;
    total.value = 0.0;
    discountAmount.value = 0.0;
    vatRate.value = 0.0;

    // Reset dates
    issueDate.value = null;
    dueDate.value = null;

    // Clear signature
    signatureBytes.value = null;
    hasSignature.value = false;

    // Reset dropdown values
    discountType.value = "None";
    dayhour.value = "Days";
    payment.value = "Standard Payment";
    discountTypeField.value = "percentage";

    // Reset edit index
    editItemIndex = null;

    // Reset invoice ID
    invoiceId.value = null;

    debugPrint('✅ Invoice data cleared successfully');
  }

  // Export invoice as PDF
  Future<void> exportInvoiceAsPdf() async {
    try {
      // Get invoice_id from controller
      final invoiceIdValue = invoiceId.value;

      if (invoiceIdValue == null) {
        EasyLoading.showError(
          'Invoice ID not found. Please create an invoice first.',
        );
        debugPrint('❌ Export PDF failed: Invoice ID is null');
        return;
      }

      // Show loading
      EasyLoading.show(status: 'Exporting PDF...');
      debugPrint('📤 Starting PDF export for invoice ID: $invoiceIdValue');

      // Get access token
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        debugPrint('❌ Export PDF failed: Access token is null or empty');
        return;
      }

      // Make GET request to export PDF endpoint
      final url = Urls.expotInvoicePdf(invoiceIdValue);
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
        debugPrint('✅ PDF received, size: ${pdfBytes.length} bytes');

        // Save PDF to device
        Directory? appDirectory;
        if (Platform.isAndroid) {
          appDirectory = await getExternalStorageDirectory();
        } else if (Platform.isIOS) {
          appDirectory = await getApplicationDocumentsDirectory();
        }

        if (appDirectory == null) {
          EasyLoading.showError('Could not get storage directory.');
          debugPrint('❌ Export PDF failed: Could not get storage directory');
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
            'invoice_${invoiceIdValue}_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final String filePath = '${customDirectory.path}/$fileName';
        final File pdfFile = File(filePath);
        await pdfFile.writeAsBytes(pdfBytes);

        debugPrint('✅ PDF saved to: $filePath');

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
      debugPrint('❌ Exception in exportInvoiceAsPdf: $e');
      EasyLoading.showError('Failed to export PDF: $e');
    }
  }

  // Export invoice as CSV
  Future<void> exportInvoiceAsCsv() async {
    try {
      // Get invoice_id from controller
      final invoiceIdValue = invoiceId.value;

      if (invoiceIdValue == null) {
        EasyLoading.showError(
          'Invoice ID not found. Please create an invoice first.',
        );
        debugPrint('❌ Export CSV failed: Invoice ID is null');
        return;
      }

      // Show loading
      EasyLoading.show(status: 'Exporting CSV...');
      debugPrint('📤 Starting CSV export for invoice ID: $invoiceIdValue');

      // Get access token
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        debugPrint('❌ Export CSV failed: Access token is null or empty');
        return;
      }

      // Make GET request to export CSV endpoint
      final url = Urls.exportInvoiceCsv(invoiceIdValue);
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
        debugPrint('✅ CSV received, size: ${csvBytes.length} bytes');

        // Save CSV to device
        Directory? appDirectory;
        if (Platform.isAndroid) {
          appDirectory = await getExternalStorageDirectory();
        } else if (Platform.isIOS) {
          appDirectory = await getApplicationDocumentsDirectory();
        }

        if (appDirectory == null) {
          EasyLoading.showError('Could not get storage directory.');
          debugPrint('❌ Export CSV failed: Could not get storage directory');
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
            'invoice_${invoiceIdValue}_${DateTime.now().millisecondsSinceEpoch}.csv';
        final String filePath = '${customDirectory.path}/$fileName';
        final File csvFile = File(filePath);
        await csvFile.writeAsBytes(csvBytes);

        debugPrint('✅ CSV saved to: $filePath');

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
      debugPrint('❌ Exception in exportInvoiceAsCsv: $e');
      EasyLoading.showError('Failed to export CSV: $e');
    }
  }

  // Export invoice as Excel
  Future<void> exportInvoiceAsExcel() async {
    try {
      // Get invoice_id from controller
      final invoiceIdValue = invoiceId.value;

      if (invoiceIdValue == null) {
        EasyLoading.showError(
          'Invoice ID not found. Please create an invoice first.',
        );
        debugPrint('❌ Export Excel failed: Invoice ID is null');
        return;
      }

      // Show loading
      EasyLoading.show(status: 'Exporting Excel...');
      debugPrint('📤 Starting Excel export for invoice ID: $invoiceIdValue');

      // Get access token
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        debugPrint('❌ Export Excel failed: Access token is null or empty');
        return;
      }

      // Make GET request to export Excel endpoint
      final url = Urls.exportInvoiceExcell(invoiceIdValue);
      debugPrint('📤 Exporting Excel from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        // Get Excel bytes from response
        final excelBytes = response.bodyBytes;
        debugPrint('✅ Excel received, size: ${excelBytes.length} bytes');

        // Save Excel to device Downloads folder
        Directory? appDirectory;
        if (Platform.isAndroid) {
          // Use Downloads directory for easier access
          appDirectory = Directory('/storage/emulated/0/Download');
        } else if (Platform.isIOS) {
          appDirectory = await getApplicationDocumentsDirectory();
        }

        if (appDirectory == null || !await appDirectory.exists()) {
          EasyLoading.showError('Could not get storage directory.');
          debugPrint('❌ Export Excel failed: Could not get storage directory');
          return;
        }

        // Save Excel file directly in Downloads folder
        final String fileName =
            'invoice_${invoiceIdValue}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
        final String filePath = '${appDirectory.path}/$fileName';
        final File excelFile = File(filePath);
        await excelFile.writeAsBytes(excelBytes);

        debugPrint('✅ Excel saved to: $filePath');

        // Show success message and open Excel
        EasyLoading.showSuccess('Excel exported successfully');

        // Open the Excel file
        await OpenFilex.open(filePath);
      } else {
        debugPrint('❌ Export Excel failed: ${response.statusCode}');
        debugPrint('❌ Response body: ${response.body}');
        EasyLoading.showError('Failed to export Excel: ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('❌ Exception in exportInvoiceAsExcel: $e');
      EasyLoading.showError('Failed to export Excel: $e');
    }
  }

  Future<void> sendInvoiceEmail() async {
    try {
      // Get invoice_id
      int? invoiceIdValue = invoiceId.value;

      // If invoiceId is still null, try to get it from invoiceData
      if (invoiceIdValue == null && invoiceData.isNotEmpty) {
        final dataInvoiceId = invoiceData['invoice_id'] ?? invoiceData['id'];
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

      // Try to get email from selectedClient
      clientEmail = selectedClient['email']?.toString().trim() ?? '';

      // If not found, try from invoiceData
      if (clientEmail.isEmpty && invoiceData.isNotEmpty) {
        clientEmail =
            invoiceData['toEmail']?.toString().trim() ??
            invoiceData['client_email']?.toString().trim() ??
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
      // Get invoice_id from controller
      final invoiceIdValue = invoiceId.value;

      if (invoiceIdValue == null) {
        EasyLoading.showError(
          'Invoice ID not found. Please create an invoice first.',
        );
        debugPrint('❌ Send WhatsApp failed: Invoice ID is null');
        return;
      }

      // Check if client has phone number
      String clientPhone = '';

      // Try to get phone from selectedClient
      clientPhone = selectedClient['phone_number']?.toString().trim() ?? '';

      // If not found, try from invoiceData
      if (clientPhone.isEmpty && invoiceData.isNotEmpty) {
        clientPhone =
            invoiceData['phone_number']?.toString().trim() ??
            invoiceData['client_phone']?.toString().trim() ??
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
        final result = await Share.shareXFiles(
          [xFile],
          text: message,
        );

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
    descriptionController.dispose();
    estimatedCostController.dispose();
    quantityController.dispose();
    bankNameController.dispose();
    accountNameController.dispose();
    sortCodeController.dispose();
    accountNoController.dispose();
    super.onClose();
  }
}
