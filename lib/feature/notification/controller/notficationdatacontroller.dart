import 'dart:convert';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:fixxa_app/feature/notification/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotficationcontrollerData extends GetxController {
  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Loading notifications...');

      debugPrint('🔔 Fetching notifications from API...');
      debugPrint('🔗 URL: ${Urls.getAllNotification}');

      final accessToken = await LoginController.getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('❌ No access token found — cannot fetch notifications');
        EasyLoading.showError('Please login again');
        return;
      }

      final masked = accessToken.length > 12
          ? '${accessToken.substring(0, 8)}...${accessToken.substring(accessToken.length - 4)}'
          : accessToken;
      debugPrint('🔑 Access token (masked): $masked');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      debugPrint('🧾 Request headers: $headers');

      final response = await http.get(
        Uri.parse(Urls.getAllNotification),
        headers: headers,
      );

      debugPrint('📥 Response Status: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> list = decoded['data'] ?? decoded ?? [];
        final parsed = list
            .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
            .toList();
        notifications.assignAll(parsed);
        debugPrint('✅ ${parsed.length} notifications loaded');
      } else {
        try {
          final err = jsonDecode(response.body);
          debugPrint('❌ API error: $err');
          EasyLoading.showError(err['message'] ?? 'Failed to load notifications');
        } catch (_) {
          debugPrint('❌ API error status: ${response.statusCode}');
          EasyLoading.showError('Failed to load notifications (${response.statusCode})');
        }
      }
    } catch (e, stack) {
      debugPrint('❌ Exception fetching notifications: $e');
      debugPrint('📎 Stack: $stack');
      EasyLoading.dismiss();
      EasyLoading.showError('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}