import 'package:fixxa_app/core/common/widgets/custom_button.dart';
import 'package:fixxa_app/core/common/widgets/custom_textField.dart';
import 'package:fixxa_app/core/common/widgets/login_header.dart';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/account create&authentication/controller/create_account_controller.dart'; // Fixed %20 to space
import 'package:fixxa_app/feature/account%20create&authentication/screen/verify_mail.dart';
import 'package:fixxa_app/feature/login/screen/login_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAccountDefault extends StatelessWidget {
  const CreateAccountDefault({super.key});
  @override
  Widget build(BuildContext context) {
    final CreateAccountController controller = Get.put(
      CreateAccountController(),
    );
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoginHeader(headerText: '90 days trial FREE'),
                SizedBox(height: 24.h),
                const EmailTextField(),
                SizedBox(height: 16.h),
                Obx(
                  () => Container(
                    height: 64.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.hasText.value
                            ? Color(0xff348DFF)
                            : const Color(0xffE8E9E6),
                        width: controller.hasText.value ? 3 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 3.h,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            IconPath.lefticon,
                            width: 24.w,
                            height: 24.h,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Obx(
                              () => TextField(
                                controller: controller.createPasswordController,
                                obscureText: controller
                                    .obsecureText
                                    .value, // Hidden when obscureText is true
                                decoration: InputDecoration(
                                  hintText: 'Create a password',
                                  hintStyle: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17.sp,
                                    color: Color(0xff434343),
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
                          ),
                          GestureDetector(
                            onTap: () {
                              controller
                                  .togglePasswordVisibility(); // Toggle visibility
                            },
                            child: Obx(
                              () => controller.obsecureText.value
                                  ? Image.asset(
                                      IconPath
                                          .passLock, // তোমার custom lock icon
                                      width: 24.w,
                                      height: 24.h,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(
                                      Icons
                                          .visibility, // visible অবস্থায় Flutter built-in icon ব্যবহার করছো
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
                    text: 'Continue',
                    textStyle: TextStyle(
                      fontSize: 17.sp,
                      fontFamily: 'SFPro',
                      fontWeight: FontWeight.w600,
                      color: const Color(0xffFFFFFF),
                    ),
                    color: controller.isFormValid
                        ? const Color(0xff1C1C1C)
                        : const Color(
                            0xff1C1C1C,
                          ).withValues(alpha: .33), // Corrected this line
                    onTap: controller.isFormValid
                        ? () {
                            controller.clearEmail();
                            controller.cleaPassword();
                            Get.to(() => VerifyMail());
                          }
                        : () {}, // Corrected this line
                  ),
                ),
                SizedBox(height: 33.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already Member?",
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff434343),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    InkWell(
                      onTap: () {
                        Get.to(() => LoginDefault());
                      },
                      child: Text(
                        "Log In",
                        style: GoogleFonts.urbanist(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff3A8DFF),
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
    );
  }
}
