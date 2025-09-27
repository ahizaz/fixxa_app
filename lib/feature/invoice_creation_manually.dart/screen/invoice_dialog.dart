import 'dart:ui';

import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/controller/invoice_manually_controller.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/screen/add_invoice_client.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/screen/add_invoice_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class InvoiceDialog {
  static void show(BuildContext context) {
    final InvoiceManuallyController controller = Get.put(
      InvoiceManuallyController(),
    );
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3), // background dim
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // blur effect
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 24.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Obx(() => AbsorbPointer(
              absorbing: controller.showSpotlight.value || controller.showAddItemSpotlight.value || controller.showPaymentSpotlight.value || controller.showPreviewSpotlight.value,
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
                            "Invoice",
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
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // --------- Spotlight Bubble (help tooltip) -----------
                  Obx(() => controller.showSpotlight.value 
                    ? Column(
                        children: [
                          SpotlightBubble(
                            title: "Add client",
                            description: "Choose your client whom you want to send the invoice.",
                          ),
                          SizedBox(height: 8.h),
                        ],
                      )
                    : SizedBox.shrink()),

                  // Client input
                  Text(
                    "CLIENT",
                    style: GoogleFonts.montserrat(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1C1C1C),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Obx(() {
                    Map<String, dynamic> client = controller.selectedClient;
                    final String name = client['name'] ?? "";
                    final String initials = name.isNotEmpty
                        ? name.split(" ").first[0].toUpperCase()
                        : "?";
                    return InkWell(
                      onTap: () {
                        Get.to(() => AddInvoiceClient());
                      },
                      child: Container(
                        width: double.infinity,
                        height: 64.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: Color(0xffE8E8E8),
                            width: 2,
                          ),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            client.isEmpty
                                ? Row(
                                    children: [
                                      Icon(Icons.person_add),
                                      SizedBox(width: 10.w),
                                      Text(
                                        "Add client",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff1C1C1C),
                                        ),
                                      ),
                                    ],
                                  )
                                : CircleAvatar(
                                    radius: 20.r,
                                    backgroundImage:
                                        null, // Always show initials
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
                  Text(
                    "DESCRIPTION OF WORK",
                    style: GoogleFonts.montserrat(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1C1C1C),
                    ),
                  ),
                  SizedBox(height: 6.h),

                  Obx(() {
                    final items = controller
                        .items; // Assume items is an RxList in your controller
                    return Column(
                      children: [
                        ...items.map(
                          (item) => Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 8.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: Color(0xffE8E8E8),
                                width: 2,
                              ),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item['description'] ?? '',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                                Text(
                                  "£${item['price'] ?? ''}",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // --------- Add Item Spotlight Bubble -----------
                        Obx(() => !controller.showSpotlight.value && controller.showAddItemSpotlight.value 
                          ? Column(
                              children: [
                                SizedBox(height: 8.h),
                                SpotlightBubble(
                                  title: "Add Service",
                                  description: "Add services or items to your invoice.",
                                ),
                                SizedBox(height: 8.h),
                              ],
                            )
                          : SizedBox.shrink()),
                        
                        InkWell(
                          onTap: () {
                            Get.to(() => AddInvoiceItem());
                          },
                          child: Container(
                            width: double.infinity,
                            height: 64.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: Color(0xffE8E8E8),
                                width: 2,
                              ),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.add),
                                SizedBox(width: 8),
                                Text(
                                  "Add Service",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff1C1C1C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: 20.h),
                  // Totals section with background color
                  Obx(
                    () => Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        children: [
                          _buildRow(
                            "Subtotal",
                            "£${controller.subtotal.value}",
                          ),
                          _buildRow(
                            "Discount",
                            "£${controller.discount.value}",
                          ),
                          _buildRow("Tax (10%)", "£${controller.tax.value}"),
                          Divider(),
                          _buildRow(
                            "Total",
                            "£${controller.total.value}",
                            bold: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "PAYMENT METHOD",
                    style: GoogleFonts.urbanist(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff434343),
                    ),
                  ),
                  
                  // --------- Payment Spotlight Bubble -----------
                  Obx(() => !controller.showSpotlight.value && !controller.showAddItemSpotlight.value && controller.showPaymentSpotlight.value 
                    ? Column(
                        children: [
                          SizedBox(height: 8.h),
                          SpotlightBubble(
                            title: "Add payment method",
                            description: "Add a payment method so that your client can pay you through Stripe.",
                          ),
                          SizedBox(height: 8.h),
                        ],
                      )
                    : SizedBox.shrink()),
                  
                  SizedBox(height: 4.h),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor:
                            Colors.transparent, // blur কাজ করার জন্য
                        builder: (context) {
                          return BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: DraggableScrollableSheet(
                              initialChildSize: 0.8,
                              maxChildSize: 0.95,
                              minChildSize: 0.5,
                              builder: (_, controller) {
                                return Container(
                                  height: 516.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20.r),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(16.w),
                                  child: SingleChildScrollView(
                                    controller: controller,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Container(
                                            width: 40.w,
                                            height: 4.h,
                                            margin: EdgeInsets.only(
                                              bottom: 16.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Add card",
                                          style: GoogleFonts.urbanist(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
                                        // ---- Card Number ----
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText: "Card number",
                                            suffixIcon: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(width: 5.w),
                                                Image(
                                                  image: AssetImage(
                                                    IconPath.visa,
                                                  ),
                                                  width: 24.w,
                                                  height: 16.h,
                                                  fit: BoxFit.cover,
                                                ),
                                                SizedBox(width: 5.w),
                                                Image(
                                                  image: AssetImage(
                                                    IconPath.mastercard,
                                                  ),
                                                  width: 24.w,
                                                  height: 16.h,
                                                  fit: BoxFit.cover,
                                                ),
                                                SizedBox(width: 5.w),
                                                Image(
                                                  image: AssetImage(
                                                    IconPath.amex,
                                                  ),
                                                  width: 24.w,
                                                  height: 16.h,
                                                  fit: BoxFit.cover,
                                                ),
                                                SizedBox(width: 5.w),
                                                Image(
                                                  image: AssetImage(
                                                    IconPath.discover,
                                                  ),
                                                  width: 24.w,
                                                  height: 16.h,
                                                  fit: BoxFit.cover,
                                                ),
                                                SizedBox(width: 5.w),
                                              ],
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                        SizedBox(height: 12.h),
                                        // ---- Expiry & CVC ----
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  labelText: "MM / YY",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12.r,
                                                        ),
                                                  ),
                                                ),
                                                keyboardType:
                                                    TextInputType.datetime,
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  labelText: "CVC",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12.r,
                                                        ),
                                                  ),
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.h),
                                        // ---- Country ----
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText:
                                                "Billing address (Country)",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12.h),
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText: "ZIP",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                        SizedBox(height: 12.h),
                                        Row(
                                          children: [
                                            Checkbox(
                                              value: false,
                                              onChanged: (_) {},
                                            ),
                                            Text(
                                              "Save this card for future payments",
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20.h),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.r),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                vertical: 16.h,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(
                                                context,
                                              ); // close sheet after save
                                            },
                                            child: Text(
                                              "Add my card",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },

                    child: Container(
                      width: double.infinity,
                      height: 64.h,
                      decoration: BoxDecoration(
                        color: Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Row(
                          children: [
                            Text(
                              "Add payment method",
                              style: GoogleFonts.montserrat(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff1C1C1C),
                              ),
                            ),
                            Spacer(),
                            Image(
                              image: AssetImage(IconPath.leftarrow),
                              width: 24.w,
                              height: 24.h,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  
                  // --------- Preview Spotlight Bubble -----------
                  Obx(() => !controller.showSpotlight.value && !controller.showAddItemSpotlight.value && !controller.showPaymentSpotlight.value && controller.showPreviewSpotlight.value 
                    ? Column(
                        children: [
                          SpotlightBubble(
                            title: "Invoice preview",
                            description: "View the invoice in branded format.",
                          ),
                          SizedBox(height: 12.h),
                        ],
                      )
                    : SizedBox.shrink()),
                  
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
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Preview",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
          )
        );
      },
    );
  }

  static Widget _buildRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------- Spotlight Bubble Widget ----------
class SpotlightBubble extends StatelessWidget {
  final String title;
  final String description;

  const SpotlightBubble({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.urbanist(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                description,
                style: GoogleFonts.urbanist(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        // Arrow pointer
        Positioned(
          bottom: -10.h,
          left: 24.w,
          child: CustomPaint(
            size: Size(20, 10),
            painter: _BubbleArrowPainter(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _BubbleArrowPainter extends CustomPainter {
  final Color color;
  _BubbleArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
