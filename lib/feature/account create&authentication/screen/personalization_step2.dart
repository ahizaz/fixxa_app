import 'package:fixxa_app/feature/account%20create&authentication/controller/personalization_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalizationStep2 extends StatelessWidget {
  const PersonalizationStep2({super.key});

  @override
  Widget build(BuildContext context) {
    final PersonalizationController controller = Get.find<PersonalizationController>();
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
                    child: Obx(() => LinearProgressIndicator(
                          value: controller.currentStep.value,
                          minHeight: 5,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff3A8DFF)),
                        )),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    "2/2",
                    style: GoogleFonts.montserrat(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff000000)),
                  )
                ],
              ),
              // Add Step2 content here as needed
            ],
          ),
        ),
      ),
    );
  }
}