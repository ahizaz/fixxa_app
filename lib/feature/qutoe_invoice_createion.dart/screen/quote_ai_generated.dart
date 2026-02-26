import 'dart:ui';

import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/quote_dialog.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/controller/manually_quote_controller.dart';

import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/quote_ai_generated_controller.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/quotespeak_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/export_preview.dart';

class QuoteAiGenerated extends StatelessWidget {
  const QuoteAiGenerated({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuoteAiGeneratedController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  width: double.infinity, // Mimic AppBar padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () => Get.back(),
                      ),
                      Expanded(
                        child: Obx(
                          () => Text(
                            controller.quoteData['quoteId'] ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Match AppBar title size
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                      IconButton(
                        icon: const Icon(Icons.mic, color: Colors.black),
                        onPressed: () {
                          final voiceCtrl = Get.put(VoiceController());
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Obx(() {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('Speak now - tap Record'),
                                        const SizedBox(height: 12),
                                        Text(voiceCtrl.recordedFilePath.value.isEmpty
                                            ? 'No recording yet'
                                            : 'File: ${voiceCtrl.recordedFilePath.value.split('/').last}'),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: voiceCtrl.isRecording.value
                                                  ? null
                                                  : () => voiceCtrl.startRecording(),
                                              child: const Text('Record'),
                                            ),
                                            ElevatedButton(
                                              onPressed: voiceCtrl.isRecording.value
                                                  ? () => voiceCtrl.stopRecording()
                                                  : null,
                                              child: const Text('Stop'),
                                            ),
                                            ElevatedButton(
                                              onPressed: voiceCtrl.recordedFilePath.value.isNotEmpty
                                                  ? () async {
                                                      // Upload to Quote AI
                                                      await voiceCtrl.uploadRecordingToQuoteAi();
                                                    }
                                                  : null,
                                              child: const Text('Upload'),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        TextButton(
                                          onPressed: () {
                                            // Cancel and close
                                            voiceCtrl.cancelRecording();
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      PopupMenuButton<String>(
                        icon: Image(
                          image: AssetImage(IconPath.aithreebutton),
                          width: 24.w,
                          height: 24.h,
                          fit: BoxFit.cover,
                        ),
                        onSelected: (String value) {
                          if (value == 'edit') {
                            QuoteDialog.show(context);
                          } else if (value == 'add_signature') {
                            controller.showSignatureDialog(context);
                          } else if (value == 'export') {
                              // Determine if export should be enabled (require quote id OR client+items present)
                              bool canExport = false;
                              try {
                                if (Get.isRegistered<ManuallyQuoteController>()) {
                                  final mqc = Get.find<ManuallyQuoteController>();
                                  canExport = mqc.selectedClient.isNotEmpty && mqc.items.isNotEmpty;
                                }
                              } catch (_) {}

                              if (!canExport) {
                                final qd = controller.quoteData;
                                if (qd != null && qd['quoteId'] != null && qd['quoteId'].toString().isNotEmpty) {
                                  canExport = true;
                                }
                              }

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 5,
                                    sigmaY: 5,
                                  ), // blur effect
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 16,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                            ListTile(
                                              leading: Opacity(
                                                opacity: canExport ? 1.0 : 0.45,
                                                child: Image.asset(
                                                  IconPath.pdf,
                                                  width: 24,
                                                  height: 24,
                                                ),
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
                                                          builder: (_) => ExportPreviewPage(
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
                                          leading: Image.asset(
                                            IconPath.csv,
                                            width: 24,
                                            height: 24,
                                          ),
                                          title: const Text("Export as CSV"),
                                          onTap: () {
                                            Navigator.pop(context);
                                            controller.exportQuoteAsCsv();
                                          },
                                        ),
                                        const Divider(),
                                        ListTile(
                                          leading: Image.asset(
                                            IconPath.excel,
                                            width: 24,
                                            height: 24,
                                          ),
                                          title: const Text("Export as Excel"),
                                          onTap: () {
                                            Navigator.pop(context);
                                            // Excel Export action
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
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierColor: Colors.black.withValues(
                                alpha: 0.3,
                              ), // dim effect
                              builder: (context) {
                                return BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 5,
                                    sigmaY: 5,
                                  ), // blur effect
                                  child: Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "Do you want to Delete?",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            "Once you delete the Quote it will be removed permanently",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 24),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                      context,
                                                    ); // শুধু বন্ধ করবে
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                    side: const BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 12,
                                                        ),
                                                    child: Text(
                                                      "No, keep it",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                      context,
                                                    ); // Close dialog first
                                                    controller
                                                        .deleteQuote(); // Call delete method
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 12,
                                                        ),
                                                    child: Text(
                                                      "Yes, delete",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: ListTile(
                                  leading: Icon(Icons.edit, color: Colors.blue),
                                  title: Text('Edit'),
                                ),
                              ),
                              // const PopupMenuItem<String>(
                              //   value: 'add_signature',
                              //   child: ListTile(
                              //     leading: Icon(
                              //       Icons.edit_attributes,
                              //       color: Colors.blue,
                              //     ),
                              //     title: Text('Add signature'),
                              //   ),
                              // ),
                              const PopupMenuItem<String>(
                                value: 'export',
                                child: ListTile(
                                  leading: Icon(
                                    Icons.download,
                                    color: Colors.blue,
                                  ),
                                  title: Text('Export as'),
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: ListTile(
                                  leading: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  title: Text('Delete'),
                                ),
                              ),
                            ],
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  var data = controller.quoteData;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (data['fromName'] ?? '').toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'From:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text((data['fromAddress'] ?? '').toString()),
                      const SizedBox(height: 16),
                      const Text(
                        'To:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // Prefer explicit `toName`/`toEmail` keys, but fall back to
                      // `client_details` or `bill_to` payloads returned by the API.
                      Builder(
                        builder: (_) {
                          String toName = '';
                          String toEmail = '';
                          String toPhone = '';
                          String toAddress = '';
                          try {
                            final cd = data['client_details'];
                            final bt = data['bill_to'];

                            toName = (data['toName'] ?? data['to_name'] ?? (cd != null ? cd['name'] : null) ?? (bt != null ? bt['name'] : null) ?? '').toString();
                            toEmail = (data['toEmail'] ?? data['to_email'] ?? (cd != null ? cd['email'] : null) ?? (bt != null ? bt['email'] : null) ?? '').toString();
                            toPhone = (data['toPhone'] ?? data['to_phone'] ?? (cd != null ? cd['phone'] : null) ?? (bt != null ? bt['phone'] : null) ?? '').toString();
                            toAddress = (data['toAddress'] ?? data['to_address'] ?? (cd != null ? cd['address'] : null) ?? (bt != null ? bt['address'] : null) ?? '').toString();
                          } catch (_) {}

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(toName),
                              if (toEmail.isNotEmpty) Text(toEmail),
                              if (toPhone.isNotEmpty) Text(toPhone),
                              if (toAddress.isNotEmpty) Text(toAddress),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Date: ${data['date'] ?? ''}'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Quote NO ${data['quoteNumber'] ?? ''}'),
                              if ((data['issued'] ?? '').toString().isNotEmpty)
                                Text('ISSUED ${data['issued']}'),
                              if ((data['due'] ?? '').toString().isNotEmpty)
                                Text('DUE ${data['due']}'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Services table
                      // Table(
                      //   border: TableBorder.all(color: Colors.grey.shade300),
                      //   columnWidths: const {
                      //     0: FlexColumnWidth(3),
                      //     1: FlexColumnWidth(2),
                      //     2: FlexColumnWidth(1.5),
                      //     3: FlexColumnWidth(1.5),
                      //   },
                      //   children: [
                      //     const TableRow(
                      //       children: [
                      //         Padding(
                      //           padding: EdgeInsets.all(8.0),
                      //           child: Text(
                      //             'Description',
                      //             style: TextStyle(fontWeight: FontWeight.bold),
                      //           ),
                      //         ),
                      //         Padding(
                      //           padding: EdgeInsets.all(8.0),
                      //           child: Text(
                      //             'Service',
                      //             style: TextStyle(fontWeight: FontWeight.bold),
                      //           ),
                      //         ),
                      //         Padding(
                      //           padding: EdgeInsets.all(8.0),
                      //           child: Text(
                      //             'Rate',
                      //             style: TextStyle(fontWeight: FontWeight.bold),
                      //           ),
                      //         ),
                      //         Padding(
                      //           padding: EdgeInsets.all(8.0),
                      //           child: Text(
                      //             'Duration',
                      //             style: TextStyle(fontWeight: FontWeight.bold),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     // Render services dynamically from API data
                      //     if (data['services'] != null && data['services'] is List && (data['services'] as List).isNotEmpty)
                      //       ...((data['services'] as List).map<TableRow>((service) {
                      //         final s = service as Map<String, dynamic>;
                      //         return TableRow(
                      //           children: [
                      //             Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: Text(s['description']?.toString() ?? ''),
                      //             ),
                      //             Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: Text(s['service']?.toString() ?? ''),
                      //             ),
                      //             Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: Text(s['rate']?.toString() ?? ''),
                      //             ),
                      //             Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: Text(s['duration']?.toString() ?? ''),
                      //             ),
                      //           ],
                      //         );
                      //       }).toList())
                      //     else
                      //       const TableRow(
                      //         children: [
                      //           Padding(
                      //             padding: EdgeInsets.all(8.0),
                      //             child: Text('-'),
                      //           ),
                      //           Padding(
                      //             padding: EdgeInsets.all(8.0),
                      //             child: Text('-'),
                      //           ),
                      //           Padding(
                      //             padding: EdgeInsets.all(8.0),
                      //             child: Text('-'),
                      //           ),
                      //           Padding(
                      //             padding: EdgeInsets.all(8.0),
                      //             child: Text('-'),
                      //           ),
                      //         ],
                      //       ),
                      //   ],
                      // ),
                      const SizedBox(height: 16),
                      // Items table with headers
                      Table(
                        border: TableBorder.all(color: Colors.grey.shade300),
                        columnWidths: const {
                          0: FlexColumnWidth(2.5),
                          1: FlexColumnWidth(1.2),
                          2: FlexColumnWidth(1.5),
                          3: FlexColumnWidth(1.5),
                        },
                        children: [
                          const TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Description',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Quantity',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Unit Price',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Amount',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          ...data['items'].map<TableRow>((item) {
                            // Prefer explicit keys: `quote_description`, `quantity`, `unit_price`
                            final desc = (item['quote_description'] ?? item['description'] ?? '').toString();
                            final qtyRaw = item['quantity'] ?? item['qty'] ?? 0;
                            final unitRaw = item['unit_price'] ?? item['unitPrice'] ?? item['unit'] ?? 0;

                            // Normalize numeric values when possible
                            final num? qty = qtyRaw is num ? qtyRaw : (int.tryParse(qtyRaw.toString()) ?? double.tryParse(qtyRaw.toString()));
                            final num? unitPrice = unitRaw is num ? unitRaw : (double.tryParse(unitRaw.toString()) ?? int.tryParse(unitRaw.toString()));

                            final amountVal = item['amount'] ?? (qty != null && unitPrice != null ? (qty * unitPrice) : null);

                            String unitText;
                            if (unitPrice != null) {
                              unitText = unitPrice.toStringAsFixed(2);
                            } else {
                              unitText = unitRaw.toString();
                            }

                            String amountText;
                            if (amountVal is num) {
                              amountText = amountVal.toStringAsFixed(2);
                            } else {
                              amountText = (amountVal ?? '').toString();
                            }

                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(desc),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(qty?.toString() ?? qtyRaw.toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(unitText),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(amountText),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Subtotal ${data['subtotal']}'),
                              Text('VAT ${data['vat']}'),
                              Text(
                                'Total ${data['total']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Signature section
                   
                      const SizedBox(height: 10),
                      // Obx(
                      //   () => GestureDetector(
                      //     onTap: () => controller.showSignatureDialog(context),
                      //     child: Container(
                      //       width: double.infinity,
                      //       height: 150,
                      //       decoration: BoxDecoration(
                      //         border: Border.all(
                      //           color: Colors.grey.shade300,
                      //           width: 2,
                      //         ),
                      //         borderRadius: BorderRadius.circular(8),
                      //         color: Colors.grey.shade50,
                      //       ),
                      //       child:
                      //           controller.hasSignature.value &&
                      //               controller.signatureBytes != null
                      //           ? ClipRRect(
                      //               borderRadius: BorderRadius.circular(6),
                      //               child: Image.memory(
                      //                 controller.signatureBytes!,
                      //                 fit: BoxFit.contain,
                      //                 width: double.infinity,
                      //                 height: double.infinity,
                      //               ),
                      //             )
                      //           : const Column(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Icon(
                      //                   Icons.edit,
                      //                   size: 30,
                      //                   color: Colors.grey,
                      //                 ),
                      //                 SizedBox(height: 8),
                      //                 Text(
                      //                   'Tap here to sign',
                      //                   style: TextStyle(
                      //                     color: Colors.grey,
                      //                     fontSize: 16,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 10),

                      const SizedBox(height: 8),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tooltip container above Send Quote button
            Obx(
              () => controller.showSpotlight.value
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Send Quote\nIf everything looks okay. Get ready to send quote to your client PDF.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          // Arrow pointing down to the button
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Obx(
              () => SpotlightWidget(
                showSpotlight: controller.showSpotlight.value,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierColor: Colors.black.withValues(
                        alpha: 0.3,
                      ), // dim effect
                      builder: (context) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 5,
                            sigmaY: 5,
                          ), // blur effect
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 348.w,
                              height: 144.h, // Adjust height as needed
                              margin: const EdgeInsets.only(
                                top: 16,
                                left: 16,
                                right: 16,
                                bottom: 16,
                              ),
                              child: Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                insetPadding:
                                    EdgeInsets.zero, // Remove default padding
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: Image(
                                        image: AssetImage(IconPath.whatsapp),
                                        width: 24.w,
                                        height: 24.h,
                                        fit: BoxFit.cover,
                                      ),
                                      title: const Text("Send by WhatsApp"),
                                      onTap: () async {
                                        // Close the dialog first
                                        Navigator.pop(context);

                                        debugPrint('📱 Send by WhatsApp clicked');

                                        // Call send WhatsApp method
                                        await controller.sendQuoteWhatsApp();
                                      },
                                    ),
                                    const Divider(height: 1),
                                    ListTile(
                                      leading: Image(
                                        image: AssetImage(IconPath.email),
                                        width: 24.w,
                                        height: 24.h,
                                        fit: BoxFit.cover,
                                      ),
                                      title: const Text("Send by Email"),
                                      onTap: () async {
                                        // Close the dialog first
                                        Navigator.pop(context);

                                        debugPrint('📧 Send by Email clicked');

                                        // Call send email method
                                        await controller.sendQuoteEmail();
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Send Quote',
                          style: GoogleFonts.urbanist(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xffFFFFFF),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image(
                          image: AssetImage(IconPath.send),
                          height: 24.h,
                          width: 24.w,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class SpotlightWidget extends StatelessWidget {
  final bool showSpotlight;
  final Widget child;

  const SpotlightWidget({
    super.key,
    required this.showSpotlight,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!showSpotlight) {
      return child;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          // Blue spotlight effect above the button like in the image
          BoxShadow(
            color: const Color(0xFF4A90E2).withValues(alpha: .6),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, -8),
          ),
          BoxShadow(
            color: const Color(0xFF87CEEB).withValues(alpha: .8),
            blurRadius: 15,
            spreadRadius: 3,
            offset: const Offset(0, -5),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: .4),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: child,
    );
  }
}
