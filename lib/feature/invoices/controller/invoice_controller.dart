import 'dart:convert';

import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/invoices/models/invoice_model.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class InvoiceController extends GetxController {
  final invoices = <InvoiceData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInvoices();
  }

  Future<void> fetchInvoices({bool showLoading = true}) async {
    try {
      if (showLoading) EasyLoading.show(status: 'Loading invoices...');

      final token = await LoginController.getAccessToken();
      if (token == null || token.isEmpty) {
        if (showLoading) EasyLoading.dismiss();
        EasyLoading.showError('Please login again');
        return;
      }

      final url = Urls.getALlInvoice;
      debugPrint('📥 Fetching invoices from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (showLoading) EasyLoading.dismiss();

      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final list = InvoiceData.listFromResponse(body);
        invoices.assignAll(list);
        debugPrint('✅ Loaded ${list.length} invoices');
      } else {
        debugPrint('❌ Failed to load invoices: ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('❌ Error fetching invoices: $e');
    }
  }

  /// Update client details for a specific invoice by invoice id string
  void updateClientDetails(String id, String name, String email, String phone) {
    final idx = invoices.indexWhere((inv) => inv.id == id);
    if (idx != -1) {
      final inv = invoices[idx];
      inv.customerName = name;
      inv.email = email;
      inv.phone = phone;
      invoices.refresh();
    }
  }
}
