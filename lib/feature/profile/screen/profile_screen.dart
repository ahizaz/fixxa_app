import 'dart:io';
import 'dart:ui';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/account%20create&authentication/controller/personalization_controller.dart';
import 'package:fixxa_app/feature/business_detail.dart/screen/business_detail.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:fixxa_app/feature/login/screen/login_default.dart';
import 'package:fixxa_app/feature/notification_preferences/screen/notification_screen.dart';
import 'package:fixxa_app/feature/profile/controller/profile_controller.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/controller/invoice_manually_controller.dart';
import 'package:fixxa_app/feature/subscription/screen/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Ensure PersonalizationController is available (use Get.put to create if not exists)
    final PersonalizationController controller =
        Get.put(PersonalizationController());
    final ProfileController controllerprofile = Get.put(ProfileController());
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.profile),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 48.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          "My Profile",
                          style: GoogleFonts.urbanist(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xffFFFFFF),
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Image(
                                image: const AssetImage(IconPath.backicon),
                                width: 18.w,
                                height: 24.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "Back",
                              style: GoogleFonts.montserrat(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff3A8DFF),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Center(
                    child: Stack(
                      children: [
                        Obx(
                          () {
                            // Check if image exists in PersonalizationController
                            final hasImage = controller.selectedImage.value != null;
                            
                            return Container(
                              width: 150.w,
                              height: 150.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: hasImage
                                  ? ClipOval(
                                      child: Image.file(
                                        File(
                                          controller.selectedImage.value!.path,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            );
                          },
                        ),
                        Positioned(
                          bottom: -8,
                          right: -8,
                          child: GestureDetector(
                            onTap: () => controller.pickImage(),
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              child: Image(
                                image: AssetImage(IconPath.camera),
                                fit: BoxFit.cover,
                                width: 49.w,
                                height: 50.h,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: Obx(() {
                      // Show loading or actual business name
                      if (controllerprofile.isProfileLoading.value) {
                        return Text(
                          "Loading...",
                          style: GoogleFonts.urbanist(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffFFFFFF),
                          ),
                        );
                      }
                      return Text(
                        controllerprofile.businessName.value.isEmpty
                            ? "Business Name"
                            : controllerprofile.businessName.value,
                        style: GoogleFonts.urbanist(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffFFFFFF),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 4.h),
                  Center(
                    child: Obx(() {
                      // Show loading or actual email
                      if (controllerprofile.isProfileLoading.value) {
                        return Text(
                          "Loading...",
                          style: GoogleFonts.montserrat(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffFFFFFF),
                          ),
                        );
                      }
                      return Text(
                        controllerprofile.userEmail.value.isEmpty
                            ? "email@example.com"
                            : controllerprofile.userEmail.value,
                        style: GoogleFonts.montserrat(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffFFFFFF),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 48.h),

                  // --- UI that reacts to the controller's state ---
                  Obx(() {
                    // While loading, show a placeholder with a loading indicator
                    if (controllerprofile.isLoading.value) {
                      return Container(
                        width: double.infinity,
                        height: 110.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Color(0xff434343),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                    }

                    // If data is loaded successfully, build the widget
                    final progressData =
                        controllerprofile.subscriptionProgress.value;
                    if (progressData != null) {
                      return Container(
                        width: double.infinity,
                       
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Color(0xff434343),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${progressData.earnedAmountDisplay} earned",
                                  style: GoogleFonts.urbanist(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                // Text(
                                //   "${progressData.amountLeftDisplay} left",
                                //   style: GoogleFonts.urbanist(
                                //     color: Colors.white,
                                //     fontSize: 14.sp,
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xff3A8DFF,
                                    ).withValues(alpha: .7),
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: LinearProgressIndicator(
                                  value: progressData.progressValue,
                                  minHeight: 8.h,
                                  backgroundColor: Colors.white,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Color(0xff3A8DFF),
                                      ),
                                ),
                              ),
                            ),
                            // const Spacer(),
                            // Text(
                            //   "You have unlocked £ 10 of your next month subscription",
                            //   style: GoogleFonts.urbanist(
                            //     color: Colors.white,
                            //     fontSize: 14.sp,
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // ),
                            // SizedBox(height: 4.h),
                          ],
                        ),
                      );
                    }

                    // Fallback in case data is null after loading (e.g., error)
                    return SizedBox(
                      height: 110.h,
                      child: const Center(
                        child: Text(
                          "Could not load data.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 24.h),
                  Text(
                    "Settings",
                    style: GoogleFonts.montserrat(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffA3A3A3),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: 16.w,
                        //     vertical: 23.h,
                        //   ),
                        //   child: Row(
                        //     children: [
                        //       Image(
                        //         image: const AssetImage(
                        //           IconPath.businessdetail,
                        //         ),
                        //         height: 24.h,
                        //         width: 24.w,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       SizedBox(width: 26.w),
                        //       Text(
                        //         "Business Detail",
                        //         style: GoogleFonts.montserrat(
                        //           fontWeight: FontWeight.w400,
                        //           color: const Color(0xff1C1C1C),
                        //           fontSize: 17.sp,
                        //         ),
                        //       ),
                        //       const Spacer(),
                        //       InkWell(
                        //         onTap: () {
                        //           Get.to(() => BusinessDetail());
                        //         },
                        //         child: Image(
                        //           image: const AssetImage(
                        //             IconPath.chevronright,
                        //           ),
                        //           width: 24.w,
                        //           height: 24.h,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Divider(
                            height: 1,
                            color: const Color(
                              0xff3C435C,
                            ).withValues(alpha: .36),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await Get.to(() => const SubscriptionScreen());
                            // Refresh subscription status when returning
                            controllerprofile.refreshSubscription();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 23.h,
                            ),
                            child: Row(
                              children: [
                                Image(
                                  image: const AssetImage(IconPath.myplan),
                                  height: 24.h,
                                  width: 24.w,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(width: 26.w),
                                Text(
                                  "My Plan",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff1C1C1C),
                                    fontSize: 17.sp,
                                  ),
                                ),
                                const Spacer(),
                                // Subscription status badge
                                Obx(() => Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 3.h,
                                      ),
                                      margin: EdgeInsets.only(right: 8.w),
                                      decoration: BoxDecoration(
                                        color: controllerprofile.isSubscribed.value
                                            ? const Color(0xff1C1C1C)
                                            : const Color(0xffE8E8E8),
                                        borderRadius: BorderRadius.circular(99.r),
                                      ),
                                      child: Text(
                                        controllerprofile.isSubscribed.value
                                            ? "Pro"
                                            : "Free",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: controllerprofile.isSubscribed.value
                                              ? Colors.white
                                              : const Color(0xff434343),
                                        ),
                                      ),
                                    )),
                                Image(
                                  image: const AssetImage(IconPath.chevronright),
                                  width: 24.w,
                                  height: 24.h,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Divider(
                            height: 1,
                            color: const Color(
                              0xff3C435C,
                            ).withValues(alpha: .36),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: 16.w,
                        //     vertical: 23.h,
                        //   ),
                        //   child: Row(
                        //     children: [
                        //       Image(
                        //         image: const AssetImage(IconPath.bellring),
                        //         height: 24.h,
                        //         width: 24.w,
                        //         fit: BoxFit.cover,
                        //       ),
                        //       SizedBox(width: 26.w),
                        //       Text(
                        //         "Notification preferences",
                        //         style: GoogleFonts.montserrat(
                        //           fontWeight: FontWeight.w400,
                        //           color: const Color(0xff1C1C1C),
                        //           fontSize: 17.sp,
                        //         ),
                        //       ),
                        //       Spacer(),
                        //       InkWell(
                        //         onTap: () {
                        //           Get.to(() => NotificationScreen());
                        //         },
                        //         child: Image(
                        //           image: const AssetImage(
                        //             IconPath.chevronright,
                        //           ),
                        //           width: 24.w,
                        //           height: 24.h,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Divider(
                            height: 1,
                            color: const Color(
                              0xff3C435C,
                            ).withValues(alpha: .36),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 23.h,
                          ),
                          child: Row(
                            children: [
                              Image(
                                image: const AssetImage(
                                  IconPath.stripepaymentsetup,
                                ),
                                height: 24.h,
                                width: 24.w,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 26.w),
                              Text(
                                "Stripe payment setup",
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff1C1C1C),
                                  fontSize: 17.sp,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  final controller = Get.put(InvoiceManuallyController());
                                  controller.connectWithStripe();
                                },
                                child: Image(
                                  image: const AssetImage(
                                    IconPath.chevronright,
                                  ),
                                  width: 24.w,
                                  height: 24.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  InkWell(
                    onTap: () {
                      Get.dialog(
                        Stack(
                          children: [
                            Positioned.fill(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 5.0,
                                  sigmaY: 5.0,
                                ),
                                child: Container(
                                  color: Colors.black.withValues(alpha: .3),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: double.infinity,
                                height: 214.h,
                                margin: EdgeInsets.all(
                                  16.w,
                                ), // চারপাশে কিছু gap
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: const Color(0xffE8E8E8),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 24.h),
                                      Center(
                                        child: Image(
                                          image: AssetImage(
                                            IconPath.logoutproject,
                                          ),
                                          width: 48.w,
                                          height: 48.h,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(height: 24.h),
                                      Center(
                                        child: Text(
                                          "Do you want to log out?",
                                          style: TextStyle(
                                            fontSize: 17.sp,
                                            fontFamily: "SFPro",
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff172601),
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 24.h),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () async {
                                                // Remove token and navigate to login
                                                await LoginController.removeAccessToken();
                                                Get.back(); // Close dialog
                                                Get.offAll(() => const LoginDefault()); // Navigate to login and clear navigation stack
                                              },
                                              child: Container(
                                                height: 48.h,
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xffD94E2E,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        999.r,
                                                      ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Log out",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Container(
                                                height: 48.h,
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xffEDEEE6,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        999.r,
                                                      ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "No, keep me logged in",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Color(
                                                            0xff172601,
                                                          ),
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        barrierDismissible: false,
                        barrierColor: Colors.transparent,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 71.h,
                      decoration: BoxDecoration(
                        color: Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Image(
                                image: AssetImage(IconPath.logout),
                                width: 24.w,
                                height: 24.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 26.w),
                            Text(
                              "Log out",
                              style: GoogleFonts.montserrat(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff1C1C1C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
