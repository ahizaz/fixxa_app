import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuoteAiGeneratedController extends GetxController {
  var quoteData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Simulated JSON data (in future, this will come from API)
    quoteData.value = {
      "quoteId": "QUO-5233",
      "fromName": "MicoFit",
      "fromAddress": "Some ukrn. City, Postal Code, United Kingdom",
      "toName": "John Smith",
      "toEmail": "samuel@email.com",
      "toAddress": "30 Sweet kid. City, Postal Code, United Kingdom",
      "date": "30/09/2023",
      "quoteNumber": "QUO/5233",
      "items": [
        {"description": "Item 1", "quantity": 1, "unitPrice": "£05", "amount": "£05"},
        {"description": "Item 3", "quantity": 1, "unitPrice": "£05", "amount": "£05"}
      ],
      "subtotal": "£13.0",
      "vat": "£0.5",
      "total": "£13.5",
      "signature": "John Smith"
    };
  }
}