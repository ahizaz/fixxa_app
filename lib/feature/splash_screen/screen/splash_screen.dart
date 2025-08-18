import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/splash_screen/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
   SplashScreen({super.key});
   final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(ImagePath.splashScreen,fit: BoxFit.cover,),

      ),
    );
  }
}