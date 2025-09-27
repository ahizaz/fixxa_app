import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  static StorageService get instance => Get.find<StorageService>();
  
  late GetStorage _storage;

  @override
  Future<void> onInit() async {
    super.onInit();
    await GetStorage.init();
    _storage = GetStorage();
  }

  // Spotlight related methods
  bool hasShownQuoteSpotlight() {
    return _storage.read('quote_spotlight_shown') ?? false;
  }

  void setQuoteSpotlightShown() {
    _storage.write('quote_spotlight_shown', true);
  }

  bool hasShownInvoiceSpotlight() {
    return _storage.read('invoice_spotlight_shown') ?? false;
  }

  void setInvoiceSpotlightShown() {
    _storage.write('invoice_spotlight_shown', true);
  }

  // Generic storage methods
  void write(String key, dynamic value) {
    _storage.write(key, value);
  }

  T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  void remove(String key) {
    _storage.remove(key);
  }

  void clearAll() {
    _storage.erase();
  }
}