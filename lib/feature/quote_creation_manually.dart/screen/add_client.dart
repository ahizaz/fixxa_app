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

  /// Helper method to safely extract image path from client data
  String? _getImagePath(Map<String, dynamic>? client) {
    if (client == null) return null;

    // Try 'image' field first
    final image = client['image'];
    if (image != null && image is String && image.isNotEmpty) {
      return image;
    }

    // Try 'photo' field
    final photo = client['photo'];
    if (photo != null && photo is String && photo.isNotEmpty) {
      return photo;
    }

    return null;
  }

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
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
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
                          await Get.to(() => MaualClient());
                          // Refresh client list after returning from manual client creation
                          await clientCtrl.fetchClientsFromApi();
                        } else if (value == 'contact') {
                          // Pick contact
                          await controller.pickContact();
                          // Set the last picked contact as recently added
                          if (controller.selectedContacts.isNotEmpty) {
                            controller.recentlyAddedClient.value =
                                controller.selectedContacts.last;
                          }
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
                  if (recentClient == null) return const SizedBox.shrink();

                  final String name = recentClient['name'] ?? '';
                  final String businessName =
                      recentClient['business_name'] ?? '';
                  final String email = recentClient['email'] ?? '';
                  final String initials = name.isNotEmpty
                      ? name.split(' ').first[0].toUpperCase()
                      : '?';
                  final String? imagePath = _getImagePath(recentClient);
                  final bool isNetworkImage = imagePath != null && 
                      (imagePath.startsWith('http://') || imagePath.startsWith('https://'));

                  return Padding(
                    padding: EdgeInsets.only(
                      top: 20.h,
                      left: 16.w,
                      right: 16.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
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
                              controller.recentlyAddedClient.value = null;
                              Get.back();
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xff3A8DFF),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                                color: const Color(0xff3A8DFF).withOpacity(0.05),
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30.r,
                                    backgroundImage: imagePath != null
                                        ? (isNetworkImage 
                                            ? NetworkImage(imagePath) as ImageProvider
                                            : FileImage(File(imagePath)))
                                        : null,
                                    backgroundColor: const Color(0xff3A8DFF).withOpacity(0.2),
                                    child: imagePath == null
                                        ? Text(
                                            initials,
                                            style: TextStyle(
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff3A8DFF),
                                            ),
                                          )
                                        : null,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    name,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (email.isNotEmpty)
                                    Text(
                                      email,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 13.sp,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
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
                      padding: EdgeInsets.only(
                        top: 20.h,
                        left: 16.w,
                        right: 16.w,
                      ),
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
                          ...clientCtrl.clients
                              .where((client) {
                                // Filter out recently added client to avoid duplication
                                final recentClient = controller.recentlyAddedClient.value;
                                if (recentClient != null && client['id'] != null && recentClient['id'] != null) {
                                  return client['id'] != recentClient['id'];
                                }
                                return true;
                              })
                              .map((client) {
                                final String name = client['name'] ?? '';
                                final String businessName =
                                    client['business_name'] ?? '';
                                final String email = client['email'] ?? '';
                                final String initials = name.isNotEmpty
                                    ? name.split(' ').first[0].toUpperCase()
                                    : '?';
                                final String? imagePath = _getImagePath(client);
                                final bool isNetworkImage = imagePath != null && 
                                    (imagePath.startsWith('http://') || imagePath.startsWith('https://'));

                                return Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: InkWell(
                                    onTap: () {
                                      // Set selected client in the quote controller and return
                                      controller.selectedClient.value = {
                                        'id': client['id'],
                                        'name': client['name'],
                                        'business_name':
                                            client['business_name'] ?? '',
                                        'email': client['email'],
                                        'phone_number':
                                            client['phone_number'] ?? '',
                                        'image':
                                            client['avatar'] ?? client['image'],
                                      };
                                      Get.back();
                                    },
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20.r,
                                          backgroundImage: imagePath != null
                                              ? (isNetworkImage 
                                                  ? NetworkImage(imagePath) as ImageProvider
                                                  : FileImage(File(imagePath)))
                                              : null,
                                          backgroundColor: Colors.grey[300],
                                          child: imagePath == null
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
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (businessName.isNotEmpty)
                                                Text(
                                                  businessName,
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: 17.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              Text(
                                                name,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: businessName.isNotEmpty
                                                      ? 15.sp
                                                      : 17.sp,
                                                  fontWeight: businessName.isNotEmpty
                                                      ? FontWeight.w400
                                                      : FontWeight.w600,
                                                  color: businessName.isNotEmpty
                                                      ? Colors.grey[700]
                                                      : Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              if (email.isNotEmpty)
                                                SizedBox(height: 2.h),
                                              if (email.isNotEmpty)
                                                Text(
                                                  email,
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: 13.sp,
                                                    color: Colors.grey,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                          Divider(),
                        ],
                      ),
                    );
                  }

                  // If no contacts selected, don't show this section
                  if (controller.selectedContacts.isEmpty)
                    return const SizedBox.shrink();

                  return Padding(
                    padding: EdgeInsets.only(
                      top: 10.h,
                      left: 16.w,
                      right: 16.w,
                    ),
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
                          final String initials =
                              name.isNotEmpty &&
                                  name.split(" ").first.isNotEmpty
                              ? name.split(" ").first[0].toUpperCase()
                              : "?";

                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: InkWell(
                              onTap: () async {
                                final String phoneNumber =
                                    contact['phone_number'] ?? "";

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
                                final success = await controller
                                    .importClientFromContact(
                                      name: name,
                                      phoneNumber: phoneNumber,
                                    );

                                if (success) {
                                  // Refresh client list to show newly added client
                                  await clientCtrl.fetchClientsFromApi();

                                  // Set as recently added client
                                  controller.recentlyAddedClient.value =
                                      Map<String, dynamic>.from(
                                        controller.selectedClient,
                                      );

                                  // Remove this contact from selectedContacts since it's now a proper client
                                  controller.selectedContacts.removeWhere(
                                    (c) => c['phone_number'] == phoneNumber,
                                  );

                                  // selectedClient is already set by importClientFromContact
                                  Get.back();
                                }
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20.r,
                                    backgroundImage:
                                        imagePath != null &&
                                            imagePath.isNotEmpty
                                        ? FileImage(File(imagePath))
                                        : null,
                                    backgroundColor: Colors.grey[300],
                                    child:
                                        imagePath == null || imagePath.isEmpty
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
