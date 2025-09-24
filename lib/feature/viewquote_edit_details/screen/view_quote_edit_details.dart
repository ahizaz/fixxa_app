import 'dart:ui';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/home_default_clients/controller/home_default_controller.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/quote_dialog.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/quote_creation.dart';
import 'package:fixxa_app/feature/scanner/screen/scanner_screen.dart';
import 'package:fixxa_app/feature/viewquote_edit_details/screen/edit_quote_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewQuoteEditDetails extends StatelessWidget {
  final int quoteIndex;
  const ViewQuoteEditDetails({super.key, required this.quoteIndex});
  @override
  Widget build(BuildContext context) {
    final HomeDefaultController homeController =
        Get.find<HomeDefaultController>();
    return Obx(() {
      final data = homeController.quoteData[quoteIndex];
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
                        "Quote details",
                        style: GoogleFonts.montserrat(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff3A8DFF),
                        ),
                      ),
                      const Spacer(),
                      PopupMenuButton<String>(
                        icon: Image(
                          image: const AssetImage(IconPath.clienthreedots),
                          width: 24.w,
                          height: 24.h,
                          fit: BoxFit.cover,
                        ),
                        offset: Offset(0, 48.h),
                        onSelected: (String result) {
                          if (result == 'edit') {
                            Get.to(
                              () => EditQuoteDetails(quoteIndex: quoteIndex),
                            );
                          } else if (result == 'remove') {
                            Get.dialog(
                              Stack(
                                children: [
                                  Positioned.fill(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 5.0,
                                        sigmaY: 5.0,
                                      ),
                                      child: Container(
                                        color: Colors.black.withValues(
                                          alpha: .3,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      width: 300.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        border: Border.all(
                                          color: const Color(0xffE8E8E8),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.w),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Are you sure you want to remove the client from your Fixxa account?",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.urbanist(
                                                decoration: TextDecoration.none,
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff1C1C1C),
                                              ),
                                            ),
                                            SizedBox(height: 24.h),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: Container(
                                                      height: 48.h,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                          0xff1C1C1C,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              999.r,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "No, Keep it",
                                                          style:
                                                              GoogleFonts.montserrat(
                                                                fontSize: 15.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white,
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12.w),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      homeController.quoteData
                                                          .removeAt(quoteIndex);
                                                      Get.close(2);
                                                    },
                                                    child: Container(
                                                      height: 48.h,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                          0xffD94E2E,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              999.r,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Yes, Remove",
                                                          style:
                                                              GoogleFonts.montserrat(
                                                                fontSize: 15.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white,
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              barrierDismissible: false,
                              barrierColor: Colors.transparent,
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Image(
                                      image: AssetImage(IconPath.penline),
                                      width: 24.w,
                                      height: 24.h,
                                      fit: BoxFit.cover,
                                      color: Color(0xff3ABDFF),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      'Edit client details',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff434343),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'remove',
                                child: Row(
                                  children: [
                                    Image(
                                      image: AssetImage(IconPath.trash),
                                      width: 18.w,
                                      height: 20.h,
                                      fit: BoxFit.cover,
                                      color: Color(0xffD94E2E),
                                    ),
                                    SizedBox(width: 18.w),
                                    Text(
                                      'Delete folder',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff1C1C1C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        color: const Color(0xffF2F2F2),
                        elevation: 8,
                      ),
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
                          backgroundImage: AssetImage(data["image"]),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          data["name"],
                          style: GoogleFonts.urbanist(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xffFFFFFF),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          data["email"],
                          style: GoogleFonts.montserrat(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xffFFFFFF),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          data["phone"],
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
                    "Quotes (${data["quotes"]})",
                    style: GoogleFonts.urbanist(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff1C1C1C),
                    ),
                  ),
                  _buildJobItem(
                    "Plumbing",
                    "London, UK",
                    "17 Mar, 2025",
                    "Pending",
                    "£120 earned",
                  ),
                  _buildJobItem(
                    "Plumbing",
                    "London, UK",
                    "17 Mar, 2025",
                    "Won",
                    "£240 earned",
                  ),
                  _buildJobItem(
                    "Electric service",
                    "London, UK",
                    "17 Mar, 2025",
                    "Lost",
                    "£99 earned",
                  ),
                  _buildJobItem(
                    "Electric service",
                    "London, UK",
                    "17 Mar, 2025",
                    "Lost",
                    "£99 earned",
                  ),
                  SizedBox(height: 34.h),

                  SizedBox(
                    width: double.infinity,
                    height: 94.h,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(ImagePath.mainbutton),
                          fit: BoxFit.contain,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 30),
                              Builder(
                                builder: (context) {
                                  return InkWell(
                                    onTap: () async {
                                      final RenderBox box =
                                          context.findRenderObject()
                                              as RenderBox;
                                      final Offset position = box.localToGlobal(
                                        Offset.zero,
                                      );

                                      final result = await showMenu<String>(
                                        context: context,
                                        color: const Color(0xffF2F2F2),
                                        position: RelativeRect.fromLTRB(
                                          position.dx,
                                          position.dy - 120,
                                          position.dx + 100,
                                          0,
                                        ),
                                        items: [
                                          PopupMenuItem(
                                            value: 'quote',
                                            child: Row(
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                    IconPath.createquote,
                                                  ),
                                                  height: 24.h,
                                                  width: 24.w,
                                                  fit: BoxFit.cover,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "Create Quote",
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: 17.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(
                                                      0xff1C1C1C,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'invoice',
                                            child: Row(
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                    IconPath.createinvoice,
                                                  ),
                                                  height: 24.h,
                                                  width: 24.w,
                                                  fit: BoxFit.cover,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "Create Invoice",
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: 17.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(
                                                      0xff1C1C1C,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );

                                      if (result == 'quote') {
                                        QuoteDialog.show(context);
                                      } else if (result == 'invoice') {}
                                    },
                                    child: Image.asset(
                                      IconPath.plus,
                                      width: 24.w,
                                      height: 24.h,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 20),
                              InkWell(
                                onTap: () {
                                  Get.to(() => ScannerScreen());
                                },
                                child: Image.asset(
                                  IconPath.scantext,
                                  width: 24.w,
                                  height: 24.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: InkWell(
                              onTap: () {
                                showCustomDialog(context);
                              },
                              child: Image.asset(
                                IconPath.voiceai,
                                width: 56.w,
                                height: 56.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildJobItem(
    String service,
    String location,
    String date,
    String status,
    String earnings,
  ) {
    Color statusBackgroundColor;
    switch (status) {
      case "Pending":
        statusBackgroundColor = const Color(0xffCA9846); // Yellow for Pending
        break;
      case "Won":
        statusBackgroundColor = const Color(0xffF2CB05); // Green for Won
        break;
      case "Lost":
        statusBackgroundColor = const Color(0xffD94E2E); // Red for Lost
        break;
      default:
        statusBackgroundColor = const Color(0xff0B8E5E); // Default green
    }

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
              Image(
                image: const AssetImage(IconPath.flag),
                width: 12.w,
                height: 12.h,
              ),
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
              Image(
                image: const AssetImage(IconPath.clock),
                width: 16.w,
                height: 16.h,
              ),
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
                  color:
                      statusBackgroundColor, // Use the dynamically determined color
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
