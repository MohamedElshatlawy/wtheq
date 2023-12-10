import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/util/localization/app_localizations.dart';

class SelectionWidget extends StatelessWidget {
  final void Function() onTap;
  final IconData icon;
  final String data;
  final bool selected;
  const SelectionWidget({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.data,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(
              color:
                  selected ? AppColors.primaryColorLight : Colors.transparent,
              width: 1.5),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black12.withOpacity(0.06),
                offset: const Offset(0, 3),
                blurRadius: 15)
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primaryColor,
              size: 50,
            ),
            SizedBox(height: 10.h),
            Text(
              data,
              style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                  .heading1
                  .copyWith(
                    color: AppColors.primaryColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
