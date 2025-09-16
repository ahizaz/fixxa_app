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

  @override
  void onInit() {
    super.onInit();
    subtotal.value = 100.0;
    discount.value = 10.0;
    tax.value = 9.0;
    total.value = subtotal.value - discount.value + tax.value;
  }

  void updateValues({double? sub, double? disc, double? tx}) {
    if (sub != null) subtotal.value = sub;
    if (disc != null) discount.value = disc;
    if (tx != null) tax.value = tx;
    total.value = subtotal.value - discount.value + tax.value;
  }

  Future<void> pickContact() async {
    if (await Permission.contacts.request().isGranted) {
      final contact = await FlutterContactsService.openDeviceContactPicker();
      if (contact != null) {
        selectedContacts.add({
          'name': contact.displayName ?? "No Name",
          'photo': contact.avatar,
        });
      }
    } else {
      Get.snackbar("Permission Denied", "Contacts permission is required");
    }
  }
}