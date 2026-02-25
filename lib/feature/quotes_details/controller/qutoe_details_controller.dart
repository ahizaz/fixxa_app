import 'dart:convert';

import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class QuoteDetailsController extends GetxController {
  RxList<Map<String, dynamic>> quotes = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllQuotes();
  }

  Future<void> fetchAllQuotes() async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Loading quotes...');

      debugPrint('🔄 Fetching all quotes...');
      final url = Urls.getAllQuote;
      debugPrint('🔗 API URL: $url');

      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        debugPrint('❌ Access token is null or empty');
        isLoading.value = false;
        return;
      }

      debugPrint(
          '🔑 Using bearer token: Bearer ${accessToken.substring(0, 10)}...');

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

        final data = responseData['data'] ?? {};
        final List<dynamic> results = data['results'] ?? [];
        debugPrint('📋 Number of quote items: ${results.length}');

        // Group quotes by client name while keeping structure expected by UI
        final Map<String, Map<String, dynamic>> groupedByClient = {};

        for (final item in results) {
          final clientDetails = item['client_details'] ?? {};
          final String clientName =
              (clientDetails['name'] ?? 'Unknown Client').toString();

          // Map backend quote_status to UI status type
          final String rawStatus =
              (item['quote_status'] ?? '').toString().toLowerCase();
          String statusType;
          switch (rawStatus) {
            case 'accepted':
            case 'won':
              statusType = 'won';
              break;
            case 'rejected':
            case 'lost':
              statusType = 'lost';
              break;
            default:
              statusType = 'sent';
          }

          final dynamic totalRaw = item['total'];
          double totalValue;
          if (totalRaw is num) {
            totalValue = totalRaw.toDouble();
          } else {
            totalValue =
                double.tryParse(totalRaw?.toString() ?? '0') ?? 0.0;
          }

          // Simple amount label; you can adjust currency formatting if needed
          final String amountLabel = '£${totalValue.toStringAsFixed(0)}';

          final existing =
              groupedByClient.putIfAbsent(clientName, () => {
                    'name': clientName,
                    'statuses': <Map<String, dynamic>>[],
                    'quotes': 0,
                  });

          // Increase quote count for this client
          existing['quotes'] = (existing['quotes'] as int) + 1;

          // Append a status pill entry; UI already knows how to render this list
          final List<Map<String, dynamic>> statuses =
              (existing['statuses'] as List).cast<Map<String, dynamic>>();
          statuses.add({
            'amount': amountLabel,
            'type': statusType,
          });
        }

        quotes.value =
            groupedByClient.values.toList().cast<Map<String, dynamic>>();

        EasyLoading.showSuccess('${quotes.length} clients loaded');
      } else {
        debugPrint(
            '❌ Failed to fetch quotes. Status: ${response.statusCode}');
        debugPrint('❌ Response: ${response.body}');

        try {
          final errorData = jsonDecode(response.body);
          final errorMessage =
              errorData['message'] ?? 'Failed to load quotes';
          EasyLoading.showError(errorMessage);
        } catch (e) {
          EasyLoading.showError(
              'Failed to load quotes (${response.statusCode})');
        }
      }
    } catch (e) {
      isLoading.value = false;
      EasyLoading.dismiss();
      debugPrint('❌ Error fetching quotes: $e');
      EasyLoading.showError('Error: $e');
    }
  }
}
