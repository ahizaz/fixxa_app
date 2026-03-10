import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationServices {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Returns the FCM device token. Returns empty string on failure.
  Future<String> getDeviceToken() async {
    try {
      final token = await _messaging.getToken();
      return token ?? '';
    } catch (e) {
      debugPrint('⚠️ NotificationServices.getDeviceToken failed: $e');
      return '';
    }
  }

  /// Requests notification permission from the OS.
  Future<void> requestNotificationPermission() async {
    try {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      debugPrint('⚠️ NotificationServices.requestNotificationPermission failed: $e');
    }
  }
}
