import 'package:fixxa_app/core/common/widgets/custom_button.dart';
import 'package:fixxa_app/core/common/widgets/custom_term_text.dart';
import 'package:fixxa_app/feature/account%20create&authentication/controller/personalization_controller.dart';
import 'package:fixxa_app/feature/account%20create&authentication/screen/personalization_step2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalizationStep1 extends StatelessWidget {
  const PersonalizationStep1({super.key});

  @override
  Widget build(BuildContext context) {
    final PersonalizationController controller = Get.put(PersonalizationController());

    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      resizeToAvoidBottomInset: true, // keyboard আসলে body adjust হবে
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(   // 👉 এটা যোগ করা হয়েছে
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 32.h,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() => LinearProgressIndicator(
                                value: controller.currentStep.value,
                                minHeight: 5,
                                backgroundColor: Colors.grey[300],
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff3A8DFF)),
                              )),
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          "1/2",
                          style: GoogleFonts.montserrat(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff000000)),
                        )
                      ],
                    ),
                    SizedBox(height: 34.h),
                    Text("Finish creating your\nFixxa account",
                        style: GoogleFonts.urbanist(
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff1C1C1C),
                        )),
                    SizedBox(height: 16.h),
                    Text("Tell us about you",
                        style: GoogleFonts.montserrat(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff434343),
                        )),
                    SizedBox(height: 24.h),
                    Obx(() => Container(
                          width: double.infinity,
                          height: 64.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: controller.namehasText.value
                                  ? const Color(0xff348DFF)
                                  : const Color(0xffE8E9E6),
                              width: controller.namehasText.value ? 3 : 1,
                            ),
                          ),
                          child: TextField(
                            controller: controller.nameController,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                              hintText: "Your full name",
                              hintStyle: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff78816C),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        )),
                    SizedBox(height: 16.h),
                    Obx(() => Container(
                          width: double.infinity,
                          height: 64.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: controller.businesHasText.value
                                  ? const Color(0xff348DFF)
                                  : const Color(0xffE8E9E6),
                              width: controller.businesHasText.value ? 3 : 1,
                            ),
                          ),
                          child: TextField(
                            controller: controller.businessController,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                              hintText: "Business name",
                              hintStyle: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff78816C),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        )),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Container(
                          width: 78.h,
                          height: 64.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: const Color(0xffE8E8E8),
                              width: 2.w,
                            ),
                          ),
                          child: Center(
                            child: Text("+44",
                                style: GoogleFonts.urbanist(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff434343),
                                )),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Obx(() => Container(
                                width: double.infinity,
                                height: 64.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: controller.phoneHasText.value
                                        ? const Color(0xff348DFF)
                                        : const Color(0xffE8E9E6),
                                    width: controller.phoneHasText.value ? 3 : 1,
                                  ),
                                ),
                                child: TextField(
                                  controller: controller.phoneController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 24.w, vertical: 14.h),
                                    hintText: "WhatsApp number",
                                    hintStyle: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff78816C),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              )),
                        )
                      ],
                    ),
                    const Spacer(),
                    const CustomTermsText(),
                    SizedBox(height: 16.h),
                    Obx(() => CustomButton(
                          text: 'Continue',
                          textStyle: TextStyle(
                            fontSize: 17.sp,
                            fontFamily: 'SFPro',
                            fontWeight: FontWeight.w600,
                            color: const Color(0xffFFFFFF),
                          ),
                          color: controller.isFormValid
                              ? const Color(0xff1C1C1C)
                              : const Color(0xff1C1C1C).withOpacity(0.33),
                          onTap: controller.isFormValid
                              ? () {
                                  controller.clearName();
                                  controller.clearBusinessText();
                                  controller.clearPhoneText();
                                  controller.businesHasText();
                                  controller.phoneHasText();
                                  controller.nextStep();
                                  Get.to(() => const PersonalizationStep2());
                                }
                              : () {},
                        )),
                        SizedBox(height: 25.h,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
