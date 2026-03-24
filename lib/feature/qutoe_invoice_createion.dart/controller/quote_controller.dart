import 'package:get/get.dart';

class QuoteItem {
  String description;
  int quantity;
  double unitPrice;

  QuoteItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;
  Map<String, dynamic> toMap() => {
        'description': description,
        'quantity': quantity,
        'unitPrice': unitPrice,
      };
}

class QuoteController extends GetxController {
  final RxString companyName = ''.obs;
  final RxString clientName = ''.obs;
  final RxList<String> companyAddress = <String>[].obs;
  final RxList<String> clientAddress = <String>[].obs;
  final RxString email = ''.obs;
  final RxString phone = ''.obs;
  final RxString clientEmail = ''.obs;
  final RxString clientPhone = ''.obs;
  final RxString companyEmail = ''.obs;
  final RxString companyPhone = ''.obs;
  final RxString bankName = ''.obs;
  final RxString accountName = ''.obs;
  final RxString sortCode = ''.obs;
  final RxString accountNo = ''.obs;
  final RxString quoteNumber = ''.obs;
  final RxString issuedDate = ''.obs;
  final RxString validUntil = ''.obs;
  final RxString clientLogo = ''.obs;
  final RxString companyLogo = ''.obs;
  final RxList<QuoteItem> items = <QuoteItem>[].obs;
  final RxDouble vatPercent = 0.0.obs;
  final RxString acceptLink = ''.obs;

  QuoteController([Map<String, dynamic>? data]) {
    loadData(data);
  }

  void loadData(Map<String, dynamic>? data) {
    if (data == null) {
      // No data provided; keep fields empty (avoid static/sample placeholders)
      companyName.value = '';
      companyAddress.assignAll(<String>[]);
      clientName.value = '';
      clientAddress.assignAll(<String>[]);
      email.value = '';
      phone.value = '';
       bankName.value = '';
       accountName.value = '';
       sortCode.value = '';
       accountNo.value = '';
      quoteNumber.value = '';
      issuedDate.value = '';
      validUntil.value = '';
      items.assignAll(<QuoteItem>[]);
      vatPercent.value = 0.0;
      return;
    }

    companyName.value = data['companyName'] ?? '';
    clientName.value = data['clientName'] ?? '';
    clientLogo.value = data['clientLogo'] ?? '';
    companyLogo.value = data['companyLogo'] ?? '';
    companyAddress.assignAll(List<String>.from(data['companyAddress'] ?? <String>[]));
    clientAddress.assignAll(List<String>.from(data['clientAddress'] ?? <String>[]));
    email.value = data['email'] ?? '';
    phone.value = data['phone'] ?? '';
    // New separate fields for client/company contact
    clientEmail.value = data['clientEmail'] ?? data['client_email'] ?? data['email'] ?? '';
    clientPhone.value = data['clientPhone'] ?? data['client_phone'] ?? data['phone'] ?? '';
    companyEmail.value = data['companyEmail'] ?? data['company_email'] ?? data['companyEmail'] ?? '';
    companyPhone.value = data['companyPhone'] ?? data['company_phone'] ?? data['companyPhone'] ?? '';
    acceptLink.value = data['acceptLink'] ?? data['accept_link'] ?? '';
    bankName.value = data['bankName'] ?? '';
    accountName.value = data['accountName'] ?? '';
    sortCode.value = data['sortCode'] ?? '';
    accountNo.value = data['accountNo'] ?? '';
    quoteNumber.value = data['quoteNumber'] ?? '';
    issuedDate.value = data['issuedDate'] ?? '';
    validUntil.value = data['validUntil'] ?? '';
    vatPercent.value = (data['vatPercent'] is num) ? (data['vatPercent'] as num).toDouble() : 0.0;

    final rawItems = data['items'];
    if (rawItems is List) {
      items.assignAll(rawItems.map((it) {
        return QuoteItem(
          description: it['description'] ?? '',
          quantity: (it['quantity'] is int) ? it['quantity'] as int : int.tryParse('${it['quantity']}') ?? 1,
          unitPrice: (it['unitPrice'] is num) ? (it['unitPrice'] as num).toDouble() : double.tryParse('${it['unitPrice']}') ?? 0.0,
        );
      }).toList());
    }
  }

  double get subtotal => items.fold(0.0, (p, e) => p + e.total);
  double get vatAmount => subtotal * (vatPercent.value / 100.0);
  double get totalDue => subtotal + vatAmount;
}
