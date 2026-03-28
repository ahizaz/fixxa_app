import 'package:flutter/foundation.dart';

class ExportMode {
  /// When true the UI should render in 'export' style (for PDF/png captures).
  static final ValueNotifier<bool> isExporting = ValueNotifier<bool>(false);
}
