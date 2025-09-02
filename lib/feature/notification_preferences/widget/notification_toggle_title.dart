
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationToggleTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const NotificationToggleTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style:GoogleFonts.montserrat( 
            fontSize: 17.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xff1C1C1C)
          )),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Color(0xff3A8DFF),
          ),
        ],
      ),
    );
  }
}
