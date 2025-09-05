import 'dart:ui';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
class DialogTabController extends GetxController {
  var selectedTab = 0.obs;
}
void showCustomDialog(BuildContext context) {
  final controller = Get.put(DialogTabController());
  
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
                Obx(() {
                  final selected = controller.selectedTab.value;
                  final fullWidth = MediaQuery.of(context).size.width - 60.w; // dialog padding
                  final segmentWidth = fullWidth / 2;

                  return Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 15.w),
                    child: Container(
                      width: fullWidth,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            left: selected == 0 ? 0 : segmentWidth,
                            top: 0,
                            child: Container(
                              width: segmentWidth,
                              height: 36.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18.r),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.selectedTab.value = 0;
                                   // close dialog if needed
                                    // first screen
                                  },
                                  child: Center(
                                    child: Text(
                                      'Quote',
                                      style: TextStyle(
                                        color: selected == 0 ? Colors.black : Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.selectedTab.value = 1;
                                 // close dialog if needed
                                    // second screen
                                  },
                                  child: Center(
                                    child: Text(
                                      'Invoice',
                                      style: TextStyle(
                                        color: selected == 1 ? Colors.black : Colors.white,
                                        fontWeight: FontWeight.bold,
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
