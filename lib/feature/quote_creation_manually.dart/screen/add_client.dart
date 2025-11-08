import 'package:fixxa_app/feature/quote_creation_manually.dart/controller/manually_quote_controller.dart';
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
                      onSelected: (String value) {
                        if (value == 'manual') {
                         Get.to(()=>MaualClient());
                        } else if (value == 'contact') {
                          // Pick contact
                          controller.pickContact();
                        }
                      },
                    ),
                  ],
                ),
                Obx(() {
                  if (controller.selectedContacts.isNotEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: 20.h, left: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.selectedContacts.map((contact) {
                          final String name = contact['name'] ?? "";
                          final String initials = name.isNotEmpty
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
                                  // Set selected client and go back
                                  controller.selectedClient.value = contact;
                                  Get.back();
                                }
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20.r,
                                    backgroundImage:
                                        null, // Force initials display
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
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
