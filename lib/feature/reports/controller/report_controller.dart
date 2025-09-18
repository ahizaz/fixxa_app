import 'package:get/get.dart';

class ReportController extends GetxController {
  RxInt selectedTab = 0.obs;
  RxInt selectedChoice = (-1).obs;

  // Chart type (Weekly/Monthly)
  RxString reportType = "Weekly".obs;

  // Weekly chart values
  RxList<double> weeklyData = <double>[8000, 2000, 2000, 9000, 8500, 10000, 3500].obs;

  // Monthly chart values
  RxList<double> monthlyData = <double>[30000, 45000, 25000, 60000, 40000, 50000].obs;

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
}
