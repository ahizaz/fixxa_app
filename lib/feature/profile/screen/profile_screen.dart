
import 'dart:io';

import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/account%20create&authentication/controller/personalization_controller.dart';
import 'package:fixxa_app/feature/business_detail.dart/screen/business_detail.dart';
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
                  ),
                  SizedBox(height: 48.h,),

                  // --- UI that reacts to the controller's state ---
                  Obx(() {
                    // While loading, show a placeholder with a loading indicator
                    if (controllerprofile.isLoading.value) {
                      return Container(
                        width: double.infinity,
                        height: 110.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Color(0xff434343)
                        ),
                        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                      );
                    }

                    // If data is loaded successfully, build the widget
                    final progressData = controllerprofile.subscriptionProgress.value;
                    if (progressData != null) {
                       return Container(
                        width: double.infinity,
                        height: 110.h,
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Color(0xff434343)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${progressData.earnedAmountDisplay} earned",
                                  style: GoogleFonts.urbanist(
                                    color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500,
                                  ),
                                ),
                                 Text(
                                  "${progressData.amountLeftDisplay} left",
                                  style: GoogleFonts.urbanist(
                                    color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Container(
                               decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                 boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff3A8DFF).withOpacity(0.7),
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                  )
                                ]
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: LinearProgressIndicator(
                                  value: progressData.progressValue,
                                  minHeight: 8.h,
                                  backgroundColor: Colors.white,
                                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff3A8DFF)),
                                ),
                              ),
                            ),
                            const Spacer(),
                             Text(
                              "Get 1 month free subscription",
                              style: GoogleFonts.urbanist(
                                color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w500,
                              ),
                            ),
                             SizedBox(height: 4.h),
                          ],
                        ),
                      );
                    }

                    // Fallback in case data is null after loading (e.g., error)
                    return SizedBox(height: 110.h, child: const Center(child: Text("Could not load data.", style: TextStyle(color: Colors.white),)));
                  }),
                  SizedBox(height: 24.h,),
                  Text("Settings",style: GoogleFonts.montserrat(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffA3A3A3)
                  ),),
                  SizedBox(height: 8.h,),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(16.r)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 23.h),
                        child: Row(
                          children: [
                            Image(image: const AssetImage(IconPath.businessdetail),height: 24.h,width: 24.w,fit: BoxFit.cover,),
                            SizedBox(width: 26.w,),
                            Text("Business Detail",style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff1C1C1C),
                              fontSize: 17.sp,
                            ),),
                            const Spacer(),
                            InkWell(onTap: (){
                              Get.to(()=>BusinessDetail());
                            },child: Image(image: const AssetImage(IconPath.chevronright),width: 24.w, height: 24.h, fit: BoxFit.cover,)),

                          ],
                        ),
                      ),
                
                       Padding(
                         padding:  EdgeInsets.symmetric(horizontal: 20.w),
                         child: Divider(height: 1, color: const Color(0xff3C435C).withOpacity(0.36),),
                       ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 23.h),
                        child: Row(
                          children: [
                            Image(image: const AssetImage(IconPath.myplan),height: 24.h,width: 24.w,fit: BoxFit.cover,),
                            SizedBox(width: 26.w,),
                            Text("My Plan",style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff1C1C1C),
                              fontSize: 17.sp,
                            ),),
                             Spacer(),
                            Image(image: const AssetImage(IconPath.chevronright),width: 24.w, height: 24.h, fit: BoxFit.cover,)
                          ],
                        ),
                      ),
                             Padding(
                         padding:  EdgeInsets.symmetric(horizontal: 20.w),
                         child: Divider(height: 1, color: const Color(0xff3C435C).withOpacity(0.36),),
                       ),
                             Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 23.h),
                        child: Row(
                          children: [
                            Image(image: const AssetImage(IconPath.bellring),height: 24.h,width: 24.w,fit: BoxFit.cover,),
                            SizedBox(width: 26.w,),
                            Text("Notification preferences",style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff1C1C1C),
                              fontSize: 17.sp,
                            ),),
                             Spacer(),
                            Image(image: const AssetImage(IconPath.chevronright),width: 24.w, height: 24.h, fit: BoxFit.cover,)
                          ],
                        ),
                      ),
                              Padding(
                         padding:  EdgeInsets.symmetric(horizontal: 20.w),
                         child: Divider(height: 1, color: const Color(0xff3C435C).withOpacity(0.36),),
                       ),
                               Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 23.h),
                        child: Row(
                          children: [
                            Image(image: const AssetImage(IconPath.stripepaymentsetup),height: 24.h,width: 24.w,fit: BoxFit.cover,),
                            SizedBox(width: 26.w,),
                            Text("Stripe payment setup",style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff1C1C1C),
                              fontSize: 17.sp,
                            ),),
                             Spacer(),
                            Image(image: const AssetImage(IconPath.chevronright),width: 24.w, height: 24.h, fit: BoxFit.cover,)
                          ],
                        ),
                      ),
                        
                      
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h,),
                  Container(
                    width: double.infinity,
                    height: 71.h,
                    decoration: BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: Row(
                      
                        children: [
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 16.w),
                            child: Image(image: AssetImage(IconPath.logout),width: 24.w,height: 24.h,fit: BoxFit.cover,),

                          ),
                          SizedBox(width: 26.w,),
                          Text("Log out",style: GoogleFonts.montserrat(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff1C1C1C)
                          ),)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}