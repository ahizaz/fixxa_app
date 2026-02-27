import 'dart:ui';

import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/screen/invoice_dialog.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/invoice_ai_generated_controller.dart';
import 'package:fixxa_app/feature/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/export_preview.dart';

// Reuse the same helper as Quote version for safe numeric parsing
num _num(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v;
  if (v is String) return num.tryParse(v) ?? 0;
  return 0;
}

class InvoiceAiGenerated extends StatelessWidget {
  const InvoiceAiGenerated({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InvoiceAiGeneratedController());
    if (!Get.isRegistered<ProfileController>()) Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              ImagePath.backgroud,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: close + title + menu
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black87),
                        onPressed: () => Get.back(),
                      ),
                      Expanded(
                        child: Obx(() {
                          final data = controller.quoteData ?? {};
                          final headerTitle = (data['invoice_number'] ?? data['quoteNumber'] ?? data['quoteId'] ?? 'Invoice').toString();
                          return Text(headerTitle, style: GoogleFonts.urbanist(fontSize: 22.sp, fontWeight: FontWeight.w700, color: Colors.black87), textAlign: TextAlign.center);
                        }),
                      ),
                      PopupMenuButton<String>(
                        icon: Image.asset(IconPath.aithreebutton, width: 28.w, height: 28.h),
                        onSelected: (value) {
                          if (value == 'edit') {
                            InvoiceDialog.show(context);
                          } else if (value == 'export') {
                            bool canExport = false;
                            try {
                              // try to determine if export possible from controller data
                              final qd = controller.quoteData;
                              if (qd['quoteId'] != null && qd['quoteId'].toString().isNotEmpty) canExport = true;
                            } catch (_) {}

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                                      ListTile(
                                        leading: Opacity(opacity: canExport ? 1.0 : 0.45, child: Image.asset(IconPath.pdf, width: 24, height: 24)),
                                        title: Text('Export as PDF', style: TextStyle(color: canExport ? null : Colors.grey)),
                                        enabled: canExport,
                                        onTap: canExport
                                            ? () {
                                                Navigator.pop(context);
                                                Navigator.push(context, MaterialPageRoute(builder: (_) => const ExportPreviewPage(data: null, source: 'invoice', fetchOnOpen: true)));
                                              }
                                            : null,
                                      ),
                                      const Divider(),
                                      ListTile(leading: Image.asset(IconPath.csv, width: 24, height: 24), title: const Text('Export as CSV'), onTap: () => Navigator.pop(context)),
                                      const Divider(),
                                      ListTile(leading: Image.asset(IconPath.excel, width: 24, height: 24), title: const Text('Export as Excel'), onTap: () => Navigator.pop(context)),
                                      const SizedBox(height: 20),
                                    ]),
                                  ),
                                );
                              },
                            );
                          } else if (value == 'delete') {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Dialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                                        const Text('Do you want to Delete?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                        const SizedBox(height: 8),
                                        const Text('Once you delete the invoice it will be removed permanently', style: TextStyle(fontSize: 14, color: Colors.grey), textAlign: TextAlign.center),
                                        const SizedBox(height: 24),
                                        Row(children: [
                                          Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('No, keep it')))),
                                          const SizedBox(width: 12),
                                          Expanded(child: ElevatedButton(onPressed: () { Navigator.pop(context); controller.deleteQuote(); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Yes, delete')))),
                                        ])
                                      ]),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit, color: Colors.blue), title: Text('Edit'))),
                          const PopupMenuItem(value: 'export', child: ListTile(leading: Icon(Icons.download, color: Colors.blue), title: Text('Export as'))),
                          const PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('Delete'))),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Header block with logo + meta
                  Builder(builder: (context) {
                    final width = MediaQuery.of(context).size.width;
                    final isNarrow = width < 380;

                    Widget logoWidget = Container(
                      width: 110.w,
                      height: 70.h,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0,2))]),
                      child: Center(child: Text('Company Logo', style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp))),
                    );

                    Widget metaCard = Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Obx(() {
                          final data = controller.quoteData ?? {};
                          // Prefer API-supplied fields when present
                          final invoiceNo = data['invoice_number'] ?? data['quoteNumber'] ?? data['quoteId'] ?? '';
                          final issued = data['issue_date'] ?? data['issued'] ?? data['date'] ?? '';
                          final due = data['due_date'] ?? data['due'] ?? '';

                          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            _metaRow(Icons.receipt, 'Invoice No', invoiceNo),
                            const SizedBox(height: 8),
                            _metaRow(Icons.calendar_today, 'Issued', issued),
                            const SizedBox(height: 8),
                            _metaRow(Icons.event_available, 'Due', due),
                          ]);
                        }),
                      ),
                    );

                    if (isNarrow) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [logoWidget, const SizedBox(height: 12), metaCard]);
                    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [logoWidget, const SizedBox(width: 16), Expanded(child: metaCard)]);
                  }),

                  const SizedBox(height: 32),

                  // Bill To & From
                  Row(children: [Expanded(child: _infoCard('Bill To', controller)), const SizedBox(width: 16), Expanded(child: _infoCard('From', controller, isFrom: true))]),

                  const SizedBox(height: 24),

                  // Items table
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0,4))]),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(children: [
                        Row(children: const [Expanded(flex:5, child: Text('Description', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600))), Expanded(flex:2, child: Text('Quantity', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))), Expanded(flex:3, child: Text('Unit Price', textAlign: TextAlign.right, style: TextStyle(color: Colors.grey))), Expanded(flex:3, child: Text('Total', textAlign: TextAlign.right, style: TextStyle(color: Colors.grey)))]),
                        const SizedBox(height: 12),
                        const Divider(height: 1.5),
                        const SizedBox(height: 12),
                        Obx(() {
                          final items = (controller.quoteData['items'] as List?) ?? [];
                          if (items.isEmpty) return const Padding(padding: EdgeInsets.symmetric(vertical:20), child: Center(child: Text('No items added yet', style: TextStyle(color: Colors.grey))));

                          return Column(
                            children: items.map((item) {
                              final desc = item['description']?.toString() ?? item['quote_description']?.toString() ?? '';
                              final qty = _num(item['quantity']).toDouble();
                              final price = _num(item['unit_price']).toDouble();
                              final total = (item['total'] ?? item['amount']) != null ? _num(item['total'] ?? item['amount']).toDouble() : qty * price;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: Row(
                                  children: [
                                    Expanded(flex: 5, child: Text(desc, style: const TextStyle(fontWeight: FontWeight.w500))),
                                    Expanded(flex: 2, child: Center(child: Text(qty.toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.w500)))),
                                    Expanded(flex: 3, child: Text('£ ${price.toStringAsFixed(2)}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w500))),
                                    Expanded(flex: 3, child: Text('£ ${total.toStringAsFixed(2)}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600))),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }),
                        const Divider(height: 1.5),
                        const SizedBox(height: 16),

                        Obx(() {
                          final data = controller.quoteData ?? {};

                          // Use API-provided totals if available, otherwise compute from items
                          double subtotal;
                          if (data['subtotal'] != null) {
                            subtotal = _num(data['subtotal']).toDouble();
                          } else {
                            subtotal = 0;
                            final items = (data['items'] as List?) ?? [];
                            for (var item in items) {
                              final qty = _num(item['quantity']).toDouble();
                              final price = _num(item['unit_price']).toDouble();
                              subtotal += qty * price;
                            }
                          }

                          final vatRate = _num(data['vat_rate'] ?? data['vat']).toDouble();
                          final vatAmount = data['vat_amount'] != null ? _num(data['vat_amount']).toDouble() : subtotal * (vatRate / 100);
                          final total = data['total'] != null ? _num(data['total']).toDouble() : subtotal + vatAmount;

                          return Column(children: [_totalRow('Subtotal', subtotal), const SizedBox(height: 8), _totalRow('VAT (${vatRate.toStringAsFixed(0)}%)', vatAmount), const Divider(height: 24), _totalRow('Total Due', total, bold: true)]);
                        }),
                      ]),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Send button area
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Obx(() => controller.showSpotlight.value
                            ? Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
                                    ]),
                                child: const Column(
                                  children: [
                                    Text('Looks good?\nSend this professional invoice to your client now.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, height: 1.4)),
                                    SizedBox(height: 8),
                                    Icon(Icons.keyboard_arrow_down, color: Colors.grey)
                                  ],
                                ),
                              )
                            : const SizedBox.shrink()),//

                            

                        // Payment Link button (added above Send invoice)
                        Obx(() => OutlinedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Payment Link'),
                                    content: const Text('Create or copy a payment link for this invoice.'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                                    ],
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                side: const BorderSide(color: Colors.black12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Payment Link', style: GoogleFonts.urbanist(fontSize: 17.sp, fontWeight: FontWeight.w600, color: Colors.black87)),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.link, color: Colors.black54),
                                  ],
                                ),
                              ),
                            )),

                        const SizedBox(height: 12),

                        Obx(() => SpotlightWidget(
                              showSpotlight: controller.showSpotlight.value,
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierColor: Colors.black.withOpacity(0.3),
                                    builder: (context) {
                                      return BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            width: 348.w,
                                            height: 144.h,
                                            margin: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                                            child: Dialog(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                              insetPadding: EdgeInsets.zero,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                    leading: Image.asset(IconPath.whatsapp, width: 24.w, height: 24.h),
                                                    title: const Text('Send by WhatsApp'),
                                                    onTap: () async {
                                                      Navigator.pop(context);
                                                      await controller.sendInvoiceWhatsApp();
                                                    },
                                                  ),
                                                  const Divider(height: 1),
                                                  ListTile(
                                                    leading: Image.asset(IconPath.email, width: 24.w, height: 24.h),
                                                    title: const Text('Send by Email'),
                                                    onTap: () async {
                                                      Navigator.pop(context);
                                                      await controller.sendInvoiceEmail();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff1C1C1C),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Send invoice', style: GoogleFonts.urbanist(fontSize: 17.sp, fontWeight: FontWeight.w600, color: const Color(0xffFFFFFF))),
                                      const SizedBox(width: 8),
                                      Image.asset(IconPath.send, width: 24.w, height: 24.h),
                                    ],
                                  ),
                                ),
                              ),
                            )),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaRow(IconData icon, String label, dynamic value) {
    return Row(children: [Icon(icon, size:16, color: Colors.grey.shade700), const SizedBox(width:8), Text(label, style: const TextStyle(color: Colors.grey)), const SizedBox(width:6), Expanded(child: Text(value?.toString() ?? '', overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w500))) ]);
  }

  Widget _infoCard(String title, InvoiceAiGeneratedController controller, {bool isFrom = false}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final data = controller.quoteData ?? {};

          // Support both old key names and the API response structure
          String name;
          String address;
          String email;
          String phone;

          if (isFrom) {
            // from details may be in 'from_details' or older keys
            final from = data['from_details'] as Map?;
            name = from != null ? (from['business_name'] ?? from['name'] ?? '') : (data['fromName'] ?? '');
            address = from != null ? (from['address'] ?? '') : (data['fromAddress'] ?? '');
            email = from != null ? (from['email'] ?? '') : (data['fromEmail'] ?? '');
            phone = from != null ? (from['contact'] ?? from['phone'] ?? '') : (data['fromPhone'] ?? '');
          } else {
            final billTo = data['bill_to'] as Map?;
            name = billTo != null ? (billTo['name'] ?? '') : (data['toName'] ?? data['client_details']?['name'] ?? '');
            address = billTo != null ? (billTo['address'] ?? '') : (data['toAddress'] ?? data['client_details']?['address'] ?? '');
            email = billTo != null ? (billTo['email'] ?? '') : (data['toEmail'] ?? '');
            phone = billTo != null ? (billTo['phone'] ?? '') : (data['toPhone'] ?? '');
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp)),
            const SizedBox(height: 8),
            Text(name, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            if (address.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(address, style: const TextStyle(height: 1.4))
            ],
            if (email.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(children: [const Icon(Icons.email_outlined, size: 16), const SizedBox(width: 6), Expanded(child: Text(email))])
            ],
            if (phone.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(children: [const Icon(Icons.phone, size: 16), const SizedBox(width: 6), Expanded(child: Text(phone))])
            ],
          ]);
        }),
      ),
    );
  }

  Widget _totalRow(String label, double amount, {bool bold = false}) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w500)), const SizedBox(width:80), Text('£ ${amount.toStringAsFixed(2)}', style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w600, fontSize: bold ? 17 : 15))]);
  }
}

class SpotlightWidget extends StatelessWidget {
  final bool showSpotlight;
  final Widget child;

  const SpotlightWidget({super.key, required this.showSpotlight, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!showSpotlight) return child;
    return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: const Color(0xFF4A90E2).withOpacity(0.5), blurRadius:20, spreadRadius:4, offset: const Offset(0,-6)), BoxShadow(color: const Color(0xFF87CEEB).withOpacity(0.6), blurRadius:16, spreadRadius:2, offset: const Offset(0,-4))]), child: child);
  }
}