import 'package:get/get.dart';

class HomeDefaultController extends GetxController {
  final RxDouble sent = 12.0.obs;
  final RxDouble won = 8.0.obs;
  final RxDouble lost = 4.0.obs;

  final RxInt selectedTab = 0.obs; // 0 = Clients, 1 = Quotes

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
}
