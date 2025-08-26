
import 'dart:io';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/account%20create&authentication/controller/personalization_controller.dart';
import 'package:fixxa_app/feature/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final PersonalizationController controller = Get.find<PersonalizationController>();
    final ProfileController controllerprofile = Get.put(ProfileController());
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.profile),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 48.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          "My Profile",
                          style: GoogleFonts.urbanist(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xffFFFFFF)),
                        ),
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        Obx(() => Container(
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
                            )),
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
                                width: 49.w,
                                height: 50.h,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h,),
                  Center(
                    child: Text("Muse Constructions",style: GoogleFonts.urbanist(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffFFFFFF),
                    ),),
                  ),
                  SizedBox(height: 4.h,),
                  Center(
                    child: Text("Leevincent@gmail.com",style: GoogleFonts.montserrat(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffFFFFFF)
                    )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}