import 'package:flutter/foundation.dart' show kIsWeb;

/// Normalize image URLs for mobile emulators/devices.
///
/// - Replace localhost/127.0.0.1/10.0.2.2 with the dev tunnel URL
/// - This ensures images load from the same server as the API
String normalizeImageUrl(String? url) {
  if (url == null) return '';
  if (!url.startsWith('http')) return url;
  if (kIsWeb) return url;

  // Replace any localhost, 127.0.0.1, or 10.0.2.2 with the dev tunnel domain
  const devTunnelDomain = 'https://6zpmb4x8-8000.inc1.devtunnels.ms';
  
  // Match the protocol, domain, and port (if any)
  final normalized = url
      .replaceFirst(RegExp(r'^https?://localhost(:\d+)?'), devTunnelDomain)
      .replaceFirst(RegExp(r'^https?://127\.0\.0\.1(:\d+)?'), devTunnelDomain)
      .replaceFirst(RegExp(r'^https?://10\.0\.2\.2(:\d+)?'), devTunnelDomain)
      .replaceFirst(RegExp(r'^https?://10\.10\.12\.14(:\d+)?'), devTunnelDomain);

  return normalized;
}
