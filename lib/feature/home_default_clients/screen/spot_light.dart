import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/home_default_clients/widget/spotlite_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SpotlightPlusButton extends StatelessWidget {
  final bool showSpotlight;
  final VoidCallback? onTap;

  const SpotlightPlusButton({
    super.key,
    required this.showSpotlight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = showSpotlight
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurpleAccent.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 12,
                ),
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 22,
                ),
              ],
              border: Border.all(
                color: Colors.deepPurpleAccent.withOpacity(0.8),
                width: 2,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue.shade50,
                ),
                child: Center(
                  child: Text(
                    "+",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          )
        : InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Center(
              child: Image.asset(
                IconPath.plus,
                width: 24.w,
                height: 24.h,
                fit: BoxFit.cover,
              ),
            ),
          );

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topLeft,
      children: [
        if (showSpotlight)
          Positioned(
            left: 0,
            top: -80.h,
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: ValueListenableBuilder<String>(
                  valueListenable: SpotlightManager.title,
                  builder: (context, title, _) {
                    return ValueListenableBuilder<String>(
                      valueListenable: SpotlightManager.description,
                      builder: (context, description, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              description,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        button,
      ],
    );
  }
}

// Separate widget for popup menu spotlight
class PopupSpotlightOverlay extends StatelessWidget {
  const PopupSpotlightOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: SpotlightManager.showPopupSpotlight,
      builder: (context, showPopupSpotlight, _) {
        if (!showPopupSpotlight) return const SizedBox.shrink();
        
        return Positioned.fill(
          child: Container(
            color: Colors.blue.withOpacity(0.3),
            child: AbsorbPointer(
              absorbing: true,
              child: Stack(
                children: [
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.3,
                    left: 100,
                
                    child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: ValueListenableBuilder<String>(
                      valueListenable: SpotlightManager.popupTitle,
                      builder: (context, title, _) {
                        return ValueListenableBuilder<String>(
                          valueListenable: SpotlightManager.popupDescription,
                          builder: (context, description, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  description,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}