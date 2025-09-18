import 'package:get/get.dart';

class InvoiceController extends GetxController {
  final invoices = <InvoiceData>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInvoices();
  }

  void loadInvoices() {
    // Dummy data for demonstration
    invoices.value = [
      InvoiceData(
        id: '1',
        customerName: 'Richardo Mathew',
        email: 'richardomathew@gmail.com',
        amount: 64506,
        status: 'paid',
        invoiceNumber: 3,
      ),
      InvoiceData(
        id: '2',
        customerName: 'Richardo Mathew',
        email: 'richardomathew@gmail.com',
        amount: 64506,
        status: 'pending',
        invoiceNumber: 3,
      ),
      InvoiceData(
        id: '3',
        customerName: 'Richardo Mathew',
        email: 'richardomathew@gmail.com',
        amount: 64506,
        status: 'paid',
        invoiceNumber: 3,
      ),
      InvoiceData(
        id: '4',
        customerName: 'Richardo Mathew',
        email: 'richardomathew@gmail.com',
        amount: 64506,
        status: 'pending',
        invoiceNumber: 3,
      ),
    ];
  }
}

class InvoiceData {
  final String id;
  final String customerName;
  final String email;
  final double amount;
  final String status;
  final int invoiceNumber;

  InvoiceData({
    required this.id,
    required this.customerName,
    required this.email,
    required this.amount,
    required this.status,
    required this.invoiceNumber,
  });
}