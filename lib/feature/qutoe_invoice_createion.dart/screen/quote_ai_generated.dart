// import 'dart:ui';

// import 'package:fixxa_app/core/utils/constants/icon_path.dart';
// import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/quote_dialog.dart';
// import 'package:fixxa_app/feature/quote_creation_manually.dart/controller/manually_quote_controller.dart';

// import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/quote_ai_generated_controller.dart';
// import 'package:fixxa_app/feature/profile/controller/profile_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/export_preview.dart';

// class QuoteAiGenerated extends StatelessWidget {
//   const QuoteAiGenerated({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(QuoteAiGeneratedController());
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16.0,
//               vertical: 8.0,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   color: Colors.white,
//                   width: double.infinity, // Mimic AppBar padding
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.close, color: Colors.black),
//                         onPressed: () => Get.back(),
//                       ),
//                       Expanded(
//                         child: Obx(
//                           () => Text(
//                             controller.quoteData['quoteId'] ?? '',
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18, // Match AppBar title size
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 48),
//                       // IconButton(
//                       //   icon: const Icon(Icons.mic, color: Colors.black),
//                       //   onPressed: () {
//                       //     final voiceCtrl = Get.put(VoiceController());
//                       //     showModalBottomSheet(
//                       //       context: context,
//                       //       isScrollControlled: true,
//                       //       backgroundColor: Colors.transparent,
//                       //       builder: (context) {
//                       //         return BackdropFilter(
//                       //           filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//                       //           child: Container(
//                       //             decoration: BoxDecoration(
//                       //               color: Colors.white,
//                       //               borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//                       //             ),
//                       //             padding: const EdgeInsets.all(16),
//                       //             child: Obx(() {
//                       //               return Column(
//                       //                 mainAxisSize: MainAxisSize.min,
//                       //                 children: [
//                       //                   const Text('Speak now - tap Record'),
//                       //                   const SizedBox(height: 12),
//                       //                   Text(voiceCtrl.recordedFilePath.value.isEmpty
//                       //                       ? 'No recording yet'
//                       //                       : 'File: ${voiceCtrl.recordedFilePath.value.split('/').last}'),
//                       //                   const SizedBox(height: 12),
//                       //                   Row(
//                       //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       //                     children: [
//                       //                       ElevatedButton(
//                       //                         onPressed: voiceCtrl.isRecording.value
//                       //                             ? null
//                       //                             : () => voiceCtrl.startRecording(),
//                       //                         child: const Text('Record'),
//                       //                       ),
//                       //                       ElevatedButton(
//                       //                         onPressed: voiceCtrl.isRecording.value
//                       //                             ? () => voiceCtrl.stopRecording()
//                       //                             : null,
//                       //                         child: const Text('Stop'),
//                       //                       ),
//                       //                       ElevatedButton(
//                       //                         onPressed: voiceCtrl.recordedFilePath.value.isNotEmpty
//                       //                             ? () async {
//                       //                                 // Upload to Quote AI
//                       //                                 await voiceCtrl.uploadRecordingToQuoteAi();
//                       //                               }
//                       //                             : null,
//                       //                         child: const Text('Upload'),
//                       //                       ),
//                       //                     ],
//                       //                   ),
//                       //                   const SizedBox(height: 12),
//                       //                   TextButton(
//                       //                     onPressed: () {
//                       //                       // Cancel and close
//                       //                       voiceCtrl.cancelRecording();
//                       //                       Navigator.pop(context);
//                       //                     },
//                       //                     child: const Text('Close'),
//                       //                   ),
//                       //                 ],
//                       //               );
//                       //             }),
//                       //           ),
//                       //         );
//                       //       },
//                       //     );
//                       //   },
//                       // ),
//                       PopupMenuButton<String>(
//                         icon: Image(
//                           image: AssetImage(IconPath.aithreebutton),
//                           width: 24.w,
//                           height: 24.h,
//                           fit: BoxFit.cover,
//                         ),
//                         onSelected: (String value) {
//                           if (value == 'edit') {
//                             QuoteDialog.show(context);
//                           } else if (value == 'add_signature') {
//                             controller.showSignatureDialog(context);
//                           } else if (value == 'export') {
//                               // Determine if export should be enabled (require quote id OR client+items present)
//                               bool canExport = false;
//                               try {
//                                 if (Get.isRegistered<ManuallyQuoteController>()) {
//                                   final mqc = Get.find<ManuallyQuoteController>();
//                                   canExport = mqc.selectedClient.isNotEmpty && mqc.items.isNotEmpty;
//                                 }
//                               } catch (_) {}

//                               if (!canExport) {
//                                 final qd = controller.quoteData;
//                                 if (qd != null && qd['quoteId'] != null && qd['quoteId'].toString().isNotEmpty) {
//                                   canExport = true;
//                                 }
//                               }

//                             showModalBottomSheet(
//                               context: context,
//                               isScrollControlled: true,
//                               backgroundColor: Colors.transparent,
//                               builder: (context) {
//                                 return BackdropFilter(
//                                   filter: ImageFilter.blur(
//                                     sigmaX: 5,
//                                     sigmaY: 5,
//                                   ), // blur effect
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: const BorderRadius.vertical(
//                                         top: Radius.circular(20),
//                                       ),
//                                     ),
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 20,
//                                       horizontal: 16,
//                                     ),
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                             ListTile(
//                                               leading: Opacity(
//                                                 opacity: canExport ? 1.0 : 0.45,
//                                                 child: Image.asset(
//                                                   IconPath.pdf,
//                                                   width: 24,
//                                                   height: 24,
//                                                 ),
//                                               ),
//                                               title: Text(
//                                                 "Export as PDF",
//                                                 style: TextStyle(color: canExport ? null : Colors.grey),
//                                               ),
//                                               enabled: canExport,
//                                               onTap: canExport
//                                                   ? () {
//                                                       Navigator.pop(context);
//                                                       Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder: (_) => ExportPreviewPage(
//                                                                 data: null,
//                                                                 source: 'quote',
//                                                                 fetchOnOpen: true,
//                                                               ),
//                                                         ),
//                                                       );
//                                                     }
//                                                   : null,
//                                             ),
//                                         const Divider(),
//                                         ListTile(
//                                           leading: Image.asset(
//                                             IconPath.csv,
//                                             width: 24,
//                                             height: 24,
//                                           ),
//                                           title: const Text("Export as CSV"),
//                                           onTap: () {
//                                             Navigator.pop(context);
//                                             controller.exportQuoteAsCsv();
//                                           },
//                                         ),
//                                         const Divider(),
//                                         ListTile(
//                                           leading: Image.asset(
//                                             IconPath.excel,
//                                             width: 24,
//                                             height: 24,
//                                           ),
//                                           title: const Text("Export as Excel"),
//                                           onTap: () {
//                                             Navigator.pop(context);
//                                             // Excel Export action
//                                           },
//                                         ),
//                                         const SizedBox(height: 20),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           } else if (value == 'delete') {
//                             showDialog(
//                               context: context,
//                               barrierDismissible: false,
//                               barrierColor: Colors.black.withValues(
//                                 alpha: 0.3,
//                               ), // dim effect
//                               builder: (context) {
//                                 return BackdropFilter(
//                                   filter: ImageFilter.blur(
//                                     sigmaX: 5,
//                                     sigmaY: 5,
//                                   ), // blur effect
//                                   child: Dialog(
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(20.0),
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           const Text(
//                                             "Do you want to Delete?",
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 18,
//                                               color: Colors.black,
//                                             ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                           const SizedBox(height: 8),
//                                           const Text(
//                                             "Once you delete the Quote it will be removed permanently",
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.grey,
//                                             ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                           const SizedBox(height: 24),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceEvenly,
//                                             children: [
//                                               Expanded(
//                                                 child: OutlinedButton(
//                                                   onPressed: () {
//                                                     Navigator.pop(
//                                                       context,
//                                                     ); // শুধু বন্ধ করবে
//                                                   },
//                                                   style: OutlinedButton.styleFrom(
//                                                     side: const BorderSide(
//                                                       color: Colors.grey,
//                                                     ),
//                                                     shape: RoundedRectangleBorder(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                             8,
//                                                           ),
//                                                     ),
//                                                   ),
//                                                   child: const Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                           vertical: 12,
//                                                         ),
//                                                     child: Text(
//                                                       "No, keep it",
//                                                       style: TextStyle(
//                                                         color: Colors.black,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               const SizedBox(width: 12),
//                                               Expanded(
//                                                 child: ElevatedButton(
//                                                   onPressed: () {
//                                                     Navigator.pop(
//                                                       context,
//                                                     ); // Close dialog first
//                                                     controller
//                                                         .deleteQuote(); // Call delete method
//                                                   },
//                                                   style: ElevatedButton.styleFrom(
//                                                     backgroundColor: Colors.red,
//                                                     shape: RoundedRectangleBorder(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                             8,
//                                                           ),
//                                                     ),
//                                                   ),
//                                                   child: const Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                           vertical: 12,
//                                                         ),
//                                                     child: Text(
//                                                       "Yes, delete",
//                                                       style: TextStyle(
//                                                         color: Colors.white,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           }
//                         },
//                         itemBuilder: (BuildContext context) =>
//                             <PopupMenuEntry<String>>[
//                               const PopupMenuItem<String>(
//                                 value: 'edit',
//                                 child: ListTile(
//                                   leading: Icon(Icons.edit, color: Colors.blue),
//                                   title: Text('Edit'),
//                                 ),
//                               ),
//                               // const PopupMenuItem<String>(
//                               //   value: 'add_signature',
//                               //   child: ListTile(
//                               //     leading: Icon(
//                               //       Icons.edit_attributes,
//                               //       color: Colors.blue,
//                               //     ),
//                               //     title: Text('Add signature'),
//                               //   ),
//                               // ),
//                               const PopupMenuItem<String>(
//                                 value: 'export',
//                                 child: ListTile(
//                                   leading: Icon(
//                                     Icons.download,
//                                     color: Colors.blue,
//                                   ),
//                                   title: Text('Export as'),
//                                 ),
//                               ),
//                               const PopupMenuItem<String>(
//                                 value: 'delete',
//                                 child: ListTile(
//                                   leading: Icon(
//                                     Icons.delete,
//                                     color: Colors.red,
//                                   ),
//                                   title: Text('Delete'),
//                                 ),
//                               ),
//                             ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Obx(() {
//                   var data = controller.quoteData ?? <String, dynamic>{};

//                   // Profile controller provides business/user info as fallback
//                   final profileCtrl = Get.isRegistered<ProfileController>()
//                       ? Get.find<ProfileController>()
//                       : Get.put(ProfileController());

//                   final fromNameRaw = (data['fromName'] ?? '').toString();
//                   final fromAddressRaw = (data['fromAddress'] ?? '').toString();

//                   var fromName = fromNameRaw;
//                   var fromAddress = fromAddressRaw;

//                   if (fromName.isEmpty && (profileCtrl.businessName.value?.isNotEmpty ?? false)) {
//                     fromName = profileCtrl.businessName.value;
//                   }
//                   if (fromAddress.isEmpty && (profileCtrl.userEmail.value?.isNotEmpty ?? false)) {
//                     fromAddress = profileCtrl.userEmail.value;
//                   }

//                   // Prepare recipient fields safely
//                   String toName = '';
//                   String toEmail = '';
//                   String toPhone = '';
//                   String toAddress = '';
//                   try {
//                     final cd = data['client_details'];
//                     final bt = data['bill_to'];

//                     toName = (data['toName'] ?? data['to_name'] ?? (cd != null ? cd['name'] : null) ?? (bt != null ? bt['name'] : null) ?? '').toString();
//                     toEmail = (data['toEmail'] ?? data['to_email'] ?? (cd != null ? cd['email'] : null) ?? (bt != null ? bt['email'] : null) ?? '').toString();
//                     toPhone = (data['toPhone'] ?? data['to_phone'] ?? (cd != null ? cd['phone'] : null) ?? (bt != null ? bt['phone'] : null) ?? '').toString();
//                     toAddress = (data['toAddress'] ?? data['to_address'] ?? (cd != null ? cd['address'] : null) ?? (bt != null ? bt['address'] : null) ?? '').toString();
//                   } catch (_) {}

//                   final date = (data['date'] ?? '').toString();
//                   final quoteNumber = (data['quoteNumber'] ?? '').toString();
//                   final issued = (data['issued'] ?? '').toString();
//                   final due = (data['due'] ?? '').toString();

//                   final itemsList = (data['items'] is List) ? List.from(data['items'] as List) : <dynamic>[];

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'From:',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               fromName,
//                               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       if (fromAddress.isNotEmpty) Text(fromAddress),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'To:',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       // Use prepared recipient fields
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(toName),
//                           if (toEmail.isNotEmpty) Text(toEmail),
//                           if (toPhone.isNotEmpty) Text(toPhone),
//                           if (toAddress.isNotEmpty) Text(toAddress),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('Date: ${data['date'] ?? ''}'),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text('Quote NO ${data['quoteNumber'] ?? ''}'),
//                               if ((data['issued'] ?? '').toString().isNotEmpty)
//                                 Text('ISSUED ${data['issued']}'),
//                               if ((data['due'] ?? '').toString().isNotEmpty)
//                                 Text('DUE ${data['due']}'),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       // Services table
//                       // Table(
//                       //   border: TableBorder.all(color: Colors.grey.shade300),
//                       //   columnWidths: const {
//                       //     0: FlexColumnWidth(3),
//                       //     1: FlexColumnWidth(2),
//                       //     2: FlexColumnWidth(1.5),
//                       //     3: FlexColumnWidth(1.5),
//                       //   },
//                       //   children: [
//                       //     const TableRow(
//                       //       children: [
//                       //         Padding(
//                       //           padding: EdgeInsets.all(8.0),
//                       //           child: Text(
//                       //             'Description',
//                       //             style: TextStyle(fontWeight: FontWeight.bold),
//                       //           ),
//                       //         ),
//                       //         Padding(
//                       //           padding: EdgeInsets.all(8.0),
//                       //           child: Text(
//                       //             'Service',
//                       //             style: TextStyle(fontWeight: FontWeight.bold),
//                       //           ),
//                       //         ),
//                       //         Padding(
//                       //           padding: EdgeInsets.all(8.0),
//                       //           child: Text(
//                       //             'Rate',
//                       //             style: TextStyle(fontWeight: FontWeight.bold),
//                       //           ),
//                       //         ),
//                       //         Padding(
//                       //           padding: EdgeInsets.all(8.0),
//                       //           child: Text(
//                       //             'Duration',
//                       //             style: TextStyle(fontWeight: FontWeight.bold),
//                       //           ),
//                       //         ),
//                       //       ],
//                       //     ),
//                       //     // Render services dynamically from API data
//                       //     if (data['services'] != null && data['services'] is List && (data['services'] as List).isNotEmpty)
//                       //       ...((data['services'] as List).map<TableRow>((service) {
//                       //         final s = service as Map<String, dynamic>;
//                       //         return TableRow(
//                       //           children: [
//                       //             Padding(
//                       //               padding: const EdgeInsets.all(8.0),
//                       //               child: Text(s['description']?.toString() ?? ''),
//                       //             ),
//                       //             Padding(
//                       //               padding: const EdgeInsets.all(8.0),
//                       //               child: Text(s['service']?.toString() ?? ''),
//                       //             ),
//                       //             Padding(
//                       //               padding: const EdgeInsets.all(8.0),
//                       //               child: Text(s['rate']?.toString() ?? ''),
//                       //             ),
//                       //             Padding(
//                       //               padding: const EdgeInsets.all(8.0),
//                       //               child: Text(s['duration']?.toString() ?? ''),
//                       //             ),
//                       //           ],
//                       //         );
//                       //       }).toList())
//                       //     else
//                       //       const TableRow(
//                       //         children: [
//                       //           Padding(
//                       //             padding: EdgeInsets.all(8.0),
//                       //             child: Text('-'),
//                       //           ),
//                       //           Padding(
//                       //             padding: EdgeInsets.all(8.0),
//                       //             child: Text('-'),
//                       //           ),
//                       //           Padding(
//                       //             padding: EdgeInsets.all(8.0),
//                       //             child: Text('-'),
//                       //           ),
//                       //           Padding(
//                       //             padding: EdgeInsets.all(8.0),
//                       //             child: Text('-'),
//                       //           ),
//                       //         ],
//                       //       ),
//                       //   ],
//                       // ),
//                       const SizedBox(height: 16),
//                       // Render items as picture-like rows (no table) inside a Builder
//                       Builder(builder: (context) {
//                         double _subtotal = 0;
//                         for (var item in itemsList) {
//                           final qtyVal = item['quantity'] is num
//                               ? (item['quantity'] as num).toDouble()
//                               : double.tryParse(item['quantity']?.toString() ?? '0') ?? 0.0;
//                           final unitVal = item['unit_price'] is num
//                               ? (item['unit_price'] as num).toDouble()
//                               : double.tryParse(item['unit_price']?.toString() ?? '0') ?? 0.0;
//                           _subtotal += qtyVal * unitVal;
//                         }

//                         final num vatRate = (data['vat_rate'] ?? data['vat'] ?? 0) is num
//                             ? (data['vat_rate'] ?? data['vat'] ?? 0) as num
//                             : num.tryParse((data['vat_rate'] ?? data['vat'] ?? 0).toString()) ?? 0;
//                         final double _vatAmount = _subtotal * (vatRate / 100);
//                         final double _total = _subtotal + _vatAmount;

//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             // Header row (muted)
//                             Container(
//                               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//                               child: Row(
//                                 children: const [
//                                   Expanded(
//                                     flex: 4,
//                                     child: Text('Description', style: TextStyle(color: Colors.grey)),
//                                   ),
//                                   Expanded(flex: 1, child: Text('Quantity', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))),
//                                   Expanded(flex: 2, child: Text('Unit Price', textAlign: TextAlign.right, style: TextStyle(color: Colors.grey))),
//                                   SizedBox(width: 16),
//                                   SizedBox(width: 80, child: Text('Total', textAlign: TextAlign.right, style: TextStyle(color: Colors.grey))),
//                                 ],
//                               ),
//                             ),
//                             const Divider(),

//                             // Item rows (visual, similar to picture)
//                             ...itemsList.map<Widget>((item) {
//                               final desc = (item['quote_description'] ?? item['description'] ?? '').toString();
//                               final qtyVal = item['quantity'] is num
//                                   ? (item['quantity'] as num).toDouble()
//                                   : double.tryParse(item['quantity']?.toString() ?? '0') ?? 0.0;
//                               final unitVal = item['unit_price'] is num
//                                   ? (item['unit_price'] as num).toDouble()
//                                   : double.tryParse(item['unit_price']?.toString() ?? '0') ?? 0.0;
//                               final lineTotal = (item['amount'] is num)
//                                   ? (item['amount'] as num).toDouble()
//                                   : (qtyVal * unitVal);

//                               return Column(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(vertical: 10.0),
//                                     child: Row(
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         Expanded(flex: 4, child: Text(desc)),
//                                         Expanded(flex: 1, child: Text(qtyVal.toString(), textAlign: TextAlign.center)),
//                                         Expanded(flex: 2, child: Text(unitVal.toStringAsFixed(2), textAlign: TextAlign.right)),
//                                         const SizedBox(width: 16),
//                                         SizedBox(width: 80, child: Text(lineTotal.toStringAsFixed(2), textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600))),
//                                       ],
//                                     ),
//                                   ),
//                                   const Divider(height: 1),
//                                 ],
//                               );
//                             }).toList(),

//                             const SizedBox(height: 12),

//                             // Summary block aligned to right (picture style)
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Container(
//                                   width: 260,
//                                   padding: const EdgeInsets.all(12),
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey.shade50,
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const Text('Subtotal'),
//                                           Text(_subtotal.toStringAsFixed(2)),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 6),
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text('VAT (${vatRate.toString()}%)'),
//                                           Text(_vatAmount.toStringAsFixed(2)),
//                                         ],
//                                       ),
//                                       const Divider(),
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
//                                           Text(_total.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         );
//                       }),
//                       const SizedBox(height: 32),
//                       // Signature section
                   
//                       const SizedBox(height: 10),
//                       // Obx(
//                       //   () => GestureDetector(
//                       //     onTap: () => controller.showSignatureDialog(context),
//                       //     child: Container(
//                       //       width: double.infinity,
//                       //       height: 150,
//                       //       decoration: BoxDecoration(
//                       //         border: Border.all(
//                       //           color: Colors.grey.shade300,
//                       //           width: 2,
//                       //         ),
//                       //         borderRadius: BorderRadius.circular(8),
//                       //         color: Colors.grey.shade50,
//                       //       ),
//                       //       child:
//                       //           controller.hasSignature.value &&
//                       //               controller.signatureBytes != null
//                       //           ? ClipRRect(
//                       //               borderRadius: BorderRadius.circular(6),
//                       //               child: Image.memory(
//                       //                 controller.signatureBytes!,
//                       //                 fit: BoxFit.contain,
//                       //                 width: double.infinity,
//                       //                 height: double.infinity,
//                       //               ),
//                       //             )
//                       //           : const Column(
//                       //               mainAxisAlignment: MainAxisAlignment.center,
//                       //               children: [
//                       //                 Icon(
//                       //                   Icons.edit,
//                       //                   size: 30,
//                       //                   color: Colors.grey,
//                       //                 ),
//                       //                 SizedBox(height: 8),
//                       //                 Text(
//                       //                   'Tap here to sign',
//                       //                   style: TextStyle(
//                       //                     color: Colors.grey,
//                       //                     fontSize: 16,
//                       //                   ),
//                       //                 ),
//                       //               ],
//                       //             ),
//                       //     ),
//                       //   ),
//                       // ),
//                       // const SizedBox(height: 10),

//                       const SizedBox(height: 8),
//                     ],
//                   );
//                 }),
//               ],
//             ),
//           ),
//         ),
//       ),
    
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Tooltip container above Send Quote button
//             Obx(
//               () => controller.showSpotlight.value
//                   ? Container(
//                       margin: const EdgeInsets.only(bottom: 12),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withValues(alpha: 0.1),
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             'Send Quote\nIf everything looks okay. Get ready to send quote to your client PDF.',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black87,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           // Arrow pointing down to the button
//                           Container(
//                             margin: const EdgeInsets.only(top: 4),
//                             child: Icon(
//                               Icons.keyboard_arrow_down,
//                               color: Colors.grey,
//                               size: 20,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : const SizedBox.shrink(),
//             ),
//             Obx(
//               () => SpotlightWidget(
//                 showSpotlight: controller.showSpotlight.value,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       barrierDismissible: true,
//                       barrierColor: Colors.black.withValues(
//                         alpha: 0.3,
//                       ), // dim effect
//                       builder: (context) {
//                         return BackdropFilter(
//                           filter: ImageFilter.blur(
//                             sigmaX: 5,
//                             sigmaY: 5,
//                           ), // blur effect
//                           child: Align(
//                             alignment: Alignment.bottomCenter,
//                             child: Container(
//                               width: 348.w,
//                               height: 144.h, // Adjust height as needed
//                               margin: const EdgeInsets.only(
//                                 top: 16,
//                                 left: 16,
//                                 right: 16,
//                                 bottom: 16,
//                               ),
//                               child: Dialog(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                                 insetPadding:
//                                     EdgeInsets.zero, // Remove default padding
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     ListTile(
//                                       leading: Image(
//                                         image: AssetImage(IconPath.whatsapp),
//                                         width: 24.w,
//                                         height: 24.h,
//                                         fit: BoxFit.cover,
//                                       ),
//                                       title: const Text("Send by WhatsApp"),
//                                       onTap: () async {
//                                         // Close the dialog first
//                                         Navigator.pop(context);

//                                         debugPrint('📱 Send by WhatsApp clicked');

//                                         // Call send WhatsApp method
//                                         await controller.sendQuoteWhatsApp();
//                                       },
//                                     ),
//                                     const Divider(height: 1),
//                                     ListTile(
//                                       leading: Image(
//                                         image: AssetImage(IconPath.email),
//                                         width: 24.w,
//                                         height: 24.h,
//                                         fit: BoxFit.cover,
//                                       ),
//                                       title: const Text("Send by Email"),
//                                       onTap: () async {
//                                         // Close the dialog first
//                                         Navigator.pop(context);

//                                         debugPrint('📧 Send by Email clicked');

//                                         // Call send email method
//                                         await controller.sendQuoteEmail();
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xff1C1C1C),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 12.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Send Quote',
//                           style: GoogleFonts.urbanist(
//                             fontSize: 17.sp,
//                             fontWeight: FontWeight.w600,
//                             color: const Color(0xffFFFFFF),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Image(
//                           image: AssetImage(IconPath.send),
//                           height: 24.h,
//                           width: 24.w,
//                           fit: BoxFit.cover,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SpotlightWidget extends StatelessWidget {
//   final bool showSpotlight;
//   final Widget child;

//   const SpotlightWidget({
//     super.key,
//     required this.showSpotlight,
//     required this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (!showSpotlight) {
//       return child;
//     }

//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           // Blue spotlight effect above the button like in the image
//           BoxShadow(
//             color: const Color(0xFF4A90E2).withValues(alpha: .6),
//             blurRadius: 20,
//             spreadRadius: 5,
//             offset: const Offset(0, -8),
//           ),
//           BoxShadow(
//             color: const Color(0xFF87CEEB).withValues(alpha: .8),
//             blurRadius: 15,
//             spreadRadius: 3,
//             offset: const Offset(0, -5),
//           ),
//           BoxShadow(
//             color: Colors.white.withValues(alpha: .4),
//             blurRadius: 10,
//             spreadRadius: 1,
//             offset: const Offset(0, -3),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }
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
                            (controller.quoteData['quoteId'] ?? 'New Quote').toString(),
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

                      Widget metaCard = Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 3,
                        child: Padding(
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
                        ),
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
                                          '£ ${price.toStringAsFixed(2)}',
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          '£ ${total.toStringAsFixed(2)}',
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
          '£ ${amount.toStringAsFixed(2)}',
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