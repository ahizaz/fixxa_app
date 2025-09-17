import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/home_default_clients/controller/home_default_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LostQotes extends StatelessWidget {
  const LostQotes({super.key});

  @override
  Widget build(BuildContext context) {
       final HomeDefaultController homeController =
        Get.find<HomeDefaultController>();
    return Scaffold(
     
 appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  automaticallyImplyLeading: true, // ✅ back arrow আসবে
  centerTitle: false,
  titleSpacing: 0, 
  title: Text(
    "LostQuotes",
    style: GoogleFonts.urbanist(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      color: const Color(0xff1C1C1C),
    ),
  ),
),
body: SafeArea(child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Obx(()=>Column(
          children: List.generate(           homeController.lostquoteData.length, (index){

             final data = homeController.lostquoteData[index];
               return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xffE8E8E8),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.folder_outlined,
                              size: 24.w, color: Colors.black),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data["name"] ?? "Unknown",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff1C1C1C),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xffD94E2E),
                                        borderRadius:
                                            BorderRadius.circular(999.r),
                                      ),
                                      child: Text(
                                        "£${data["lost"] ?? 0} lost",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Center(
                            child: Image.asset(
                              IconPath.chevronright,
                              width: 24.w,
                              height: 24.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

          }),
        )),

)),
    );
  }
}