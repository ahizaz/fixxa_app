import 'dart:convert';
import 'package:fixxa_app/core/services/spotlight_service.dart';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/client_details/controller/client_details_controller.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

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

  // Add a new service item (for the Service Table only)
  void addService({
    required String description,
    required String service,
    required double rate,
    required int duration,
  }) {
    // Add to items list instead of services list
    addItem(
      description: description,
      service: service,
      rate: rate,
      duration: duration,
    );
  }

  // Controllers for add dialogs to keep UI stateless
  final serviceDescriptionController = TextEditingController();
  final serviceNameController = TextEditingController();
  final serviceRateController = TextEditingController();
  final serviceDurationController = TextEditingController();

  final materialNameController = TextEditingController();
  final materialQtyController = TextEditingController();
  final materialUnitPriceController = TextEditingController();

  /// Shows combined dialog to add both service and material data together
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

              // Only keep Quantity and Unit Price fields (these map to backend)
              // Other service fields are kept commented for future use.
              /*
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
              */

              const SizedBox(height: 8),
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

              // Material details removed from UI but kept commented for future use.
              /*
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
              */
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
              // final service = serviceNameController.text.trim();
              // final rate = double.tryParse(serviceRateController.text) ?? 0.0;
              // final duration = int.tryParse(serviceDurationController.text) ?? 0;
              // final material = materialNameController.text.trim();
              final qty = int.tryParse(materialQtyController.text) ?? 0;
              final unitPrice = double.tryParse(materialUnitPriceController.text) ?? 0.0;

              // Add item with only required backend fields; keep others commented for future
              addItem(
                description: desc,
                // service: service,
                // rate: rate,
                // duration: duration,
                // material: material,
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
    final price = double.tryParse(unitPrice) ?? 0.0;
    // Add to items list instead of materials list
    addItem(material: material, quantity: quantity, unitPrice: price);
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
    // Don't calculate total locally - backend will provide it
    // total.value will be set when we receive the response from backend
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
        debugPrint('🔍 responseData type: ${responseData.runtimeType}');
        debugPrint(
          '🔍 responseData keys: ${responseData is Map ? responseData.keys : 'not a map'}',
        );
        final data = (responseData is Map && responseData['data'] != null)
            ? responseData['data']
            : responseData;
        debugPrint('🔍 data after extraction: $data');

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

        // Try to get vat_amount first, if not available calculate from vat_rate
        double? tx = parseNum(
          data['vat_amount'] ?? data['tax'] ?? data['tax_amount'],
        );

        // If vat_amount not in response, calculate it from vat_rate and subtotal
        if (tx == null || tx == 0.0) {
          final vatRate = parseNum(data['vat_rate'] ?? data['vat']) ?? 0.0;
          final discountType = data['discount_type'] ?? 'percentage';

          if (sub != null && vatRate > 0) {
            // Calculate discount value
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
            tx = subtotalAfterDiscount * (vatRate / 100.0);
          }
        }

        final tot = parseNum(
          data['total'] ??
              data['grand_total'] ??
              data['grandTotal'] ??
              data['total_amount'],
        );

        debugPrint('═══════════════════════════════════════════════════════');
        debugPrint('📊 FINANCIAL DETAILS FROM API (Backend Calculated):');
        debugPrint('   Quote ID: $qid');
        debugPrint('   Subtotal: £${sub?.toStringAsFixed(2) ?? '0.00'}');
        debugPrint('   Discount: £${disc?.toStringAsFixed(2) ?? '0.00'}');
        debugPrint('   VAT: £${tx?.toStringAsFixed(2) ?? '0.00'}');
        debugPrint('   Total: £${tot?.toStringAsFixed(2) ?? '0.00'}');
        debugPrint('═══════════════════════════════════════════════════════');

        // Just set whatever backend sends - no calculation, no validation
        subtotal.value = sub ?? 0.0;
        discount.value = disc ?? 0.0;
        tax.value = tx ?? 0.0;
        total.value = tot ?? 0.0;

        if (showLoading) {
          EasyLoading.showSuccess('Financial details loaded successfully!');
        }
        return true;
      } else {
        try {
          final err = jsonDecode(response.body);
          if (showLoading) {
            EasyLoading.showError(
              err['message'] ?? 'Failed to load financials',
            );
          }
        } catch (e) {
          if (showLoading) {
            EasyLoading.showError(
              'Failed to load financials (status ${response.statusCode})',
            );
          }
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
                'image': match['image'] ?? match['avatar'],
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

  /// Reset all quote data when dialog is closed
  void resetQuoteData() {
    // Clear client data
    selectedClient.value = {};
    recentlyAddedClient.value = null;

    // Clear items
    items.clear();
    services.clear();
    materials.clear();

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

    // Reset values
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
    clearSignature();

    // Reset dropdown values
    discountType.value = "None";
    dayhour.value = "Days";
    payment.value = "Standard Payment";
    discountTypeField.value = "percentage";

    // Reset edit index
    editItemIndex = null;

    // Reset quote ID
    quoteId.value = null;

    debugPrint('✅ Quote data reset successfully');
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
      //'description': description,
      'quote_description': description, // Backend expects this field
      'service_rate': rate, // Use service_rate instead of rate
      'unit_price': rate, // Also store as unit_price for materials
      'quantity': quantity,
      'service_duration': quantity.toDouble(), // Store duration
      'duration_unit': dayhourVal.toLowerCase(), // Store duration unit
      'discountType': discountTypeVal,
      'isTaxable': taxable,
      'dayhour': dayhourVal,
      // Don't calculate price locally - backend will calculate
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

    // No need to calculate totals - backend will do this
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
    // Sync discount_type from UI dropdown to backend field
    if (discountType.value == "Percentage (%)") {
      discountTypeField.value = "percentage";
    } else if (discountType.value == "Fixed") {
      discountTypeField.value = "fixed";
    } else {
      // If "None", default to percentage with 0 amount
      discountTypeField.value = "percentage";
    }

    // Basic validation
    final missing = <String>[];
    if (selectedClient.isEmpty) missing.add('client');
    // Check if ANY of the three lists has items
    if (items.isEmpty && services.isEmpty && materials.isEmpty) {
      missing.add('items (add service or material)');
    }
    // Remove discount_amount validation as it can be 0
    // if (discountAmount.value == 0.0) missing.add('discount_amount');
    if (discountTypeField.value.isEmpty) missing.add('discount_type');
    // Remove vat_rate validation as it can be 0
    // if (vatRate.value == 0.0) missing.add('vat_rate');
    if (issueDate.value == null || issueDate.value!.isEmpty) {
      missing.add('issue_date');
    }
    if (dueDate.value == null || dueDate.value!.isEmpty) {
      missing.add('due_date');
    }
    // Signature is optional now; do not require it for creating quotes.

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
      debugPrint(
        '🔴 ITEMS CONTENT: ${items.toString()}',
      ); // See what's in items
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

      // Build valid items list (filtered and normalised)
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

      debugPrint(
        '🟢 Valid items count: ${validItems.length} (filtered from ${items.length})',
      );

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
        final durationUnit = (it['duration_unit'] ?? it['dayhour'] ?? 'hours')
            .toString()
            .toLowerCase();
        final serviceType =
            (it['service_type'] ?? it['service'] ?? it['dayhour'] ?? '')
                .toString();
        final materialName = (it['material_name'] ?? it['material'] ?? '')
            .toString();

        return {
          'quote_description':
              (it['quote_description'] ?? it['description'] ?? '').toString(),
          'service_type': serviceType,
          'material_name': materialName,
          'quantity': qty,
          'unit_price': unitPrice,
          'service_duration': serviceDuration,
          'duration_unit': durationUnit,
          'service_rate': serviceRate,
        };
      }).toList();

      debugPrint('🔵 itemsList count: ${itemsList.length}');
      debugPrint('🔵 itemsList data: $itemsList');

      // Build JSON payload for non-file requests
      final payload = {
        'client': int.tryParse(clientField.toString()) ?? clientField,
        'discount_amount': discountAmount.value,
        'discount_type': discountTypeField.value,
        'vat_rate': vatRate.value,
        'issue_date': issueDate.value!,
        'due_date': dueDate.value!,
        'items': itemsList,
      };

      // Send request with retry for duplicate-quote-number server error
      const int maxRetries = 3;
      int attempt = 0;
      while (true) {
        attempt++;
        debugPrint('   Sending request attempt #$attempt to: ${Urls.createquote}');

        http.Response response;

        if (signatureBytes == null) {
          // No signature file — send JSON body (server expects items array)
          debugPrint('   Sending JSON payload (no signature)');
          response = await http.post(
            Uri.parse(Urls.createquote),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(payload),
          );
        } else {
          // Signature present — use multipart/form-data
          var req = http.MultipartRequest('POST', Uri.parse(Urls.createquote));
          req.headers['Authorization'] = 'Bearer $accessToken';
          req.fields['client'] = payload['client'].toString();
          req.fields['discount_amount'] = payload['discount_amount'].toString();
          req.fields['discount_type'] = payload['discount_type'].toString();
          req.fields['vat_rate'] = payload['vat_rate'].toString();
          req.fields['issue_date'] = payload['issue_date'].toString();
          req.fields['due_date'] = payload['due_date'].toString();
          req.fields['items'] = jsonEncode(itemsList);
          req.files.add(
            http.MultipartFile.fromBytes(
              'signature',
              signatureBytes!,
              filename: 'signature.png',
              contentType: MediaType('image', 'png'),
            ),
          );

          debugPrint('   Request fields: ${req.fields}');
          final streamedResponse = await req.send();
          response = await http.Response.fromStream(streamedResponse);
        }

        debugPrint('   Response status: ${response.statusCode}');
        debugPrint('   Response body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          EasyLoading.dismiss();
          isSubmitting.value = false;

          // Try to parse totals from server response and update UI values
          try {
            final responseData = jsonDecode(response.body);
            debugPrint(
              '🔍 createQuote responseData type: ${responseData.runtimeType}',
            );
            debugPrint(
              '🔍 createQuote responseData keys: ${responseData is Map ? responseData.keys : 'not a map'}',
            );
            final data = (responseData is Map && responseData['data'] != null)
                ? responseData['data']
                : responseData;
            debugPrint('🔍 createQuote data after extraction: $data');

            // If server returned a quote id, store it for later requests
            try {
              if (data != null &&
                  (data['id'] != null || data['quote_id'] != null)) {
                final dynamic idVal = data['id'] ?? data['quote_id'];
                if (idVal != null) {
                  final parsed = int.tryParse(idVal.toString());
                  if (parsed != null) {
                    quoteId.value = parsed;
                    debugPrint('✅ Quote ID set to: ${quoteId.value}');
                  }
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

            debugPrint(
              '═══════════════════════════════════════════════════════',
            );
            debugPrint('📊 FINANCIAL DETAILS FROM createQuote RESPONSE:');
            debugPrint('   Quote ID: ${quoteId.value}');
            debugPrint('   Subtotal: £${sub?.toStringAsFixed(2) ?? '0.00'}');
            debugPrint('   Discount: £${disc?.toStringAsFixed(2) ?? '0.00'}');
            debugPrint('   VAT: £${tx?.toStringAsFixed(2) ?? '0.00'}');
            debugPrint('   Total: £${tot?.toStringAsFixed(2) ?? '0.00'}');
            debugPrint(
              '═══════════════════════════════════════════════════════',
            );

            // Just set whatever backend sends - no calculation
            subtotal.value = sub ?? 0.0;
            discount.value = disc ?? 0.0;
            tax.value = tx ?? 0.0;
            total.value = tot ?? 0.0;
          } catch (e) {
            debugPrint(
              ' Could not parse totals from createQuote response: $e',
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
              ' createQuote: fetching financials for quote ${quoteId.value}',
            );
            if (quoteId.value != null) {
              // Add a small delay to allow server to calculate financials
              await Future.delayed(const Duration(milliseconds: 800));
              // Reuse the same access token and show loading to user
              EasyLoading.show(status: 'Fetching financial details...');
              final financialsFetched = await fetchFinancials(
                id: quoteId.value,
                accessToken: accessToken,
                showLoading: true,
              );

              if (financialsFetched) {
                debugPrint(
                  ' Financial details loaded and displayed successfully',
                );
                debugPrint('   Final UI values:');
                debugPrint(
                  '   - Subtotal: £${subtotal.value.toStringAsFixed(2)}',
                );
                debugPrint(
                  '   - Discount: £${discount.value.toStringAsFixed(2)}',
                );
                debugPrint('   - VAT: £${tax.value.toStringAsFixed(2)}');
                debugPrint('   - Total: £${total.value.toStringAsFixed(2)}');
              }
            }
          } catch (e) {
            debugPrint('fetchFinancials after createQuote failed: $e');
            EasyLoading.dismiss();
          }


          EasyLoading.showSuccess('Quote sent successfully');
          return true;
        }

     
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
      debugPrint(' Exception in createQuote: $e');
      debugPrint(st.toString());
      EasyLoading.showError('An error occurred: $e');
      return false;
    }
  }

  void addServiceItem(String serviceName, double rate) {
    items.add({
      'quote_description': serviceName,
      'service_rate': rate,
      'unit_price': 0.0,
      'quantity': 1,
      'service_duration': 1.0,
      'duration_unit': 'days',
      'discountType': 'None',
      'isTaxable': false,
      'dayhour': 'Days',
      // Don't calculate price locally - backend will calculate
    });
    // No need to calculate totals - backend will do this
  }

  /// Send exactly the provided `payload` as JSON to the create-quote endpoint.
  /// This method will NOT add any extra fields to the payload; it sends
  /// exactly what the caller provides (JSON-encoded).
  Future<bool> createQuoteExact(Map<String, dynamic> payload) async {
    try {
      isSubmitting.value = true;
      EasyLoading.show(status: 'Sending quote...');

      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        isSubmitting.value = false;
        EasyLoading.showError('Please login first');
        return false;
      }

      final uri = Uri.parse(Urls.createquote);
      debugPrint('➡️ createQuoteExact posting to: $uri');
      debugPrint('➡️ createQuoteExact payload: $payload');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(payload),
      );

      debugPrint('   Response status: ${response.statusCode}');
      debugPrint('   Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.dismiss();
        isSubmitting.value = false;

        try {
          final responseData = jsonDecode(response.body);
          final data = (responseData is Map && responseData['data'] != null)
              ? responseData['data']
              : responseData;
          if (data != null && (data['id'] != null || data['quote_id'] != null)) {
            final dynamic idVal = data['id'] ?? data['quote_id'];
            final parsed = int.tryParse(idVal.toString());
            if (parsed != null) quoteId.value = parsed;
          }
        } catch (e) {
          debugPrint('⚠️ createQuoteExact: could not parse response json: $e');
        }

        EasyLoading.showSuccess('Quote sent successfully');
        return true;
      }

      EasyLoading.dismiss();
      isSubmitting.value = false;
      try {
        final errorData = jsonDecode(response.body);
        final msg = errorData['message'] ?? 'Failed to send quote';
        EasyLoading.showError(msg);
      } catch (e) {
        EasyLoading.showError('Failed to send quote (status ${response.statusCode})');
      }
      return false;
    } catch (e, st) {
      EasyLoading.dismiss();
      isSubmitting.value = false;
      debugPrint(' Exception in createQuoteExact: $e');
      debugPrint(st.toString());
      EasyLoading.showError('An error occurred: $e');
      return false;
    }
  }

  void calculateTotals() {
 
  }

  void clearManualClientForm() {
    manualClientNameController.clear();
    manualClientBusinessNameController.clear();
    manualClientPhoneController.clear();
    manualClientEmailController.clear();
    manualClientAddressController.clear();
    manualClientImage.value = null;
  }

  /// Reset all form data after successful quote creation
  void resetFormData() {
    debugPrint('🔄 Resetting form data for new quote...');

    // Clear financial values
    subtotal.value = 0.0;
    discount.value = 0.0;
    tax.value = 0.0;
    total.value = 0.0;
    quoteId.value = null;

    // Clear items and services
    items.clear();
    services.clear();
    materials.clear();

    // Clear client data
    selectedClient.clear();
    selectedContacts.clear();
    recentlyAddedClient.value = null;
    clearManualClientForm();

    // Reset form fields
    discountAmount.value = 0.0;
    discountTypeField.value = "percentage";
    vatRate.value = 0.0;
    issueDate.value = null;
    dueDate.value = null;

    // Clear controllers
    descriptionController.clear();
    estimatedCostController.clear();
    quantityController.clear();

    // Clear service controllers
    serviceDescriptionController.clear();
    serviceNameController.clear();
    serviceRateController.clear();
    serviceDurationController.clear();

    // Clear material controllers
    materialNameController.clear();
    materialQtyController.clear();
    materialUnitPriceController.clear();

    // Reset dropdown values
    discountType.value = "None";
    dayhour.value = "Days";
    payment.value = "Standard Payment";
    isTaxable.value = true;

    // Clear signature
    clearSignature();

    // Reset submission state
    isSubmitting.value = false;
    editItemIndex = null;

    debugPrint('✅ Form data reset complete');
  }

  // Export quote as CSV
  Future<void> exportQuoteAsCsv() async {
    try {
      // Get quote_id from controller
      final quoteIdValue = quoteId.value;

      if (quoteIdValue == null) {
        EasyLoading.showError(
          'Quote ID not found. Please create a quote first.',
        );
        debugPrint('❌ Export CSV failed: Quote ID is null');
        return;
      }

      // Show loading
      EasyLoading.show(status: 'Exporting CSV...');
      debugPrint('📤 Starting CSV export for quote ID: $quoteIdValue');

      // Get access token
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        debugPrint('❌ Export CSV failed: Access token is null or empty');
        return;
      }

      // Make GET request to export CSV endpoint
      final url = Urls.exportQuoteCsv(quoteIdValue);
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

        // Save CSV to device Downloads folder
        Directory? appDirectory;
        if (Platform.isAndroid) {
          // Use Downloads directory for easier access
          appDirectory = Directory('/storage/emulated/0/Download');
        } else if (Platform.isIOS) {
          appDirectory = await getApplicationDocumentsDirectory();
        }

        if (appDirectory == null || !await appDirectory.exists()) {
          EasyLoading.showError('Could not get storage directory.');
          debugPrint('❌ Export CSV failed: Could not get storage directory');
          return;
        }

        // Save CSV file directly in Downloads folder
        final String fileName =
            'quote_${quoteIdValue}_${DateTime.now().millisecondsSinceEpoch}.csv';
        final String filePath = '${appDirectory.path}/$fileName';
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
      debugPrint('❌ Exception in exportQuoteAsCsv: $e');
      EasyLoading.showError('Failed to export CSV: $e');
    }
  }

  // Export quote as Excel
  Future<void> exportQuoteAsExcel() async {
    try {
      // Get quote_id from controller
      final quoteIdValue = quoteId.value;

      if (quoteIdValue == null) {
        EasyLoading.showError(
          'Quote ID not found. Please create a quote first.',
        );
        debugPrint('❌ Export Excel failed: Quote ID is null');
        return;
      }

      // Show loading
      EasyLoading.show(status: 'Exporting Excel...');
      debugPrint('📤 Starting Excel export for quote ID: $quoteIdValue');

      // Get access token
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        debugPrint('❌ Export Excel failed: Access token is null or empty');
        return;
      }

      // Make GET request to export Excel endpoint
      final url = Urls.exportQuoteExcell(quoteIdValue);
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
            'quote_${quoteIdValue}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
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
      debugPrint('❌ Exception in exportQuoteAsExcel: $e');
      EasyLoading.showError('Failed to export Excel: $e');
    }
  }

  // Connect with Stripe API call
  Future<void> connectWithStripe() async {
    try {
      // Show country selection dialog first
      final selectedCountry = await Get.dialog<Country>(
        _CountrySelectionDialog(),
        barrierDismissible: true,
      );

      // If user cancelled the dialog, return
      if (selectedCountry == null) {
        debugPrint('❌ Country selection cancelled');
        return;
      }

      debugPrint(
        '✅ Selected country: ${selectedCountry.name} (${selectedCountry.code})',
      );

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

      // Make POST request with Bearer token and country code in body
      final response = await http.post(
        Uri.parse(Urls.paymentStripe),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'country': selectedCountry.code}),
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

  // Send quote via email
  Future<void> sendQuoteEmail() async {
    try {
      // Get quote_id from controller
      final quoteIdValue = quoteId.value;

      if (quoteIdValue == null) {
        EasyLoading.showError(
          'Quote ID not found. Please create a quote first.',
        );
        debugPrint('❌ Send email failed: Quote ID is null');
        return;
      }

      // Check if client has email
      final clientEmail = selectedClient['email']?.toString().trim() ?? '';

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
          final errorData = jsonDecode(response.body);
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
  Future<void> sendQuoteWhatsApp() async {
    try {
      // Get quote_id from controller
      final quoteIdValue = quoteId.value;

      if (quoteIdValue == null) {
        EasyLoading.showError(
          'Quote ID not found. Please create a quote first.',
        );
        debugPrint('❌ Send WhatsApp failed: Quote ID is null');
        return;
      }

      // Check if client has phone number
      String clientPhone = '';

      // Try to get phone from selectedClient
      clientPhone = selectedClient['phone_number']?.toString().trim() ?? '';

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
        final message = 'Here is your quote from Fixxa';
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

  // Export quote as PDF
  Future<void> exportQuoteAsPdf() async {
    try {
      // Get quote_id
      final quoteIdValue = quoteId.value;

      if (quoteIdValue == null) {
        EasyLoading.showError(
          'Quote ID not found. Please save the quote first.',
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
      final url = Urls.exportQuotePdf(quoteIdValue);
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
            'quote_${quoteIdValue}_${DateTime.now().millisecondsSinceEpoch}.pdf';
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
}

// Country model for Stripe
class Country {
  final String code;
  final String name;

  Country({required this.code, required this.name});
}

// Country selection dialog
class _CountrySelectionDialog extends StatefulWidget {
  @override
  _CountrySelectionDialogState createState() => _CountrySelectionDialogState();
}

class _CountrySelectionDialogState extends State<_CountrySelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Country> _filteredCountries = [];

  // Complete list of Stripe supported countries
  final List<Country> _allCountries = [
    Country(code: 'AU', name: 'Australia'),
    Country(code: 'AT', name: 'Austria'),
    Country(code: 'BE', name: 'Belgium'),
    Country(code: 'BR', name: 'Brazil'),
    Country(code: 'BG', name: 'Bulgaria'),
    Country(code: 'CA', name: 'Canada'),
    Country(code: 'CI', name: 'Côte d\'Ivoire (Ivory Coast)'),
    Country(code: 'HR', name: 'Croatia'),
    Country(code: 'CY', name: 'Cyprus'),
    Country(code: 'CZ', name: 'Czechia (Czech Republic)'),
    Country(code: 'DK', name: 'Denmark'),
    Country(code: 'EE', name: 'Estonia'),
    Country(code: 'FI', name: 'Finland'),
    Country(code: 'FR', name: 'France'),
    Country(code: 'DE', name: 'Germany'),
    Country(code: 'GH', name: 'Ghana'),
    Country(code: 'GI', name: 'Gibraltar (British Overseas Territory)'),
    Country(code: 'GR', name: 'Greece'),
    Country(
      code: 'HK',
      name: 'Hong Kong (Special Administrative Region of China)',
    ),
    Country(code: 'HU', name: 'Hungary'),
    Country(code: 'IN', name: 'India'),
    Country(code: 'ID', name: 'Indonesia'),
    Country(code: 'IE', name: 'Ireland'),
    Country(code: 'IT', name: 'Italy'),
    Country(code: 'JP', name: 'Japan'),
    Country(code: 'KE', name: 'Kenya'),
    Country(code: 'LV', name: 'Latvia'),
    Country(code: 'LI', name: 'Liechtenstein'),
    Country(code: 'LT', name: 'Lithuania'),
    Country(code: 'LU', name: 'Luxembourg'),
    Country(code: 'MY', name: 'Malaysia'),
    Country(code: 'MT', name: 'Malta'),
    Country(code: 'MX', name: 'Mexico'),
    Country(code: 'NL', name: 'Netherlands'),
    Country(code: 'NZ', name: 'New Zealand'),
    Country(code: 'NG', name: 'Nigeria'),
    Country(code: 'NO', name: 'Norway'),
    Country(code: 'PL', name: 'Poland'),
    Country(code: 'PT', name: 'Portugal'),
    Country(code: 'RO', name: 'Romania'),
    Country(code: 'SG', name: 'Singapore'),
    Country(code: 'SK', name: 'Slovakia'),
    Country(code: 'SI', name: 'Slovenia'),
    Country(code: 'ZA', name: 'South Africa'),
    Country(code: 'ES', name: 'Spain'),
    Country(code: 'SE', name: 'Sweden'),
    Country(code: 'CH', name: 'Switzerland'),
    Country(code: 'TH', name: 'Thailand'),
    Country(code: 'AE', name: 'United Arab Emirates'),
    Country(code: 'GB', name: 'United Kingdom'),
    Country(code: 'US', name: 'United States'),
  ];

  @override
  void initState() {
    super.initState();
    _filteredCountries = _allCountries;
    _searchController.addListener(_filterCountries);
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = _allCountries;
      } else {
        _filteredCountries = _allCountries.where((country) {
          return country.name.toLowerCase().contains(query) ||
              country.code.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Country',
                  style: GoogleFonts.urbanist(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Search field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search country...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Color(0xffE8E8E8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Color(0xffE8E8E8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Country list
            Expanded(
              child: _filteredCountries.isEmpty
                  ? Center(
                      child: Text(
                        'No countries found',
                        style: GoogleFonts.urbanist(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredCountries.length,
                      itemBuilder: (context, index) {
                        final country = _filteredCountries[index];
                        return InkWell(
                          onTap: () => Get.back(result: country),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xffE8E8E8),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                // Country code badge
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    country.code,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                // Country name
                                Expanded(
                                  child: Text(
                                    country.name,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
