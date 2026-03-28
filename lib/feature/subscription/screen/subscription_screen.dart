import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/subscription/controller/subscription_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionController());
    return Scaffold(
      backgroundColor: const Color(0xffF8F8FF),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xff1C1C1C)),
            );
          }
          return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  "Upgrade to Fixxa pro",
                  style: GoogleFonts.urbanist(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1C1C1C),
                  ),
                ),
                SizedBox(height: 48.h),
                Text(
                  "Select a billing option",
                  style: GoogleFonts.montserrat(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff434343),
                  ),
                ),
                SizedBox(height: 16.h),
                // Custom toggle: First Fix (Monthly) / Second Fix (Yearly)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => controller.selectBilling(0),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                          'First Fix',
                          style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: controller.selectedBillingIndex.value == 0
                                ? const Color(0xff1C1C1C)
                                : const Color(0xffA0A0A0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Pill switch
                    GestureDetector(
                      onTap: () => controller.selectBilling(controller.selectedBillingIndex.value == 0 ? 1 : 0),
                      child: Container(
                        width: 74.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: const Color(0xff1C1C1C),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Obx(() {
                          final isMonthly = controller.selectedBillingIndex.value == 0;
                          return Stack(
                            children: [
                              Positioned.fill(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(width: 8.w),
                                    SizedBox(width: 8.w),
                                  ],
                                ),
                              ),
                              AnimatedPositioned(
                                duration: Duration(milliseconds: 220),
                                left: isMonthly ? 4.w : 74.w - 4.w - 28.w,
                                top: 4.h,
                                child: Container(
                                  width: 28.w,
                                  height: 28.h,
                                  decoration: BoxDecoration(
                                    color: isMonthly ? Colors.white : const Color(0xff6EBDB6),
                                    borderRadius: BorderRadius.circular(999.r),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () => controller.selectBilling(1),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          children: [
                            Text(
                              'Second Fix',
                              style: GoogleFonts.montserrat(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: controller.selectedBillingIndex.value == 1
                                    ? const Color(0xff1C1C1C)
                                    : const Color(0xffA0A0A0),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            // Save months badge when yearly selected
                            if (controller.selectedBillingIndex.value == 1)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xff6EBDB6),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  'Save 2 months',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 48.h),
                Text(
                  "Select a membership plan",
                  style: GoogleFonts.montserrat(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff434343),
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: const Color(0xffE8E8E8), width: 1),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 32.h),
                      Center(
                        child: Text(
                          "Member",
                          style: GoogleFonts.urbanist(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff1C1C1C),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Offer pill
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: const Color(0xffE6FAF6),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            'First on site offer - limited time',
                            style: GoogleFonts.montserrat(
                              fontSize: 12.sp,
                              color: const Color(0xff1C1C1C),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // Fixed prices to match screenshots
                      Center(
                        child: Obx(() {
                          final isMonthly = controller.selectedBillingIndex.value == 0;
                          if (isMonthly) {
                            return Column(
                              children: [
                                Text(
                                  '£19',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 36.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xff1C1C1C),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '£29',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14.sp,
                                        decoration: TextDecoration.lineThrough,
                                        color: const Color(0xff434343),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      '/month',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14.sp,
                                        color: const Color(0xff434343),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Save £10/mo',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14.sp,
                                        color: const Color(0xff6EBDB6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                Text(
                                  '£190',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 36.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xff1C1C1C),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '£290',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14.sp,
                                        decoration: TextDecoration.lineThrough,
                                        color: const Color(0xff434343),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      '/year',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14.sp,
                                        color: const Color(0xff434343),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Save £100',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14.sp,
                                        color: const Color(0xff6EBDB6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        }),
                      ),
                      SizedBox(height: 24.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          "Unlock premium quoting & invoicing tools – convert voice to invoices 3x faster. Cancel anytime with one tap.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      // Subscribe / Active button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Obx(() => controller.isSubscribed.value
                            ? Container(
                                width: double.infinity,
                                height: 44.h,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(999.r),
                                ),
                                child: Center(
                                  child: Text(
                                    "Active Subscription ✓",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: controller.purchaseSelected,
                                child: Container(
                                  width: double.infinity,
                                  height: 44.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff1C1C1C),
                                    borderRadius: BorderRadius.circular(999.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Start Free Trial",
                                      style: GoogleFonts.urbanist(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xffFFFFFF),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                      ),
                      SizedBox(height: 12.h),
                      // Restore purchases
                      GestureDetector(
                        onTap: controller.restorePurchases,
                        child: Text(
                          "Restore purchases",
                          style: GoogleFonts.urbanist(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff434343),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Divider(
                        height: 1,
                        color: const Color(0xffE8E8E8),
                        indent: 35,
                        endIndent: 35,
                      ),

                      SizedBox(height: 24.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage(IconPath.check),
                              width: 20.w,
                              height: 20.h,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              "Voice to invoice conversion",
                              style: GoogleFonts.urbanist(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff434343),
                              ),
                            ),
                            SizedBox(height: 10.h),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage(IconPath.check),
                              width: 20.w,
                              height: 20.h,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              "Voice to invoice conversion",
                              style: GoogleFonts.urbanist(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff434343),
                              ),
                            ),
                            SizedBox(height: 10.h),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage(IconPath.check),
                              width: 20.w,
                              height: 20.h,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              "Priority support",
                              style: GoogleFonts.urbanist(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff434343),
                              ),
                            ),
                            SizedBox(height: 10.h),
                          ],
                        ),
                      ),
                      SizedBox(height: 47.h),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
          ); // end SingleChildScrollView
        }), // end Obx
      ),
    );
  }
}
