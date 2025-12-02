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
  var quoteId = RxnInt();

  var selectedContacts = <Map<String, dynamic>>[].obs;
  var selectedClient = <String, dynamic>{}.obs;
  var recentlyAddedClient = Rx<Map<String, dynamic>?>(
    null,
  ); // Recently added client (manual or contact)

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
  final manualClientBusinessNameController = TextEditingController();
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
  var payment = "Standard Payment".obs;
  var items = <Map<String, dynamic>>[].obs;
  var services = <Map<String, dynamic>>[].obs;
  var materials = <Map<String, dynamic>>[].obs;

  // For editing existing items
  int? editItemIndex;

  var isTaxable = true.obs;

  // Add a new service item (for the Service Table only)
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

  // Controllers for add dialogs to keep UI stateless
  final serviceDescriptionController = TextEditingController();
  final serviceNameController = TextEditingController();
  final serviceRateController = TextEditingController();
  final serviceDurationController = TextEditingController();

  final materialNameController = TextEditingController();
  final materialQtyController = TextEditingController();
  final materialUnitPriceController = TextEditingController();

  /// Shows add service dialog and handles adding via controller methods
  void showAddServiceDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Add Service'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                  int.tryParse(serviceDurationController.text) ?? 1;
              if (desc.isNotEmpty || service.isNotEmpty) {
                addService(
                  description: desc,
                  service: service,
                  rate: rate,
                  duration: duration,
                );
              }
              // Clear after adding
              serviceDescriptionController.clear();
              serviceNameController.clear();
              serviceRateController.clear();
              serviceDurationController.clear();
              Get.back();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // Add a material row
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

  /// Shows add material dialog and handles adding via controller methods
  void showAddMaterialDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Add Material'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              decoration: const InputDecoration(labelText: 'Unit Price'),
            ),
          ],
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
              final mat = materialNameController.text.trim();
              final qty = int.tryParse(materialQtyController.text) ?? 1;
              final unit = materialUnitPriceController.text.trim();
              if (mat.isNotEmpty) {
                addMaterial(material: mat, quantity: qty, unitPrice: unit);
              }
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

  /// Fetch financials for a given quote id from server and update totals.
  /// If `id` is not provided, uses `quoteId` stored after creating a quote.
  Future<bool> fetchFinancials({
    int? id,
    String? accessToken,
    bool showLoading = true,
  }) async {
    final int? qid = id ?? quoteId.value;
    if (qid == null) {
      debugPrint('⚠️ fetchFinancials called without quote id');
      return false;
    }

    try {
      if (showLoading) EasyLoading.show(status: 'Loading quote financials...');
      final token = accessToken ?? await LoginController.getAccessToken();
      if (token == null || token.isEmpty) {
        if (showLoading) {
          EasyLoading.dismiss();
          EasyLoading.showError('Please login first');
        }
        return false;
      }

      final uri = Uri.parse(Urls.quoteFinancials(qid));
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (showLoading) EasyLoading.dismiss();

      if (response.statusCode == 200) {
        // Debug: show raw response so we can inspect server payload
        debugPrint('🔍 fetchFinancials response body: ${response.body}');
        final responseData = jsonDecode(response.body);
        final data = (responseData is Map && responseData['data'] != null)
            ? responseData['data']
            : responseData;

        // Tolerant number parser: accept numbers, numeric strings, and
        // formatted currency strings like "£1,234.56" or "(1,234.56)".
        double? parseNum(dynamic v) {
          if (v == null) return null;
          if (v is num) return v.toDouble();
          var s = v.toString().trim();
          // Replace parentheses used to indicate negative values: (1,234.56) -> -1,234.56
          if (s.startsWith('(') && s.endsWith(')')) {
            s = '-${s.substring(1, s.length - 1)}';
          }
          // Remove common currency symbols and thousands separators
          s = s.replaceAll(RegExp(r'[£$€, -\s]'), '');
          // Remove any characters that are not digits, dot or minus
          s = s.replaceAll(RegExp(r'[^0-9\.\-]'), '');
          return double.tryParse(s);
        }

        final sub = parseNum(
          data['subtotal'] ??
              data['sub_total'] ??
              data['subTotal'] ??
              data['subTotalAmount'] ??
              data['sub_total_amount'],
        );
        final disc = parseNum(
          data['discount_amount'] ??
              data['discount'] ??
              data['discountAmount'] ??
              data['discount_amount_value'],
        );
        final tx = parseNum(
          data['vat_amount'] ??
              data['tax'] ??
              data['tax_amount'] ??
              data['vat'] ??
              data['tax_amount_value'],
        );
        final tot = parseNum(
          data['total'] ??
              data['grand_total'] ??
              data['grandTotal'] ??
              data['total_amount'],
        );

        // If vat_amount is not provided but vat_rate is, calculate vat_amount
        double? calculatedTax = tx;
        if (calculatedTax == null && sub != null && disc != null) {
          final vatRate = parseNum(data['vat_rate']);
          if (vatRate != null) {
            calculatedTax = (sub - disc) * (vatRate / 100);
            debugPrint(
              '   calculated tax from vat_rate: $calculatedTax (rate: $vatRate%)',
            );
          }
        }

        debugPrint(
          '   parsed financials -> subtotal: $sub, discount: $disc, tax: $calculatedTax, total: $tot',
        );

        if (sub != null) subtotal.value = sub;
        if (disc != null) discount.value = disc;
        if (calculatedTax != null) tax.value = calculatedTax;

        // Always set a sensible total: prefer server-provided total, else compute
        if (tot != null) {
          total.value = tot;
        } else {
          total.value = subtotal.value - discount.value + tax.value;
        }

        if (showLoading) EasyLoading.showSuccess('Financials loaded');
        return true;
      } else {
        try {
          final err = jsonDecode(response.body);
          if (showLoading)
            EasyLoading.showError(
              err['message'] ?? 'Failed to load financials',
            );
        } catch (e) {
          if (showLoading)
            EasyLoading.showError(
              'Failed to load financials (status ${response.statusCode})',
            );
        }
        return false;
      }
    } catch (e) {
      if (showLoading) EasyLoading.dismiss();
      debugPrint('❌ fetchFinancials exception: $e');
      if (showLoading) EasyLoading.showError('An error occurred: $e');
      return false;
    }
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

        // Check if phone number exists
        if (phoneNumber == null || phoneNumber.isEmpty) {
          Get.snackbar(
            "No Phone Number",
            "This contact doesn't have a phone number",
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        // Call API to import client from contact immediately
        final success = await importClientFromContact(
          name: contactName,
          phoneNumber: phoneNumber,
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
      final requestBody = {'name': name, 'phone_number': phoneNumber};

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
        debugPrint('⚠️ Client import response: $errorData');

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
                'business_name': match['business_name'] ?? '',
                'email': match['email'] ?? '',
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

  /// Save or update an item using the controllers populated on Add Item screen.
  /// This centralizes the logic so UI file stays small.
  void saveOrUpdateItemFromAddScreen() {
    final description = descriptionController.text.trim();
    final rate = double.tryParse(estimatedCostController.text) ?? 0.0;
    final quantity = int.tryParse(quantityController.text) ?? 1;
    final discountTypeVal = discountType.value;
    final taxable = isTaxable.value;
    final dayhourVal = dayhour.value;

    final itemMap = {
      'description': description,
      'rate': rate,
      'quantity': quantity,
      'discountType': discountTypeVal,
      'isTaxable': taxable,
      'dayhour': dayhourVal,
      'price': rate * quantity,
    };

    if (editItemIndex != null &&
        editItemIndex! >= 0 &&
        editItemIndex! < items.length) {
      items[editItemIndex!] = itemMap;
      editItemIndex = null;
    } else {
      items.add(itemMap);
    }

    // Clear UI controllers for next input
    descriptionController.clear();
    estimatedCostController.clear();
    quantityController.clear();
    discountType.value = 'None';
    isTaxable.value = false;
    dayhour.value = 'Days';

    // Recalculate totals
    calculateTotals();
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

  // Build and submit quote
  Future<bool> createQuote() async {
    // Basic validation
    final missing = <String>[];
    if (selectedClient.isEmpty) missing.add('client');
    if (items.isEmpty) missing.add('items');
    if (discountAmount.value == 0.0) missing.add('discount_amount');
    if (discountTypeField.value.isEmpty) missing.add('discount_type');
    if (vatRate.value == 0.0) missing.add('vat_rate');
    if (issueDate.value == null || issueDate.value!.isEmpty)
      missing.add('issue_date');
    if (dueDate.value == null || dueDate.value!.isEmpty)
      missing.add('due_date');
    if (!hasSignature.value || signatureBytes == null) missing.add('signature');

    if (missing.isNotEmpty) {
      Get.snackbar(
        'Missing fields',
        'Please provide: ${missing.join(', ')}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint('⚠️ createQuote missing fields: ${missing.join(', ')}');
      return false;
    }

    try {
      isSubmitting.value = true;
      EasyLoading.show(status: 'Sending quote...');

      // Debug: print key values so we can trace failures
      debugPrint('➡️ createQuote starting');
      debugPrint('   selectedClient: ${selectedClient.toString()}');
      debugPrint('   items count: ${items.length}');
      debugPrint('   discountAmount: ${discountAmount.value}');
      debugPrint('   discountTypeField: ${discountTypeField.value}');
      debugPrint('   vatRate: ${vatRate.value}');
      debugPrint('   issueDate: ${issueDate.value}');
      debugPrint('   dueDate: ${dueDate.value}');
      debugPrint('   hasSignature: ${hasSignature.value}');

      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        isSubmitting.value = false;
        debugPrint('❌ createQuote: no access token');
        return false;
      }
      // Print token length but not full token
      debugPrint('   accessToken length: ${accessToken.length}');

      // Determine client field once and validate it before building request
      final clientField =
          selectedClient['id']?.toString() ??
          selectedClient['phone_number'] ??
          selectedClient['name'] ??
          '';
      debugPrint('   clientField resolved to: <$clientField>');

      // If clientField doesn't look like a server id (digits), warn and stop to avoid 404
      final isNumericId =
          RegExp(r'^\d+ ? ? ? ? ? ?$').hasMatch(clientField) ||
          int.tryParse(clientField ?? '') != null;
      if (!isNumericId) {
        // Allow if app legitimately expects phone or name, but most servers require id. Fail fast with helpful message.
        EasyLoading.dismiss();
        isSubmitting.value = false;
        debugPrint(
          '❌ createQuote: clientField is not numeric id: <$clientField>',
        );
        EasyLoading.showError(
          'Selected client is not linked to account (missing server id). Please choose an existing client or import/save the contact first.',
        );
        return false;
      }

      // Helper: build a fresh multipart request (must be new for each retry)
      http.MultipartRequest _buildRequest(String token) {
        var req = http.MultipartRequest('POST', Uri.parse(Urls.createquote));
        req.headers['Authorization'] = 'Bearer $token';

        // Attach fields
        req.fields['client'] = clientField;
        req.fields['source'] = source.value;
        req.fields['discount_amount'] = discountAmount.value.toString();
        req.fields['discount_type'] = discountTypeField.value;
        req.fields['vat_rate'] = vatRate.value.toString();
        req.fields['issue_date'] = issueDate.value!;
        req.fields['due_date'] = dueDate.value!;

        // Items as JSON: produce fields expected by server (see server error expecting no 'rate')
        final itemsList = items.map((it) {
          // Normalise numeric fields
          final qty = (it['quantity'] is int)
              ? it['quantity'] as int
              : int.tryParse((it['quantity'] ?? '').toString()) ?? 1;

          final unitPrice =
              double.tryParse(
                (it['unit_price'] ?? it['unit_price'] ?? it['rate'] ?? '0')
                    .toString(),
              ) ??
              double.tryParse((it['rate'] ?? '0').toString()) ??
              0.0;

          final serviceDuration =
              double.tryParse(
                (it['service_duration'] ??
                        it['duration'] ??
                        it['quantity'] ??
                        '0')
                    .toString(),
              ) ??
              0.0;
          final serviceRate =
              double.tryParse(
                (it['service_rate'] ?? it['rate'] ?? '0').toString(),
              ) ??
              0.0;
          final durationUnit = it['duration_unit'] ?? it['dayhour'] ?? 'hours';
          final serviceType = it['service'] ?? it['dayhour'] ?? '';
          final materialName = it['material'] ?? it['description'] ?? '';

          return {
            'quote_description': it['description'] ?? '',
            'service_type': serviceType,
            'material_name': materialName,
            'quantity': qty,
            'unit_price': unitPrice,
            'service_duration': serviceDuration,
            'duration_unit': durationUnit,
            'service_rate': serviceRate,
          };
        }).toList();
        req.fields['items'] = jsonEncode(itemsList);

        // Attach signature file
        if (signatureBytes != null) {
          req.files.add(
            http.MultipartFile.fromBytes(
              'signature',
              signatureBytes!,
              filename: 'signature.png',
              contentType: MediaType('image', 'png'),
            ),
          );
        }

        debugPrint('   Request fields: ${req.fields}');

        return req;
      }

      // Send request with retry for duplicate-quote-number server error
      const int maxRetries = 3;
      int attempt = 0;
      while (true) {
        attempt++;
        final req = _buildRequest(accessToken);
        debugPrint(
          '   Sending request attempt #$attempt to: ${Urls.createquote}',
        );
        final streamedResponse = await req.send();
        final response = await http.Response.fromStream(streamedResponse);
        debugPrint('   Response status: ${response.statusCode}');
        debugPrint('   Response body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          EasyLoading.dismiss();
          isSubmitting.value = false;

          // Try to parse totals from server response and update UI values
          try {
            final responseData = jsonDecode(response.body);
            final data = (responseData is Map && responseData['data'] != null)
                ? responseData['data']
                : responseData;

            // If server returned a quote id, store it for later requests
            try {
              if (data != null &&
                  (data['id'] != null || data['quote_id'] != null)) {
                final dynamic idVal = data['id'] ?? data['quote_id'];
                if (idVal != null) {
                  final parsed = int.tryParse(idVal.toString());
                  if (parsed != null) quoteId.value = parsed;
                }
              }
            } catch (e) {
              debugPrint('⚠️ Could not parse quote id from response: $e');
            }

            double? parseNum(dynamic v) {
              if (v == null) return null;
              if (v is num) return v.toDouble();
              return double.tryParse(v.toString());
            }

            final sub = parseNum(
              data['subtotal'] ?? data['sub_total'] ?? data['subTotal'],
            );
            final disc = parseNum(
              data['discount_amount'] ??
                  data['discount'] ??
                  data['discountAmount'],
            );
            final tx = parseNum(
              data['vat_amount'] ??
                  data['tax'] ??
                  data['tax_amount'] ??
                  data['vat'],
            );
            final tot = parseNum(data['total'] ?? data['grand_total']);

            // If vat_amount is not provided but vat_rate is, calculate vat_amount
            double? calculatedTax = tx;
            if (calculatedTax == null && sub != null && disc != null) {
              final vatRate = parseNum(data['vat_rate']);
              if (vatRate != null) {
                calculatedTax = (sub - disc) * (vatRate / 100);
                debugPrint(
                  '   calculated tax from vat_rate in createQuote: $calculatedTax (rate: $vatRate%)',
                );
              }
            }

            if (sub != null) subtotal.value = sub;
            if (disc != null) discount.value = disc;
            if (calculatedTax != null) tax.value = calculatedTax;
            if (tot != null) {
              total.value = tot;
            } else {
              total.value = subtotal.value - discount.value + tax.value;
            }
          } catch (e) {
            debugPrint(
              '⚠️ Could not parse totals from createQuote response: $e',
            );
            // keep existing calculated totals
            total.value = subtotal.value - discount.value + tax.value;
          }

          // After successfully creating the quote on the server, fetch
          // the financials for the created quote so UI reflects server
          // calculated totals. Log progress with debugPrint and handle
          // any errors gracefully.
          try {
            debugPrint(
              '➡️ createQuote: fetching financials for quote ${quoteId.value}',
            );
            if (quoteId.value != null) {
              // Add a small delay to allow server to calculate financials
              await Future.delayed(const Duration(milliseconds: 800));
              // Reuse the same access token and suppress the loading overlay
              await fetchFinancials(
                id: quoteId.value,
                accessToken: accessToken,
                showLoading: false,
              );
            }
          } catch (e) {
            debugPrint('⚠️ fetchFinancials after createQuote failed: $e');
          }

          EasyLoading.showSuccess('Quote sent successfully');
          return true;
        }

        // Non-success: try to detect duplicate key error and retry a few times
        String body = response.body.toLowerCase();
        final bool isDuplicateKey =
            body.contains('duplicate key') ||
            body.contains('quotes_quote_number_key') ||
            body.contains('quote_number');

        if (isDuplicateKey && attempt < maxRetries) {
          debugPrint(
            '   Detected duplicate quote_number error, will retry (attempt $attempt)',
          );
          // short backoff
          await Future.delayed(Duration(milliseconds: 500 * attempt));
          continue; // retry
        }

        // No retry or exhausted attempts: show error to user
        EasyLoading.dismiss();
        isSubmitting.value = false;
        try {
          final errorData = jsonDecode(response.body);
          final msg = errorData['message'] ?? 'Failed to send quote';
          // If duplicate key detected, give clearer instruction
          if (isDuplicateKey) {
            EasyLoading.showError(
              'Failed to create quote: duplicate quote number. Please try again.',
            );
          } else {
            EasyLoading.showError(msg);
          }
        } catch (e) {
          if (isDuplicateKey) {
            EasyLoading.showError(
              'Failed to create quote: duplicate quote number. Please try again.',
            );
          } else {
            EasyLoading.showError(
              'Failed to send quote (status ${response.statusCode})',
            );
          }
        }
        return false;
      }
    } catch (e, st) {
      EasyLoading.dismiss();
      isSubmitting.value = false;
      debugPrint('❌ Exception in createQuote: $e');
      debugPrint(st.toString());
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
    // Don't calculate locally - backend will handle all calculations
    // This method is kept for compatibility but does nothing
    // Financial values will be fetched from API after quote creation
  }

  void clearManualClientForm() {
    manualClientNameController.clear();
    manualClientBusinessNameController.clear();
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
    manualClientBusinessNameController.dispose();
    manualClientPhoneController.dispose();
    manualClientEmailController.dispose();
    manualClientAddressController.dispose();
    // Dispose dialog controllers
    serviceDescriptionController.dispose();
    serviceNameController.dispose();
    serviceRateController.dispose();
    serviceDurationController.dispose();

    materialNameController.dispose();
    materialQtyController.dispose();
    materialUnitPriceController.dispose();
    super.onClose();
  }
}
