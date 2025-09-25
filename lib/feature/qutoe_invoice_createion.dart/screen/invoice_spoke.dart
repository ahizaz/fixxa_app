import 'dart:ui' as ui;

import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/invoice_ai_generated_controller.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/invoicespeak_controller.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/invoice_ai_generated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class InvoiceSpoke extends StatelessWidget {
  const InvoiceSpoke({super.key});

 @override
  Widget build(BuildContext context) {
    final voiceCtrl = Get.put( InvoicespeakController());
    return Column(
      children: [
        SizedBox(height: 26.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffFFFFFF),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 14.h),
                  Image(
                    image: AssetImage(IconPath.lightlamp),
                    width: 24.w,
                    height: 24.h,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Tips",
                    style: GoogleFonts.urbanist(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff1C1C1C),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Client name, list and describe the item\nin details, add any other details.",
                    style: GoogleFonts.urbanist(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff1C1C1C),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Center(
                    child: Obx(() {
                      if (voiceCtrl.isRecording.value) {
                        return Column(
                          children: [
                            Container(
                              height: 60.h,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: Center(
                                child: Text(
                                  "Waveform (Recording... WAV)",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: voiceCtrl.pauseRecording,
                                  child: CircleAvatar(
                                    radius: 28.r,
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      Icons.pause,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                GestureDetector(
                                  onTap: () async {
                                    await voiceCtrl.confirmRecording();
                                    // Directly show the popup and navigate
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => BackdropFilter(
                                        filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                        child: AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.mic, size: 50),
                                              SizedBox(height: 10.h),
                                              Text(
                                                "Processing your quote...",
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                    // Wait for 2 seconds before navigating
                                    await Future.delayed(const Duration(seconds: 2));
                                    Navigator.pop(context); // Close the dialog
                                    Get.to(() => InvoiceAiGenerated()); // Navigate to next page
                                  },
                                  child: CircleAvatar(
                                    radius: 28.r,
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else if (voiceCtrl.isPaused.value) {
                        return Column(
                          children: [
                            Container(
                              height: 60.h,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: Center(
                                child: Text(
                                  "Paused",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: voiceCtrl.resumeRecording,
                                  child: CircleAvatar(
                                    radius: 28.r,
                                    backgroundColor: Colors.blue,
                                    child: Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                GestureDetector(
                                  onTap: () async {
                                    await voiceCtrl.confirmRecording();
                                    // Directly show the popup and navigate
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => BackdropFilter(
                                        filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                        child: AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.mic, size: 50),
                                              SizedBox(height: 10.h),
                                              Text(
                                                "Processing your quote...",
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                    // Wait for 2 seconds before navigating
                                    await Future.delayed(const Duration(seconds: 2));
                                    Navigator.pop(context); // Close the dialog
                                    Get.to(() => InvoiceAiGenerated()); // Navigate to next page
                                  },
                                  child: CircleAvatar(
                                    radius: 28.r,
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return GestureDetector(
                          onTap: voiceCtrl.startRecording,
                          child: CircleAvatar(
                            radius: 30.r,
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.mic,
                              color: Colors.white,
                              size: 30.sp,
                            ),
                          ),
                        );
                      }
                    }),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
