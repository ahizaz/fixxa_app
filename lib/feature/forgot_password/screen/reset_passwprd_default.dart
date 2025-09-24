import 'dart:ui';

import 'package:fixxa_app/core/common/widgets/custom_button.dart';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/forgot_password/controller/reset_passoword_controller.dart';
import 'package:fixxa_app/feature/home_default_clients/screen/home_default_clients.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordDefault extends StatelessWidget {
  const ResetPasswordDefault({super.key});

  @override
  Widget build(BuildContext context) {
    final ResetPasswordController controller = Get.put(
      ResetPasswordController(),
    );
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(height: 14.h),
              Center(
                child: Text(
                  "Reset Password",
                  style: GoogleFonts.urbanist(
                    fontSize: 34.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1C1C1C),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Obx(
                () => Container(
                  // Wrap in Obx for reactive border
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: controller.createnewhasText.value
                          ? const Color(0xff348DFF)
                          : const Color(0xffE8E9E6),
                      width: controller.createnewhasText.value ? 3.w : 1.w,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 3.h,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          IconPath.lockicon,
                          width: 24.w,
                          height: 24.h,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: TextField(
                            // Removed unnecessary Obx here; moved to parent Container
                            controller: controller.createnewPassword,
                            obscureText: controller
                                .obsecurecreatenew
                                .value, // This still reacts via controller's obs
                            decoration: InputDecoration(
                              hintText: 'Create a new Password',
                              hintStyle: GoogleFonts.montserrat(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff434343),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(
                              fontFamily: 'SFPro',
                              fontSize: 16.sp,
                              color: const Color(0xff172601),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            controller.togglecreatenewPassVisibility();
                          },
                          child: Obx(
                            () => controller.obsecurecreatenew.value
                                ? Image.asset(
                                    IconPath.passLock,
                                    width: 24.w,
                                    height: 24.h,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    size: 24,
                                    color: Color(0xff78816C),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Obx(
                () => Container(
                  // Wrap in Obx for reactive border
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: controller.confirmnewhasText.value
                          ? const Color(0xff348DFF)
                          : const Color(0xffE8E9E6),
                      width: controller.confirmnewhasText.value ? 3.w : 1.w,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 3.h,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          IconPath.lockicon,
                          width: 24.w,
                          height: 24.h,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: TextField(
                            // Removed unnecessary Obx here; moved to parent Container
                            controller: controller.confirmnewPassword,
                            obscureText: controller
                                .obsecureconfirmnew
                                .value, // This still reacts via controller's obs
                            decoration: InputDecoration(
                              hintText: 'Confirm new password',
                              hintStyle: GoogleFonts.montserrat(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff434343),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(
                              fontFamily: 'SFPro',
                              fontSize: 16.sp,
                              color: const Color(0xff172601),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            controller.toggleconfirmnewPassVisibility();
                          },
                          child: Obx(
                            () => controller.obsecureconfirmnew.value
                                ? Image.asset(
                                    IconPath.passLock,
                                    width: 24.w,
                                    height: 24.h,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    size: 24,
                                    color: Color(0xff78816C),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Obx(
                () => CustomButton(
                  text: "Save Changes",
                  textStyle: GoogleFonts.urbanist(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffFFFFFF),
                  ),
                  color: controller.isFormValid
                      ? const Color(0xff1C1C1C)
                      : const Color(0xff1C1C1C).withValues(alpha: .33),
                  onTap: controller.isFormValid
                      ? () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                    vertical: 24.h,
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.back(); // Dismiss the dialog
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            color: Color(0xff78816C),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16.h),
                                      CircleAvatar(
                                        radius: 30.r,
                                        backgroundColor: const Color(
                                          0xffE6F5E8,
                                        ), // Light green background
                                        child: Icon(
                                          Icons.check,
                                          color: const Color(
                                            0xff34C759,
                                          ), // Darker green checkmark
                                          size: 40.sp,
                                        ),
                                      ),
                                      SizedBox(height: 24.h),
                                      Text(
                                        "Password reset successfully.",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff1C1C1C),
                                        ),
                                      ),
                                      SizedBox(height: 32.h),
                                      InkWell(
                                        onTap: () {
                                          Get.to(() => HomeDefaultClients());
                                          controller.confirmnewPassword.clear();
                                          controller.createnewPassword.clear();
                                        },
                                        child: Text(
                                          "Done",
                                          style: GoogleFonts.urbanist(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff3A8DFF),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      : () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
