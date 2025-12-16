import 'dart:io';
import 'dart:convert';
import 'package:fixxa_app/feature/home_default_clients/controller/home_default_controller.dart';
import 'package:fixxa_app/feature/client_details/screen/client_details.dart';
import 'package:fixxa_app/feature/viewclient_edit_details/screen/viewclient_edit_details.dart';
import 'package:get/get.dart';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fixxa_app/core/utils/network_helper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Client extends StatelessWidget {
  const Client({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeDefaultController homeController =
        Get.find<HomeDefaultController>();
    return Obx(() {
      // When controller is loading, show an inline loader so this page doesn't show empty state.
      if (homeController.isLoadingClients.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 24.h),
              SizedBox(
                width: 36.w,
                height: 36.w,
                child: const CircularProgressIndicator(),
              ),
              SizedBox(height: 12.h),
              Text(
                'Loading clients...',
                style: GoogleFonts.urbanist(
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        );
      }

      // Show empty state (no Refresh button — users will see EasyLoading when fetch runs)
      if (homeController.clientData.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  'No clients yet',
                  style: GoogleFonts.urbanist(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Add your first client to get started',
                  style: GoogleFonts.urbanist(
                    fontSize: 14.sp,
                    color: Colors.grey[500],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      }

      // Show client list (limit to 4 on home view)
      final int displayCount = homeController.clientData.length > 4
          ? 4
          : homeController.clientData.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => Get.to(() => ClientDetails(showAll: true)),
                  child: Text(
                    'See all',
                    style: GoogleFonts.urbanist(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff3A8DFF),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // client items
          Column(
            children: List.generate(displayCount, (index) {
              final data = homeController.clientData[index];
              return InkWell(
                onTap: () async {
                  // Validate client still exists before navigating
                  final clientId = data['id'];
                  if (clientId != null) {
                    final exists = await homeController.validateClientExists(
                      clientId,
                    );
                    if (!exists) {
                      EasyLoading.showError(
                        'This client has been deleted from the admin panel. Refreshing list...',
                      );
                      // Refresh the client list to show updated data
                      await homeController.getAllClients();
                      return;
                    }
                  }
                  Get.to(() => ViewclientEditDetails(clientIndex: index));
                },
                child: Container(
                  width: double.infinity,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xffE8E8E8), width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Handle both network and asset images with error handling
                        _ClientAvatar(clientData: data),
                        SizedBox(width: 12.w),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data["name"],
                              style: GoogleFonts.urbanist(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff1C1C1C),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              // Show phone number or "Contact" if email is empty/dummy
                              (data["email"]?.toString().isNotEmpty ?? false) &&
                                      !data["email"].toString().contains(
                                        "no-email",
                                      ) &&
                                      !data["email"].toString().contains(
                                        "noone",
                                      )
                                  ? data["email"]
                                  : (data["phone"] ??
                                        data["phone_number"] ??
                                        "Contact"),
                              style: GoogleFonts.montserrat(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff434343),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                Container(
                                  width: 75.w,
                                  height: 22.h,
                                  decoration: BoxDecoration(
                                    color: Color(0xffF2CB05),
                                    borderRadius: BorderRadius.circular(999.r),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 8.w),
                                      Image(
                                        image: AssetImage(IconPath.briefcase),
                                        width: 16.w,
                                        height: 16.h,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        "${data["jobCount"]} Job",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff1C1C1C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  width: 99.w,
                                  height: 22.h,
                                  decoration: BoxDecoration(
                                    color: Color(0xff0B8E5E),
                                    borderRadius: BorderRadius.circular(999.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "€${(data["earnings"] is double ? data["earnings"].toStringAsFixed(0) : data["earnings"])} earned",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xffFFFFFF),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 25.h),
                          child: Image(
                            image: AssetImage(IconPath.chevronright),
                            width: 24.w,
                            height: 24.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      );
    });
  }
}

// StatefulWidget to handle client avatar with proper error handling
class _ClientAvatar extends StatefulWidget {
  final Map<String, dynamic> clientData;

  const _ClientAvatar({required this.clientData});

  @override
  State<_ClientAvatar> createState() => _ClientAvatarState();
}

class _ClientAvatarState extends State<_ClientAvatar> {
  ImageProvider? backgroundImage;
  bool imageLoadFailed = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() {
    final img = widget.clientData["image"]?.toString();
    final source = widget.clientData["source"]?.toString() ?? "manual";
    final isFromContact = source == "contact";

    // For contacts, always show initials, don't try to load image
    if (isFromContact) {
      setState(() {
        backgroundImage = null;
        imageLoadFailed = false;
      });
      return;
    }

    // Only load image if it's from manual entry
    try {
      if (img != null && img.isNotEmpty) {
        // Base64 image (starts with data:image or is raw base64)
        if (img.startsWith('data:image')) {
          try {
            final base64String = img.split(',').last;
            final bytes = base64Decode(base64String);
            if (bytes.isNotEmpty) {
              setState(() {
                backgroundImage = MemoryImage(bytes);
              });
              return;
            }
          } catch (e) {
            debugPrint('⚠️ Base64 decode error: $e');
          }
        }

        // Try to decode as raw base64
        if (!img.startsWith('http') &&
            !img.startsWith('/') &&
            !img.startsWith('assets/') &&
            !RegExp(r'^[a-zA-Z]:\\').hasMatch(img)) {
          try {
            final bytes = base64Decode(img);
            if (bytes.isNotEmpty) {
              setState(() {
                backgroundImage = MemoryImage(bytes);
              });
              return;
            }
          } catch (e) {
            debugPrint('⚠️ Raw base64 decode error: $e');
          }
        }

        // Network image
        if (img.startsWith('http')) {
          setState(() {
            backgroundImage = NetworkImage(normalizeImageUrl(img));
          });
          return;
        }

        // Local file path (Windows paths like C:\ or unix-like / or file://)
        if (img.startsWith('/') ||
            img.startsWith('file://') ||
            RegExp(r'^[a-zA-Z]:\\').hasMatch(img)) {
          final file = File(img);
          if (file.existsSync()) {
            setState(() {
              backgroundImage = FileImage(file);
            });
            return;
          } else {
            debugPrint('⚠️ File not found: $img');
          }
        }

        // Asset image fallback
        if (img.startsWith('assets/')) {
          setState(() {
            backgroundImage = AssetImage(img);
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('⚠️ Image loading error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.clientData["name"]?.toString().trim() ?? "";
    final initial = name.isNotEmpty
        ? name.split(' ').first.substring(0, 1).toUpperCase()
        : "?";

    return CircleAvatar(
      radius: 24.r,
      backgroundColor: Colors.grey[300],
      backgroundImage: imageLoadFailed ? null : backgroundImage,
      onBackgroundImageError: backgroundImage != null
          ? (exception, stackTrace) {
              debugPrint('⚠️ Background image failed to load: $exception');
              // When image fails to load, show initials instead
              if (mounted) {
                setState(() {
                  imageLoadFailed = true;
                  backgroundImage = null;
                });
              }
            }
          : null,
      child: (backgroundImage == null || imageLoadFailed)
          ? Text(
              initial,
              style: GoogleFonts.urbanist(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xff1C1C1C),
              ),
            )
          : null,
    );
  }
}
