import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginHeader extends StatelessWidget {
  final String headerText; // ✅ dynamic text

  const LoginHeader({super.key, required this.headerText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 7.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image(
                image: const AssetImage(IconPath.cross),
                width: 32.w,
                height: 32.h,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        SizedBox(height: 9.h),
        Center(
          child: Image(
            image: const AssetImage(ImagePath.title),
            fit: BoxFit.cover,
            height: 42.h,
          ),
        ),
        SizedBox(height: 36.h),
        Center(
          child: Text(
            headerText,
            textAlign: TextAlign.center,
            style: GoogleFonts.urbanist(
              fontWeight: FontWeight.w700,
              fontSize: 34.sp,
              color: const Color(0xff1C1C1C),
            ),
          ),
        ),
      ],
    );
  }
}
