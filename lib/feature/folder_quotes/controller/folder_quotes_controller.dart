import 'dart:convert';
import 'dart:io';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class FolderQuotesController extends GetxController {
  RxList<dynamic> quotes = <dynamic>[].obs;
  RxBool isLoading = false.obs;

  // Fetch quotes for a specific folder
  Future<void> getQuotesForFolder(int folderId) async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Loading quotes...');

      debugPrint('🔄 Fetching quotes for folder ID: $folderId');
      final url = Urls.allQuotesOfSpecificFolder(folderId);
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
        debugPrint('✅ Quotes fetched successfully!');
        debugPrint('📊 Success: ${responseData['success']}');
        debugPrint('📊 Message: ${responseData['message']}');

        // Get data array
        final List<dynamic> quotesArray = responseData['data'] ?? [];
        debugPrint('📋 Number of quotes: ${quotesArray.length}');

        quotes.value = quotesArray;
        EasyLoading.showSuccess('${quotesArray.length} quotes loaded');
      } else {
        debugPrint('❌ Failed to fetch quotes. Status: ${response.statusCode}');
        debugPrint('❌ Response: ${response.body}');
        
        // Try to parse error message from backend
        try {
          final errorData = jsonDecode(response.body);
          final errorMessage = errorData['message'] ?? 'Failed to load quotes';
          EasyLoading.showError(errorMessage);
        } catch (e) {
          EasyLoading.showError('Failed to load quotes (${response.statusCode})');
        }
      }
    } catch (e) {
      isLoading.value = false;
      EasyLoading.dismiss();
      debugPrint('❌ Error fetching quotes: $e');
      EasyLoading.showError('Error: $e');
    }
  }

  // Open PDF from URL
  Future<void> openPdf(String pdfUrl, String quoteName) async {
    try {
      EasyLoading.show(status: 'Opening PDF...');
      debugPrint('📄 Opening PDF from: $pdfUrl');

      // Get access token for authenticated requests
      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        debugPrint('❌ Access token is null or empty');
        return;
      }

      // Download PDF with authentication
      final response = await http.get(
        Uri.parse(pdfUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // Get PDF bytes
        final pdfBytes = response.bodyBytes;
        debugPrint('✅ PDF downloaded, size: ${pdfBytes.length} bytes');

        // Save to temporary directory
        final Directory tempDir = await getTemporaryDirectory();
        final String fileName = '${quoteName.replaceAll('/', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final String filePath = '${tempDir.path}/$fileName';
        final File pdfFile = File(filePath);
        await pdfFile.writeAsBytes(pdfBytes);

        debugPrint('✅ PDF saved to: $filePath');
        EasyLoading.dismiss();

        // Open the PDF
        final result = await OpenFilex.open(filePath);
        debugPrint('📄 Open PDF result: ${result.message}');

        if (result.type != ResultType.done) {
          EasyLoading.showError('Could not open PDF: ${result.message}');
        }
      } else {
        EasyLoading.dismiss();
        debugPrint('❌ Download PDF failed: ${response.statusCode}');
        debugPrint('❌ Response: ${response.body}');
        EasyLoading.showError('Failed to download PDF (${response.statusCode})');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('❌ Error opening PDF: $e');
      EasyLoading.showError('Error opening PDF: $e');
    }
  }
}
