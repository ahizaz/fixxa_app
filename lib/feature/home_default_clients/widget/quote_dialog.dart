import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class QuoteDialog {
  /// call this method: QuoteDialog.show(context)
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3), // background dim
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // blur effect
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            "Quote",
                            style: GoogleFonts.urbanist(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, color: Colors.black),
                      )
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Client input
                  Text("CLIENT",
                      style: GoogleFonts.urbanist(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey)),
                  SizedBox(height: 6.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.person_outline),
                        SizedBox(width: 8),
                        Text("Add Client",
                            style: GoogleFonts.urbanist(fontSize: 16.sp)),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Work input
                  Text("DESCRIPTION OF WORK",
                      style: GoogleFonts.urbanist(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey)),
                  SizedBox(height: 6.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text("Add item",
                            style: GoogleFonts.urbanist(fontSize: 16.sp)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Totals section with background color
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100, // background color
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        _buildRow("Subtotal", "£0.0"),
                        _buildRow("Discount", "£0.0"),
                        _buildRow("Tax (10%)", "£0.0"),
                        Divider(),
                        _buildRow("Total", "£0.0", bold: true),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.grey.shade400),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r)),
                          ),
                          onPressed: () {},
                          child: Text("Preview",
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r)),
                          ),
                          onPressed: () {},
                          child: Text("Save",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Private helper for rows
  static Widget _buildRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.urbanist(
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
          Text(value,
              style: GoogleFonts.urbanist(
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
        ],
      ),
    );
  }
}
