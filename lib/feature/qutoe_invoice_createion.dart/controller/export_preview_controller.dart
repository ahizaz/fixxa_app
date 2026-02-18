import 'package:get/get.dart';
import 'quote_controller.dart';

class ExportPreviewController extends GetxController {
  final QuoteController quoteController;

  ExportPreviewController([Map<String, dynamic>? data]) : quoteController = QuoteController(data);
  // controller currently just wraps QuoteController; add lifecycle logic if needed
}
