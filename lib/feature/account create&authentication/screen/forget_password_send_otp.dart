import 'package:fixxa_app/core/common/widgets/custom_button.dart';
import 'package:fixxa_app/core/common/widgets/login_header.dart';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/account%20create&authentication/controller/create_account_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPasswordSendOtp extends StatelessWidget {
  const ForgetPasswordSendOtp({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateAccountController controller = Get.put(CreateAccountController());
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoginHeader(headerText: "Forget Password"),
                SizedBox(height: 20.h),
                Text(
                  "Enter your email address to receive OTP",
                  style: GoogleFonts.urbanist(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff78816C),
                  ),
                ),
                SizedBox(height: 20.h),
                // Email Field
                Obx(
                  () => Container(
                    width: double.infinity,
                    height: 64.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: controller.isCreateEmailhasText.value
                            ? const Color(0xff3A8DFF)
                            : const Color(0xffE8E8E8),
                        width: controller.isCreateEmailhasText.value ? 3.w : 2.w,
                      ),
                    ),
                    child: TextField(
                      controller: controller.createaccountemailController,
                      keyboardType: TextInputType.emailAddress,
                      onTap: () {
                        controller.isCreateEmailFocused.value = true;
                      },
                      onTapOutside: (event) {
                        controller.isCreateEmailFocused.value = false;
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 16.h,
                        ),
                        border: InputBorder.none,
                        hintText: 'Email',
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff434343),
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: const Color(0xff172601),
                          size: 20.sp,
                        ),
                        suffixIcon: controller.isCreateEmailhasText.value
                            ? IconButton(
                                icon: Image.asset(
                                  IconPath.cross,
                                  width: 20.sp,
                                  height: 20.sp,
                                  fit: BoxFit.cover,
                                ),
                                onPressed: () {
                                  controller.clearEmail();
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                // Continue Button
                Obx(
                  () => CustomButton(
                    text: 'Send OTP',
                    textStyle: TextStyle(
                      fontSize: 17.sp,
                      fontFamily: 'SFPro',
                      fontWeight: FontWeight.w600,
                      color: const Color(0xffFFFFFF),
                    ),
                    color: controller.isCreateEmailhasText.value
                        ? const Color(0xff1C1C1C)
                        : const Color(0xff1C1C1C).withValues(alpha: .33),
                    onTap: controller.isCreateEmailhasText.value
                        ? () {
                            FocusScope.of(context).unfocus();
                        
                           
                          }
                        : () {},
                  ),
                ),
                SizedBox(height: 80.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}