
import 'package:fixxa_app/feature/home_default_clients/widget/glow_ptogress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildStatItem({
  required double value,
  required Color color,
  required String label,
  required int count,
  VoidCallback? onTap, 
}) {
  return GestureDetector(
    onTap: onTap, 
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 48.w,
          height: 48.h,
          child: CustomPaint(
            painter: GlowingProgressPainter(value: value, color: color),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 13.sp,
            color: Color(0xffA2A2A2),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          "$count",
          style: GoogleFonts.urbanist(
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xffFFFFFF),
          ),
        ),
      ],
    ),
  );
}
