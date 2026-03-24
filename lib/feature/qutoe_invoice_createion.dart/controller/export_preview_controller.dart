import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/controller/manually_quote_controller.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/quote_ai_generated_controller.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/controller/invoice_manually_controller.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/invoice_ai_generated_controller.dart';
import 'quote_controller.dart';

class ExportPreviewController extends GetxController {
  final QuoteController quoteController;
  final Map<String, dynamic>? initialData;
  final String source;
  final bool autoFetch;

  // When controller is disposed we avoid applying any async results
  bool _active = true;

  ExportPreviewController([Map<String, dynamic>? data, this.source = 'quote', this.autoFetch = false])
      : quoteController = QuoteController(data),
        initialData = data;

  @override
  void onInit() {
    super.onInit();
    // Only fetch automatically when explicitly requested (e.g. opened via Export)
    if (autoFetch) {
      _tryFetchFromApi();
    }
  }

  @override
  void onClose() {
    _active = false;
    try {
      EasyLoading.dismiss();
    } catch (_) {}
    super.onClose();
  }

  /// Public method to fetch data on demand (callable from UI when starting export)
  Future<void> fetchFromApi() async {
    if (!_active) return;
    await _tryFetchFromApi();
  }

  Future<void> _tryFetchFromApi() async {
    try {
      if (!_active) return;
      int? id;

      // 1) Check initial data for common keys
      if (initialData != null) {
        final possible = initialData!['quote_id'] ?? initialData!['quoteId'] ?? initialData!['invoice_id'] ?? initialData!['invoiceId'] ?? initialData!['id'];
        if (possible != null) id = int.tryParse(possible.toString());
      }

      // 2) If still null, try to find a registered controller that may hold quote id
      if (id == null) {
        // Try controllers depending on source
        if (source == 'quote') {
          if (Get.isRegistered<ManuallyQuoteController>()) {
            try {
              final mqc = Get.find<ManuallyQuoteController>();
              final qv = mqc.quoteId.value;
              if (qv != null && qv != 0) id = qv;
            } catch (e) {
              debugPrint('ExportPreviewController: error reading ManuallyQuoteController: $e');
            }
          }

          if (id == null && Get.isRegistered<QuoteAiGeneratedController>()) {
            try {
              final aic = Get.find<QuoteAiGeneratedController>();
              final data = aic.quoteData;
              if (data != null && data is RxMap && data.isNotEmpty) {
                final possible = data['quoteId'] ?? data['quote_id'] ?? data['id'];
                if (possible != null) id = int.tryParse(possible.toString());
              }
            } catch (e) {
              debugPrint('ExportPreviewController: error reading QuoteAiGeneratedController: $e');
            }
          }
        } else if (source == 'invoice') {
          if (Get.isRegistered<InvoiceManuallyController>()) {
            try {
              final imc = Get.find<InvoiceManuallyController>();
              final iv = imc.invoiceId.value;
              if (iv != null && iv != 0) id = iv;
            } catch (e) {
              debugPrint('ExportPreviewController: error reading InvoiceManuallyController: $e');
            }
          }

          if (id == null && Get.isRegistered<InvoiceAiGeneratedController>()) {
            try {
              final aic = Get.find<InvoiceAiGeneratedController>();
              final data = aic.quoteData;
              if (data != null && data is RxMap && data.isNotEmpty) {
                final possible = data['invoice_id'] ?? data['invoiceId'] ?? data['id'];
                if (possible != null) id = int.tryParse(possible.toString());
              }
            } catch (e) {
              debugPrint('ExportPreviewController: error reading InvoiceAiGeneratedController: $e');
            }
          }
        }
      }

      // 3) If we couldn't determine id, abort quietly (keep static data)
      if (id == null) {
        debugPrint('ExportPreviewController: No id available to fetch from API.');
        return;
      }

      // Show loading while fetching
      if (!_active) return;
      EasyLoading.show(status: 'Loading ${source}...');

      final token = await LoginController.getAccessToken();
      if (token == null || token.isEmpty) {
        EasyLoading.dismiss();
        debugPrint('ExportPreviewController: No access token found.');
        return;
      }

      final url = (source == 'invoice') ? Urls.getSpecificInvoice(id) : Urls.getSpecificQUote(id);
      debugPrint('ExportPreviewController: Fetching $source from $url');

      // Apply a timeout so the UI doesn't hang indefinitely on slow networks
      late http.Response resp;
      try {
        resp = await http
            .get(Uri.parse(url), headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            })
            .timeout(const Duration(seconds: 12));
      } on TimeoutException catch (_) {
        EasyLoading.dismiss();
        debugPrint('ExportPreviewController: Request timed out when fetching $source');
        EasyLoading.showError('Request timed out. Please check your internet and try again.');
        return;
      } catch (e) {
        EasyLoading.dismiss();
        debugPrint('ExportPreviewController: Exception when fetching $source: $e');
        EasyLoading.showError('Failed to load data. Please try again.');
        return;
      }

      EasyLoading.dismiss();

      if (!_active) return;

      if (resp.statusCode == 200) {
        if (!_active) return;
        final body = jsonDecode(resp.body) as Map<String, dynamic>;
        debugPrint('ExportPreviewController: API response: $body');

        if (body['success'] == true && body['data'] != null) {
          final d = body['data'] as Map<String, dynamic>;
          final mapped = _mapApiDataToLocal(d);
          debugPrint(
              'ExportPreviewController: BANK DEBUG -> '
              '${mapped['bankName']} | '
              '${mapped['accountName']} | '
              '${mapped['sortCode']} | '
              '${mapped['accountNo']}');
          quoteController.loadData(mapped);
          update();
          debugPrint('ExportPreviewController: $source data loaded from API.');
        } else {
          debugPrint('ExportPreviewController: API returned unexpected body for $source: ${resp.body}');
          EasyLoading.showError('No data returned from server');
        }
      } else {
        debugPrint('ExportPreviewController: Failed to fetch $source. Status: ${resp.statusCode}');
        debugPrint('ExportPreviewController: Body: ${resp.body}');
        EasyLoading.showError('Failed to load $source: ${resp.statusCode}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('ExportPreviewController: Exception while fetching $source: $e');
      EasyLoading.showError('Failed to load $source');
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
      // Provide separate client/company contact fields to avoid duplication in the UI
      'clientEmail': billTo['email'] ?? billTo['email_address'] ?? '',
      'clientPhone': billTo['phone'] ?? billTo['tel'] ?? '',
      'companyEmail': from['email'] ?? from['contact_email'] ?? '',
      'companyPhone': from['contact'] ?? from['phone'] ?? '',
      // Backwards-compatible single fields (kept for other consumers)
      'email': billTo['email'] ?? from['email'] ?? '',
      'clientLogo': api['client_logo'] ?? billTo['logo'] ?? '',
      'acceptLink': api['payment_link'] ?? api['accept_link'] ?? api['acceptLink'] ?? '',
      'companyLogo': from['logo'] ?? '',
      'phone': billTo['phone'] ?? from['contact'] ?? '',
      'bankName': api['bank_name'] ?? '',
      'accountName': api['account_name'] ?? '',
      'sortCode': api['sort_code'] ?? '',
      'accountNo': api['account_no'] ?? '',
      'quoteNumber': api['quote_number'] ?? api['invoice_number'] ?? api['quoteId'] ?? api['invoice_id'] ?? api['quoteId'] ?? '',
      'issuedDate': api['issue_date'] ?? api['issued_date'] ?? api['issueDate'] ?? '',
      'validUntil': api['due_date'] ?? api['valid_until'] ?? api['validUntil'] ?? '',
      'items': items,
      'vatPercent': (api['vat_rate'] is num) ? (api['vat_rate'] as num).toDouble() : double.tryParse('${api['vat_rate'] ?? ''}') ?? 0.0,
    };
  }
}
