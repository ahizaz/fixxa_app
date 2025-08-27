import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(

        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // আপনার কাস্টম অ্যাপ-বার
                SizedBox(
                  height: 48.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "Privacy policy",
                        style: GoogleFonts.urbanist(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff000000)),
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

                SizedBox(height: 24.h), // স্পেস

                // মূল শিরোনাম
                Text(
                  "Privacy policy",
                  style: GoogleFonts.urbanist(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff3A8DFF),
                  ),
                ),
                SizedBox(height: 8.h),

                // আপডেটের তারিখ
                Text(
                  "Updated November 27,2025",
                  style: GoogleFonts.urbanist(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 32.h),

                // সেকশনের শিরোনাম
                Text(
                  "Protecting your privacy",
                  style: GoogleFonts.urbanist(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff3A8DFF),
                  ),
                ),
                SizedBox(height: 16.h),

                // বিস্তারিত প্যারাগ্রাফ
                Text(
                  "This Privacy Policy explains how American Airlines, Inc. (\"we,\" \"us,\" \"our,\" \"American\") collects, uses, shares, and protects information both in connection with American's online and offline services, systems, websites, and apps that refer or link to this Privacy Policy (our \"Services\"), and as explained below, including without limitation, the collection and processing of personal information in connection with bookings and travel on American Airlines or flights operated by our regional carriers (for example, Envoy Air, Piedmont Airlines and PSA Airlines), as well as loyalty data collected and processed in connection with the AAdvantage® program. This Privacy Policy applies regardless of the way you interact with our Services or the type of device or other means you use to access our Services.",
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    color: Colors.grey[800],
                    height: 1.5, // লাইনগুলোর মধ্যে স্পেস
                  ),
                ),
                SizedBox(height: 24.h),

                // বুলেট পয়েন্টসহ টেক্সট
                _buildBulletPoint(
                    "Generally, the \"Services\" covered by this Privacy Policy fall into one of three categories:Services related to your reservations and travel, for bookings that include travel on American or that are made through an American owned and operated service (\"Travel Services\")"),
                SizedBox(height: 16.h),
                _buildBulletPoint(
                    "Services related to memberships or programs that you enroll in or purchase benefits from, such as the AAdvantage® or Admirals Club® programs (\"Membership Services\")"),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // বুলেট পয়েন্ট তৈরির জন্য একটি হেল্পার উইজেট
  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Text(
            "-",
            style: GoogleFonts.urbanist(
              fontSize: 15.sp,
              color: Colors.grey[800],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.urbanist(
              fontSize: 15.sp,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}