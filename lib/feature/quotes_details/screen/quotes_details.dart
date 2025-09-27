import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/quotes_details/controller/qutoe_details_controller.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/quote_creation.dart';
import 'package:fixxa_app/feature/viewquote_edit_details/screen/view_quote_edit_details.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/screen/invoice_dialog.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/quote_dialog.dart';
import 'package:fixxa_app/feature/scanner/screen/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class QuotesDetails extends StatelessWidget {
  const QuotesDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final QuoteDetailsController controller = Get.put(QuoteDetailsController());
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
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
                      Icon(
                        Icons.add,
                        color: const Color(0xff3A8DFF),
                        size: 18.sp,
                      ),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 15.h,
                  ),
                  child: Text(
                    "Quotes",
                    style: GoogleFonts.urbanist(
                      fontSize: 34.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff1C1C1C),
                    ),
                  ),
                ),
                SizedBox(height: 7.5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.quotes.length,
                      itemBuilder: (context, index) {
                        var quote = controller.quotes[index];
                        return Column(
                          children: [
                            SizedBox(
                              height: 98.h,
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.folder_outlined,
                                    size: 24.sp,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              quote['name'],
                                              style: GoogleFonts.urbanist(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xff1C1C1C),
                                              ),
                                            ),
                                            const Spacer(),
                                            if (quote['remind'] != null)
                                              Text(
                                                quote['remind'],
                                                style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.sp,
                                                  color: Color(0xff434343),
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(height: 8.h),

                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: quote['statuses'].map<Widget>((status) {
                                                Color statusColor;
                                                String statusText;
                                                final amount = status['amount'];
                                                switch (status['type']) {
                                                  case 'won':
                                                    statusColor = const Color(0xff108759);
                                                    statusText = 'won';
                                                    break;
                                                  case 'lost':
                                                    statusColor = const Color(0xffD9534F);
                                                    statusText = 'lost';
                                                    break;
                                                  default: // sent
                                                    statusColor = const Color(0xff2563EB);
                                                    statusText = 'sent';
                                                }
                                                return Padding(
                                                  padding: EdgeInsets.only(right: 4.w),
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                                    decoration: BoxDecoration(
                                                      color: statusColor,
                                                      borderRadius: BorderRadius.circular(20.r),
                                                    ),
                                                    child: Text(
                                                      '$amount $statusText',
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 13.sp,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                            const Spacer(),
                                            Text(
                                              '${quote['quotes']} quote${quote['quotes'] > 1 ? 's' : ''}',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff434343),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                        () => ViewQuoteEditDetails(
                                          quoteIndex: index,
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.chevron_right,
                                      color: Colors.grey,
                                      size: 24.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(color: Colors.grey[300], height: 1.h),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Bottom Navigation Bar same as invoices.dart
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
    );
  }
}