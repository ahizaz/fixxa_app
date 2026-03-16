import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/controller/invoice_manually_controller.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/invoice_ai_generated_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/export_preview_controller.dart';
import 'package:fixxa_app/feature/quote/controller/quote_controller.dart';

class ExportInvoicePage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const ExportInvoicePage({
    super.key,
    this.data,
  });

  @override
  State<ExportInvoicePage> createState() => _ExportInvoicePageState();
}

class _ExportInvoicePageState extends State<ExportInvoicePage> {
  late final String _tag;
  late final ExportPreviewController controller;
  final GlobalKey _previewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tag = UniqueKey().toString();
    controller = Get.put(ExportPreviewController(widget.data, 'invoice', true), tag: _tag);
    // Trigger fetch for invoice preview when opened
    controller.fetchFromApi();
  }

  @override
  void dispose() {
    try {
      Get.delete<ExportPreviewController>(tag: _tag, force: true);
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;

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
              child: RepaintBoundary(
                key: _previewKey,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: logo left, meta card right (responsive)
                  Builder(builder: (context) {
                    final width = MediaQuery.of(context).size.width;
                    final isNarrow = width < 360;

                    Widget logoWidget = Obx(() {
                      final q = controller.quoteController;
                      final logo = q.clientLogo.value;
                      if (logo.isEmpty) {
                        return SizedBox(
                          width: 100,
                          height: 60,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Client Logo',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[700]),
                            ),
                          ),
                        );
                      }

                      return SizedBox(
                        width: 100,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            logo,
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => Container(
                              color: Colors.grey[200],
                              child: Center(child: Text('Logo', style: TextStyle(color: Colors.grey))),
                            ),
                          ),
                        ),
                      );
                    });

                    Widget metaCard = Obx(() {
                      final q = controller.quoteController;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [const Icon(Icons.receipt, size: 16), const SizedBox(width: 8), const Text('Invoice No') , const SizedBox(width: 8), Flexible(child: Text(q.quoteNumber.value, overflow: TextOverflow.ellipsis))]),
                          const SizedBox(height: 6),
                          Row(children: [const Icon(Icons.calendar_today, size: 16), const SizedBox(width: 8), const Text('Issued'), const SizedBox(width: 8), Flexible(child: Text(q.issuedDate.value, overflow: TextOverflow.ellipsis))]),
                          const SizedBox(height: 6),
                          Row(children: [const Icon(Icons.calendar_today_outlined, size: 16), const SizedBox(width: 8), const Text('Valid Until'), const SizedBox(width: 8), Flexible(child: Text(q.validUntil.value, overflow: TextOverflow.ellipsis))]),
                        ],
                      );
                    });

                    if (isNarrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          logoWidget,
                          const SizedBox(height: 8),
                          metaCard,
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Align(alignment: Alignment.centerLeft, child: logoWidget)),
                        Expanded(child: Align(alignment: Alignment.centerRight, child: metaCard)),
                      ],
                    );
                  }),

                  const SizedBox(height: 18),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Invoice',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Bill To & From
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Obx(() {
                              final q = controller.quoteController;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Bill To', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  const SizedBox(height: 8),
                                  Text(q.clientName.value, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  ...q.clientAddress.map((e) => Text(e)),
                                  const SizedBox(height: 10),
                                  Row(children: [const Icon(Icons.email_outlined, size: 16), const SizedBox(width: 6), Expanded(child: Text(q.email.value, overflow: TextOverflow.ellipsis))]),
                                  const SizedBox(height: 6),
                                  Row(children: [const Icon(Icons.phone, size: 16), const SizedBox(width: 6), Expanded(child: Text(q.phone.value, overflow: TextOverflow.ellipsis))]),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Obx(() {
                              final q = controller.quoteController;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('From', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  const SizedBox(height: 8),
                                  Text(q.companyName.value, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  ...q.companyAddress.map((e) => Text(e)),
                                  const SizedBox(height: 10),
                                  Row(children: [const Icon(Icons.email_outlined, size: 16), const SizedBox(width: 6), Expanded(child: Text(q.email.value, overflow: TextOverflow.ellipsis))]),
                                  const SizedBox(height: 6),
                                  Row(children: [const Icon(Icons.phone, size: 16), const SizedBox(width: 6), Expanded(child: Text(q.phone.value, overflow: TextOverflow.ellipsis))]),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Items table
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Expanded(flex: 4, child: Text('Description', style: TextStyle(color: Colors.grey)) ),
                              Expanded(flex: 2, child: Text('Quantity', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))),
                              Expanded(flex: 2, child: Text('Unit Price', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))),
                              Expanded(flex: 2, child: Text('Total', textAlign: TextAlign.right, style: TextStyle(color: Colors.grey))),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),
                          Obx(() {
                            final items = controller.quoteController.items;
                            return Column(
                              children: items.map((it) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(flex: 5, child: Text(it.description, style: const TextStyle(fontWeight: FontWeight.w600))),

                                       Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                '${it.quantity}',
                                                textAlign: TextAlign.center,
                                                softWrap: false,
                                              ),
                                            ),
                                          ),
                                        ),

                                          Expanded(
                                          flex: 2,
                                          child: Center(
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                '1 x £\u00A0${it.unitPrice.toStringAsFixed(2)}',
                                                textAlign: TextAlign.center,
                                                softWrap: false,
                                              ),
                                            ),
                                          ),
                                        ),


                                           Expanded(
                                          flex: 2,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                '£\u00A0${it.total.toStringAsFixed(2)}',
                                                textAlign: TextAlign.right,
                                                softWrap: false,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                );
                              }).toList(),
                            );
                          }),
                          const Divider(),
                          const SizedBox(height: 8),
                  
                          // Totals aligned right
                          Obx(() {
                            final q = controller.quoteController;
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(flex: 7, child: SizedBox()),
                                    const Expanded(flex: 3, child: Text('Subtotal', textAlign: TextAlign.right)),
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            '£\u00A0${q.subtotal.toStringAsFixed(2)}',
                                            textAlign: TextAlign.right,
                                            softWrap: false,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Expanded(flex: 7, child: SizedBox()),
                                    const Expanded(flex: 3, child: Text('VAT', textAlign: TextAlign.right)),
                                      Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            '£\u00A0${q.vatAmount.toStringAsFixed(2)}',
                                            textAlign: TextAlign.right,
                                            softWrap: false,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Expanded(flex: 7, child: SizedBox()),
                                    const Expanded(flex: 3, child: Text('Total Due  ', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
                                  Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            '£\u00A0${q.totalDue.toStringAsFixed(2)}',
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                            softWrap: false,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Pay Invoice button — only visible when Smart Pay is enabled
                  Builder(builder: (context) {
                    final imc = Get.isRegistered<InvoiceManuallyController>()
                        ? Get.find<InvoiceManuallyController>()
                        : null;
                    if (imc == null) return const SizedBox.shrink();
                    return Obx(() {
                      if (!imc.isSmartPayEnabled.value) return const SizedBox.shrink();
                      final link = imc.paymentLink.value;
                      return Center(
                        child: Column(
                          children: [
                            const Text(
                              'To pay this invoice, click the button below',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: link.isNotEmpty
                                      ? () async {
                                          final uri = Uri.parse(link);
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(
                                              uri,
                                              mode: LaunchMode.externalApplication,
                                            );
                                          }
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    backgroundColor: Colors.grey[800],
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Pay Invoice', style: TextStyle(fontSize: 16)),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward_ios, size: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                  }),

                  const SizedBox(height: 18),

                  // Manual bank transfer section (dynamic from API)
                  Obx(() {
                    final q = controller.quoteController;
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Manual bank transfer, use details below',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Bank Name',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      q.bankName.value.isEmpty ? 'null' : q.bankName.value,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Account',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      q.accountName.value.isEmpty ? 'null' : q.accountName.value,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Sort Code',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      q.sortCode.value.isEmpty ? 'null' : q.sortCode.value,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Account No',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      q.accountNo.value.isEmpty ? 'null' : q.accountNo.value,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 18),

                  // Send buttons (match quote preview design)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                try {
                                  if (Get.isRegistered<InvoiceManuallyController>()) {
                                    await Get.find<InvoiceManuallyController>().sendInvoiceWhatsApp();
                                  } else if (Get.isRegistered<InvoiceAiGeneratedController>()) {
                                    await Get.find<InvoiceAiGeneratedController>().sendInvoiceWhatsApp();
                                  }
                                } catch (e) {
                                  Get.snackbar('Error', 'Could not send via WhatsApp');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF25D366),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              icon: const Icon(Icons.chat, color: Colors.white),
                              label: const Text(
                                'Send via WhatsApp',
                                style: TextStyle(color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                                  onPressed: () async {
                                try {
                                  // Determine invoice id dynamically
                                  int? invoiceId;
                                  if (Get.isRegistered<InvoiceManuallyController>()) {
                                    invoiceId = Get.find<InvoiceManuallyController>().invoiceId.value;
                                  }
                                  if (invoiceId == null && Get.isRegistered<InvoiceAiGeneratedController>()) {
                                    try {
                                      final aic = Get.find<InvoiceAiGeneratedController>();
                                      final data = aic.quoteData;
                                      if (data != null && data is RxMap && data.isNotEmpty) {
                                        final possible = data['invoice_id'] ?? data['invoiceId'] ?? data['id'];
                                        if (possible != null) invoiceId = int.tryParse(possible.toString());
                                      }
                                    } catch (_) {}
                                  }

                                  if (invoiceId == null) {
                                    Get.snackbar('Error', 'Invoice ID not found');
                                    return;
                                  }

                                  // Export widget to PDF and upload (send_email = true)
                                  final success = await QuoteExportController().exportAndSendInvoice(invoiceId, _previewKey);
                                  if (!success) {
                                    Get.snackbar('Error', 'Failed to send invoice PDF');
                                  }
                                } catch (e) {
                                  Get.snackbar('Error', 'Could not send via Email');
                                  debugPrint('Send email error: $e');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A73E8),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              icon: const Icon(Icons.email, color: Colors.white),
                              label: const Text(
                                'Send via Email',
                                style: TextStyle(color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}
