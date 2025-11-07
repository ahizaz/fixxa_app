import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SpotlightService extends GetxService {
  static SpotlightService get instance => Get.find<SpotlightService>();
  
  late GetStorage _storage;
  
  // Track navigation source to manage spotlight behavior
  String? _lastNavigationSource;
  
  // Track current user token for user-specific spotlight storage
  String? _currentUserToken;

  @override
  Future<void> onInit() async {
    super.onInit();
    await GetStorage.init();
    _storage = GetStorage();
  }
  
  // Set current user token to make spotlights user-specific
  void setUserToken(String token) {
    _currentUserToken = token;
    debugPrint("SpotlightService: User token set for spotlight tracking");
  }
  
  // Clear user token (call on logout)
  void clearUserToken() {
    _currentUserToken = null;
    debugPrint("SpotlightService: User token cleared");
  }
  
  // Get user-specific key for storage
  String _getUserKey(String baseKey) {
    if (_currentUserToken != null && _currentUserToken!.isNotEmpty) {
      // Create a user-specific key by combining token with base key
      return '${_currentUserToken}_$baseKey';
    }
    // Fallback to non-user-specific key (shouldn't happen in normal flow)
    return baseKey;
  }
  
  // Set navigation source for tracking spotlight behavior
  void setNavigationSource(String source) {
    _lastNavigationSource = source;
    debugPrint("SpotlightService: Navigation source set to $source");
  }
  
  // Get current navigation source
  String? getNavigationSource() {
    return _lastNavigationSource;
  }
  
  // Clear navigation source
  void clearNavigationSource() {
    _lastNavigationSource = null;
  }

  // Check if AI generated spotlight has been shown before
  bool hasShownAiGeneratedSpotlight() {
    return _storage.read(_getUserKey('ai_generated_spotlight_shown')) ?? false;
  }

  // Mark AI generated spotlight as shown
  void setAiGeneratedSpotlightShown() {
    _storage.write(_getUserKey('ai_generated_spotlight_shown'), true);
  }

  // Check if Quote AI generated spotlight has been shown before
  bool hasShownQuoteAiGeneratedSpotlight() {
    // Check if spotlight has been shown globally (from any source)
    bool hasShownGlobally = _storage.read(_getUserKey('quote_ai_generated_spotlight_shown_globally')) ?? false;
    
    return hasShownGlobally; // Return true if shown before, false if should show
  }

  // Mark Quote AI generated spotlight as shown globally
  void setQuoteAiGeneratedSpotlightShown() {
    // Mark as shown globally so it never shows again from any source
    _storage.write(_getUserKey('quote_ai_generated_spotlight_shown_globally'), true);
    debugPrint("Quote AI Generated: Spotlight marked as shown globally");
  }

  // Check if Invoice AI generated spotlight has been shown before
  bool hasShownInvoiceAiGeneratedSpotlight() {
    // Check if spotlight has been shown globally (from any source)
    bool hasShownGlobally = _storage.read(_getUserKey('invoice_ai_generated_spotlight_shown_globally')) ?? false;
    
    return hasShownGlobally; // Return true if shown before, false if should show
  }

  // Mark Invoice AI generated spotlight as shown globally
  void setInvoiceAiGeneratedSpotlightShown() {
    // Mark as shown globally so it never shows again from any source
    _storage.write(_getUserKey('invoice_ai_generated_spotlight_shown_globally'), true);
    debugPrint("Invoice AI Generated: Spotlight marked as shown globally");
  }

  // Check if Manually Quote spotlight has been shown before
  bool hasShownManuallyQuoteSpotlight() {
    return _storage.read(_getUserKey('manually_quote_spotlight_shown')) ?? false;
  }

  // Mark Manually Quote spotlight as shown
  void setManuallyQuoteSpotlightShown() {
    _storage.write(_getUserKey('manually_quote_spotlight_shown'), true);
    debugPrint("Manually Quote: Spotlight marked as shown");
  }

  // Check if Add Item Screen spotlight has been shown before
  bool hasShownAddItemScreenSpotlight() {
    return _storage.read(_getUserKey('add_item_screen_spotlight_shown')) ?? false;
  }

  // Mark Add Item Screen spotlight as shown
  void setAddItemScreenSpotlightShown() {
    _storage.write(_getUserKey('add_item_screen_spotlight_shown'), true);
    debugPrint("Add Item Screen: Spotlight marked as shown");
  }

  // Invoice Manually Spotlights (separate from Quote Manually)
  // Check if Invoice Manually spotlight has been shown before
  bool hasShownInvoiceManuallySpotlight() {
    return _storage.read(_getUserKey('invoice_manually_spotlight_shown')) ?? false;
  }

  // Mark Invoice Manually spotlight as shown
  void setInvoiceManuallySpotlightShown() {
    _storage.write(_getUserKey('invoice_manually_spotlight_shown'), true);
    debugPrint("Invoice Manually: Spotlight marked as shown");
  }

  // Check if Invoice Add Item Screen spotlight has been shown before
  bool hasShownInvoiceAddItemScreenSpotlight() {
    return _storage.read(_getUserKey('invoice_add_item_screen_spotlight_shown')) ?? false;
  }

  // Mark Invoice Add Item Screen spotlight as shown
  void setInvoiceAddItemScreenSpotlightShown() {
    _storage.write(_getUserKey('invoice_add_item_screen_spotlight_shown'), true);
    debugPrint("Invoice Add Item Screen: Spotlight marked as shown");
  }

  // Home Screen Main Spotlight (plus button)
  bool hasShownMainSpotlight() {
    return _storage.read(_getUserKey('main_spotlight_shown')) ?? false;
  }

  void setMainSpotlightShown() {
    _storage.write(_getUserKey('main_spotlight_shown'), true);
    debugPrint("Main Spotlight: Marked as shown");
  }

  // Home Screen Popup Spotlight (popup menu)
  bool hasShownPopupSpotlight() {
    return _storage.read(_getUserKey('popup_spotlight_shown')) ?? false;
  }

  void setPopupSpotlightShown() {
    _storage.write(_getUserKey('popup_spotlight_shown'), true);
    debugPrint("Popup Spotlight: Marked as shown");
  }

  // Reset spotlight (for testing purposes)
  void resetAiGeneratedSpotlight() {
    _storage.remove(_getUserKey('ai_generated_spotlight_shown'));
  }

  // Reset all spotlights (for testing purposes)
  void resetAllSpotlights() {
    _storage.remove(_getUserKey('ai_generated_spotlight_shown'));
    _storage.remove(_getUserKey('quote_ai_generated_spotlight_shown_globally'));
    _storage.remove(_getUserKey('invoice_ai_generated_spotlight_shown_globally'));
    _storage.remove(_getUserKey('manually_quote_spotlight_shown'));
    _storage.remove(_getUserKey('invoice_manually_spotlight_shown'));
    _storage.remove(_getUserKey('add_item_screen_spotlight_shown'));
    _storage.remove(_getUserKey('invoice_add_item_screen_spotlight_shown'));
    _storage.remove(_getUserKey('main_spotlight_shown'));
    _storage.remove(_getUserKey('popup_spotlight_shown'));
    debugPrint("All spotlights reset for current user!");
  }

  // Debug method to check service status
  void debugAllSpotlights() {
    debugPrint("=== All Spotlights Debug ===");
    debugPrint("Navigation Source: $_lastNavigationSource");
    debugPrint("AI Generated Spotlight: ${hasShownAiGeneratedSpotlight()}");
    debugPrint("Quote AI Generated Spotlight: ${hasShownQuoteAiGeneratedSpotlight()}");
    debugPrint("Invoice AI Generated Spotlight: ${hasShownInvoiceAiGeneratedSpotlight()}");
    debugPrint("============================");
  }
}