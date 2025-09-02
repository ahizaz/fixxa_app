import 'package:fixxa_app/feature/notification/widget/notification_item.dart';
import 'package:get/get.dart';

class NotficationcontrollerData extends GetxController{
  var notifications = <NotificationItem>[].obs;
   void loadNotifications() {
    var demoData = [
      NotificationItem(
        title: 'Invoice Overdue - John Smith',
        subtitle: '£350 • Due yesterday',
        type: 'overdue',
        action: 'Remind',
      ),
      NotificationItem(
        title: 'Quote Reminder',
        subtitle: 'Kitchen remodel • Sent 7 days ago',
        type: 'quote',
      ),
      NotificationItem(
        title: 'Invoice Paid - Richardo Mathew',
        subtitle: '£1,200 • Paid via Stripe',
        type: 'paid',
        amount: '£1,200',
      ),
      NotificationItem(
        title: 'Invoice Paid - James Anderson',
        subtitle: '£900 • Paid via Stripe',
        type: 'paid',
        amount: '£900',
      ),
        NotificationItem(
        title: 'Invoice Paid - James Anderson',
        subtitle: '£900 • Paid via Stripe',
        type: 'paid',
        amount: '£900',
      ),
        NotificationItem(
        title: 'Invoice Paid - James Anderson',
        subtitle: '£900 • Paid via Stripe',
        type: 'paid',
        amount: '£900',
      ),
      // aro add korte paren...
    ];

    notifications.assignAll(demoData);
  }
    Future<void> fetchNotificationsFromAPI() async {
    // Example: await API call
    // var response = await api.getNotifications();
    // notifications.assignAll(response);
  }
}