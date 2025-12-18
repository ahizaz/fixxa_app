import 'dart:convert';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FolderInvoicesController extends GetxController {
  RxList<dynamic> invoices = <dynamic>[].obs;
  RxBool isLoading = false.obs;

  // Fetch invoices for a specific folder
  Future<void> getInvoicesForFolder(int folderId) async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Loading invoices...');

      debugPrint('🔄 Fetching invoices for folder ID: $folderId');
      final url = Urls.allInvoicesOfSpecificFolder(folderId);
      debugPrint('🔗 API URL: $url');

      // Get access token
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        debugPrint('❌ Access token is null or empty');
        isLoading.value = false;
        return;
      }

      debugPrint('🔑 Using bearer token: Bearer ${accessToken.substring(0, 10)}...');

      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      debugPrint('📥 Response Status Code: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      EasyLoading.dismiss();
      isLoading.value = false;

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Invoices fetched successfully!');
        debugPrint('📊 Success: ${responseData['success']}');
        debugPrint('📊 Message: ${responseData['message']}');

        // Get data array
        final List<dynamic> invoicesArray = responseData['data'] ?? [];
        debugPrint('📋 Number of invoices: ${invoicesArray.length}');

        invoices.value = invoicesArray;
        EasyLoading.showSuccess('${invoicesArray.length} invoices loaded');
      } else {
        debugPrint('❌ Failed to fetch invoices. Status: ${response.statusCode}');
        debugPrint('❌ Response: ${response.body}');
        EasyLoading.showError('Failed to load invoices');
      }
    } catch (e) {
      isLoading.value = false;
      EasyLoading.dismiss();
      debugPrint('❌ Error fetching invoices: $e');
      EasyLoading.showError('Error: $e');
    }
  }
}
