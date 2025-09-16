import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/quote_dialog.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/quote_creation.dart';
import 'package:fixxa_app/feature/scanner/screen/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class Invoices extends StatelessWidget {
  const Invoices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   backgroundColor: Color(0xffFFFFFF),
   body: SafeArea(child: SingleChildScrollView(
    child: Padding(padding:EdgeInsets.symmetric(horizontal: 6.w),
    child: Column(
       mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
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
                      const Spacer(),
                      Icon(Icons.add, color: const Color(0xff3A8DFF), size: 18.sp),
                      SizedBox(width: 10.w),
                      Text(
                        "Add Contact",
                        style: GoogleFonts.urbanist(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff3A8DFF),
                        ),
                      ),
                    ],
                  ),
                ),
                    Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
                  child: Text(
                    "Invoices",
                    style: GoogleFonts.urbanist(
                      fontSize: 34.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff1C1C1C),
                    ),
                  ),
                ),
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
                            Builder(builder: (context) {
                              return InkWell(
                                onTap: () async {
                                  final RenderBox box = context.findRenderObject() as RenderBox;
                                  final Offset position = box.localToGlobal(Offset.zero);

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
                                              image: AssetImage(IconPath.createinvoice),
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
                                  } else if (result == 'invoice') {}
                                },
                                child: Image.asset(
                                  IconPath.plus,
                                  width: 24.w,
                                  height: 24.h,
                                  fit: BoxFit.cover,
                                ),
                              );
                            }),
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

   )),
    );
  }
}