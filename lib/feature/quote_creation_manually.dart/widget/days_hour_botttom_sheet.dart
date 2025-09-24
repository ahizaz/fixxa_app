import 'dart:ui';

import 'package:fixxa_app/feature/quote_creation_manually.dart/controller/manually_quote_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DaysHourBotttomSheet {
  static void show(BuildContext context) {
    final controller = Get.find<ManuallyQuoteController>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 276.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  /// Options
                  Obx(
                    () => Column(
                      children: [
                        ListTile(
                          title: Text(
                            "Days",
                            style: GoogleFonts.urbanist(fontSize: 16.sp),
                          ),
                          trailing: controller.dayhour.value == "Days"
                              ? const Icon(Icons.check, color: Colors.blue)
                              : null,
                          onTap: () => controller.dayhour.value = "Days",
                        ),
                        ListTile(
                          title: Text(
                            "Hours",
                            style: GoogleFonts.urbanist(fontSize: 16.sp),
                          ),
                          trailing: controller.dayhour.value == "Hours"
                              ? const Icon(Icons.check, color: Colors.blue)
                              : null,
                          onTap: () => controller.dayhour.value = "Hours",
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 46.h),

                  /// Done Button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: const Color(0xff1C1C1C),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: Text(
                          "Done",
                          style: GoogleFonts.urbanist(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
