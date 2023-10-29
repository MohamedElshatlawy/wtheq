import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wteq_demo/core/common/app_colors/app_colors.dart';

import '../../common/app_font_style/app_font_style_global.dart';
import '../../util/localization/app_localizations.dart';

class AppButton extends StatelessWidget {
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? radius;
  final Color? color;
  final String title;
  final TextStyle? titleStyle;

  const AppButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.padding,
    this.height,
    this.radius,
    this.color,
    this.titleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: height ?? 32.h,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 32.r),
            color: color ?? AppColors.primaryColor,
          ),
          child: Text(
            title,
            style: titleStyle ??
                AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                    .subTitle2
                    .copyWith(
                      color: AppColors.white,
                    ),
          ),
        ),
      ),
    );
  }
}
