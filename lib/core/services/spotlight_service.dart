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

  // Reset spotlight (for testing purposes)
  void resetAiGeneratedSpotlight() {
    _storage.remove('ai_generated_spotlight_shown');
  }
}