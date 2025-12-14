import 'dart:ui';

import 'package:fixxa_app/feature/invoice_creation_manually.dart/controller/invoice_manually_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DiscountTypeInvoiceSheet {
  static void show(BuildContext context) {
    final controller = Get.find<InvoiceManuallyController>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 402.h,
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
                  Center(
                    child: Text(
                      "Discount type",
                      style: GoogleFonts.urbanist(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff1C1C1C),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  /// Options
                  Obx(
                    () => Column(
                      children: [
                        ListTile(
                          title: Text(
                            "None",
                            style: GoogleFonts.urbanist(fontSize: 16.sp),
                          ),
                          trailing: controller.discountType.value == "None"
                              ? const Icon(Icons.check, color: Colors.blue)
                              : null,
                          onTap: () => controller.setDiscountType("None"),
                        ),
                        SizedBox(height: 16.h),
                        ListTile(
                          title: Text(
                            "Percentage (%)",
                            style: GoogleFonts.urbanist(fontSize: 16.sp),
                          ),
                          trailing:
                              controller.discountType.value == "Percentage (%)"
                              ? const Icon(Icons.check, color: Colors.blue)
                              : null,
                          onTap: () => controller.setDiscountType("Percentage (%)"),
                        ),
                        SizedBox(height: 16.h),
                        ListTile(
                          title: Text(
                            "Fixed",
                            style: GoogleFonts.urbanist(fontSize: 16.sp),
                          ),
                          trailing: controller.discountType.value == "Fixed"
                              ? const Icon(Icons.check, color: Colors.blue)
                              : null,
                          onTap: () => controller.setDiscountType("Fixed"),
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
