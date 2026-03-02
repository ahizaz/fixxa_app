import 'dart:ui';
import 'dart:io';
import 'dart:convert';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/home_default_clients/controller/home_default_controller.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/screen/invoice_dialog.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/quote_dialog.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/add_client.dart';
import 'package:fixxa_app/core/services/spotlight_service.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/quote_creation.dart';
import 'package:fixxa_app/feature/scanner/screen/scanner_screen.dart';
import 'package:fixxa_app/feature/viewclient_edit_details/screen/edit_details.dart';
import 'package:fixxa_app/feature/viewclient_edit_details/controller/edit_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fixxa_app/core/utils/network_helper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ViewclientEditDetails extends StatelessWidget {
  final int clientIndex;
  const ViewclientEditDetails({super.key, required this.clientIndex});

  // Helper function to extract numeric value from earnings string
  double _extractRateFromEarnings(String earnings) {
    // Remove '£' symbol and 'earned' text, then parse the number
    String numericString = earnings
        .replaceAll('£', '')
        .replaceAll(' earned', '')
        .trim();
    return double.tryParse(numericString) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final HomeDefaultController homeController =
        Get.find<HomeDefaultController>();
    final EditDetailsController editController = Get.put(
      EditDetailsController(clientIndex),
    );

    // Validate client exists when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (clientIndex >= 0 && clientIndex < homeController.clientData.length) {
        final data = homeController.clientData[clientIndex];
        final clientId = data['id'];
        if (clientId != null) {
          final exists = await homeController.validateClientExists(clientId);
          if (!exists && context.mounted) {
            Get.back();
            EasyLoading.showError(
              'This client has been deleted from the admin panel.',
            );
            await homeController.getAllClients();
          }
        }
      }
    });

    return Obx(() {
      // Check if client still exists in the list
      if (clientIndex >= homeController.clientData.length) {
        return Scaffold(
          backgroundColor: const Color(0xffF8F8FF),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Client not found',
                  style: GoogleFonts.urbanist(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'This client may have been deleted',
                  style: GoogleFonts.urbanist(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: Text('Go Back'),
                ),
              ],
            ),
          ),
        );
      }

      final data = homeController.clientData[clientIndex];
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
                      SizedBox(
                        height: 48.h,
                        child: Stack(
                          alignment: Alignment.centerLeft,
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
                                  "Client", // This should probably be "My Profile" as per the initial design, or dynamic
                                  style: GoogleFonts.montserrat(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff3A8DFF),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                        offset: Offset(
                          0,
                          48.h,
                        ), // Adjust offset to position the menu
                        onSelected: (String result) {
                          if (result == 'edit') {
                            Get.to(() => EditDetails(clientIndex: clientIndex));
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
                                          alpha: 0.3,
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
                                                      // Call delete API
                                                      editController
                                                          .deleteClient();
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
                                      'Remove client',
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
                        color: const Color(
                          0xffF2F2F2,
                        ), // Background color of the pop-up
                        elevation: 8, // Shadow of the pop-up
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
                        Builder(
                          builder: (context) {
                            final img = data["image"]?.toString();
                            final source =
                                data["source"]?.toString() ?? "manual";
                            final isFromContact = source == "contact";
                            ImageProvider? backgroundImage;

                            // Only load image if it's from manual entry, not from contacts
                            if (!isFromContact) {
                              try {
                                if (img != null && img.isNotEmpty) {
                                  // Base64 image handling
                                  if (img.startsWith('data:image')) {
                                    try {
                                      final base64String = img.split(',').last;
                                      final bytes = base64Decode(base64String);
                                      if (bytes.isNotEmpty) {
                                        backgroundImage = MemoryImage(bytes);
                                      }
                                    } catch (e) {
                                      debugPrint('⚠️ Base64 decode error: $e');
                                    }
                                  }

                                  // Raw base64
                                  if (backgroundImage == null &&
                                      !img.startsWith('http') &&
                                      !img.startsWith('/') &&
                                      !img.startsWith('assets/') &&
                                      !RegExp(r'^[a-zA-Z]:\\').hasMatch(img)) {
                                    try {
                                      final bytes = base64Decode(img);
                                      if (bytes.isNotEmpty) {
                                        backgroundImage = MemoryImage(bytes);
                                      }
                                    } catch (e) {
                                      debugPrint(
                                        '⚠️ Raw base64 decode error: $e',
                                      );
                                    }
                                  }

                                  // Network image
                                  if (backgroundImage == null &&
                                      img.startsWith('http')) {
                                    backgroundImage = NetworkImage(
                                      normalizeImageUrl(img),
                                    );
                                  }

                                  // Local file
                                  if (backgroundImage == null &&
                                      (img.startsWith('/') ||
                                          img.startsWith('file://') ||
                                          RegExp(
                                            r'^[a-zA-Z]:\\',
                                          ).hasMatch(img))) {
                                    final file = File(img);
                                    if (file.existsSync()) {
                                      backgroundImage = FileImage(file);
                                    } else {
                                      debugPrint('⚠️ File not found: $img');
                                    }
                                  }

                                  // Asset image
                                  if (backgroundImage == null &&
                                      img.startsWith('assets/')) {
                                    backgroundImage = AssetImage(img);
                                  }
                                }
                              } catch (e) {
                                debugPrint('⚠️ Image loading error: $e');
                              }
                            }

                            final name = data["name"]?.toString().trim() ?? "";
                            final initial = name.isNotEmpty
                                ? name.substring(0, 1).toUpperCase()
                                : "?";

                            return CircleAvatar(
                              radius: 40.r,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: backgroundImage,
                              onBackgroundImageError: backgroundImage != null
                                  ? (exception, stackTrace) {
                                      debugPrint(
                                        '⚠️ Background image failed to load: $exception',
                                      );
                                    }
                                  : null,
                              child: Text(
                                initial,
                                style: GoogleFonts.urbanist(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff1C1C1C),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          data["name"] ?? "Unknown", // Use client's name
                          style: GoogleFonts.urbanist(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xffFFFFFF),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          data["email"] ??
                              "no-email@example.com", // Use client's email
                          style: GoogleFonts.montserrat(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xffFFFFFF),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          data["phone"] ??
                              "+44 1234 567896", // Use client's phone
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
                    "Quotes (${data["jobCount"] ?? 0})", // Display job count
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
                    "Success",
                    "£120 earned",
                    (serviceName, rate) {
                      // Set navigation source for other pages
                      SpotlightService.instance.setNavigationSource('other');
                      QuoteDialog.show(
                        context,
                        prefilledClient: {
                          'name': data["name"] ?? "Unknown",
                          'phone': data["phone"] ?? "+44 1234 567896",
                          'image': data["image"] ?? ImagePath.client1,
                        },
                        serviceName: serviceName,
                        serviceRate: rate,
                      );
                    },
                  ),
                  _buildJobItem(
                    "Plumbing",
                    "London, UK",
                    "17 Mar, 2025",
                    "Success",
                    "£240 earned",
                    (serviceName, rate) {
                      // Set navigation source for other pages
                      SpotlightService.instance.setNavigationSource('other');
                      QuoteDialog.show(
                        context,
                        prefilledClient: {
                          'name': data["name"] ?? "Unknown",
                          'phone': data["phone"] ?? "+44 1234 567896",
                          'image': data["image"] ?? ImagePath.client1,
                        },
                        serviceName: serviceName,
                        serviceRate: rate,
                      );
                    },
                  ),
                  _buildJobItem(
                    "Electric service",
                    "London, UK",
                    "17 Mar, 2025",
                    "Success",
                    "£99 earned",
                    (serviceName, rate) {
                      // Set navigation source for other pages
                      SpotlightService.instance.setNavigationSource('other');
                      QuoteDialog.show(
                        context,
                        prefilledClient: {
                          'name': data["name"] ?? "Unknown",
                          'phone': data["phone"] ?? "+44 1234 567896",
                          'image': data["image"] ?? ImagePath.client1,
                        },
                        serviceName: serviceName,
                        serviceRate: rate,
                      );
                    },
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
                                          PopupMenuItem(
                                            value: 'add_client',
                                            child: Row(
                                              children: [
                                                Icon(Icons.person_add, size: 24),
                                                SizedBox(width: 8),
                                                const Text('Add Client'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );

                                      if (result == 'quote') {
                                        //
                                        // Set navigation source for other pages
                                        SpotlightService.instance
                                            .setNavigationSource('other');
                                        QuoteDialog.show(context);
                                      } else if (result == 'invoice') {
                                        // Set navigation source for other pages
                                        SpotlightService.instance
                                            .setNavigationSource('other');
                                        InvoiceDialog.show(context);
                                      } else if (result == 'add_client') {
                                        Get.to(() => const AddClient());
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
    Function(String service, double rate)? onTap,
  ) {
    final double rate = _extractRateFromEarnings(earnings);
    return InkWell(
      onTap: onTap != null ? () => onTap(service, rate) : null,
      child: Container(
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
                  image: AssetImage(IconPath.flag),
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
                  image: AssetImage(IconPath.clock),
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
                    color: const Color(0xff0B8E5E),
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
      ),
    );
  }
}
