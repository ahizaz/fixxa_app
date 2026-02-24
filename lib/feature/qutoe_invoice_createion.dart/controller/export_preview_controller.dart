import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/controller/manually_quote_controller.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/quote_ai_generated_controller.dart';
import 'quote_controller.dart';

class ExportPreviewController extends GetxController {
  final QuoteController quoteController;
  final Map<String, dynamic>? initialData;

  ExportPreviewController([Map<String, dynamic>? data])
      : quoteController = QuoteController(data),
        initialData = data;

  @override
  void onInit() {
    super.onInit();
    // If initialData contains a quote id, or if other controllers have it,
    // try to fetch latest from API and update the quote controller.
    _tryFetchFromApi();
  }

  Future<void> _tryFetchFromApi() async {
    try {
      int? quoteId;

      // 1) Check initial data for common keys
      if (initialData != null) {
        final possible = initialData!['quote_id'] ?? initialData!['quoteId'] ?? initialData!['id'];
        if (possible != null) quoteId = int.tryParse(possible.toString());
      }

      // 2) If still null, try to find a registered controller that may hold quote id
      if (quoteId == null) {
        if (Get.isRegistered<ManuallyQuoteController>()) {
          try {
            final mqc = Get.find<ManuallyQuoteController>();
            final qv = mqc.quoteId.value;
            if (qv != null && qv != 0) quoteId = qv;
          } catch (e) {
            debugPrint('ExportPreviewController: error reading ManuallyQuoteController: $e');
          }
        }

        if (quoteId == null && Get.isRegistered<QuoteAiGeneratedController>()) {
          try {
            final aic = Get.find<QuoteAiGeneratedController>();
            final data = aic.quoteData;
            if (data != null && data is RxMap && data.isNotEmpty) {
              final possible = data['quoteId'] ?? data['quote_id'] ?? data['id'];
              if (possible != null) quoteId = int.tryParse(possible.toString());
            }
          } catch (e) {
            debugPrint('ExportPreviewController: error reading QuoteAiGeneratedController: $e');
          }
        }

        // If still null, try generic QuoteController
        if (quoteId == null && Get.isRegistered<QuoteController>()) {
          final qc = Get.find<QuoteController>();
          // no numeric id stored here generally
        }
      }

      // 3) If we couldn't determine quoteId, abort quietly (keep static data)
      if (quoteId == null) {
        debugPrint('ExportPreviewController: No quoteId available to fetch from API.');
        return;
      }

      // Show loading while fetching
      EasyLoading.show(status: 'Loading quote...');

      final token = await LoginController.getAccessToken();
      if (token == null || token.isEmpty) {
        EasyLoading.dismiss();
        debugPrint('ExportPreviewController: No access token found.');
        return;
      }

      final url = Urls.getSpecificQUote(quoteId);
      debugPrint('ExportPreviewController: Fetching quote from $url');

      final resp = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      EasyLoading.dismiss();

      if (resp.statusCode == 200) {
        final body = jsonDecode(resp.body) as Map<String, dynamic>;
        debugPrint('ExportPreviewController: API response: $body');

        if (body['success'] == true && body['data'] != null) {
          final d = body['data'] as Map<String, dynamic>;
          final mapped = _mapApiDataToLocal(d);
          quoteController.loadData(mapped);
          update();
          debugPrint('ExportPreviewController: Quote data loaded from API.');
        } else {
          debugPrint('ExportPreviewController: API returned unexpected body: ${resp.body}');
        }
      } else {
        debugPrint('ExportPreviewController: Failed to fetch quote. Status: ${resp.statusCode}');
        debugPrint('ExportPreviewController: Body: ${resp.body}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('ExportPreviewController: Exception while fetching quote: $e');
    }
  }

  Map<String, dynamic> _mapApiDataToLocal(Map<String, dynamic> api) {
    // Map API response into the shape expected by QuoteController.loadData
    final billTo = api['bill_to'] ?? api['client_details'] ?? {};
    final from = api['from_details'] ?? {};

    final itemsRaw = api['items'] as List<dynamic>? ?? <dynamic>[];
    final items = itemsRaw.map((it) {
      return {
        'description': it['quote_description'] ?? it['description'] ?? '',
        'quantity': it['quantity'] ?? 1,
        'unitPrice': (it['unit_price'] ?? it['unitPrice'] ?? 0).toString(),
      };
    }).toList();

    return {
      'companyName': from['business_name'] ?? from['name'] ?? '',
      'companyAddress': [from['address'] ?? ''],
      'clientName': billTo['name'] ?? api['client']?.toString() ?? '',
      'clientAddress': [billTo['address'] ?? ''],
      'email': billTo['email'] ?? from['email'] ?? '',
      'phone': billTo['phone'] ?? from['contact'] ?? '',
      'quoteNumber': api['quote_number'] ?? api['quoteId'] ?? '',
      'issuedDate': api['issue_date'] ?? api['issued_date'] ?? '',
      'validUntil': api['due_date'] ?? api['valid_until'] ?? '',
      'items': items,
      'vatPercent': (api['vat_rate'] is num) ? (api['vat_rate'] as num).toDouble() : double.tryParse('${api['vat_rate'] ?? ''}') ?? 0.0,
    };
  }
}
