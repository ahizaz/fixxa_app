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
                // Replaced AppBar with Row
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
                      Image(image: AssetImage(IconPath.aithreebutton),width: 24.w,height: 24.h,fit: BoxFit.cover,) // Balance the IconButton width
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
                      // Import from gallery and clear signature options
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () => controller.importSignatureFromGallery(),
                            icon: const Icon(Icons.photo_library, size: 16),
                            label: const Text('Import from Gallery'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.blue,
                            ),
                          ),
                          Obx(() => controller.hasSignature.value
                              ? TextButton(
                                  onPressed: () => controller.clearSignature(),
                                  child: const Text(
                                    'Clear Signature',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )
                              : const SizedBox.shrink()),
                        ],
                      ),
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
          onPressed: () {
            // Add your action here, e.g., add new item or edit
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(child: Image(image: AssetImage(IconPath.audiolines), fit: BoxFit.cover, width: 24.w, height: 24.h)),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {},
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
                Image(image: AssetImage(IconPath.send), height: 24.h, width: 24.w, fit: BoxFit.cover),
              ],
            ),
          ),
        ),
      ),
    );
  }
}