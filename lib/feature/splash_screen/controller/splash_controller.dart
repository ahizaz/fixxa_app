import 'dart:async';

import 'package:fixxa_app/feature/account%20create&authentication/screen/welcome_sceen.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    startDisplay();
  }

  void startDisplay() {
    Timer(const Duration(seconds: 5), () {
      Get.off(() => WelcomeSceen());
    });
  }
}
