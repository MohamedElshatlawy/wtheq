import 'package:flutter/material.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/util/localization/app_localizations.dart';

class InfoWidget extends StatelessWidget {
  final String title;
  final String value;
  const InfoWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
              .caption
              .copyWith(
                color: AppColors.grey.withOpacity(0.7),
              ),
        ),
        Text(
          value,
          style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
              .bodyMedium1
              .copyWith(
                color: AppColors.primaryColor,
              ),
        ),
      ],
    );
  }
}
