
class InvoiceModel {
  final int invoiceId;
  final String invoiceNumber;
  final String? issueDate;
  final String? dueDate;
  final String? clientLogo;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final double? subtotal;
  final double? vatAmount;
  final double? total;

  InvoiceModel({
    required this.invoiceId,
    required this.invoiceNumber,
    this.issueDate,
    this.dueDate,
    this.clientLogo,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.subtotal,
    this.vatAmount,
    this.total,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    final billTo = json['bill_to'] as Map<String, dynamic>?;

    return InvoiceModel(
      invoiceId: (json['invoice_id'] ?? json['id']) is int
          ? (json['invoice_id'] ?? json['id'])
          : int.tryParse((json['invoice_id'] ?? json['id']).toString()) ?? 0,
      invoiceNumber: (json['invoice_number'] ?? '').toString(),
      issueDate: json['issue_date']?.toString(),
      dueDate: json['due_date']?.toString(),
      clientLogo: json['client_logo']?.toString(),
      customerName: billTo != null ? billTo['name']?.toString() : null,
      customerEmail: billTo != null ? billTo['email']?.toString() : null,
      customerPhone: billTo != null ? billTo['phone']?.toString() : null,
      subtotal: toDouble(json['subtotal']),
      vatAmount: toDouble(json['vat_amount']),
      total: toDouble(json['total'] ?? json['grand_total']),
    );
  }

  static List<InvoiceModel> listFromResponse(Map<String, dynamic> body) {
    try {
      final data = body['data'];
      final results = (data != null && data['results'] != null)
          ? data['results'] as List
          : (body['results'] is List ? body['results'] as List : []);

      return results
          .map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Map<String, dynamic> toJson() => {
        'invoice_id': invoiceId,
        'invoice_number': invoiceNumber,
        'issue_date': issueDate,
        'due_date': dueDate,
        'client_logo': clientLogo,
        'bill_to': {
          'name': customerName,
          'email': customerEmail,
          'phone': customerPhone,
        },
        'subtotal': subtotal,
        'vat_amount': vatAmount,
        'total': total,
      };
}

  // Backwards-compatible lightweight InvoiceData used by existing UI code
  class InvoiceData {
    final String id;
    String customerName;
    String email;
    String? phone;
    double paidAmount;
    double pendingAmount;
    int invoiceNumber;
    String? avatarUrl;

    InvoiceData({
      required this.id,
      required this.customerName,
      required this.email,
      this.phone,
      required this.paidAmount,
      required this.pendingAmount,
      required this.invoiceNumber,
      this.avatarUrl,
    });

    factory InvoiceData.fromJson(Map<String, dynamic> json) {
      final model = InvoiceModel.fromJson(json);
      return InvoiceData(
        id: model.invoiceId.toString(),
        customerName: model.customerName ?? '',
        email: model.customerEmail ?? '',
        phone: model.customerPhone,
        paidAmount: model.total ?? 0.0,
        pendingAmount: model.total ?? 0.0,
        invoiceNumber: int.tryParse(model.invoiceNumber.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
        avatarUrl: model.clientLogo,
      );
    }

    static List<InvoiceData> listFromResponse(Map<String, dynamic> body) {
      try {
        final data = body['data'];
        final results = (data != null && data['results'] != null)
            ? data['results'] as List
            : (body['results'] is List ? body['results'] as List : []);

        return results
            .map((e) => InvoiceData.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        return [];
      }
    }
  }
