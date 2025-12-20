import 'dart:convert';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FolderScannedController extends GetxController {
  RxList<dynamic> images = <dynamic>[].obs;
  RxBool isLoading = false.obs;

  Future<void> getScannedImagesForFolder(int folderId) async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Loading scanned images...');

      final url = Urls.scannedImages(folderId);
      debugPrint('🔗 Scanned images URL: $url');

      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        isLoading.value = false;
        return;
      }

      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      });

      EasyLoading.dismiss();
      isLoading.value = false;

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> dataArray = responseData['data'] ?? [];
        images.value = dataArray;
        EasyLoading.showSuccess('${dataArray.length} images loaded');
      } else {
        debugPrint('❌ Failed to fetch scanned images: ${response.statusCode}');
        debugPrint('❌ Response: ${response.body}');
        EasyLoading.showError('Failed to load scanned images');
      }
    } catch (e) {
      isLoading.value = false;
      EasyLoading.dismiss();
      debugPrint('❌ Error fetching scanned images: $e');
      EasyLoading.showError('Error: $e');
    }
  }
}
