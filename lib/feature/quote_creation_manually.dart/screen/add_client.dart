import 'dart:typed_data';

import 'package:fixxa_app/feature/quote_creation_manually.dart/controller/manually_quote_controller.dart';
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
                    InkWell(
                      onTap: controller.pickContact,
                      child: Icon(Icons.add,
                          color: const Color(0xff3A8DFF), size: 18.sp),
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
                Obx(() {
                  if (controller.selectedContacts.isNotEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: 20.h, left: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.selectedContacts.map((contact) {
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
                                    backgroundImage: contact['photo'] != null
                                        ? MemoryImage(contact['photo'] as Uint8List)
                                        : null,
                                    backgroundColor: Colors.grey[300],
                                    child: contact['photo'] == null
                                        ? Text(
                                            contact['name'].isNotEmpty
                                                ? contact['name'][0]
                                                : '',
                                            style: TextStyle(fontSize: 18.sp),
                                            textAlign: TextAlign.center,
                                          )
                                        : null,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    contact['name'],
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