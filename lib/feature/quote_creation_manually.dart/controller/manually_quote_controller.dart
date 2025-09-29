import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';

class ManuallyQuoteController extends GetxController {
  var subtotal = 0.0.obs;
  var discount = 0.0.obs;
  var tax = 0.0.obs;
  var total = 0.0.obs;

  var selectedContacts = <Map<String, dynamic>>[].obs;
  var selectedClient = <String, dynamic>{}.obs;
  
  var showSpotlight = true.obs;
  var showAddItemSpotlight = true.obs;
  var showPaymentSpotlight = true.obs;
  var showPreviewSpotlight = true.obs;
  var showAddItemScreenSpotlight = true.obs;

  final descriptionController = TextEditingController();
  final estimatedCostController = TextEditingController();
  final quantityController = TextEditingController();

  var discountType = "None".obs;
  var dayhour = "Days".obs;
  var payment ="Standard Payment".obs;
  var items = <Map<String, dynamic>>[].obs;
  
  // For editing existing items
  int? editItemIndex;

  var isTaxable = false.obs;

  @override
  void onInit() {
    super.onInit();
    subtotal.value = 100.0;
    discount.value = 10.0;
    tax.value = 9.0;
    total.value = subtotal.value - discount.value + tax.value;
    
    // Hide spotlight after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      showSpotlight.value = false;
    });
    
    // Hide add item spotlight after 4 seconds (starts after client spotlight ends)
    Future.delayed(const Duration(seconds: 8), () {
      showAddItemSpotlight.value = false;
    });
    
    // Hide payment spotlight after 4 seconds (starts after add item spotlight ends)
    Future.delayed(const Duration(seconds: 12), () {
      showPaymentSpotlight.value = false;
    });
    
    // Hide preview spotlight after 4 seconds (starts after payment spotlight ends)
    Future.delayed(const Duration(seconds: 16), () {
      showPreviewSpotlight.value = false;
    });
  }

  void updateValues({double? sub, double? disc, double? tx}) {
    if (sub != null) subtotal.value = sub;
    if (disc != null) discount.value = disc;
    if (tx != null) tax.value = tx;
    total.value = subtotal.value - discount.value + tax.value;
  }

  void startAddItemScreenSpotlight() {
    if (showAddItemScreenSpotlight.value) {
      // Hide spotlight after 4 seconds and make sure it doesn't show again
      Future.delayed(const Duration(seconds: 4), () {
        showAddItemScreenSpotlight.value = false;
      });
    }
  }

  Future<void> pickContact() async {
    if (await Permission.contacts.request().isGranted) {
      final contact = await FlutterContactsService.openDeviceContactPicker();
      if (contact != null) {
        final String contactName = contact.displayName ?? "No Name";
        // Check for duplicates by name
        if (!selectedContacts.any((c) => c['name'] == contactName)) {
          selectedContacts.add({'name': contactName, 'photo': contact.avatar});
        } else {
          Get.snackbar("Duplicate", "This contact is already added.");
        }
      }
    } else {
      Get.snackbar("Permission Denied", "Contacts permission is required");
    }
  }

  void setClientData(Map<String, dynamic> clientData) {
    selectedClient.value = clientData;
  }

  void addServiceItem(String serviceName, double rate) {
    items.add({
      'description': serviceName,
      'rate': rate,
      'quantity': 1,
      'discountType': 'None',
      'isTaxable': false,
      'dayhour': 'Days',
      'price': rate * 1, // rate * quantity
    });
    // Recalculate totals
    calculateTotals();
  }

  void calculateTotals() {
    double newSubtotal = 0.0;
    for (var item in items) {
      newSubtotal += (item['price'] ?? 0.0);
    }
    subtotal.value = newSubtotal;
    total.value = subtotal.value - discount.value + tax.value;
  }

  @override
  void onClose() {
    descriptionController.dispose();
    estimatedCostController.dispose();
    quantityController.dispose();
    super.onClose();
  }
}
