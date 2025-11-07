import 'dart:async';

import 'package:fixxa_app/feature/account%20create&authentication/screen/welcome_sceen.dart';
import 'package:fixxa_app/feature/home_default_clients/screen/home_default_clients.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:fixxa_app/core/services/spotlight_service.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    startDisplay();
  }

  void startDisplay() async {
    // Wait for 3 seconds to show splash screen
    await Future.delayed(const Duration(seconds: 3));
    
    // Check if user has saved token
    final token = await LoginController.getAccessToken();
    
    if (token != null && token.isNotEmpty) {
      // User is logged in, set token in SpotlightService for user-specific spotlight tracking
      SpotlightService.instance.setUserToken(token);
      
      // Go to home screen
      Get.off(() => const HomeDefaultClients());
    } else {
      // No token found, go to welcome screen
      Get.off(() => WelcomeSceen());
    }
  }
}
