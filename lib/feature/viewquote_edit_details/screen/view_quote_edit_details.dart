import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/home_default_clients/controller/home_default_controller.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/screen/invoice_dialog.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/quote_dialog.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/add_client.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/quote_creation.dart';
import 'package:fixxa_app/feature/scanner/screen/scanner_screen.dart';

import 'package:fixxa_app/feature/folder_quotes/screen/folder_quotes_screen.dart';
import 'package:fixxa_app/feature/folder_invoices/screen/folder_invoices_screen.dart';
import 'package:fixxa_app/feature/folder_scanned/screen/folder_scanned_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewQuoteEditDetails extends StatelessWidget {
  final int quoteIndex;
  const ViewQuoteEditDetails({super.key, required this.quoteIndex});
  // Note: counts are now provided by `HomeDefaultController.folderQuotesCount` and
  // `HomeDefaultController.folderInvoicesCount` (fetched on demand).
  @override
  Widget build(BuildContext context) {
    final HomeDefaultController homeController =
        Get.find<HomeDefaultController>();
    return Obx(() {
      final data = homeController.quoteData[quoteIndex];
      final folderId = data['folder_id'];
      final folderNameFromData = (data['name'] ?? data['folder_name'] ?? '')
          .toString();

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
                  SizedBox(height: 24.h),

                  // Root Folder Text
                  Text(
                    "Root Folder",
                    style: GoogleFonts.urbanist(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff1C1C1C),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // If this folder represents scanned documents, show only
                  // a 'Scanned Documents' item which navigates to the scanned
                  // images screen. Otherwise show Quotes & Invoices as before.
                  if (folderNameFromData.toLowerCase() == 'scanned documents' &&
                      folderId != null) ...[
                    _buildFolderItem(
                      icon: Icons.image,
                      folderName: 'Scanned Documents',
                      fileCount: 'View scans',
                      color: const Color(0xff8B5CF6),
                      onTap: () {
                        debugPrint(
                          '📂 Navigating to Scanned Documents folder with ID: $folderId',
                        );
                        Get.to(
                          () => FolderScannedScreen(
                            folderId: folderId,
                            folderName:
                                'Scanned Documents - ${data['name'] ?? ''}',
                          ),
                        );
                      },
                    ),
                  ] else ...[
                    // Quotes Folder
                    _buildFolderItem(
                      icon: Icons.folder,
                      folderName: "Quotes",
                      fileCount: _getQuotesCountText(homeController, folderId),
                      color: const Color(0xff3A8DFF),
                      onTap: () {
                        if (folderId != null) {
                          debugPrint(
                            '📂 Navigating to Quotes folder with ID: $folderId',
                          );
                          Get.to(
                            () => FolderQuotesScreen(
                              folderId: folderId,
                              folderName: 'Quotes - ${data['name']}',
                            ),
                          );
                        } else {
                          debugPrint('❌ folder_id not found in data');
                        }
                      },
                    ),

                    // Invoices Folder
                    _buildFolderItem(
                      icon: Icons.folder,
                      folderName: "Invoices",
                      fileCount: _getInvoicesCountText(homeController, folderId),
                      color: const Color(0xff0B8E5E),
                      onTap: () {
                        if (folderId != null) {
                          debugPrint(
                            '📂 Navigating to Invoices folder with ID: $folderId',
                          );
                          Get.to(
                            () => FolderInvoicesScreen(
                              folderId: folderId,
                              folderName: 'Invoices - ${data['name']}',
                            ),
                          );
                        } else {
                          debugPrint('❌ folder_id not found in data');
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: SizedBox(
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
                                QuoteDialog.show(context);
                              } else if (result == 'invoice') {
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
        ),
      );
    });
  }

  String _getQuotesCountText(HomeDefaultController ctrl, dynamic folderId) {
    if (folderId == null) return '0 PDFs';
    final int? id = folderId is int ? folderId : int.tryParse(folderId.toString());
    if (id == null) return '0 PDFs';

    // Trigger fetch if not cached yet. fetchCountsForFolder is idempotent.
    if (!ctrl.folderQuotesCount.containsKey(id) ||
        !ctrl.folderInvoicesCount.containsKey(id)) {
      // Fire and forget; Obx will update view when values arrive.
      ctrl.fetchCountsForFolder(id);
    }

    final int count = ctrl.folderQuotesCount[id] ?? 0;
    return '$count PDFs';
  }

  String _getInvoicesCountText(HomeDefaultController ctrl, dynamic folderId) {
    if (folderId == null) return '0 PDFs';
    final int? id = folderId is int ? folderId : int.tryParse(folderId.toString());
    if (id == null) return '0 PDFs';

    if (!ctrl.folderInvoicesCount.containsKey(id) ||
        !ctrl.folderQuotesCount.containsKey(id)) {
      ctrl.fetchCountsForFolder(id);
    }

    final int count = ctrl.folderInvoicesCount[id] ?? 0;
    return '$count PDFs';
  }

  Widget _buildFolderItem({
    required IconData icon,
    required String folderName,
    required String fileCount,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xffE8E8E8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 40.sp, color: color),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    folderName,
                    style: GoogleFonts.urbanist(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff1C1C1C),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    fileCount,
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff8E8E8E),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: const Color(0xff8E8E8E),
            ),
          ],
        ),
      ),
    );
  }
}
