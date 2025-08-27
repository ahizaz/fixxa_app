import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewclientEditDetails extends StatelessWidget {
  const ViewclientEditDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8FF),
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
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
                       Spacer(),
              Image(image: AssetImage(IconPath.clienthreedots,),width: 24.w,height: 24.h,fit: BoxFit.cover,)
              ],
            ),
         

            ],
          ),
        ),
      )),
    );
  }
}