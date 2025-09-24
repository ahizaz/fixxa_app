import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:get/get.dart';

class HomeDefaultController extends GetxController {
  final RxDouble sent = 12.0.obs;
  final RxDouble won = 8.0.obs;
  final RxDouble lost = 4.0.obs;

  final RxInt selectedTab = 0.obs;

  final RxList<Map<String, dynamic>> clientData = [
    {
      "name": "Richardo Mathew",
      "email": "richardomathew@gmail.com",
      "jobCount": 1,
      "earnings": 120,
      "image": ImagePath.client1,
      "phone": "+44 1234 567896",
    },
    {
      "name": "Sarah Johnson",
      "email": "sarahjohnson@gmail.com",
      "jobCount": 3,
      "earnings": 350,
      "image": ImagePath.client2,
      "phone": "+44 1234 567896",
    },
    {
      "name": "Michael Brown",
      "email": "michaelbrown@gmail.com",
      "jobCount": 2,
      "earnings": 200,
      "image": ImagePath.client3,
      "phone": "+44 1234 567896",
    },
  ].obs;

  // Quote data
  final RxList<Map<String, dynamic>> quoteData = [
    {
      "name": "John Smith",
      "won": 850,
      "lost": 200,
      "email": "jamessmith@gmail.com",
      "quotes": 3,

      "image": ImagePath.client1,
      "phone": "+44 1234 567896",
    },
    {
      "jobCount": 3,
      "name": "John Carter",
      "email": "jamessmith@gmail.com",
      "won": 237,
      "lost": 60,
      "quotes": 3,
      "image": ImagePath.client2,
      "phone": "+44 1234 567896",
    },
    {
      "name": "James Williams",
      "email": "jamessmith@gmail.com",
      "won": 0, // Default to 0 if not provided
      "lost": 420,
      "quotes": 2,
      "image": ImagePath.client3,
      "phone": "+44 1234 567896",
    },
    {
      "name": "Emma Brown",
      "email": "jamessmith@gmail.com",
      "won": 0, // Default to 0 if not provided
      "sent": 850, // Note: 'sent' is present but not used in current UI
      "quotes": 1,
      "image": ImagePath.client1,
      "phone": "+44 1234 567896",
    },
  ].obs;

  final RxList<Map<String, dynamic>> wonquoteData = [
    {
      "name": "John Smith",
      "won": 850,

      "email": "jamessmith@gmail.com",
      "quotes": 3,

      "image": ImagePath.client1,
      "phone": "+44 1234 567896",
    },

    {
      "jobCount": 3,
      "name": "John Carter",
      "email": "jamessmith@gmail.com",

      "won": 50,
      "quotes": 3,
      "image": ImagePath.client2,
      "phone": "+44 1234 567896",
    },
    {
      "name": "James Williams",
      "email": "jamessmith@gmail.com",
      "won": 0, // Default to 0 if not provided

      "quotes": 2,
      "image": ImagePath.client3,
      "phone": "+44 1234 567896",
    },
    {
      "name": "Emma Brown",
      "email": "jamessmith@gmail.com",
      "won": 0, // Default to 0 if not provided
      // Note: 'sent' is present but not used in current UI
      "quotes": 1,
      "image": ImagePath.client1,
      "phone": "+44 1234 567896",
    },
  ].obs;

  final RxList<Map<String, dynamic>> lostquoteData = [
    {
      "name": "John Smith",
      "lost": 850,

      "email": "jamessmith@gmail.com",
      "quotes": 3,

      "image": ImagePath.client1,
      "phone": "+44 1234 567896",
    },

    {
      "jobCount": 3,
      "name": "John Carter",
      "email": "jamessmith@gmail.com",

      "lost": 50,
      "quotes": 3,
      "image": ImagePath.client2,
      "phone": "+44 1234 567896",
    },
    {
      "name": "James Williams",
      "email": "jamessmith@gmail.com",
      "lost": 0, // Default to 0 if not provided

      "quotes": 2,
      "image": ImagePath.client3,
      "phone": "+44 1234 567896",
    },
    {
      "name": "Emma Brown",
      "email": "jamessmith@gmail.com",
      "lost": 0, // Default to 0 if not provided
      // Note: 'sent' is present but not used in current UI
      "quotes": 1,
      "image": ImagePath.client1,
      "phone": "+44 1234 567896",
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
    clientData.value = jsonList
        .map(
          (item) => {
            "name": item['name'] ?? "Unknown",
            "email": item['email'] ?? "no-email@example.com",
            "jobCount": (item['jobCount'] as num?)?.toInt() ?? 0,
            "earnings": (item['earnings'] as num?)?.toInt() ?? 0,
            "image": item['image'] ?? ImagePath.client1,
            "phone": item['phone'] ?? "+44 1234 567896",
          },
        )
        .toList();
  }

  // Method to update quote data from API
  void updateQuoteDataFromJson(List<dynamic> jsonList) {
    quoteData.value = jsonList
        .map(
          (item) => {
            "name": item['name'] ?? "Unknown",
            "won": (item['won'] as num?)?.toInt() ?? 0,
            "lost": (item['lost'] as num?)?.toInt() ?? 0,
            "quotes": (item['quotes'] as num?)?.toInt() ?? 0,
          },
        )
        .toList();
  }
}
