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
  final RxString quoteNumber = ''.obs;
  final RxString issuedDate = ''.obs;
  final RxString validUntil = ''.obs;
  final RxList<QuoteItem> items = <QuoteItem>[].obs;
  final RxDouble vatPercent = 0.0.obs;

  QuoteController([Map<String, dynamic>? data]) {
    loadData(data);
  }

  void loadData(Map<String, dynamic>? data) {
    if (data == null) {
      // sample fallback data
      companyName.value = 'Company Name';
      companyAddress.assignAll(['Address Line 1', 'Address Line 2', 'Address Line 3']);
      clientName.value = 'Client Name';
      clientAddress.assignAll(['Address Line 1', 'Address Line 2', 'Address Line 3']);
      email.value = 'email@example.com';
      phone.value = '+44 1234 567890';
      quoteNumber.value = '#12345';
      issuedDate.value = 'April 2026';
      validUntil.value = 'May 2026';
      items.assignAll([
        QuoteItem(description: 'Item 1', quantity: 1, unitPrice: 40.0),
        QuoteItem(description: 'Item 2', quantity: 1, unitPrice: 40.0),
        QuoteItem(description: 'Item 3', quantity: 1, unitPrice: 40.0),
        QuoteItem(description: 'Item 4', quantity: 1, unitPrice: 40.0),
      ]);
      vatPercent.value = 0.0;
      return;
    }

    companyName.value = data['companyName'] ?? '';
    clientName.value = data['clientName'] ?? '';
    companyAddress.assignAll(List<String>.from(data['companyAddress'] ?? <String>[]));
    clientAddress.assignAll(List<String>.from(data['clientAddress'] ?? <String>[]));
    email.value = data['email'] ?? '';
    phone.value = data['phone'] ?? '';
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
