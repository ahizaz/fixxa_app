import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpotlightPlusButton extends StatelessWidget {
  final bool showSpotlight;
  final VoidCallback? onTap;

  const SpotlightPlusButton({
    Key? key,
    required this.showSpotlight,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget button = showSpotlight
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurpleAccent.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 12,
                ),
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 22,
                ),
              ],
              border: Border.all(
                color: Colors.deepPurpleAccent.withOpacity(0.8),
                width: 2,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue.shade50,
                ),
                child: Center(
                  child: Text(
                    "+",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          )
        : InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Center(
              child: Image.asset(
                IconPath.plus,
                width: 24.w,
                height: 24.h,
                fit: BoxFit.cover,
              ),
            ),
          );

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topLeft,
      children: [
        if (showSpotlight)
          Positioned(
            left: 0,
            top: -60.h,
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Getting started",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Click the plus (+) icon first.",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        button,
      ],
    );
  }
}