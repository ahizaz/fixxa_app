import 'dart:io';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/account%20create&authentication/controller/personalization_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeDefaultClients extends StatelessWidget {
  const HomeDefaultClients({super.key});

  @override
  Widget build(BuildContext context) {
    final PersonalizationController controller = Get.find<PersonalizationController>();
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      body: SafeArea(child: Padding(padding: EdgeInsets.symmetric(
        horizontal: 16.w, vertical: 16.h
      ),
      child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.only(top: 10.h),
                child: InkWell(onTap: (){
                
                },child: Image(image: AssetImage(IconPath.thereedots),fit: BoxFit.cover,width: 24.w,height: 24.h,)),
              ),
              SizedBox(width: 20.w,),
              Padding(
                padding:  EdgeInsets.only(top: 10.h),
                child: Image(image: AssetImage(ImagePath.fixxa),width: 110.w,height: 25.h,fit: BoxFit.cover,),
              ),
              Spacer(),
              Container(
                width: 137.w,
                height: 48.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(
                    width: 1,
                    color: Color(0xffE8E8E8)
                  ),
 
                ),
                child: Center(
                  child: Text("€ 14,568 earned",style: GoogleFonts.montserrat(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff1C1C1C)
                  ),),
                ),
              ),
              SizedBox(width: 8.w,),
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                border: Border.all(
                  width: 1,
                  color: Color(0xffE8E8E8),
                  
                )
                ),
                child: Obx(() => controller.selectedImage.value == null
                    ? const SizedBox.shrink()
                    : ClipOval(
                        child: Image.file(
                          File(controller.selectedImage.value!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                ),
              ),
    
         

            ],
           ),
                     SizedBox(height: 20,),
                Center(
                  child: Text("Good afternoon, Lee!",style: GoogleFonts.urbanist(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1C1C1C)
                                ),),
                ),
                SizedBox(height: 24.h,),
                Container(
                  width: double.infinity,
                  height: 191.h,
                  decoration: BoxDecoration(
                    color: Color(0xff1C1C1C),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                )
        ],
      ),
      )),
      
    );
  }
}