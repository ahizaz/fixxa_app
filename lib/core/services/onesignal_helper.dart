import 'dart:convert';

import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/core/utils/constants/app_constants.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalHelper {
  static Future<void> initialize() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.initialize(AppConstants.onesignalAppId);
    OneSignal.LiveActivities.setupDefault();
    _addObservers();
  }

  static Future<String?> getPlayerId() async {
    try {
      final playerId = await OneSignal.User.getOnesignalId();
      debugPrint('OneSignal Player ID ========>: $playerId');
      return playerId;
    } catch (e) {
      debugPrint('Error fetching OneSignal Player ID: $e');
      return null;
    }
  }
///subsciber Id
  static Future<String?> getSubscriptionId() async {
    try {
      final subscriptionId = OneSignal.User.pushSubscription.id;
      debugPrint('OneSignal Subscription ID: $subscriptionId');
      return subscriptionId;
    } catch (e) {
      debugPrint('Error fetching OneSignal Subscription ID: $e');
      return null;
    }
  }

  /// Registers the OneSignal subscription ID with the backend device-token endpoint.
  static Future<void> registerDeviceToken() async {
    EasyLoading.show(status: 'Registering device...');
    try {
      final subscriptionId = await getSubscriptionId();

      if (subscriptionId == null || subscriptionId.isEmpty) {
        EasyLoading.dismiss();
        debugPrint('❌ OneSignal subscription ID not available');
        return;
      }

      debugPrint('📡 Registering device token: $subscriptionId');

      final accessToken = await LoginController.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        EasyLoading.dismiss();
        debugPrint('❌ Access token not available — cannot register device');
        return;
      }

      final response = await http.post(
        Uri.parse(Urls.device),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'subscription_id': subscriptionId}),
      );

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Device token registered successfully');
      } else {
        debugPrint(
          '❌ Device token registration failed: ${response.statusCode} — ${response.body}',
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('❌ Error registering device token: $e');
    }
  }

  static void _addObservers() {
    OneSignal.User.pushSubscription.addObserver((state) {
      debugPrint('${OneSignal.User.pushSubscription.optedIn}');
      debugPrint(OneSignal.User.pushSubscription.id);
      debugPrint(OneSignal.User.pushSubscription.token);
      debugPrint(state.current.jsonRepresentation());
    });

    OneSignal.User.addObserver((state) {
      debugPrint('OneSignal user changed: ${state.jsonRepresentation()}');
    });

    OneSignal.Notifications.addPermissionObserver((state) {
      debugPrint('Has permission $state');
    });

    OneSignal.Notifications.addClickListener((event) async {
      debugPrint('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) async {
      debugPrint(
        'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}',
      );
      event.preventDefault();
      event.notification.display();
    });

    OneSignal.InAppMessages.addClickListener((event) {
      debugPrint('In-App Message Clicked: ${event.result.jsonRepresentation()}');
    });
    OneSignal.InAppMessages.addWillDisplayListener((event) {
      debugPrint('Will Display In-App Message: ${event.message.messageId}');
    });
    OneSignal.InAppMessages.addDidDisplayListener((event) {
      debugPrint('Did Display In-App Message: ${event.message.messageId}');
    });
    OneSignal.InAppMessages.addWillDismissListener((event) {
      debugPrint('Will Dismiss In-App Message: ${event.message.messageId}');
    });
    OneSignal.InAppMessages.addDidDismissListener((event) {
      debugPrint('Did Dismiss In-App Message: ${event.message.messageId}');
    });
  }

  static void sendTags(Map<String, String> tags) {
    debugPrint('Sending tags');
    OneSignal.User.addTags(tags);
  }

  static Future<void> getTags() async {
    debugPrint('Getting tags');
    final tags = await OneSignal.User.getTags();
    debugPrint('$tags');
  }

  static void setEmail(String email) {
    debugPrint('Setting email');
    OneSignal.User.addEmail(email);
  }

  static void removeEmail(String email) {
    debugPrint('Removing email');
    OneSignal.User.removeEmail(email);
  }

  static void setSMSNumber(String smsNumber) {
    debugPrint('Setting SMS Number');
    OneSignal.User.addSms(smsNumber);
  }

  static void removeSMSNumber(String smsNumber) {
    debugPrint('Removing SMS Number');
    OneSignal.User.removeSms(smsNumber);
  }

  static void setLocationShared(bool shared) {
    debugPrint('Setting location shared to $shared');
    OneSignal.Location.setShared(shared);
  }

  static void setExternalUserId(String externalUserId) {
    debugPrint('Setting external user ID');
    OneSignal.login(externalUserId);
  }

  static void logout() {
    debugPrint('Logging out');
    OneSignal.logout();
  }

  static void requestPushPermission() {
    debugPrint('Requesting Push Permission');
    OneSignal.Notifications.requestPermission(true);
  }

  static void provideConsent(bool consent) {
    debugPrint('Setting consent to $consent');
    OneSignal.consentGiven(consent);
  }

  static void optIn() {
    debugPrint('Opting in for Push Notifications');
    OneSignal.User.pushSubscription.optIn();
  }

  static void optOut() {
    debugPrint('Opting out of Push Notifications');
    OneSignal.User.pushSubscription.optOut();
  }

  static void startLiveActivity(
    String liveActivityId,
    Map<String, dynamic> data,
  ) {
    debugPrint('Starting live activity with ID: $liveActivityId');
    OneSignal.LiveActivities.startDefault(
      liveActivityId,
      {'title': 'Welcome!', 'message': {'en': 'Hello World!'}},
      data,
    );
  }

  static void enterLiveActivity(String liveActivityId, String token) {
    debugPrint('Entering live activity with ID: $liveActivityId');
    OneSignal.LiveActivities.enterLiveActivity(liveActivityId, token);
  }

  static void exitLiveActivity(String liveActivityId) {
    debugPrint('Exiting live activity with ID: $liveActivityId');
    OneSignal.LiveActivities.exitLiveActivity(liveActivityId);
  }
}
