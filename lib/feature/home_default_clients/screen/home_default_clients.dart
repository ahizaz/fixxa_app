
import 'dart:io';

import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/account%20create&authentication/controller/personalization_controller.dart';
import 'package:fixxa_app/feature/home_default_clients/controller/home_default_controller.dart';
import 'package:fixxa_app/feature/home_default_clients/screen/client.dart';
import 'package:fixxa_app/feature/home_default_clients/screen/quotes.dart';
import 'package:fixxa_app/feature/home_default_clients/widget/custom_pop_up_menue.dart';
import 'package:fixxa_app/feature/home_default_clients/widget/state_item_widget.dart';
import 'package:fixxa_app/feature/invoices/screen/invoices.dart';
import 'package:fixxa_app/feature/profile/screen/profile_screen.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/quote_creation.dart';
import 'package:fixxa_app/feature/scanner/screen/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeDefaultClients extends StatelessWidget {
  const HomeDefaultClients({super.key});

  @override
  Widget build(BuildContext context) {
    final PersonalizationController controller = Get.put(PersonalizationController());
    final HomeDefaultController homeController = Get.put(HomeDefaultController());

   
 
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomPopupMenu(),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Image(
                        image: AssetImage(ImagePath.fixxa),
                        width: 110.w,
                        height: 25.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 48.h,
                        width: 137.w,
                        decoration: BoxDecoration(
                          color: Color(0xffFFFFFF),
                          borderRadius: BorderRadius.circular(999.r),
                          border: Border.all(
                            width: 1,
                            color: Color(0xffE8E8E8),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "€ 14,568 earned",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.montserrat(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1C1C1C),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(ProfileScreen());
                      },
                      child: Container(
                        width: 48.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1,
                            color: Color(0xffE8E8E8),
                          ),
                        ),
                        child: Obx(
                          () => controller.selectedImage.value == null
                              ? const SizedBox.shrink()
                              : ClipOval(
                                  child: Image.file(
                                    File(controller.selectedImage.value!.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    "Good afternoon, Lee!",
                    style: GoogleFonts.urbanist(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff1C1C1C),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImagePath.backgroundContainer),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16.w, top: 16.h),
                          child: Text(
                            "Quote Stats",
                            style: GoogleFonts.urbanist(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildStatItem(
                              value: homeController.sent.value,
                              color: Color(0xff00FFFF),
                              label: "Sent",
                              count: homeController.sent.value.toInt(),
                              onTap: () {
                                Get.to(() => Scaffold(
                                      appBar: AppBar(
                                        title: Text(
                                          "Quotes",
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      body: Quotes(),
                                    ));
                              },
                            ),
                            buildStatItem(
                              onTap: () {
                                Get.to(() => Invoices());
                              },
                              value: homeController.won.value /
                                  homeController.sent.value,
                              color: Color(0xffFFFF00),
                              label: "Won",
                              count: homeController.won.value.toInt(),
                            ),
                            buildStatItem(
                              onTap: () {},
                              value: homeController.lost.value /
                                  homeController.sent.value,
                              color: Color(0xffD94E2E).withValues(alpha: 0.33),
                              label: "Lost",
                              count: homeController.lost.value.toInt(),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => homeController.switchTab(0),
                              child: Column(
                                children: [
                                  Text(
                                    "Clients",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color: homeController.selectedTab.value == 0
                                          ? Color(0xff3A8DFF)
                                          : Color(0xff434343),
                                    ),
                                  ),
                                  if (homeController.selectedTab.value == 0)
                                    Container(
                                      margin: EdgeInsets.only(top: 4.h),
                                      height: 2.h,
                                      width: 40.w,
                                      color: Color(0xff3A8DFF),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16.w),
                            GestureDetector(
                              onTap: () => homeController.switchTab(1),
                              child: Column(
                                children: [
                                  Text(
                                    "Quotes",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color: homeController.selectedTab.value == 1
                                          ? Color(0xff3A8DFF)
                                          : Color(0xff434343),
                                    ),
                                  ),
                                  if (homeController.selectedTab.value == 1)
                                    Container(
                                      margin: EdgeInsets.only(top: 4.h),
                                      height: 2.h,
                                      width: 54.w,
                                      color: Color(0xff3A8DFF),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        homeController.selectedTab.value == 0
                            ? Row(
                                children: [
                                  Image(
                                    image: AssetImage(ImagePath.import),
                                    width: 24.w,
                                    height: 24.h,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "Import",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff3A8DFF),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Icon(Icons.add,
                                      color: Color(0xff3A8DFF), size: 18.sp),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "New folder",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff3A8DFF),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    )),
                SizedBox(height: 20.h),
                Obx(() {
                  if (homeController.selectedTab.value == 0) {
                    return Client();
                  } else {
                    return Quotes();
                  }
                }),
                SizedBox(height: 41.h),
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
                            SizedBox(width: 30),
                            InkWell(
                              onTap: ()async {
                                final result = await showMenu<String>(
                                  color: Color(0xffF2F2F2),
                                  
                                   context: context,
                           position: RelativeRect.fromLTRB(50, 800, 600, 100),
                           items: [
                            PopupMenuItem(
                                 value: 'quote',
                              child: Row(
                                children: [
                                   Image(image: AssetImage(IconPath.createquote,),height: 24.h,width: 24.w,fit: BoxFit.cover,),
                                      SizedBox(width: 8),
                                Text("Create Quote",style: GoogleFonts.urbanist( 
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff1C1C1C)
                                ),),
                                ],

                            )),
                            PopupMenuItem( value: 'invoice',child: Row(
                             children: [
                                              Image(image: AssetImage(IconPath.createinvoice,),height: 24.h,width: 24.w,fit: BoxFit.cover,),
              SizedBox(width: 8),
            Text("Create Invoice",style: GoogleFonts.urbanist( 
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff1C1C1C)
                                ),),
                             ],
                            ))
                           ]
                                );
                                if(result=='quote'){

                                }else if(result=='invoice'){

                                }
                      
                              },
                              child: Image.asset(
                                IconPath.plus,
                                width: 24.w,
                                height: 24.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 20),
                            InkWell(
                              onTap: (){
                               Get.to(()=>ScannerScreen());
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
                          padding: EdgeInsets.only(right: 40),
                          child: InkWell(
                            onTap: (){
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
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}