import 'package:fixxa_app/core/common/widgets/custom_button.dart';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/viewclient_edit_details/controller/edit_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditDetails extends StatelessWidget {
  final int clientIndex;
  const EditDetails({super.key, required this.clientIndex});

  @override
  Widget build(BuildContext context) {
    final EditDetailsController controller = Get.put(
      EditDetailsController(clientIndex),
    );
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    "Edit",
                    style: GoogleFonts.montserrat(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff3A8DFF),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Text(
                "Client details",
                style: GoogleFonts.urbanist(
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000),
                ),
              ),
              SizedBox(height: 36.h),
              Obx(
                () => Container(
                  width: double.infinity,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: controller.isNamehasText.value
                          ? const Color(0xff3A8DFF)
                          : const Color(0xffE8E8E8),
                      width: controller.isNamehasText.value ? 3.w : 2.w,
                    ),
                  ),
                  child: TextField(
                    controller: controller.nameController,
                    keyboardType: TextInputType.text,
                    onTap: () {
                      controller.isNameFocused.value = true;
                    },
                    onTapOutside: (event) {
                      controller.isNameFocused.value = false;
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 16.h,
                      ),
                      border: InputBorder.none,
                      hintText: 'Name',
                      hintStyle: GoogleFonts.montserrat(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff434343),
                      ),
                      suffixIcon: controller.isNamehasText.value
                          ? IconButton(
                              icon: Image.asset(
                                IconPath.cross, // Use your cross icon path
                                width: 20.sp,
                                height: 20.sp,
                                fit: BoxFit.cover,
                              ),
                              onPressed: () {
                                controller.clearName();
                              },
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(height: 10.h),
              Obx(
                () => Container(
                  width: double.infinity,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: controller.isPhonehasText.value
                          ? const Color(0xff3A8DFF)
                          : const Color(0xffE8E8E8),
                      width: controller.isPhonehasText.value ? 3.w : 2.w,
                    ),
                  ),
                  child: TextField(
                    controller: controller.phoneNumberController,
                    keyboardType: TextInputType.phone,
                    onTap: () {
                      controller.isPhoneFocused.value = true;
                    },
                    onTapOutside: (event) {
                      controller.isPhoneFocused.value = false;
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 16.h,
                      ),
                      border: InputBorder.none,
                      hintText: 'Phone number',
                      hintStyle: GoogleFonts.montserrat(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff434343),
                      ),
                      suffixIcon: controller.isPhonehasText.value
                          ? IconButton(
                              icon: Image.asset(
                                IconPath.cross, // Use your cross icon path
                                width: 20.sp,
                                height: 20.sp,
                                fit: BoxFit.cover,
                              ),
                              onPressed: () {
                                controller.clearPhone();
                              },
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              Obx(
                () => CustomButton(
                  text: 'Save Changes',
                  textStyle: TextStyle(
                    fontSize: 17.sp,
                    fontFamily: 'SFPro',
                    fontWeight: FontWeight.w600,
                    color: const Color(0xffFFFFFF),
                  ),
                  color: controller.isFormValidRx.value
                      ? const Color(0xff1C1C1C)
                      : const Color(
                          0xff1C1C1C,
                        ).withValues(alpha: .33),
                  onTap: controller.isFormValidRx.value
                      ? () {
                          controller.updateClient();
                        }
                      : () {},
                ),
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
}
