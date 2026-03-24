import 'package:fixxa_app/core/common/widgets/custom_button.dart';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/business_detail.dart/controller/business_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessDetail extends StatelessWidget {
  const BusinessDetail({super.key});
  @override
  Widget build(BuildContext context) {
    final BusinessController controller = Get.put(BusinessController());
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image(
                      image: const AssetImage(IconPath.cross),
                      width: 32.w,
                      height: 32.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                "Business details",
                style: GoogleFonts.urbanist(
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1C1C1C),
                ),
              ),
              SizedBox(height: 8.h),
              Obx(
                () => Container(
                  width: double.infinity,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: controller.isLoactionhasText.value
                          ? const Color(0xff3A8DFF)
                          : const Color(0xffE8E8E8),
                      width: controller.isLoactionhasText.value ? 3.w : 2.w,
                    ),
                  ),
                  child: TextField(
                    controller: controller.locationController,
                    keyboardType: TextInputType.text,
                    onTap: () {
                      controller.isLoactionFocused.value = true;
                    },
                    onTapOutside: (event) {
                      controller.isLoactionFocused.value = false;
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 16.h,
                      ),
                      border: InputBorder.none,
                      hintText: 'Location',
                      hintStyle: GoogleFonts.montserrat(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff434343),
                      ),
                      suffixIcon: controller.isLoactionhasText.value
                          ? IconButton(
                              icon: Image.asset(
                                IconPath.cross, // Use your cross icon path
                                width: 20.sp,
                                height: 20.sp,
                                fit: BoxFit.cover,
                              ),
                              onPressed: () {
                                controller.clearLocation();
                              },
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Obx(
                () => Container(
                  width: double.infinity,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: controller.phonenumberhasText.value
                          ? const Color(0xff3A8DFF)
                          : const Color(0xffE8E8E8),
                      width: controller.phonenumberhasText.value ? 3.w : 2.w,
                    ),
                  ),
                  child: TextField(
                    controller: controller.phoneNumberController,
                    keyboardType: TextInputType.number,
                    onTap: () {
                      controller.phoneNumberFocused.value = true;
                    },
                    onTapOutside: (event) {
                      controller.phoneNumberFocused.value = false;
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 16.h,
                      ),
                      border: InputBorder.none,
                      hintText: 'Phone number',
                      hintStyle: GoogleFonts.montserrat(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff434343),
                      ),
                      suffixIcon: controller.phonenumberhasText.value
                          ? IconButton(
                              icon: Image.asset(
                                IconPath.cross, // Use your cross icon path
                                width: 20.sp,
                                height: 20.sp,
                                fit: BoxFit.cover,
                              ),
                              onPressed: () {
                                controller.clearPhone();
                              },
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              // Obx(
              //   () => Container(
              //     width: double.infinity,
              //     height: 64.h,
              //     decoration: BoxDecoration(
              //       color: const Color(0xffFFFFFF),
              //       borderRadius: BorderRadius.circular(8.r),
              //       border: Border.all(
              //         color: controller.emailhasText.value
              //             ? const Color(0xff3A8DFF)
              //             : const Color(0xffE8E8E8),
              //         width: controller.emailhasText.value ? 3.w : 2.w,
              //       ),
              //     ),
              //     child: TextField(
              //       controller: controller.emailController,
              //       keyboardType: TextInputType.number,
              //       onTap: () {
              //         controller.emailFocused.value = true;
              //       },
              //       onTapOutside: (event) {
              //         controller.emailFocused.value = false;
              //         FocusScope.of(context).unfocus();
              //       },
              //       decoration: InputDecoration(
              //         contentPadding: EdgeInsets.symmetric(
              //           horizontal: 12.w,
              //           vertical: 16.h,
              //         ),
              //         border: InputBorder.none,
              //         hintText: 'Email',
              //         hintStyle: GoogleFonts.montserrat(
              //           fontSize: 17.sp,
              //           fontWeight: FontWeight.w400,
              //           color: const Color(0xff434343),
              //         ),
              //         suffixIcon: controller.emailhasText.value
              //             ? IconButton(
              //                 icon: Image.asset(
              //                   IconPath.cross, // Use your cross icon path
              //                   width: 20.sp,
              //                   height: 20.sp,
              //                   fit: BoxFit.cover,
              //                 ),
              //                 onPressed: () {
              //                   controller.clearEmail();
              //                 },
              //               )
              //             : null,
              //       ),
              //     ),
              //   ),
              // ),

              SizedBox(height: 20.h),
              Obx(
                () => CustomButton(
                  text: 'Save Changes',
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
                        Get.back();
                      }
                      : () {}, // Corrected this line
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
