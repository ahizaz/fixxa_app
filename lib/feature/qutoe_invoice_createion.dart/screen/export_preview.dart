import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/export_preview_controller.dart';

class ExportPreviewPage extends StatefulWidget {
  final Map<String, dynamic>? data;
  final String source;
  final bool fetchOnOpen;

  const ExportPreviewPage({
    super.key,
    this.data,
    required this.source,
    this.fetchOnOpen = false,
  });

  @override
  State<ExportPreviewPage> createState() => _ExportPreviewPageState();
}

class _ExportPreviewPageState extends State<ExportPreviewPage> {
  late final String _tag;
  late final ExportPreviewController controller;

  String _title() {
    if (widget.source.isEmpty) return 'Quote';
    return '${widget.source[0].toUpperCase()}${widget.source.substring(1)}';
  }

  @override
  void initState() {
    super.initState();
    _tag = UniqueKey().toString();
    controller = Get.put(
        ExportPreviewController(widget.data, widget.source, widget.fetchOnOpen),
        tag: _tag);

    if (widget.fetchOnOpen) {
      // Trigger an explicit fetch when the page opens for export
      controller.fetchFromApi();
    }
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
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [const Icon(Icons.receipt, size: 16), const SizedBox(width: 8), const Text('Quote No') , const SizedBox(width: 8), Flexible(child: Text(q.quoteNumber.value, overflow: TextOverflow.ellipsis))]),
                              const SizedBox(height: 6),
                              Row(children: [const Icon(Icons.calendar_today, size: 16), const SizedBox(width: 8), const Text('Issued'), const SizedBox(width: 8), Flexible(child: Text(q.issuedDate.value, overflow: TextOverflow.ellipsis))]),
                              const SizedBox(height: 6),
                              Row(children: [const Icon(Icons.calendar_today_outlined, size: 16), const SizedBox(width: 8), const Text('Valid Until'), const SizedBox(width: 8), Flexible(child: Text(q.validUntil.value, overflow: TextOverflow.ellipsis))]),
                            ],
                          ),
                        ),
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
                        logoWidget,
                        const SizedBox(width: 12),
                        Expanded(child: metaCard),
                      ],
                    );
                  }),

                  const SizedBox(height: 18),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _title(),
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
                              Expanded(flex: 5, child: Text('Description', style: TextStyle(color: Colors.grey)) ),
                              Expanded(flex: 1, child: Text('Quantity', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))),
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
                                    const Expanded(flex: 3, child: Text('Total Due', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
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

                  Center(
                    child: Column(
                      children: [
                        const Text('To approve this quote, click the button below, or contact us directly', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () async {
                                  final q = controller.quoteController;
                                  final link = q.acceptLink?.value ?? '';
                                  if (link.isEmpty) {
                                    Get.snackbar('Error', 'No accept link available');
                                    return;
                                  }
                                  final uri = Uri.tryParse(link);
                                  if (uri == null) {
                                    Get.snackbar('Error', 'Invalid link');
                                    return;
                                  }
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                                  } else {
                                    Get.snackbar('Error', 'Could not open link');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  backgroundColor: Colors.grey[800],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('Approve Now', style: TextStyle(fontSize: 16)),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_ios, size: 16),
                                  ],
                                ),
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
