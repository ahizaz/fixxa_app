import 'dart:io';
import 'dart:typed_data';

import 'package:fixxa_app/feature/invoice_creation_manually.dart/controller/invoice_manually_controller.dart';
import 'package:fixxa_app/feature/client_details/controller/client_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddInvoiceClient extends StatelessWidget {
  const AddInvoiceClient({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InvoiceManuallyController());
    final clientCtrl = Get.isRegistered<ClientDetailsController>()
      ? Get.find<ClientDetailsController>()
      : Get.put(ClientDetailsController());
    
    // Refresh client list when this screen opens to show latest clients
    // This will run every time the screen is built, ensuring new clients appear
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await clientCtrl.fetchClientsFromApi();
      // Force UI refresh after fetching
      clientCtrl.clients.refresh();
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
                    InkWell(
                      onTap: () async {
                        await controller.pickContact();
                        // Set the last picked contact as recently added
                        if (controller.selectedContacts.isNotEmpty) {
                          controller.recentlyAddedClient.value = controller.selectedContacts.last;
                        }
                        // Refresh client list after picking a contact
                        await clientCtrl.fetchClientsFromApi();
                      },
                      child: Icon(
                        Icons.add,
                        color: const Color(0xff3A8DFF),
                        size: 18.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "New Client",
                      style: GoogleFonts.urbanist(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff3A8DFF),
                      ),
                    ),
                  ],
                ),
                // Recently Added Client (shown above existing clients)
                Obx(() {
                  final recentClient = controller.recentlyAddedClient.value;
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

                  // Show contacts only if there are any
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
                          final dynamic photoData = contact['photo'];
                          final String initials = name.isNotEmpty && name.split(" ").first.isNotEmpty
                              ? name.split(" ").first[0].toUpperCase()
                              : "?";

                          // Handle photo as Uint8List (from contacts) or String (file path)
                          ImageProvider? avatarImage;
                          if (photoData != null) {
                            if (photoData is Uint8List && photoData.isNotEmpty) {
                              avatarImage = MemoryImage(photoData);
                            } else if (photoData is String && photoData.isNotEmpty) {
                              avatarImage = FileImage(File(photoData));
                            }
                          }

                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: InkWell(
                              onTap: () {
                                controller.selectedClient.value = contact;
                                Get.back();
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20.r,
                                    backgroundImage: avatarImage,
                                    backgroundColor: Colors.grey[300],
                                    child: avatarImage == null
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
