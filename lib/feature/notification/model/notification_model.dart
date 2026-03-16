class NotificationModel {
  final int id;
  final String notificationType;
  final String title;
  final String body;
  final NotificationPayload? data;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.notificationType,
    required this.title,
    required this.body,
    this.data,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      notificationType: json['notification_type'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      data: json['data'] != null
          ? NotificationPayload.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class NotificationPayload {
  final String type;
  final String total;
  final String invoiceId;
  final String clientName;
  final String invoiceNumber;

  NotificationPayload({
    required this.type,
    required this.total,
    required this.invoiceId,
    required this.clientName,
    required this.invoiceNumber,
  });

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      type: json['type'] ?? '',
      total: json['total'] ?? '0.00',
      invoiceId: json['invoice_id'] ?? '',
      clientName: json['client_name'] ?? '',
      invoiceNumber: json['invoice_number'] ?? '',
    );
  }
}
