import 'package:fixxa_app/core/services/spotlight_service.dart';
import 'package:flutter/material.dart';

// Singleton SpotlightManager: you can call SpotlightManager.triggerSpotlight(seconds, spotlightTitle, spotlightDescription) from anywhere in your code.
class SpotlightManager {
  // Main spotlight (for plus button)
  static final ValueNotifier<bool> showSpotlight = ValueNotifier<bool>(false);
  static final ValueNotifier<String> title = ValueNotifier<String>("Getting started");
  static final ValueNotifier<String> description = ValueNotifier<String>("Click the plus (+) icon first.");
  
  // Popup spotlight (for popup menu)
  static final ValueNotifier<bool> showPopupSpotlight = ValueNotifier<bool>(false);
  static final ValueNotifier<String> popupTitle = ValueNotifier<String>("Choose your option");
  static final ValueNotifier<String> popupDescription = ValueNotifier<String>("Select Create Quote or Create Invoice");

  static void triggerSpotlight({
    int seconds = 1,
    String? spotlightTitle,
    String? spotlightDescription,
  }) {
    // Check if main spotlight has been shown before
    if (SpotlightService.instance.hasShownMainSpotlight()) {
      return; // Don't show if already shown
    }
    
    if (spotlightTitle != null) title.value = spotlightTitle;
    if (spotlightDescription != null) description.value = spotlightDescription;
    showSpotlight.value = true;
    Future.delayed(Duration(seconds: seconds), () {
      showSpotlight.value = false;
      SpotlightService.instance.setMainSpotlightShown();
    });
  }
  
  static void triggerPopupSpotlight({
    int seconds = 1,
    String? spotlightTitle,
    String? spotlightDescription,
  }) {
    // Check if popup spotlight has been shown before using persistent storage
    if (SpotlightService.instance.hasShownPopupSpotlight()) {
      return; // Don't show if already shown
    }
    
    if (spotlightTitle != null) popupTitle.value = spotlightTitle;
    if (spotlightDescription != null) popupDescription.value = spotlightDescription;
    showPopupSpotlight.value = true;
    Future.delayed(Duration(seconds: seconds), () {
      showPopupSpotlight.value = false;
      SpotlightService.instance.setPopupSpotlightShown();
    });
  }
}