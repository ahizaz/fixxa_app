import 'dart:io';

import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/account%20create&authentication/controller/personalization_controller.dart';
import 'package:fixxa_app/feature/home_default_clients/controller/home_default_controller.dart';
import 'package:fixxa_app/feature/home_default_clients/screen/client.dart';
import 'package:fixxa_app/feature/home_default_clients/screen/lost_qotes.dart';
import 'package:fixxa_app/feature/home_default_clients/screen/quotes.dart';
import 'package:fixxa_app/feature/home_default_clients/screen/spot_light.dart';
import 'package:fixxa_app/feature/home_default_clients/screen/won_qotes.dart';
import 'package:fixxa_app/feature/home_default_clients/widget/custom_pop_up_menue.dart';

import 'package:fixxa_app/feature/home_default_clients/widget/spotlite_manager.dart';
import 'package:fixxa_app/feature/home_default_clients/widget/state_item_widget.dart';
import 'package:fixxa_app/feature/profile/screen/profile_screen.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/quote_creation.dart';
import 'package:fixxa_app/feature/scanner/screen/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fixxa_app/feature/invoice_creation_manually.dart/screen/invoice_dialog.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/quote_dialog.dart';
import 'package:fixxa_app/core/services/spotlight_service.dart';
import 'package:fixxa_app/core/services/notification_services.dart';

// Show a one-time notification permission prompt and request system permission
Future<void> _showNotificationPermissionIfNeeded(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final asked = prefs.getBool('notification_permission_asked') ?? false;
  if (asked) return;

  // small delay so UI has settled
  await Future.delayed(const Duration(milliseconds: 250));

  // Directly request system notification permission so the OS dialog is shown
  try {
    // Use centralized NotificationServices to handle permission requests
    await NotificationServices().requestNotificationPermission();
    // On Android (API 33+) also request the runtime notification permission
    if (Platform.isAndroid) {
      await Permission.notification.request();
    }
  } catch (_) {
    // ignore any errors from permission request
  }

  await prefs.setBool('notification_permission_asked', true);
}

class HomeDefaultClients extends StatelessWidget {
  const HomeDefaultClients({super.key});

  @override
  Widget build(BuildContext context) {
    final PersonalizationController controller = Get.put(
      PersonalizationController(),
    );
    final HomeDefaultController homeController = Get.put(
      HomeDefaultController(),
    );

    // Trigger spotlight automatically when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Very short delay, then show spotlight for few seconds
      Future.delayed(const Duration(milliseconds: 200), () {
        SpotlightManager.triggerSpotlight(
          seconds: 3,
          spotlightTitle: "Getting started",
          spotlightDescription: "Click the plus (+) icon first",
        );
      });

      // After UI settles, show notification permission dialog if needed
      Future.delayed(const Duration(milliseconds: 600), () {
        _showNotificationPermissionIfNeeded(context);
      });
    });

    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      body: ValueListenableBuilder<bool>(
        valueListenable: SpotlightManager.showSpotlight,
        builder: (context, showSpotlight, _) {
          return Stack(
            children: [
              // Main content
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Top Row
                      ValueListenableBuilder<bool>(
                        valueListenable: SpotlightManager.showSpotlight,
                        builder: (context, showSpotlight, _) {
                          return AbsorbPointer(
                            absorbing: showSpotlight,
                            child: Opacity(
                              opacity: showSpotlight ? 0.3 : 1.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomPopupMenu(),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.h),
                                    child: Image.asset(
                                      ImagePath.fixxa,
                                      width: 110.w,
                                      height: 25.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: 48.h,
                                      width: 137.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          999.r,
                                        ),
                                        border: Border.all(
                                          color: const Color(0xffE8E8E8),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "€ 14,568 earned",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xff1C1C1C),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  InkWell(
                                    onTap: () => Get.to(() => ProfileScreen()),
                                    child: Container(
                                      width: 48.w,
                                      height: 48.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xffE8E8E8),
                                        ),
                                      ),
                                      child: Obx(
                                        () =>
                                            controller.selectedImage.value ==
                                                null
                                            ? const SizedBox.shrink()
                                            : ClipOval(
                                                child: Image.file(
                                                  File(
                                                    controller
                                                        .selectedImage
                                                        .value!
                                                        .path,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
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
                      SizedBox(height: 20.h),

                      /// Greeting
                      Center(
                        child: Text(
                          "Good afternoon, Lee!",
                          style: GoogleFonts.urbanist(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff1C1C1C),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      /// Quote Stats Section
                      ValueListenableBuilder<bool>(
                        valueListenable: SpotlightManager.showSpotlight,
                        builder: (context, showSpotlight, _) {
                          return AbsorbPointer(
                            absorbing: showSpotlight,
                            child: Opacity(
                              opacity: showSpotlight ? 0.3 : 1.0,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      ImagePath.backgroundContainer,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 16.w,
                                        top: 16.h,
                                      ),
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
                                    Obx(() {
                                      if (homeController.isLoadingStats.value) {
                                        // While stats are loading we keep the area empty — global EasyLoading is shown
                                        return SizedBox.shrink();
                                      }
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          buildStatItem(
                                            value:
                                                (homeController.sent.value *
                                                        0.1)
                                                    .clamp(0.0, 1.0),
                                            color: const Color(0xff00FFFF),
                                            label: "Sent",
                                            count: homeController.sent.value
                                                .toInt(),
                                            onTap: () {
                                              Get.to(
                                                () => Scaffold(
                                                  appBar: AppBar(
                                                    title: const Text("Quotes"),
                                                  ),
                                                  body: Quotes(),
                                                ),
                                              );
                                            },
                                          ),
                                          buildStatItem(
                                            value:
                                                (homeController.won.value * 0.1)
                                                    .clamp(0.0, 1.0),
                                            color: const Color(0xffFFFF00),
                                            label: "Won",
                                            count: homeController.won.value
                                                .toInt(),
                                            onTap: () =>
                                                Get.to(() => WonQotes()),
                                          ),
                                          buildStatItem(
                                            value:
                                                (homeController.lost.value *
                                                        0.1)
                                                    .clamp(0.0, 1.0),
                                            color: const Color(
                                              0xffD94E2E,
                                            ).withValues(alpha: 0.33),
                                            label: "Lost",
                                            count: homeController.lost.value
                                                .toInt(),
                                            onTap: () =>
                                                Get.to(() => LostQotes()),
                                          ),
                                        ],
                                      );
                                    }),
                                    SizedBox(height: 20.h),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20.h),

                      /// Tabs
                      ValueListenableBuilder<bool>(
                        valueListenable: SpotlightManager.showSpotlight,
                        builder: (context, showSpotlight, _) {
                          return AbsorbPointer(
                            absorbing: showSpotlight,
                            child: Opacity(
                              opacity: showSpotlight ? 0.3 : 1.0,
                              child: Obx(
                                () => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () =>
                                              homeController.switchTab(0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Clients",
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      homeController
                                                              .selectedTab
                                                              .value ==
                                                          0
                                                      ? const Color(0xff3A8DFF)
                                                      : const Color(0xff434343),
                                                ),
                                              ),
                                              if (homeController
                                                      .selectedTab
                                                      .value ==
                                                  0)
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    top: 4.h,
                                                  ),
                                                  height: 2.h,
                                                  width: 40.w,
                                                  color: const Color(
                                                    0xff3A8DFF,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 16.w),
                                        GestureDetector(
                                          onTap: () =>
                                              homeController.switchTab(1),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Folders",
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      homeController
                                                              .selectedTab
                                                              .value ==
                                                          1
                                                      ? const Color(0xff3A8DFF)
                                                      : const Color(0xff434343),
                                                ),
                                              ),
                                              if (homeController
                                                      .selectedTab
                                                      .value ==
                                                  1)
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    top: 4.h,
                                                  ),
                                                  height: 2.h,
                                                  width: 54.w,
                                                  color: const Color(
                                                    0xff3A8DFF,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20.h),

                      /// Expanded Content (Clients / Quotes Scrollable)
                      Expanded(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: SpotlightManager.showSpotlight,
                          builder: (context, showSpotlight, _) {
                            return AbsorbPointer(
                              absorbing: showSpotlight,
                              child: Opacity(
                                opacity: showSpotlight ? 0.3 : 1.0,
                                child: Obx(() {
                                  if (homeController.selectedTab.value == 0) {
                                    return SingleChildScrollView(
                                      child: Client(),
                                    );
                                  } else {
                                    return SingleChildScrollView(
                                      child: Quotes(),
                                    );
                                  }
                                }),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 20.h),

                      /// Main Button
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
                                  // Listen for spotlight changes
                                  ValueListenableBuilder<bool>(
                                    valueListenable:
                                        SpotlightManager.showSpotlight,
                                    builder: (context, showSpotlight, _) {
                                      return Container(
                                        decoration: showSpotlight
                                            ? BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.blue
                                                        .withValues(alpha: 0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 15,
                                                  ),
                                                ],
                                              )
                                            : null,
                                        child: SpotlightPlusButton(
                                          showSpotlight: showSpotlight,
                                          onTap: () async {
                                            final RenderBox box =
                                                context.findRenderObject()
                                                    as RenderBox;
                                            final Offset position = box
                                                .localToGlobal(Offset.zero);

                                            // Trigger separate popup spotlight
                                            SpotlightManager.triggerPopupSpotlight(
                                              seconds: 1,
                                              spotlightTitle:
                                                  "Choose your option",
                                              spotlightDescription:
                                                  "Select Create Quote or Create Invoice",
                                            );

                                            final result =
                                                await showMenu<String>(
                                                  context: context,
                                                  color: const Color(
                                                    0xffF2F2F2,
                                                  ),
                                                  position:
                                                      RelativeRect.fromLTRB(
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
                                                          Image.asset(
                                                            IconPath
                                                                .createquote,
                                                            height: 24.h,
                                                            width: 24.w,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Text("Create Quote"),
                                                        ],
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 'invoice',
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            IconPath
                                                                .createinvoice,
                                                            height: 24.h,
                                                            width: 24.w,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Text(
                                                            "Create Invoice",
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );

                                            if (result == 'quote') {
                                              // Set navigation source before opening quote dialog
                                              SpotlightService.instance
                                                  .setNavigationSource(
                                                    'home_default',
                                                  );
                                              QuoteDialog.show(context);
                                            } else if (result == 'invoice') {
                                              // Set navigation source before opening invoice dialog
                                              SpotlightService.instance
                                                  .setNavigationSource(
                                                    'home_default',
                                                  );
                                              InvoiceDialog.show(context);
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 20),
                                  ValueListenableBuilder<bool>(
                                    valueListenable:
                                        SpotlightManager.showSpotlight,
                                    builder: (context, showSpotlight, _) {
                                      return AbsorbPointer(
                                        absorbing: showSpotlight,
                                        child: Opacity(
                                          opacity: showSpotlight ? 0.3 : 1.0,
                                          child: InkWell(
                                            onTap: () =>
                                                Get.to(() => ScannerScreen()),
                                            child: Image.asset(
                                              IconPath.scantext,
                                              width: 24.w,
                                              height: 24.h,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 40),
                                child: ValueListenableBuilder<bool>(
                                  valueListenable:
                                      SpotlightManager.showSpotlight,
                                  builder: (context, showSpotlight, _) {
                                    return AbsorbPointer(
                                      absorbing: showSpotlight,
                                      child: Opacity(
                                        opacity: showSpotlight ? 0.3 : 1.0,
                                        child: InkWell(
                                          onTap: () =>
                                              showCustomDialog(context),
                                          child: Image.asset(
                                            IconPath.voiceai,
                                            width: 56.w,
                                            height: 56.h,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
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

              // Transparent overlay to disable interactions when spotlight is active
              if (showSpotlight)
                Positioned.fill(
                  child: AbsorbPointer(
                    absorbing: true,
                    child: Container(color: Colors.transparent),
                  ),
                ),

              // Popup spotlight overlay
              PopupSpotlightOverlay(),
            ],
          );
        },
      ),
    );
  }
}
