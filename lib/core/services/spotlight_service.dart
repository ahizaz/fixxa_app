import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SpotlightService extends GetxService {
  static SpotlightService get instance => Get.find<SpotlightService>();
  
  late GetStorage _storage;

  @override
  Future<void> onInit() async {
    super.onInit();
    await GetStorage.init();
    _storage = GetStorage();
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
    return _storage.read('quote_ai_generated_spotlight_shown') ?? false;
  }

  // Mark Quote AI generated spotlight as shown
  void setQuoteAiGeneratedSpotlightShown() {
    _storage.write('quote_ai_generated_spotlight_shown', true);
  }

  // Check if Invoice AI generated spotlight has been shown before
  bool hasShownInvoiceAiGeneratedSpotlight() {
    return _storage.read('invoice_ai_generated_spotlight_shown') ?? false;
  }

  // Mark Invoice AI generated spotlight as shown
  void setInvoiceAiGeneratedSpotlightShown() {
    _storage.write('invoice_ai_generated_spotlight_shown', true);
  }

  // Reset spotlight (for testing purposes)
  void resetAiGeneratedSpotlight() {
    _storage.remove('ai_generated_spotlight_shown');
  }

  // Reset all spotlights (for testing purposes)
  void resetAllSpotlights() {
    _storage.remove('ai_generated_spotlight_shown');
    _storage.remove('quote_ai_generated_spotlight_shown');
    _storage.remove('invoice_ai_generated_spotlight_shown');
    print("All AI spotlights reset!");
  }

  // Debug method to check service status
  void debugAllSpotlights() {
    print("=== All Spotlights Debug ===");
    print("AI Generated Spotlight: ${hasShownAiGeneratedSpotlight()}");
    print("Quote AI Generated Spotlight: ${hasShownQuoteAiGeneratedSpotlight()}");
    print("Invoice AI Generated Spotlight: ${hasShownInvoiceAiGeneratedSpotlight()}");
    print("============================");
  }
}