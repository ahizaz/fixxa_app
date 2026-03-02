
import 'dart:ui';

import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart'; // ← add this if not already
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/quote_dialog.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/controller/manually_quote_controller.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/quote_ai_generated_controller.dart';
import 'package:fixxa_app/feature/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/export_preview.dart';

// Safe numeric parser: handles num, String, null and returns 0 on failure.
num _num(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v;
  if (v is String) return num.tryParse(v) ?? 0;
  return 0;
}

class QuoteAiGenerated extends StatelessWidget {
  const QuoteAiGenerated({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuoteAiGeneratedController());
    // Ensure ProfileController is available — some widgets call Get.find<ProfileController>()
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController());
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
          // Background image (same as ExportPreview)
          Positioned.fill(
            child: Image.asset(
              ImagePath.backgroud, // make sure this asset exists
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Modern Header: Close + Title + Menu ──
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black87),
                        onPressed: () => Get.back(),
                      ),
                      Expanded(
                        child: Obx(
                          () => Text(
                            (controller.quoteData['quote_number'] ?? 'New Quote').toString(),
                            style: GoogleFonts.urbanist(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Image(
                          image: AssetImage(IconPath.aithreebutton),
                          width: 28.w,
                          height: 28.h,
                        ),
                        onSelected: (value) {
                          // ── Your existing logic (unchanged) ──
                          if (value == 'edit') {
                            QuoteDialog.show(context);
                          } else if (value == 'export') {
                            bool canExport = false;
                            try {
                              if (Get.isRegistered<ManuallyQuoteController>()) {
                                final mqc = Get.find<ManuallyQuoteController>();
                                canExport = mqc.selectedClient.isNotEmpty && mqc.items.isNotEmpty;
                              }
                            } catch (_) {}

                            if (!canExport) {
                              final qd = controller.quoteData;
                              if (qd != null && qd['quoteId']?.toString().isNotEmpty == true) {
                                canExport = true;
                              }
                            }

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: Opacity(
                                            opacity: canExport ? 1.0 : 0.45,
                                            child: Image.asset(IconPath.pdf, width: 24, height: 24),
                                          ),
                                          title: Text(
                                            "Export as PDF",
                                            style: TextStyle(color: canExport ? null : Colors.grey),
                                          ),
                                          enabled: canExport,
                                          onTap: canExport
                                              ? () {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => const ExportPreviewPage(
                                                        data: null,
                                                        source: 'quote',
                                                        fetchOnOpen: true,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              : null,
                                        ),
                                        const Divider(),
                                        ListTile(
                                          leading: Image.asset(IconPath.csv, width: 24, height: 24),
                                          title: const Text("Export as CSV"),
                                          onTap: () {
                                            Navigator.pop(context);
                                            controller.exportQuoteAsCsv();
                                          },
                                        ),
                                        const Divider(),
                                        ListTile(
                                          leading: Image.asset(IconPath.excel, width: 24, height: 24),
                                          title: const Text("Export as Excel"),
                                          onTap: () {
                                            Navigator.pop(context);
                                            // Excel export logic here
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if (value == 'delete') {
                            // Your existing delete dialog logic (unchanged)
                            // showDialog(...); // ← keep your original delete dialog
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: ListTile(leading: Icon(Icons.edit, color: Colors.blue), title: Text('Edit')),
                          ),
                          const PopupMenuItem(
                            value: 'export',
                            child: ListTile(leading: Icon(Icons.download, color: Colors.blue), title: Text('Export as')),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('Delete')),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Header: Logo + Quote Info Card (like ExportPreview) ──
                  Builder(
                    builder: (context) {
                      final width = MediaQuery.of(context).size.width;
                      final isNarrow = width < 380;

                      Widget logoWidget = Container(
                        width: 110.w,
                        height: 70.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Company Logo',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );

                      Widget metaCard = Padding(
                        padding: const EdgeInsets.all(14),
                        child: Obx(() {
                          var data = controller.quoteData ?? {};
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _metaRow(Icons.receipt, 'Quote No', data['quoteNumber'] ?? ''),
                              const SizedBox(height: 8),
                              _metaRow(Icons.calendar_today, 'Issued', data['issued'] ?? data['date'] ?? ''),
                              const SizedBox(height: 8),
                              _metaRow(Icons.event_available, 'Valid Until', data['due'] ?? ''),
                            ],
                          );
                        }),
                      );

                      if (isNarrow) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [logoWidget, const SizedBox(height: 12), metaCard],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          logoWidget,
                          const SizedBox(width: 16),
                          Expanded(child: metaCard),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Title
                

                  

                  // ── Bill To & From ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _infoCard('Bill To', controller)),
                      const SizedBox(width: 16),
                      Expanded(child: _infoCard('From', controller, isFrom: true)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Items Table (styled like ExportPreview) ──
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: Offset(0, 4))],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Header
                          Row(
                            children: const [
                              Expanded(flex: 5, child: Text('Description', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600))),
                              Expanded(flex: 2, child: Text('Quantity', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))),
                              Expanded(flex: 3, child: Text('Unit Price', textAlign: TextAlign.right, style: TextStyle(color: Colors.grey))),
                              Expanded(flex: 3, child: Text('Total', textAlign: TextAlign.right, style: TextStyle(color: Colors.grey))),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1.5),
                          const SizedBox(height: 12),

                          // Items
                          Obx(() {
                            final items = (controller.quoteData['items'] as List?) ?? [];
                            if (items.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(child: Text('No items added yet', style: TextStyle(color: Colors.grey))),
                              );
                            }

                            return Column(
                              children: items.map((item) {
                                final desc = item['description']?.toString() ?? item['quote_description']?.toString() ?? '';
                                final qty = _num(item['quantity']).toDouble();
                                final price = _num(item['unit_price']).toDouble();
                                final total = item['amount'] != null ? _num(item['amount']).toDouble() : qty * price;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: Row(
                                    children: [
                                      Expanded(flex: 5, child: Text(desc, style: const TextStyle(fontWeight: FontWeight.w500))),
                                      Expanded(
                                        flex: 2,
                                        child: Center(child: Text(qty.toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.w500))),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          '£${price.toStringAsFixed(2)}',
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          '£${total.toStringAsFixed(2)}',
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          }),

                          const Divider(height: 1.5),
                          const SizedBox(height: 16),

                          // Totals (right aligned)
                          Obx(() {
                            final data = controller.quoteData;
                            double subtotal = 0;
                            final items = (data['items'] as List?) ?? [];
                            for (var item in items) {
                              final qty = _num(item['quantity']).toDouble();
                              final price = _num(item['unit_price']).toDouble();
                              subtotal += qty * price;
                            }
                            final vatRate = _num(data['vat_rate'] ?? data['vat']).toDouble();
                            final vatAmount = subtotal * (vatRate / 100);
                            final total = subtotal + vatAmount;

                            return Column(
                              children: [
                                _totalRow('Subtotal', subtotal),
                                const SizedBox(height: 8),
                                _totalRow('VAT ($vatRate%)', vatAmount),
                                const Divider(height: 24),
                                _totalRow('Total Due', total, bold: true),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── Bottom Send Button Area ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Obx(
                          () => controller.showSpotlight.value
                              ? Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                                    ],
                                  ),
                                  child: const Column(
                                    children: [
                                      Text(
                                        'Looks good?\nSend this professional quote to your client now.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 16, height: 1.4),
                                      ),
                                      SizedBox(height: 8),
                                      Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),

                        // SpotlightWidget(
                        //   showSpotlight: controller.showSpotlight.value,
                        //   child: ElevatedButton(
                        //     onPressed: () {
                        //       // Your existing send dialog logic (unchanged)
                        //       showDialog(...); // ← keep your WhatsApp / Email dialog
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: const Color(0xFF1C1C1C),
                        //       minimumSize: Size(double.infinity, 56.h),
                        //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        //     ),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         Text(
                        //           'Send Quote',
                        //           style: GoogleFonts.urbanist(
                        //             fontSize: 18.sp,
                        //             fontWeight: FontWeight.w600,
                        //             color: Colors.white,
                        //           ),
                        //         ),
                        //         const SizedBox(width: 12),
                        //         Image.asset(IconPath.send, width: 28.w, height: 28.h),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _infoCard(String title, QuoteAiGeneratedController controller, {bool isFrom = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final data = controller.quoteData ?? {};
          String name = isFrom
              ? (data['fromName'] ?? Get.find<ProfileController>().businessName.value ?? '')
              : (data['toName'] ?? data['client_details']?['name'] ?? '');
          String address = isFrom
              ? (data['fromAddress'] ?? '')
              : (data['toAddress'] ?? data['client_details']?['address'] ?? '');
          String email = isFrom ? '' : (data['toEmail'] ?? '');
          String phone = isFrom ? '' : (data['toPhone'] ?? '');

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp)),
              const SizedBox(height: 8),
              Text(name, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
              if (address.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(address, style: const TextStyle(height: 1.4)),
              ],
              if (email.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(children: [Icon(Icons.email_outlined, size: 16), const SizedBox(width: 6), Expanded(child: Text(email))]),
              ],
              if (phone.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(children: [Icon(Icons.phone, size: 16), const SizedBox(width: 6), Expanded(child: Text(phone))]),
              ],
            ],
          );
        }),
      ),
    );
  }

  Widget _totalRow(String label, double amount, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w500)),
        const SizedBox(width: 80),
        Text(
          '£${amount.toStringAsFixed(2)}',
          style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w600, fontSize: bold ? 17 : 15),
        ),
      ],
    );
  }
}

// Keep your SpotlightWidget class unchanged
class SpotlightWidget extends StatelessWidget {
  final bool showSpotlight;
  final Widget child;

  const SpotlightWidget({super.key, required this.showSpotlight, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!showSpotlight) return child;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: const Color(0xFF4A90E2).withOpacity(0.5), blurRadius: 20, spreadRadius: 4, offset: const Offset(0, -6)),
          BoxShadow(color: const Color(0xFF87CEEB).withOpacity(0.6), blurRadius: 16, spreadRadius: 2, offset: const Offset(0, -4)),
        ],
      ),
      child: child,
    );
  }
}