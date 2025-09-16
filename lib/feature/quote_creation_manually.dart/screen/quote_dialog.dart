import 'dart:ui';
import 'package:fixxa_app/feature/quote_creation_manually.dart/controller/manually_quote_controller.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/add_client.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/add_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class QuoteDialog {
  /// call this method: QuoteDialog.show(context)
  static void show(BuildContext context) {
    final ManuallyQuoteController controller = Get.put(ManuallyQuoteController());
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
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w500,
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
                      style: GoogleFonts.montserrat(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1C1C1C))),
                  SizedBox(height: 6.h),
               Obx(() {
  var client = controller.selectedClient.value;
  final String name = client['name'] ?? "";
  final String initials = name.isNotEmpty
      ? name.split(" ").first[0].toUpperCase()
      : "?";
  return InkWell(
    onTap: () {
      Get.to(() => AddClient());
    },
    child: Container(
      width: double.infinity,
      height: 64.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Color(0xffE8E8E8), width: 2),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          client.isEmpty
              ? Row(children: [
                Icon(Icons.person_add),
                SizedBox(width: 10.w,),
                Text("Add client",style: GoogleFonts.montserrat( 
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1C1C1C)

                ),)
              ],)
              : CircleAvatar(
                  radius: 20.r,
                  backgroundImage: null, // Always show initials
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
       
           SizedBox(width: 10.w),
          Text(
           name,
            style: GoogleFonts.urbanist(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
             ),
          ),
        ],
      ),
    ),
  );
}),
                  SizedBox(height: 16.h),
                  // Work input
                  Text("DESCRIPTION OF WORK",
                      style: GoogleFonts.montserrat(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1C1C1C))),
                  SizedBox(height: 6.h),
                  // InkWell(
                  //   onTap: (){
                  //     Get.to(()=>AddItem());
                  //   },
                  //   child: Container(
                  //     width: double.infinity,
                  //     height: 64.h,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10.r),
                  //       border: Border.all(color: Color(0xffE8E8E8), width: 2),
                  //       color: Colors.white,
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         Icon(Icons.add),
                  //         SizedBox(width: 8),
                  //         Text("Add item",
                  //             style: GoogleFonts.montserrat(
                  //                 fontSize: 17.sp,
                  //                 fontWeight: FontWeight.w400,
                  //                 color: Color(0xff1C1C1C))),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Obx(() {
  final items = controller.items; // Assume items is an RxList in your controller
  return Column(
    children: [
      ...items.map((item) => Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Color(0xffE8E8E8), width: 2),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(item['description'] ?? '', style: GoogleFonts.urbanist(fontSize: 16.sp))),
            Text("£${item['price'] ?? ''}", style: GoogleFonts.urbanist(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          ],
        ),
      )),
      InkWell(
        onTap: () {
          Get.to(() => AddItem());
        },
        child: Container(
          width: double.infinity,
          height: 64.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Color(0xffE8E8E8), width: 2),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.add),
              SizedBox(width: 8),
              Text("Add item",
                  style: GoogleFonts.montserrat(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff1C1C1C))),
            ],
          ),
        ),
      ),
    ],
  );
}),
                  SizedBox(height: 20.h),
                  // Totals section with background color
                  Obx(() => Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          children: [
                            _buildRow("Subtotal", "£${controller.subtotal.value}"),
                            _buildRow("Discount", "£${controller.discount.value}"),
                            _buildRow("Tax (10%)", "£${controller.tax.value}"),
                            Divider(),
                            _buildRow("Total", "£${controller.total.value}", bold: true),
                          ],
                        ),
                      )),
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
                          child: Text("Preview", style: TextStyle(color: Colors.black)),
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
                          child: Text("Save", style: TextStyle(color: Colors.white)),
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