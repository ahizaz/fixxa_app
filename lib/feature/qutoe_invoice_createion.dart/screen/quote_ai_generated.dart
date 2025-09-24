import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/quote_ai_generated_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class QuoteAiGenerated extends StatelessWidget {
  const QuoteAiGenerated({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuoteAiGeneratedController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(
              controller.quoteData['quoteId'] ?? '',
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Obx(() {
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
                            child: Text(item['tax'] ?? '10%'), // Assuming tax per item, adjust if needed
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
               
                // Signature line
                Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
               Text("Signature"),
                const SizedBox(height: 8),
            
              ],
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here, e.g., add new item or edit
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Send Quote', style: TextStyle(color: Colors.white)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}