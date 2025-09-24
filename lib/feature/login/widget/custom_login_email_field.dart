import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomLoginEmailField extends StatelessWidget {
  const CustomLoginEmailField({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    return Obx(
      () => Container(
        width: double.infinity,
        height: 64.h,
        decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: controller.isLoginEmailhasText.value
                ? const Color(0xff3A8DFF)
                : const Color(0xffE8E8E8),
            width: controller.isLoginEmailhasText.value ? 3.w : 2.w,
          ),
        ),
        child: TextField(
          controller: controller.loginEmailCOntroller,
          keyboardType: TextInputType.emailAddress,
          onTap: () {
            controller.isLoginEmailFocuesd.value = true;
          },
          onTapOutside: (event) {
            controller.isLoginEmailFocuesd.value = false;
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
            suffixIcon: controller.isLoginEmailhasText.value
                ? IconButton(
                    icon: Image.asset(
                      IconPath.cross, // Use your cross icon path
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
    );
  }
}
