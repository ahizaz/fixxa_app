
import 'package:fixxa_app/feature/folder_invoices/controller/folder_invoices_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FolderInvoicesScreen extends StatelessWidget {
  final int folderId;
  final String folderName;

  const FolderInvoicesScreen({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FolderInvoicesController());

    // Fetch invoices when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getInvoicesForFolder(folderId);
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
          style: GoogleFonts.urbanist(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xff1C1C1C),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.invoices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open,
                    size: 80.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No invoices found in this folder',
                    style: GoogleFonts.urbanist(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.invoices.length,
            itemBuilder: (context, index) {
              final invoice = controller.invoices[index];
              final invoiceIdStr = invoice['invoice_id']?.toString() ?? 'Invoice #${index + 1}';
              final pdfUrl = (invoice['pdf_url'] ?? invoice['pdf'] ?? invoice['invoice_pdf'] ?? invoice['file_url'] ?? invoice['download_url'])?.toString();

              return InkWell(
                onTap: () async {
                  if (pdfUrl != null && pdfUrl.isNotEmpty) {
                    await controller.openPdf(pdfUrl, invoiceIdStr);
                  }
                },
                child: Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(16.w),
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
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 40.sp,
                      color: const Color(0xff0B8E5E),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            invoiceIdStr,
                            style: GoogleFonts.urbanist(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff1C1C1C),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            invoice['client_name'] ?? 'No client',
                            style: GoogleFonts.urbanist(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (invoice['total_amount'] != null)
                            Text(
                              '\$${invoice['total_amount']}',
                              style: GoogleFonts.urbanist(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff0B8E5E),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Show a PDF icon if a PDF URL exists, otherwise chevron
                    if (pdfUrl != null && pdfUrl.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: const Color(0xffFFEBEE),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.picture_as_pdf,
                          color: Colors.red,
                          size: 28.sp,
                        ),
                      )
                    else
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                      ),
                  ],
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
