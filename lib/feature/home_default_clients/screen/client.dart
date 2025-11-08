import 'package:fixxa_app/feature/home_default_clients/controller/home_default_controller.dart';
import 'package:fixxa_app/feature/viewclient_edit_details/screen/viewclient_edit_details.dart';
import 'package:get/get.dart';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Client extends StatelessWidget {
  const Client({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeDefaultController homeController =
        Get.find<HomeDefaultController>();
    return Obx(
      () => Column(
        children: List.generate(homeController.clientData.length, (index) {
          final data = homeController.clientData[index];
          return InkWell(
            onTap: () {
              Get.to(() => ViewclientEditDetails(clientIndex: index));
            },
            child: Container(
              width: double.infinity,

              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xffE8E8E8), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle both network and asset images
                    CircleAvatar(
                      radius: 24.r,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: data["image"] != null && data["image"].toString().startsWith('http')
                          ? NetworkImage(data["image"]) as ImageProvider
                          : data["image"] != null
                              ? AssetImage(data["image"]) as ImageProvider
                              : null,
                      child: (data["image"] == null || data["image"].toString().isEmpty)
                          ? Text(
                              data["name"]?.toString().substring(0, 1).toUpperCase() ?? "?",
                              style: GoogleFonts.urbanist(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff1C1C1C),
                              ),
                            )
                          : null,
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data["name"],
                          style: GoogleFonts.urbanist(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1C1C1C),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          data["email"],
                          style: GoogleFonts.montserrat(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff434343),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Container(
                              width: 75.w,
                              height: 22.h,
                              decoration: BoxDecoration(
                                color: Color(0xffF2CB05),
                                borderRadius: BorderRadius.circular(999.r),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 8.w),
                                  Image(
                                    image: AssetImage(IconPath.briefcase),
                                    width: 16.w,
                                    height: 16.h,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "${data["jobCount"]} Job",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff1C1C1C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              width: 99.w,
                              height: 22.h,
                              decoration: BoxDecoration(
                                color: Color(0xff0B8E5E),
                                borderRadius: BorderRadius.circular(999.r),
                              ),
                              child: Center(
                                child: Text(
                                  "€${(data["earnings"] is double ? data["earnings"].toStringAsFixed(0) : data["earnings"])} earned",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 25.h),
                      child: Image(
                        image: AssetImage(IconPath.chevronright),
                        width: 24.w,
                        height: 24.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
