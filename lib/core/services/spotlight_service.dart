import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SpotlightService extends GetxService {
  static SpotlightService get instance => Get.find<SpotlightService>();
  
  late GetStorage _storage;
  
  // Track navigation source to manage spotlight behavior
  String? _lastNavigationSource;

  @override
  Future<void> onInit() async {
    super.onInit();
    await GetStorage.init();
    _storage = GetStorage();
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
    return _storage.read('ai_generated_spotlight_shown') ?? false;
  }

  // Mark AI generated spotlight as shown
  void setAiGeneratedSpotlightShown() {
    _storage.write('ai_generated_spotlight_shown', true);
  }

  // Check if Quote AI generated spotlight has been shown before
  bool hasShownQuoteAiGeneratedSpotlight() {
    // Check if spotlight has been shown globally (from any source)
    bool hasShownGlobally = _storage.read('quote_ai_generated_spotlight_shown_globally') ?? false;
    
    return hasShownGlobally; // Return true if shown before, false if should show
  }

  // Mark Quote AI generated spotlight as shown globally
  void setQuoteAiGeneratedSpotlightShown() {
    // Mark as shown globally so it never shows again from any source
    _storage.write('quote_ai_generated_spotlight_shown_globally', true);
    debugPrint("Quote AI Generated: Spotlight marked as shown globally");
  }

  // Check if Invoice AI generated spotlight has been shown before
  bool hasShownInvoiceAiGeneratedSpotlight() {
    // Check if spotlight has been shown globally (from any source)
    bool hasShownGlobally = _storage.read('invoice_ai_generated_spotlight_shown_globally') ?? false;
    
    return hasShownGlobally; // Return true if shown before, false if should show
  }

  // Mark Invoice AI generated spotlight as shown globally
  void setInvoiceAiGeneratedSpotlightShown() {
    // Mark as shown globally so it never shows again from any source
    _storage.write('invoice_ai_generated_spotlight_shown_globally', true);
    debugPrint("Invoice AI Generated: Spotlight marked as shown globally");
  }

  // Reset spotlight (for testing purposes)
  void resetAiGeneratedSpotlight() {
    _storage.remove('ai_generated_spotlight_shown');
  }

  // Reset all spotlights (for testing purposes)
  void resetAllSpotlights() {
    _storage.remove('ai_generated_spotlight_shown');
    _storage.remove('quote_ai_generated_spotlight_shown_globally');
    _storage.remove('invoice_ai_generated_spotlight_shown_globally');
    debugPrint("All AI spotlights reset!");
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