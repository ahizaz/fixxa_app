import 'package:get/get.dart';

class InvoiceController extends GetxController {
  final invoices = <InvoiceData>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInvoices();
  }

  void updateClientDetails(String id, String name, String email, String phone) {
    final index = invoices.indexWhere((invoice) => invoice.id == id);
    if (index != -1) {
      final invoice = invoices[index];
      invoice.customerName = name;
      invoice.email = email;
      invoice.phone = phone;
      invoices.refresh();
    }
  }

  void loadInvoices() {
    // Dummy data for demonstration
    invoices.value = [
      InvoiceData(
        id: '1',
        customerName: 'Richardo Mathew',
        email: 'richardomathew@gmail.com',
        phone: '+44 1234 568778',
        paidAmount: 4506,
        pendingAmount: 4506,
        invoiceNumber: 3,
        avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
      ),
      InvoiceData(
        id: '2',
        customerName: 'Richardo Mathew',
        email: 'richardomathew@gmail.com',
        paidAmount: 4506,
        pendingAmount: 4506,
        invoiceNumber: 3,
        avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
      ),
      InvoiceData(
        id: '3',
        customerName: 'Richardo Mathew',
        email: 'richardomathew@gmail.com',
        paidAmount: 4506,
        pendingAmount: 4506,
        invoiceNumber: 3,
        avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
      ),
      InvoiceData(
        id: '4',
        customerName: 'Richardo Mathew',
        email: 'richardomathew@gmail.com',
        paidAmount: 4506,
        pendingAmount: 4506,
        invoiceNumber: 3,
        avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
      ),
       InvoiceData(
        id: '5',
        customerName: 'Richardo Mathew',
        email: 'richardomathew@gmail.com',
        paidAmount: 4506,
        pendingAmount: 4506,
        invoiceNumber: 3,
        avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
      ),
    ];
  }
}

class InvoiceData {
  final String id;
  String customerName;
  String email;
  String? phone;
  final double paidAmount;
  final double pendingAmount;
  final int invoiceNumber;
  final String? avatarUrl;

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
}