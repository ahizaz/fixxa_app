import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/quotespeak_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class QuoteSpeak extends StatelessWidget {
  const QuoteSpeak({super.key});

  @override
  Widget build(BuildContext context) {
    final voiceCtrl = Get.put(VoiceController());

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

                  // 🔥 Recording UI
                  Center(
                    child: Obx(() {
                      return voiceCtrl.isRecording.value
                          ? Column(
                              children: [
                                // waveform দেখানোর জায়গা (dummy box)
                                Container(
                                  height: 60.h,
                                  width: double.infinity,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: Text(
                                      "Waveform (Recording...)",
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),

                                // Stop & Confirm buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: voiceCtrl.stopRecording,
                                      child: CircleAvatar(
                                        radius: 28.r,
                                        backgroundColor: Colors.red,
                                        child: Icon(Icons.stop,
                                            color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 20.w),
                                    GestureDetector(
                                      onTap: voiceCtrl.confirmRecording,
                                      child: CircleAvatar(
                                        radius: 28.r,
                                        backgroundColor: Colors.green,
                                        child: Icon(Icons.check,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : voiceCtrl.recordedFilePath.value.isNotEmpty
                              ? Column(
                                  children: [
                                    Text(
                                      "Recording Saved!",
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    GestureDetector(
                                      onTap: voiceCtrl.playRecording,
                                      child: CircleAvatar(
                                        radius: 28.r,
                                        backgroundColor: Colors.blue,
                                        child: Icon(Icons.play_arrow,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                )
                              : GestureDetector(
                                  onTap: voiceCtrl.startRecording,
                                  child: CircleAvatar(
                                    radius: 30.r,
                                    backgroundColor: Colors.black,
                                    child: Icon(Icons.mic,
                                        color: Colors.white, size: 30.sp),
                                  ),
                                );
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
