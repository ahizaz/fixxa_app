
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewclientEditDetails extends StatelessWidget {
  // 1. Declare a final variable to hold the client data
  final Map<String, dynamic> clientData;

  // 2. Update the constructor to require clientData
  const ViewclientEditDetails({super.key, required this.clientData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 48.h,
                      child: Stack(
                        alignment: Alignment.centerLeft, // Align "Client" to the left
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
                                "Client", // This should probably be "My Profile" as per the initial design, or dynamic
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
                    const Spacer(),
                    Image(
                      image: const AssetImage(IconPath.clienthreedots),
                      width: 24.w,
                      height: 24.h,
                      fit: BoxFit.cover,
                    )
                  ],
                ),
                SizedBox(height: 24.h),
                Container(
                  width: double.infinity,
                  height: 188.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage(ImagePath.backgroundContainer),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        backgroundImage: AssetImage(clientData["image"]), // Use client's image
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        clientData["name"], // Use client's name
                        style: GoogleFonts.urbanist(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xffFFFFFF),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        clientData["email"], // Use client's email
                        style: GoogleFonts.montserrat(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffFFFFFF),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "+44 1234 567896", // Assuming a static phone number for now, or add to clientData
                        style: GoogleFonts.montserrat(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffFFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "Jobs (${clientData["jobCount"]})", // Display job count
                  style: GoogleFonts.urbanist(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff1C1C1C),
                  ),
                ),
                // Here you would typically loop through and display the actual job list
                // For demonstration, let's create a placeholder similar to your second image
                _buildJobItem("Plumbing", "London, UK", "17 Mar, 2025", "Success", "£120 earned"),
                _buildJobItem("Plumbing", "London, UK", "17 Mar, 2025", "Success", "£240 earned"),
                _buildJobItem("Electric service", "London, UK", "17 Mar, 2025", "Success", "£99 earned"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to build a job item
  Widget _buildJobItem(String service, String location, String date, String status, String earnings) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xffE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service,
            style: GoogleFonts.urbanist(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff1C1C1C),
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Image(image:  AssetImage(IconPath.flag), width: 12.w, height: 12.h),
              SizedBox(width: 4.w),
              Text(
                location,
                style: GoogleFonts.montserrat(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff434343),
                ),
              ),
              SizedBox(width: 12.w),
              const Icon(Icons.circle, size: 6, color: Color(0xffBDBDBD)),
              SizedBox(width: 12.w),
              Image(image:  AssetImage(IconPath.clock), width: 16.w, height: 16.h),
              SizedBox(width: 4.w),
              Text(
                date,
                style: GoogleFonts.montserrat(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff434343),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xff0B8E5E),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.montserrat(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xffFFFFFF),
                  ),
                ),
              ),
              Text(
                earnings,
                style: GoogleFonts.montserrat(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff3A8DFF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}