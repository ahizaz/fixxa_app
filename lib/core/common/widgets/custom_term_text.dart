import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTermsText extends StatelessWidget {
  const CustomTermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'SFPro',
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xff434343),
        ),
        children: [
          const TextSpan(text: 'By continuing, you agree to our '),
          TextSpan(
            text: 'Terms of Service',
            style: TextStyle(
              fontFamily: 'SFPro',
              decoration: TextDecoration.underline,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff348DFF),
            ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(
              fontFamily: 'SFPro',
              decoration: TextDecoration.underline,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff348DFF),
            ),
          ),
        ],
      ),
    );
  }
}
