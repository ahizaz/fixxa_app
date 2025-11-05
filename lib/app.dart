import 'package:fixxa_app/core/services/spotlight_service.dart';
import 'package:fixxa_app/core/utils/theme/theme.dart';
import 'package:fixxa_app/feature/splash_screen/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FixxaApp extends StatelessWidget {
  const FixxaApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
    // Initialize SpotlightService
    Get.put(SpotlightService());
    
    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fixxa App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: SplashScreen(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
