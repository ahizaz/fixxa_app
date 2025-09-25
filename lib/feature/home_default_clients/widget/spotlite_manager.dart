import 'package:flutter/material.dart';

// Singleton SpotlightManager: you can call SpotlightManager.triggerSpotlight(seconds) from anywhere in your code.
class SpotlightManager {
  static final ValueNotifier<bool> showSpotlight = ValueNotifier<bool>(true);

  static void triggerSpotlight({int seconds = 1}) {
    showSpotlight.value = true;
    Future.delayed(Duration(seconds: seconds), () {
      showSpotlight.value = false;
    });
  }
}