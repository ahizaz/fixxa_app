class NotificationItem {
  final String title;
  final String subtitle;
  final String type; // 'overdue', 'quote', 'paid'
  final String? amount;
  final String? action; // optional actions like 'Remind', 'Mark won'

  NotificationItem({
    required this.title,
    required this.subtitle,
    required this.type,
    this.amount,
    this.action,
  });
}
