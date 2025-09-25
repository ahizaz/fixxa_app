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
  
  // Track if popup spotlight has been shown once
  static bool _hasShownPopupSpotlight = false;

  static void triggerSpotlight({
    int seconds = 1,
    String? spotlightTitle,
    String? spotlightDescription,
  }) {
    if (spotlightTitle != null) title.value = spotlightTitle;
    if (spotlightDescription != null) description.value = spotlightDescription;
    showSpotlight.value = true;
    Future.delayed(Duration(seconds: seconds), () {
      showSpotlight.value = false;
    });
  }
  
  static void triggerPopupSpotlight({
    int seconds = 1,
    String? spotlightTitle,
    String? spotlightDescription,
  }) {
    // Only show popup spotlight once
    if (_hasShownPopupSpotlight) return;
    
    _hasShownPopupSpotlight = true;
    if (spotlightTitle != null) popupTitle.value = spotlightTitle;
    if (spotlightDescription != null) popupDescription.value = spotlightDescription;
    showPopupSpotlight.value = true;
    Future.delayed(Duration(seconds: seconds), () {
      showPopupSpotlight.value = false;
    });
  }
}