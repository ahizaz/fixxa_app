
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/client_details/controller/client_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientDetails extends StatelessWidget {
  const ClientDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final ClientDetailsController controller = Get.put(ClientDetailsController());
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image(
                          image: const AssetImage(IconPath.cross),
                          width: 32.w,
                          height: 32.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.add, color: const Color(0xff3A8DFF), size: 18.sp),
                      SizedBox(width: 10.w),
                      Text(
                        "Add Contact",
                        style: GoogleFonts.urbanist(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff3A8DFF),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
                  child: Text(
                    "Client",
                    style: GoogleFonts.urbanist(
                      fontSize: 34.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff1C1C1C),
                    ),
                  ),
                ),
                SizedBox(height: 7.5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.clients.length,
                      itemBuilder: (context, index) {
                        var client = controller.clients[index];
                        Color statusColor = client['status'] == 'earned' ? Color(0xff0B8E5E) : Color(0xffB5681B);
                        return Column(
                          children: [
                            SizedBox(
                              height: 98.h,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Image(image: AssetImage(client['avatar'])),
                                  ),
                                  SizedBox(width: 12.w),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        client['name'],
                                        style: GoogleFonts.urbanist(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xff1C1C1C),
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        client['email'],
                                        style: GoogleFonts.urbanist(
                                          fontSize: 14.sp,
                                          color: Colors.grey,
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
                                            child: Center(
                                              child: Text(
                                                '${client['jobs']} Jobs',
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 14.sp,
                                                  color: const Color(0xff1C1C1C),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                            decoration: BoxDecoration(
                                              color: statusColor,
                                              borderRadius: BorderRadius.circular(20.r),
                                            ),
                                            child: Text(
                                              '${client['currency']}${client['amount']} ${client['status']}',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 13.sp,
                                                color: Color(0xffFFFFFF),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey,
                                    size: 24.sp,
                                  ),
                                ],
                              ),
                            ),
                            if (index < controller.clients.length - 1) // Avoid divider after last item
                              Divider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                                height: 16.h,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}