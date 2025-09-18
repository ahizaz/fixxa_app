import 'package:fixxa_app/core/utils/constants/image_path.dart';

import 'package:get/get.dart';

class ReportController extends GetxController {
  RxInt selectedTab = 0.obs;
  RxInt selectedChoice = (-1).obs;

  // Chart type (Weekly/Monthly)
  RxString reportType = "Weekly".obs;

  // Weekly chart values
  RxList<double> weeklyData = <double>[8000, 2000, 2000, 9000, 8500, 10000, 3500].obs;
  RxList<double> weeklyDatabalance = <double>[80000, 2500, 2000, 95000, 8500, 10000, 3500].obs;

  // Monthly chart values
  RxList<double> monthlyData = <double>[
    30000, 45000, 25000, 60000, 40000, 50000,
    55000, 35000, 70000, 45000, 60000, 30000
  ].obs;

  // Summary values
  RxDouble paid = 0.0.obs;
  RxDouble unpaid = 0.0.obs;
  RxDouble total = 0.0.obs;
  RxDouble tax = 0.0.obs;

  void choiceTab(int index) {
    if (selectedChoice.value == index) {
      selectedChoice.value = -1;
    } else {
      selectedChoice.value = index;
    }
  }

  // Toggle report type
  void toggleReportType() {
    if (reportType.value == "Weekly") {
      reportType.value = "Monthly";
    } else {
      reportType.value = "Weekly";
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
