import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixxa_app/feature/home_default_clients/controller/home_default_controller.dart';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';

class EditDetailsController extends GetxController {
  late final int clientIndex;
  EditDetailsController(this.clientIndex);

  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final isNameFocused = false.obs;
  final isNamehasText = false.obs;
  final isPhoneFocused = false.obs;
  final isPhonehasText = false.obs;
  String _initialName = '';
  String _initialPhone = '';

  // Enable Save when any field value differs from its initial value.
  bool get isFormValid =>
      nameController.text.trim() != _initialName.trim() ||
      phoneNumberController.text.trim() != _initialPhone.trim();
  final RxBool isLoadingSummary = false.obs;
  final Rx<Map<String, dynamic>> clientSummary = Rx<Map<String, dynamic>>({});
  final RxList<Map<String, dynamic>> summaryQuotes =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> summaryInvoices =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    final homeController = Get.find<HomeDefaultController>();
    final data = homeController.clientData[clientIndex];
    nameController.text = data['name'];
    phoneNumberController.text = data['phone'];
    // Save initial values so we can detect whether the user changed any field.
    _initialName = data['name'] ?? '';
    _initialPhone = data['phone'] ?? '';
    nameController.addListener(() {
      isNamehasText.value = nameController.text.isNotEmpty;
    });
    phoneNumberController.addListener(() {
      isPhonehasText.value = phoneNumberController.text.isNotEmpty;
    });
    fetchClientSummary();

    super.onInit();
  }

  void clearName() {
    nameController.clear();
    isNamehasText.value = false;
  }

  void clearPhone() {
    phoneNumberController.clear();
    isPhonehasText.value = false;
  }

  // Update client via PATCH API
  Future<void> updateClient() async {
    try {
      // Show loading
      EasyLoading.show(status: 'Saving changes...');

      final homeController = Get.find<HomeDefaultController>();
      final clientId = homeController.clientData[clientIndex]['id'];

      debugPrint('🔄 Updating client with ID: $clientId');

      // Get access token
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        debugPrint('❌ No access token found');
        return;
      }

      // Prepare request body
      final requestBody = {
        'name': nameController.text,
        'phone_number': phoneNumberController.text,
      };

      debugPrint('📤 Request Body: $requestBody');

      // Make PATCH request
      final response = await http.patch(
        Uri.parse(Urls.updateClient(clientId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint('📥 Response Status Code: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      // Hide loading
      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        // Parse response
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Client updated successfully!');

        // Update local data with response from server
        final updatedClient = responseData['data'];
        homeController.clientData[clientIndex]['name'] = updatedClient['name'];
        homeController.clientData[clientIndex]['email'] =
            updatedClient['email'];
        homeController.clientData[clientIndex]['phone'] =
            updatedClient['phone_number'];
        homeController.clientData.refresh();

        EasyLoading.showSuccess('Client updated successfully');

        // Show success dialog
        Get.dialog(
          SizedBox(
            width: Get.width,
            height: Get.height,
            child: Stack(
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(color: Colors.black.withValues(alpha: .2)),
                  ),
                ),
                Center(
                  child: Container(
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.close, size: 20),
                            onPressed: () {
                              Get.close(2);
                            },
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xffE8F5E9),
                          child: Icon(
                            Icons.check,
                            color: Color(0xff4CAF50),
                            size: 40,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "You're done!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1C1C1C),
                          ),
                        ),
                        SizedBox(height: 24),
                        TextButton(
                          onPressed: () {
                            Get.close(2);
                          },
                          child: Text(
                            "Go back",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff3A8DFF),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          barrierColor: Colors.transparent,
          barrierDismissible: false,
        );
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint('❌ Error: $errorData');
        EasyLoading.showError(
          errorData['message'] ?? 'Failed to update client. Please try again.',
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('❌ Exception updating client: $e');
      EasyLoading.showError('An error occurred: $e');
    }
  }

  // Delete client via DELETE API
  Future<void> deleteClient() async {
    try {
      // Show loading
      EasyLoading.show(status: 'Deleting client...');

      // Get client ID
      final homeController = Get.find<HomeDefaultController>();
      final clientId = homeController.clientData[clientIndex]['id'];

      debugPrint('🗑️ Deleting client with ID: $clientId');

      // Get access token
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        debugPrint('❌ No access token found');
        return;
      }

      // Make DELETE request
      final response = await http.delete(
        Uri.parse(Urls.deleteClient(clientId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      debugPrint('📥 Response Status Code: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      // Hide loading
      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Parse response
        debugPrint('✅ Client deleted successfully!');

        // Remove from local data
        homeController.clientData.removeAt(clientIndex);

        EasyLoading.showSuccess('Client removed successfully');

        // Close dialogs and go back
        Get.close(2);
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint('❌ Error: $errorData');
        EasyLoading.showError(
          errorData['message'] ?? 'Failed to delete client. Please try again.',
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('❌ Exception deleting client: $e');
      EasyLoading.showError('An error occurred: $e');
    }
  }

  Future<void> fetchClientSummary() async {
    try {
      isLoadingSummary.value = true;
      EasyLoading.show(status: 'Loading summary...');

      final homeController = Get.find<HomeDefaultController>();
      final clientId = homeController.clientData[clientIndex]['id'] as int;

      debugPrint('🔄 Fetching summary for client ID: $clientId');

      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        debugPrint('❌ No access token found');
        isLoadingSummary.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse(Urls.getSpecificClientSummary(clientId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      debugPrint('📥 Summary Response Status: ${response.statusCode}');
      debugPrint('📥 Summary Response Body: ${response.body}');

      EasyLoading.dismiss();
      isLoadingSummary.value = false;

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];

        clientSummary.value = Map<String, dynamic>.from(data['client']);

        summaryQuotes.value = (data['quotes'] as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

        summaryInvoices.value = (data['invoices'] as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

        debugPrint(
          ' Summary fetched! Quotes: ${summaryQuotes.length}, Invoices: ${summaryInvoices.length}',
        );
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint('❌ Error: $errorData');
        EasyLoading.showError(
          errorData['message'] ?? 'Failed to fetch summary',
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      isLoadingSummary.value = false;
      debugPrint('❌ Exception fetching summary: $e');
    }
  }
}
