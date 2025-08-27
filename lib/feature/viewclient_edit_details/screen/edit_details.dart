import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditDetails extends StatelessWidget {
  const EditDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    "Edit",
                    style: GoogleFonts.montserrat(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff3A8DFF),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h,),
              Text("Client details",style: GoogleFonts.urbanist(
                fontSize: 34.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff000000)
              ),),
              SizedBox(height: 36.h,),
              

        ],
      ),
      )),
    );
  }
}