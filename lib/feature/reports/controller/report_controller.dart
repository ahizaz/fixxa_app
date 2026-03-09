import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ReportController extends GetxController {
  RxInt selectedTab = 0.obs;
  RxInt selectedChoice = (-1).obs;

  // Chart type (Monthly/Yearly)
  RxString reportType = "Monthly".obs;

  // Selected filters
  RxInt selectedYear = DateTime.now().year.obs;
  RxInt selectedMonth = DateTime.now().month.obs;

  // Chart bar data (single bar representing the period total)
  RxList<double> chartData = <double>[0.0].obs;

  // Summary values from API
  RxDouble paid = 0.0.obs;
  RxDouble unpaid = 0.0.obs;
  RxDouble total = 0.0.obs;
  RxDouble tax = 0.0.obs;
  RxInt totalInvoiceCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFinancialStatistics();
  }

  void choiceTab(int index) {
    if (selectedChoice.value == index) {
      selectedChoice.value = -1;
    } else {
      selectedChoice.value = index;
    }
  }

  // Toggle report type between Monthly and Yearly
  void toggleReportType() {
    if (reportType.value == "Monthly") {
      reportType.value = "Yearly";
    } else {
      reportType.value = "Monthly";
    }
  }

  Future<void> fetchFinancialStatistics() async {
    try {
      EasyLoading.show(status: 'Loading...');

      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please login first');
        debugPrint('❌ No access token found for financial statistics');
        return;
      }

      final String url;
      if (reportType.value == "Yearly") {
        url = Urls.financialStatisticsYearly(selectedYear.value);
      } else {
        url = Urls.financialStatisticsMonthly(selectedYear.value, selectedMonth.value);
      }

      debugPrint('📊 Fetching financial statistics: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      debugPrint('📥 Financial stats status: ${response.statusCode}');
      debugPrint('📥 Financial stats body: ${response.body}');

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        final data = responseBody['data'] as Map<String, dynamic>;
        paid.value = (data['paid_amount'] ?? 0).toDouble();
        unpaid.value = (data['unpaid_amount'] ?? 0).toDouble();
        total.value = (data['total_amount'] ?? 0).toDouble();
        totalInvoiceCount.value = (data['total_invoices'] ?? 0) as int;
        chartData.value = [total.value > 0 ? total.value : 0.0];
        debugPrint('✅ Financial statistics loaded successfully');
      } else {
        EasyLoading.showError('Failed to load statistics');
        debugPrint('❌ Financial stats error: ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Error loading statistics');
      debugPrint('❌ Financial statistics exception: $e');
    }
  }

  // ✅ Paid Invoices data (avatar সবসময় string path)
  RxList<Map<String, dynamic>> paidInvoices = <Map<String, dynamic>>[
    {
      "name": "Richardo Mathew",
      "email": "richardomathew@gmail.com",
      "amount": 4506.0,
      "currency": "£",
      "avatar": ImagePath.client1,
    },
    {
      "name": "Alex Johnson",
      "email": "alexjohnson@gmail.com",
      "amount": 3200.0,
      "currency": "£",
      "avatar": ImagePath.client1,
    },
    {
      "name": "Sophia Lee",
      "email": "sophialee@gmail.com",
      "amount": 5000.0,
      "currency": "£",
      "avatar": ImagePath.client1,
    },
    {
      "name": "David Brown",
      "email": "davidbrown@gmail.com",
      "amount": 2750.0,
      "currency": "£",
      "avatar": ImagePath.client1,
    },
  ].obs;
  RxList<Map<String, dynamic>> unpaidInvoices = <Map<String, dynamic>>[
    {
      "name": "Richardo Mathew",
      "email": "richardomathew@gmail.com",
      "amount": 4506.0,
      "currency": "£",
      "avatar": ImagePath.client1,
    },
    {
      "name": "Alex Johnson",
      "email": "alexjohnson@gmail.com",
      "amount": 3200.0,
      "currency": "£",
      "avatar": ImagePath.client1,
    },
    {
      "name": "Sophia Lee",
      "email": "sophialee@gmail.com",
      "amount": 5000.0,
      "currency": "£",
      "avatar": ImagePath.client1,
    },
    {
      "name": "David Brown",
      "email": "davidbrown@gmail.com",
      "amount": 2750.0,
      "currency": "£",
      "avatar": ImagePath.client1,
    },
  ].obs;
  RxList<Map<String, dynamic>> totalInvoices = <Map<String, dynamic>>[
    {
      "name": "Richardo Mathew",
      "email": "richardomathew@gmail.com",
      "amount": 4506.0,
      "currency": "£",
      "status": "paid", // Add status field
      "avatar": ImagePath.client1,
    },
    {
      "name": "John Smith",
      "email": "johnsmith@gmail.com",
      "amount": 3200.0,
      "currency": "£",
      "status": "unpaid",
      "avatar": ImagePath.client1,
    },
    {
      "name": "Emma Wilson",
      "email": "emmawilson@gmail.com",
      "amount": 5100.0,
      "currency": "£",
      "status": "paid",
      "avatar": ImagePath.client1,
    },
    {
      "name": "Michael Brown",
      "email": "michaelbrown@gmail.com",
      "amount": 2800.0,
      "currency": "£",
      "status": "unpaid",
      "avatar": ImagePath.client1,
    },
  ].obs;
}
