import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:get/get.dart';

class HomeDefaultController extends GetxController {
  final RxDouble sent = 12.0.obs;
  final RxDouble won = 8.0.obs;
  final RxDouble lost = 4.0.obs;

  final RxInt selectedTab = 0.obs; 
  
  final RxList<Map<String,dynamic>>clientData =[
  {
    "name": "Richardo Mathew",
      "email": "richardomathew@gmail.com",
      "jobCount": 1,
      "earnings": 120,
      "image": ImagePath.client1,
  },
  {
      "name": "Sarah Johnson",
      "email": "sarahjohnson@gmail.com",
      "jobCount": 3,
      "earnings": 350,
      "image": ImagePath.client2, // Assuming client2 exists, adjust if needed
    },
    {
      "name": "Michael Brown",
      "email": "michaelbrown@gmail.com",
      "jobCount": 2,
      "earnings": 200,
      "image": ImagePath.client3, // Assuming client3 exists, adjust if needed
    },
  ].obs;

  void switchTab(int index) {
    selectedTab.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  }

  void updateStatsFromJson(Map<String, dynamic> json) {
    sent.value = (json['sent'] as num?)?.toDouble() ?? 0.0;
    won.value = (json['won'] as num?)?.toDouble() ?? 0.0;
    lost.value = (json['lost'] as num?)?.toDouble() ?? 0.0;
  }

  void updateClientDataFromJson(List<dynamic> jsonList) {
    clientData.value = jsonList.map((item) => {
      "name": item['name'] ?? "Unknown",
      "email": item['email'] ?? "no-email@example.com",
      "jobCount": (item['jobCount'] as num?)?.toInt() ?? 0,
      "earnings": (item['earnings'] as num?)?.toInt() ?? 0,
      "image": item['image'] ?? ImagePath.client1, // Default image if not provided
    }).toList();
  }
}
