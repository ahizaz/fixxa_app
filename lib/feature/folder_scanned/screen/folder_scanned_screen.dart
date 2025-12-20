import 'package:fixxa_app/feature/folder_scanned/controller/folder_scanned_controller.dart';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FolderScannedScreen extends StatelessWidget {
  final int folderId;
  final String folderName;

  const FolderScannedScreen({super.key, required this.folderId, required this.folderName});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FolderScannedController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getScannedImagesForFolder(folderId);
    });

    return Scaffold(
      backgroundColor: const Color(0xffF8F8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          folderName,
          style: GoogleFonts.urbanist(fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xff1C1C1C)),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.images.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 80.sp, color: Colors.grey[400]),
                  SizedBox(height: 16.h),
                  Text('No scanned images found in this folder', style: GoogleFonts.urbanist(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.grey[600])),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.all(12.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12.w, mainAxisSpacing: 12.h, childAspectRatio: 0.9),
            itemCount: controller.images.length,
            itemBuilder: (context, index) {
              final item = controller.images[index];
              // Try common keys where backend might store path/url
              final rawPath = (item['image'] ?? item['image_url'] ?? item['file'] ?? item['path'] ?? item['scanned_image'] ?? item['url'])?.toString();
              final imageUrl = Urls.scannedImageUrl(rawPath);

              return GestureDetector(
                onTap: () {
                  if (imageUrl.isNotEmpty) {
                    Get.dialog(Center(child: InteractiveViewer(child: Image.network(imageUrl, fit: BoxFit.contain))));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: const Color(0xffE8E8E8))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: imageUrl.isEmpty
                        ? Center(child: Text('No image', style: GoogleFonts.urbanist()))
                        : Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => Center(child: Icon(Icons.broken_image, color: Colors.grey[400]))),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
