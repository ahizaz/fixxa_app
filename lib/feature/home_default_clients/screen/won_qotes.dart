import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/home_default_clients/controller/home_default_controller.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/screen/invoice_dialog.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/quote_dialog.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/quote_creation.dart';
import 'package:fixxa_app/feature/scanner/screen/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WonQotes extends StatelessWidget {
  const WonQotes({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeDefaultController homeController =
        Get.find<HomeDefaultController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          "WonQuotes",
          style: GoogleFonts.urbanist(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff1C1C1C),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Obx(
            () => Column(
              children: List.generate(homeController.wonquoteData.length, (
                index,
              ) {
                final data = homeController.wonquoteData[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xffE8E8E8),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.folder_outlined,
                          size: 24.w,
                          color: Colors.black,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data["name"] ?? "Unknown",
                                style: GoogleFonts.urbanist(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff1C1C1C),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff0B8E5E),
                                      borderRadius: BorderRadius.circular(
                                        999.r,
                                      ),
                                    ),
                                    child: Text(
                                      "£${data["won"] ?? 0} won",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SizedBox(
          width: double.infinity,
          height: 94.h + 60.h,
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
                                context.findRenderObject() as RenderBox;
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
                                        image: AssetImage(IconPath.createquote),
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
                                          color: const Color(0xff1C1C1C),
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
                                          color: const Color(0xff1C1C1C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );

                            if (result == 'quote') {
                              QuoteDialog.show(context);
                            } else if (result == 'invoice') {
                              InvoiceDialog.show(context);
                            }
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
      ),

      /// --- Fixed Bottom Button Section ---
    );
  }
}
