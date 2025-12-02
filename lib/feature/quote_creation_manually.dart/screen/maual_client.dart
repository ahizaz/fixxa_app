import 'package:fixxa_app/feature/quote_creation_manually.dart/controller/manually_quote_controller.dart';
import 'package:fixxa_app/feature/client_details/controller/client_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MaualClient extends StatelessWidget {
  const MaualClient({super.key});

  Future<void> _pickImage(ManuallyQuoteController controller) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      controller.manualClientImage.value = image.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ManuallyQuoteController>();
    
    return Scaffold(
      backgroundColor: const Color(0xffF8F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8F8FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Add Manual Client',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image Section
            Center(
              child: Obx(() {
                return GestureDetector(
                  onTap: () => _pickImage(controller),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                      image: controller.manualClientImage.value != null
                          ? DecorationImage(
                              image: FileImage(File(controller.manualClientImage.value!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: controller.manualClientImage.value == null
                        ? Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.grey[600],
                          )
                        : null,
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Tap to add photo',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Name Field
            const Text(
              'Name *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.manualClientNameController,
              decoration: InputDecoration(
                hintText: 'Enter client name',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xff6C63FF), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Business Name Field
            const Text(
              'Business name',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.manualClientBusinessNameController,
              decoration: InputDecoration(
                hintText: 'Enter business name',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xff6C63FF), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Phone Number Field
            const Text(
              'Phone Number *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.manualClientPhoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xff6C63FF), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Email Field
            const Text(
              'Email',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.manualClientEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter email address',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xff6C63FF), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Address Field
            const Text(
              'Address',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.manualClientAddressController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter address',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xff6C63FF), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  // Validate required fields
                  if (controller.manualClientNameController.text.trim().isEmpty) {
                    Get.snackbar(
                      'Required Field',
                      'Please enter client name',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  if (controller.manualClientPhoneController.text.trim().isEmpty) {
                    Get.snackbar(
                      'Required Field',
                      'Please enter phone number',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  // Call API to create manual client
                  final success = await controller.createManualClient(
                    name: controller.manualClientNameController.text.trim(),
                    businessName: controller.manualClientBusinessNameController.text.trim(),
                    phoneNumber: controller.manualClientPhoneController.text.trim(),
                    email: controller.manualClientEmailController.text.trim(),
                    address: controller.manualClientAddressController.text.trim(),
                    imagePath: controller.manualClientImage.value,
                  );

                  if (success) {
                    // First, if controller already received server id for the created client, keep it
                    final createdClientId = controller.selectedClient['id'];

                    if (createdClientId != null && createdClientId.toString().isNotEmpty) {
                      // We already have a full client (including id) from the controller
                      final newClient = {
                        'id': controller.selectedClient['id'],
                        'name': controller.selectedClient['name'] ?? controller.manualClientNameController.text.trim(),
                        'business_name': controller.selectedClient['business_name'] ?? controller.manualClientBusinessNameController.text.trim(),
                        'phone_number': controller.selectedClient['phone_number'] ?? controller.manualClientPhoneController.text.trim(),
                        'email': controller.selectedClient['email'] ?? controller.manualClientEmailController.text.trim(),
                        'address': controller.selectedClient['address'] ?? controller.manualClientAddressController.text.trim(),
                      'image': controller.manualClientImage.value,
                    };
                    controller.selectedContacts.add(newClient);
                    controller.recentlyAddedClient.value = newClient;
                    debugPrint('✅ Manual client added to recently added');
                    Get.back();
                      return;
                    }

                    // Otherwise, try to resolve the created client from the server-side clients list by phone
                    try {
                      final clientCtrl = Get.isRegistered<ClientDetailsController>()
                          ? Get.find<ClientDetailsController>()
                          : Get.put(ClientDetailsController());
                      await clientCtrl.fetchClientsFromApi();

                      final phone = controller.manualClientPhoneController.text.trim();
                      Map<String, dynamic>? match;
                      for (var c in clientCtrl.clients) {
                        if ((c['phone_number'] ?? '').toString() == phone) {
                          match = c as Map<String, dynamic>?;
                          break;
                        }
                      }

                      if (match != null) {
                        controller.selectedClient.value = {
                          'id': match['id'],
                          'name': match['name'] ?? controller.manualClientNameController.text.trim(),
                          'business_name': match['business_name'] ?? controller.manualClientBusinessNameController.text.trim(),
                          'email': match['email'] ?? controller.manualClientEmailController.text.trim(),
                          'phone_number': match['phone_number'] ?? phone,
                          'image': controller.manualClientImage.value, // preserve local image
                        };
                        controller.selectedContacts.add(match);
                        controller.recentlyAddedClient.value = match;
                        debugPrint('✅ Manual client matched from server and added to recently added');
                        Get.back();
                        return;
                      }
                    } catch (e) {
                      // ignore - we'll fallback to adding minimal contact
                      debugPrint('⚠️ Could not resolve created client id after create: $e');
                    }

                    // Fallback: add minimal client to selectedContacts (no server id available)
                    final clientData = {
                      'name': controller.manualClientNameController.text.trim(),
                      'business_name': controller.manualClientBusinessNameController.text.trim(),
                      'phone_number': controller.manualClientPhoneController.text.trim(),
                      'email': controller.manualClientEmailController.text.trim(),
                      'address': controller.manualClientAddressController.text.trim(),
                      'image': controller.manualClientImage.value,
                    };

                    controller.selectedContacts.add(clientData);
                    controller.selectedClient.value = clientData;
                    controller.recentlyAddedClient.value = clientData;
                    debugPrint('✅ Manual client added (fallback) to recently added');
                    Get.back();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6C63FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Client',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}