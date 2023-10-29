import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../common/app_colors/app_colors.dart';

abstract class AppSnakeBar {
  static showSnakeBar({
    required BuildContext context,
    required String message,
    Duration? duration,
    EdgeInsetsGeometry? margin,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        margin: margin ??
            EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 200.h,
              right: 24.w,
              left: 24.w,
            ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              message,
              style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                  .subTitle2
                  .copyWith(
                    color: AppColors.white,
                  ),
            ),
            IconButton(
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              icon: const Icon(Icons.close, size: 20, color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
