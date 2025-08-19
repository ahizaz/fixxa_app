import 'package:fixxa_app/core/common/widgets/login_header.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:fixxa_app/feature/login/widget/custom_login_email_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginDefault extends StatelessWidget {
  const LoginDefault({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
       LoginHeader(headerText: "Welcome back!"),
       SizedBox(height: 24.h,),
       CustomLoginEmailField(),
       SizedBox(height: 20.h,),
       
       
         ],
      ),
      
      )),
    );
  }
}