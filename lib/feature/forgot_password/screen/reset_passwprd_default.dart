import 'package:fixxa_app/core/common/widgets/custom_button.dart';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/forgot_password/controller/reset_passoword_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordDefault extends StatelessWidget {
  const ResetPasswordDefault({super.key});

  @override
  Widget build(BuildContext context) {
    final ResetPasswordController controller = Get.put(ResetPasswordController());
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
              Obx(() => Container(  // Wrap in Obx for reactive border
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3.h),
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
                        child: TextField(  // Removed unnecessary Obx here; moved to parent Container
                          controller: controller.createnewPassword,
                          obscureText: controller.obsecurecreatenew.value,  // This still reacts via controller's obs
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
                        child: Obx(() => controller.obsecurecreatenew.value
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
              )),
              SizedBox(height: 20.h),
              Obx(() => Container(  // Wrap in Obx for reactive border
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3.h),
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
                        child: TextField(  // Removed unnecessary Obx here; moved to parent Container
                          controller: controller.confirmnewPassword,
                          obscureText: controller.obsecureconfirmnew.value,  // This still reacts via controller's obs
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
                        child: Obx(() => controller.obsecureconfirmnew.value
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
              )),
              SizedBox(height: 24.h,),
              Obx(()=>CustomButton(text: "Save Changes",textStyle: GoogleFonts.urbanist(
             fontSize: 17.sp,
             fontWeight: FontWeight.w600,
             color: Color(0xffFFFFFF)
              ), color: controller.isFormValid?const Color(0xff1C1C1C):const Color(0xff1C1C1C).withValues(alpha: .33), onTap: controller.isFormValid
          ? () {
         
            }
          : (){},))
            ],
          ),
        ),
      ),
    );
  }
}