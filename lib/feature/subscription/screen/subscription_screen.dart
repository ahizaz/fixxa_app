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
                // Billing toggle ─ Monthly / Annual
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.selectBilling(0),
                        child: Obx(() => Container(
                              height: 71.h,
                              decoration: BoxDecoration(
                                color: controller.selectedBillingIndex.value == 0
                                    ? const Color(0xff1C1C1C)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: controller.selectedBillingIndex.value == 0
                                      ? const Color(0xff1C1C1C)
                                      : const Color(0xffE8E8E8),
                                  width: 1.4,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Pay monthly",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                    color: controller.selectedBillingIndex.value == 0
                                        ? Colors.white
                                        : const Color(0xff1C1C1C),
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.selectBilling(1),
                        child: Obx(() => Container(
                              height: 71.h,
                              decoration: BoxDecoration(
                                color: controller.selectedBillingIndex.value == 1
                                    ? const Color(0xff1C1C1C)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: controller.selectedBillingIndex.value == 1
                                      ? const Color(0xff1C1C1C)
                                      : const Color(0xffE8E8E8),
                                  width: 1.4,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Pay annually",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500,
                                      color: controller.selectedBillingIndex.value == 1
                                          ? Colors.white
                                          : const Color(0xff1C1C1C),
                                    ),
                                  ),
                                  Text(
                                    "save 20% £39/year",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: controller.selectedBillingIndex.value == 1
                                          ? Colors.white70
                                          : const Color(0xff434343),
                                    ),
                                  ),
                                ],
                              ),
                            )),
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
                      SizedBox(height: 4.h),
                      // Dynamic price from RevenueCat
                      Center(
                        child: Obx(() => Text(
                              controller.selectedPriceString,
                              style: GoogleFonts.urbanist(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff1C1C1C),
                              ),
                            )),
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
                                      "Continue",
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
