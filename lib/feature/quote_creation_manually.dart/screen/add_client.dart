import 'dart:io';

import 'package:fixxa_app/feature/quote_creation_manually.dart/controller/manually_quote_controller.dart';
import 'package:fixxa_app/feature/client_details/controller/client_details_controller.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/maual_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddClient extends StatelessWidget {
  const AddClient({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ManuallyQuoteController());
    final clientCtrl = Get.isRegistered<ClientDetailsController>()
      ? Get.find<ClientDetailsController>()
      : Get.put(ClientDetailsController());
    
    // Refresh client list when this screen opens to show latest clients
    // This will run every time the screen is built, ensuring new clients appear
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await clientCtrl.fetchClientsFromApi();
    });
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Colors.black),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "Clients",
                      style: GoogleFonts.urbanist(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff1C1C1C),
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton<String>(
                      offset: Offset(0, 40.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: const Color(0xff3A8DFF),
                            size: 18.sp,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "Add New Client",
                            style: GoogleFonts.urbanist(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff3A8DFF),
                            ),
                          ),
                        ],
                      ),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'manual',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: const Color(0xff3A8DFF),
                                size: 18.sp,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'Manual',
                                style: GoogleFonts.urbanist(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff1C1C1C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'contact',
                          child: Row(
                            children: [
                              Icon(
                                Icons.contacts,
                                color: const Color(0xff3A8DFF),
                                size: 18.sp,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'Contact',
                                style: GoogleFonts.urbanist(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff1C1C1C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (String value) async {
                        if (value == 'manual') {
                          await Get.to(()=>MaualClient());
                          // Refresh client list after returning from manual client creation
                          await clientCtrl.fetchClientsFromApi();
                        } else if (value == 'contact') {
                          // Pick contact
                          await controller.pickContact();
                          // Refresh client list after picking a contact
                          await clientCtrl.fetchClientsFromApi();
                        }
                      },
                    ),
                  ],
                ),
                // Recently Added Client (shown above existing clients)
                Obx(() {
                  final recentClient = controller.recentlyAddedClient.value;
                  debugPrint('🔍 Recently Added Client in UI: $recentClient');
                  if (recentClient == null) return const SizedBox.shrink();

                  final String name = recentClient['name'] ?? '';
                  final String email = recentClient['email'] ?? '';
                  final String initials = name.isNotEmpty ? name.split(' ').first[0].toUpperCase() : '?';

                  return Padding(
                    padding: EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: const Color(0xff3A8DFF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                'NEW',
                                style: GoogleFonts.urbanist(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xff3A8DFF),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Recently Added',
                              style: GoogleFonts.urbanist(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: InkWell(
                            onTap: () {
                              controller.selectedClient.value = recentClient;
                              // Move to existing clients
                              controller.recentlyAddedClient.value = null;
                              Get.back();
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xff3A8DFF), width: 2),
                                borderRadius: BorderRadius.circular(8.r),
                                color: const Color(0xff3A8DFF).withOpacity(0.05),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20.r,
                                    backgroundColor: const Color(0xff3A8DFF).withOpacity(0.2),
                                    child: Text(
                                      initials,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff3A8DFF),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: GoogleFonts.urbanist(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        email,
                                        style: GoogleFonts.urbanist(
                                          fontSize: 13.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  );
                }),
                // Existing clients from the app
                Obx(() {
                  if (clientCtrl.clients.isNotEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Existing clients',
                            style: GoogleFonts.urbanist(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          ...clientCtrl.clients.where((client) {
                            // Filter out recently added client to avoid duplication
                            final recentClient = controller.recentlyAddedClient.value;
                            if (recentClient != null && client['id'] != null && recentClient['id'] != null) {
                              return client['id'] != recentClient['id'];
                            }
                            return true;
                          }).map((client) {
                            final String name = client['name'] ?? '';
                            final String email = client['email'] ?? '';
                            final String initials = name.isNotEmpty ? name.split(' ').first[0].toUpperCase() : '?';

                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: InkWell(
                                onTap: () {
                                  // Clear recently added client
                                  controller.recentlyAddedClient.value = null;
                                  // Set selected client in the quote controller and return
                                  controller.selectedClient.value = {
                                    'id': client['id'],
                                    'name': client['name'],
                                    'email': client['email'],
                                    'phone_number': client['phone_number'] ?? '',
                                    'image': client['avatar'] ?? client['image'],
                                  };
                                  Get.back();
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20.r,
                                      backgroundColor: Colors.grey[300],
                                      child: Text(
                                        initials,
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: GoogleFonts.urbanist(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          email,
                                          style: GoogleFonts.urbanist(
                                            fontSize: 13.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          Divider(),
                        ],
                      ),
                    );
                  }

                  // If no contacts selected, don't show this section
                  if (controller.selectedContacts.isEmpty) return const SizedBox.shrink();

                  return Padding(
                    padding: EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'From Contacts',
                          style: GoogleFonts.urbanist(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        ...controller.selectedContacts.map((contact) {
                        final String name = contact['name'] ?? "";
                        final String? imagePath = contact['image'];
                        final String initials = name.isNotEmpty && name.split(" ").first.isNotEmpty
                            ? name.split(" ").first[0].toUpperCase()
                            : "?";

                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: InkWell(
                            onTap: () async {
                              final String phoneNumber = contact['phone_number'] ?? "";
                              
                              // Check if phone number exists
                              if (phoneNumber.isEmpty) {
                                Get.snackbar(
                                  "No Phone Number", 
                                  "This contact doesn't have a phone number",
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                                return;
                              }
                              
                              // Call API to import client from contact
                              final success = await controller.importClientFromContact(
                                name: name,
                                phoneNumber: phoneNumber,
                              );
                              
                              if (success) {
                                // Refresh client list to show newly added client
                                await clientCtrl.fetchClientsFromApi();
                                
                                // Set as recently added client
                                controller.recentlyAddedClient.value = Map<String, dynamic>.from(controller.selectedClient);
                                
                                // Remove this contact from selectedContacts since it's now a proper client
                                controller.selectedContacts.removeWhere((c) => c['phone_number'] == phoneNumber);
                                
                                // selectedClient is already set by importClientFromContact
                                Get.back();
                              }
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.r,
                                  backgroundImage: imagePath != null && imagePath.isNotEmpty
                                      ? FileImage(File(imagePath))
                                      : null,
                                  backgroundColor: Colors.grey[300],
                                  child: imagePath == null || imagePath.isEmpty
                                      ? Text(
                                          initials,
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        )
                                      : null,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  name,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      ],
                    ),
                  );
                }),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
