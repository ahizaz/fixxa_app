import 'dart:io';
import 'package:fixxa_app/core/common/widgets/custom_button.dart';
import 'package:fixxa_app/core/common/widgets/custom_term_text.dart';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/account%20create&authentication/controller/personalization_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalizationStep2 extends StatelessWidget {
  const PersonalizationStep2({super.key});

  @override
  Widget build(BuildContext context) {
    final PersonalizationController controller =
        Get.find<PersonalizationController>();
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => LinearProgressIndicator(
                        value: controller.currentStep.value,
                        minHeight: 5,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xff3A8DFF),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    "2/2",
                    style: GoogleFonts.montserrat(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff000000),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Text(
                "Upload your business\nlogo or profile photo",
                style: GoogleFonts.urbanist(
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1C1C1C),
                ),
              ),
              SizedBox(height: 48.h),
              Center(
                child: Stack(
                  children: [
                    Obx(
                      () => Container(
                        width: 150.w,
                        height: 150.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: controller.selectedImage.value == null
                            ? const SizedBox.shrink()
                            : ClipOval(
                                child: Image.file(
                                  File(controller.selectedImage.value!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
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
                            width: 48.w,
                            height: 48.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 17.h),
              Center(
                child: Text(
                  "Muse Constructions",
                  style: GoogleFonts.urbanist(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              Spacer(),
              CustomTermsText(),
              SizedBox(height: 16.h),
              Obx(
                () => CustomButton(
                  text: "Continue",
                  color: controller.selectedImage.value == null
                      ? Color(0xffE8E8E8)
                      : Color(0xff1C1C1C),
                  onTap: controller.selectedImage.value == null
                      ? () {}
                      : () async {
                          // Submit business profile (navigation handled in controller)
                          await controller.submitBusinessProfile();
                        },
                ),
              ),
              SizedBox(height: 16.h),
              CustomButton(
                text: "Skip",
                textStyle: GoogleFonts.urbanist(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1C1C1C),
                ),
                color: Color(0xffE8E8E8),
                onTap: () {
                  Get.back();
                },
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
