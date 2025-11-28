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

  // Session flags to prevent multiple triggers in same session
  static bool _hasTriggeredMainSpotlightInSession = false;
  static bool _hasTriggeredPopupSpotlightInSession = false;

  // Reset session flags (call on logout or app restart)
  static void resetSessionFlags() {
    _hasTriggeredMainSpotlightInSession = false;
    _hasTriggeredPopupSpotlightInSession = false;
  }

  static void triggerSpotlight({
    int seconds = 1,
    String? spotlightTitle,
    String? spotlightDescription,
  }) {
    debugPrint("SpotlightManager: triggerSpotlight called");
    
    // FIRST check persistent storage - this is the source of truth
    if (SpotlightService.instance.hasShownMainSpotlight()) {
      if (!_hasTriggeredMainSpotlightInSession) {
        debugPrint("SpotlightManager: Main spotlight already shown (from storage), skipping");
        _hasTriggeredMainSpotlightInSession = true; // Mark as attempted to avoid repeated logs
      }
      return; // Don't show if already shown before
    }
    
    // Check if already triggered in this session (prevents multiple triggers in same session)
    if (_hasTriggeredMainSpotlightInSession) {
      debugPrint("SpotlightManager: Main spotlight already triggered in this session, skipping");
      return; // Don't trigger again in same session
    }
    
    // Mark as triggered in this session IMMEDIATELY
    _hasTriggeredMainSpotlightInSession = true;
    
    debugPrint("SpotlightManager: Showing main spotlight for $seconds seconds");
    if (spotlightTitle != null) title.value = spotlightTitle;
    if (spotlightDescription != null) description.value = spotlightDescription;
    showSpotlight.value = true;
    
    Future.delayed(Duration(seconds: seconds), () {
      showSpotlight.value = false;
      SpotlightService.instance.setMainSpotlightShown();
      debugPrint("SpotlightManager: Main spotlight marked as shown in persistent storage");
    });
  }
  
  static void triggerPopupSpotlight({
    int seconds = 1,
    String? spotlightTitle,
    String? spotlightDescription,
  }) {
    // FIRST check persistent storage - this is the source of truth
    if (SpotlightService.instance.hasShownPopupSpotlight()) {
      if (!_hasTriggeredPopupSpotlightInSession) {
        debugPrint("SpotlightManager: Popup spotlight already shown (from storage), skipping");
        _hasTriggeredPopupSpotlightInSession = true; // Mark as attempted to avoid repeated logs
      }
      return; // Don't show if already shown before
    }
    
    // Check if already triggered in this session (prevents multiple triggers in same session)
    if (_hasTriggeredPopupSpotlightInSession) {
      debugPrint("SpotlightManager: Popup spotlight already triggered in this session, skipping");
      return; // Don't trigger again in same session
    }
    
    // Mark as triggered in this session IMMEDIATELY
    _hasTriggeredPopupSpotlightInSession = true;
    
    debugPrint("SpotlightManager: Showing popup spotlight for $seconds seconds");
    if (spotlightTitle != null) popupTitle.value = spotlightTitle;
    if (spotlightDescription != null) popupDescription.value = spotlightDescription;
    showPopupSpotlight.value = true;
    
    Future.delayed(Duration(seconds: seconds), () {
      showPopupSpotlight.value = false;
      SpotlightService.instance.setPopupSpotlightShown();
      debugPrint("SpotlightManager: Popup spotlight marked as shown in persistent storage");
    });
  }
}