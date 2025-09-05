import 'dart:ui';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/tap_controller.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/quote_speak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
class DialogTabController extends GetxController {
  var selectedTab = 0.obs;
}
void showCustomDialog(BuildContext context) {
  final tapcontroller = Get.put(TapController());
  
  showDialog(
    context: context,
    barrierColor: Colors.transparent, // Make barrier transparent for blur effect
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Apply blur effect
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            width: double.infinity,
            height: 556.h,
            decoration: BoxDecoration(
              color: Color(0xffF2F2F2).withOpacity(0.8),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16.h, right: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          IconPath.cross,
                          width: 32.w,
                          height: 32.h,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      IconPath.star,
                      width: 19.w,
                      height: 24.h,
                    ),
                    SizedBox(width: 21.w),
                    Image.asset(
                      ImagePath.title,
                      width: 107.w,
                      height: 24.h,
                    ),
                  ],
                ),
                SizedBox(height: 46.h),
//  
    Padding(
      padding:  EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
                  height: 32.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => tapcontroller.selectedTab.value = 0,
                          child: Obx(
                            () => Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color:
                                    tapcontroller.selectedTab.value == 0
                                        ? Color(0xffFFFFFF)
                                        : Color(0xffF5F5F5),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  if (tapcontroller.selectedTab.value == 0)
                                    BoxShadow(
                                      color: Color(
                                        0xff000000,
                                      ).withValues(alpha: 0.3),
                                      blurRadius: 1,
                                    ),
                                ],
                              ),
                              child: Text(
                                "Quote",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      tapcontroller.selectedTab.value == 0
                                          ? Color(0xff1A1A1A)
                                          : Color(0xff666666),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => tapcontroller.selectedTab.value = 1,
                          child: Obx(
                            () => Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color:
                                    tapcontroller.selectedTab.value == 1
                                        ? Color(0xffFFFFFF)
                                        : Color(0xffF5F5F5),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  if (tapcontroller.selectedTab.value == 1)
                                    BoxShadow(
                                      color: Color(
                                        0xff000000,
                                      ).withValues(alpha: .3),
                                      blurRadius: 1,
                                    ),
                                ],
                              ),
                              child: Text(
                                "Invoice",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      tapcontroller.selectedTab.value == 1
                                          ? Color(0xff1A1A1A)
                                          : Color(0xff666666),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    ),

              SizedBox(height: 16.h),
              Obx(() {
                final selected = tapcontroller.selectedTab.value;
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: selected == 0
                      ? const QuoteSpeak(key: ValueKey('quote'))
                      : const _InvoiceSection(key: ValueKey('invoice')),
                );
              }),

              ],
            ),
          ),
        ),
      );
    },
  );
}


class _InvoiceSection extends StatelessWidget {
  const _InvoiceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        'Invoice content goes here',
        style: TextStyle(fontSize: 14.sp, color: const Color(0xFF1A1A1A)),
      ),
    );
  }
}

