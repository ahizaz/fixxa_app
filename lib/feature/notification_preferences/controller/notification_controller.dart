import 'package:get/get.dart';

class NotificationController extends GetxController {
  var emailUpdates = true.obs;
  var smsUpdates = true.obs;
  var pushUpdates = true.obs;

  var emailReminders = true.obs;
  var smsReminders = true.obs;
  var pushReminders = true.obs;

  void toggleEmailUpdates(bool value) => emailUpdates.value = value;
  void toggleSmsUpdates(bool value) => smsUpdates.value = value;
  void togglePushUpdates(bool value) => pushUpdates.value = value;

  void toggleEmailReminders(bool value) => emailReminders.value = value;
  void toggleSmsReminders(bool value) => smsReminders.value = value;
  void togglePushReminders(bool value) => pushReminders.value = value;

  void saveSettings() {
    // Add storage saving logic here
  }
}
