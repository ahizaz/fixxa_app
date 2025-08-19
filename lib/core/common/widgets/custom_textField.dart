import 'package:fixxa_app/feature/account create&authentication/controller/create_account_controller.dart';  // Fixed %20 to space
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fixxa_app/core/utils/constants/icon_path.dart'; // Assuming you have a cross icon path here

class EmailTextField extends StatelessWidget {
  const EmailTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateAccountController>();

    return Obx(() {
      return Container(
        width: double.infinity,
        height: 64.h,
        decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            // Change border color based on whether text is present
            color: controller.isCreateEmailhasText.value ? const Color(0xff3A8DFF) : const Color(0xffE8E8E8), // Example: change to a highlighted color when has text
            width: controller.isCreateEmailhasText.value?3.w:2.w,
          ),
        ),
        child: TextField(
          controller: controller.createaccountemailController,
          keyboardType: TextInputType.emailAddress,
          onTap: () {
            // Optional: Set focused if needed, though not used in the request
            controller.isCreateEmailFocused.value = true;
          },
          onTapOutside: (event) {
            // Optional: Unfocus logic if needed
            controller.isCreateEmailFocused.value = false;
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
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
      );
    });
  }
}