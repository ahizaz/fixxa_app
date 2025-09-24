import 'package:get/get.dart';

class TapController extends GetxController {
  RxInt selectedTab = 0.obs;
  RxInt selectedChoice = (-1).obs;
  void choiceTab(int index) {
    if (selectedChoice.value == index) {
      selectedChoice.value = -1;
    } else {
      selectedChoice.value = index;
    }
  }
}
