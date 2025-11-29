import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

/// Normalize image URLs for mobile emulators/devices.
///
/// - When running on Android emulators, replace `localhost`/`127.0.0.1`
///   with `10.0.2.2` so the emulator can reach the host machine.
/// - On web/iOS leave the URL unchanged.
String normalizeImageUrl(String? url) {
  if (url == null) return '';
  if (!url.startsWith('http')) return url;
  if (kIsWeb) return url;

  final platform = defaultTargetPlatform;
  if (platform == TargetPlatform.android) {
    return url
        .replaceFirst(RegExp(r'^http://localhost'), 'http://10.0.2.2')
        .replaceFirst(RegExp(r'^http://127\\.0\\.0\\.1'), 'http://10.0.2.2');
  }

  // Other platforms (iOS, macOS, windows, linux) can reach localhost directly
  return url;
}
