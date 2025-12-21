
import 'package:fixxa_app/feature/folder_quotes/controller/folder_quotes_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class FolderQuotesScreen extends StatelessWidget {
  final int folderId;
  final String folderName;

  const FolderQuotesScreen({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FolderQuotesController());

    // Fetch quotes when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getQuotesForFolder(folderId);
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

          if (controller.quotes.isEmpty) {
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
                    'No quotes found in this folder',
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
            itemCount: controller.quotes.length,
            itemBuilder: (context, index) {
              final quote = controller.quotes[index];
              final quoteNumber = quote['quote_number'] ?? 'Quote #${index + 1}';
              final clientName = quote['client'] ?? 'No client';
              final pdfUrl = quote['pdf_url'];
              final generatedAt = quote['generated_at'];

              return InkWell(
                onTap: () async {
                  if (pdfUrl != null && pdfUrl.isNotEmpty) {
                    await controller.openPdf(pdfUrl, quoteNumber);
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
                      // PDF Icon
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: const Color(0xffFFEBEE),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.picture_as_pdf,
                          size: 32.sp,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Quote Number
                            Text(
                              quoteNumber,
                              style: GoogleFonts.urbanist(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff1C1C1C),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6.h),
                            // Client Name
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 14.sp,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    clientName,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            if (generatedAt != null) ...[
                              SizedBox(height: 4.h),
                              // Generated Date
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 12.sp,
                                    color: Colors.grey[500],
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    _formatDate(generatedAt),
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      // View PDF Button
                      Icon(
                        Icons.visibility_outlined,
                        color: const Color(0xff3A8DFF),
                        size: 24.sp,
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

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateStr;
    }
  }
}
