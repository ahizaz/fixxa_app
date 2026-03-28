import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/home_default_clients/controller/home_default_controller.dart';
import 'package:fixxa_app/feature/viewquote_edit_details/screen/view_quote_edit_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Quotes extends StatelessWidget {
  const Quotes({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeDefaultController homeController =
        Get.find<HomeDefaultController>();
    return Obx(
      () {
        // Show empty state if no folders
        if (homeController.quoteData.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_outlined,
                    size: 80.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'No folders yet',
                    style: GoogleFonts.urbanist(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Create quotes and invoices to organize them in folders',
                    style: GoogleFonts.urbanist(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
        children: List.generate(
          homeController.quoteData.length > 4
              ? 4
              : homeController.quoteData.length,
          (index) {
            final data = homeController.quoteData[index];
            return InkWell(
              onTap: () {
                Get.to(() => ViewQuoteEditDetails(quoteIndex: index));
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xffE8E8E8), width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.folder_outlined,
                        size: 24.w,
                        color: Colors.black,
                      ),
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
                                color: Color(0xff1C1C1C),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            // Row(
                            //   children: [
                            //     Container(
                            //       padding: EdgeInsets.symmetric(
                            //         horizontal: 12.w,
                            //         vertical: 4.h,
                            //       ),
                            //       decoration: BoxDecoration(
                            //         color: Color(0xff0B8E5E),
                            //         borderRadius: BorderRadius.circular(999.r),
                            //       ),
                            //       child: Text(
                            //         "£${data["won"] ?? 0} won",
                            //         style: GoogleFonts.montserrat(
                            //           fontSize: 13.sp,
                            //           fontWeight: FontWeight.w400,
                            //           color: Colors.white,
                            //         ),
                            //       ),
                            //     ),
                            //     SizedBox(width: 12.w),
                            //     Container(
                            //       padding: EdgeInsets.symmetric(
                            //         horizontal: 12.w,
                            //         vertical: 4.h,
                            //       ),
                            //       decoration: BoxDecoration(
                            //         color: Color(0xffD94E2E),
                            //         borderRadius: BorderRadius.circular(999.r),
                            //       ),
                            //       child: Text(
                            //         "£${data["lost"] ?? 0} lost",
                            //         style: GoogleFonts.montserrat(
                            //           fontSize: 13.sp,
                            //           fontWeight: FontWeight.w400,
                            //           color: Colors.white,
                            //         ),
                            //       ),
                            //     ),
                            //     Spacer(),
                            //     Text(
                            //       "${data["quotes"] ?? 0} Quotes",
                            //       style: GoogleFonts.montserrat(
                            //         fontSize: 13.sp,
                            //         fontWeight: FontWeight.w500,
                            //         color: Color(0xff434343),
                            //       ),
                            //     ),
                            //   ],
                            // ),
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
              ),
            );
          },
        ),
      );
      },
    );
  }
}
