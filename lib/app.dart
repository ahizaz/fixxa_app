import 'package:device_preview/device_preview.dart';
import 'package:fixxa_app/core/services/spotlight_service.dart';
import 'package:fixxa_app/core/utils/theme/theme.dart';
import 'package:fixxa_app/feature/splash_screen/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// Global route observer used by pages to detect when they become visible
final RouteObserver<ModalRoute<void>> routeObserver =
  RouteObserver<ModalRoute<void>>();

class FixxaApp extends StatelessWidget {
  const FixxaApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Initialize SpotlightService
    Get.put(SpotlightService());

    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        navigatorObservers: [routeObserver],

        // ✅ Combined builder
        builder: (context, child) {
          final devicePreview = DevicePreview.appBuilder(context, child);
          return EasyLoading.init()(context, devicePreview);
        },

        debugShowCheckedModeBanner: false,
        title: 'Fixxa App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: SplashScreen(),
      ),
    );
  }
}