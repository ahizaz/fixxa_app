import 'package:fixxa_app/core/common/widgets/custom_button.dart';
import 'package:fixxa_app/core/common/widgets/login_header.dart';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/forgot_password/screen/email_forgot_verfication.dart';
import 'package:fixxa_app/feature/home_default_clients/screen/home_default_clients.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:fixxa_app/feature/login/widget/custom_login_email_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginDefault extends StatelessWidget {
  const LoginDefault({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ),
          child: SingleChildScrollView(
            // ✅ this makes the page scrollable when keyboard opens
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoginHeader(headerText: "Welcome back!"),
                SizedBox(height: 24.h),
                CustomLoginEmailField(),
                SizedBox(height: 20.h),
                Obx(
                  () => Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.hasText.value
                            ? const Color(0xff348DFF)
                            : const Color(0xffE8E9E6),
                        width: controller.hasText.value ? 3 : 1,
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
                            IconPath.lock,
                            width: 24.w,
                            height: 24.h,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Obx(
                              () => TextField(
                                controller: controller.loginPasswordController,
                                obscureText: controller.obsecureText.value,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    fontFamily: 'SFPro',
                                    fontSize: 16.sp,
                                    color: Colors.grey,
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
                              controller.togglePasswordVisibility();
                            },
                            child: Obx(
                              () => controller.obsecureText.value
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
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => EmailForgotVerfication());
                    },
                    child: Text(
                      "Forget Password",
                      style: GoogleFonts.urbanist(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff3A8DFF),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
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
                        : const Color(0xff1C1C1C).withValues(alpha: .33),
                    onTap: controller.isFormValid
                        ? () {
                            Get.to(() => HomeDefaultClients());
                          }
                        : () {},
                  ),
                ),
                // ✅ extra space for keyboard push
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
