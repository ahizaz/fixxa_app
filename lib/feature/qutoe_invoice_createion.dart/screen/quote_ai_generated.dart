import 'dart:ui';

import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/quote_ai_generated_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                        child: Obx(() => Text(
                              controller.quoteData['quoteId'] ?? '',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18, // Match AppBar title size
                              ),
                              textAlign: TextAlign.center,
                            )),
                      ),
                      const SizedBox(width: 48),
                      PopupMenuButton<String>(
                        icon: Image(
                          image: AssetImage(IconPath.aithreebutton),
                          width: 24.w,
                          height: 24.h,
                          fit: BoxFit.cover,
                        ),
                        onSelected: (String value) {
                          if (value == 'edit') {
       
                         
                          } else if (value == 'add_signature') {
                            controller.showSignatureDialog(context);
                          } else if (value == 'export') {
                                                showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // blur effect
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Image.asset(
                  IconPath.pdf,
                  width: 24,
                  height: 24,
                ),
                title: const Text("Export as PDF"),
                onTap: () {
                  Navigator.pop(context);
                  // PDF Export action
                },
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
                  // CSV Export action
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
                      
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit, color: Colors.blue),
                              title: Text('Edit'),
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'add_signature',
                            child: ListTile(
                              leading: Icon(Icons.edit_attributes, color: Colors.blue),
                              title: Text('Add signature'),
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'export',
                            child: ListTile(
                              leading: Icon(Icons.download, color: Colors.blue),
                              title: Text('Export as'),
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: ListTile(
                              leading: Icon(Icons.delete, color: Colors.red),
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
                  if (data.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['fromName'],
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'From:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(data['fromAddress']),
                      const SizedBox(height: 16),
                      const Text(
                        'To:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(data['toName']),
                      Text(data['toEmail']),
                      if (data['toPhone'] != null) Text(data['toPhone']),
                      Text(data['toAddress']),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Date: ${data['date']}'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Quote NO ${data['quoteNumber']}'),
                              if (data['issued'] != null) Text('ISSUED ${data['issued']}'),
                              if (data['due'] != null) Text('DUE ${data['due']}'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Items table with headers
                      Table(
                        border: TableBorder.all(color: Colors.grey.shade300),
                        columnWidths: const {
                          0: FlexColumnWidth(3),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1.5),
                          3: FlexColumnWidth(1.5),
                          4: FlexColumnWidth(1.5),
                        },
                        children: [
                          const TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Item', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Unit Price', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Tax', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          ...data['items'].map<TableRow>((item) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['description']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['quantity'].toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['unitPrice']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['tax'] ?? '10%'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['amount']),
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
                              Text('Total ${data['total']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Signature section
                      const Text(
                        'Signature:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Obx(() => GestureDetector(
                            onTap: () => controller.showSignatureDialog(context),
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300, width: 2),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade50,
                              ),
                              child: controller.hasSignature.value && controller.signatureBytes != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.memory(
                                        controller.signatureBytes!,
                                        fit: BoxFit.contain,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    )
                                  : const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          size: 30,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Tap here to sign',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          )),
                      const SizedBox(height: 10),
              
                      const SizedBox(height: 8),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xff3A8DFF), // Blue Violet
              Color(0xff8C33FF), // Dark Orchid
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
              child: Image(
            image: AssetImage(IconPath.audiolines),
            fit: BoxFit.cover,
            width: 24.w,
            height: 24.h,
          )),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierColor: Colors.black.withOpacity(0.3), // dim effect
                  builder: (context) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // blur effect
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 348.w,
                          height: 144.h, // Adjust height as needed
                          margin: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                          child: Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            insetPadding: EdgeInsets.zero, // Remove default padding
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
                                  onTap: () {
                                    // WhatsApp action
                                    Navigator.pop(context);
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
                                  onTap: () {
                                    // Email action
                                    Navigator.pop(context);
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
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}