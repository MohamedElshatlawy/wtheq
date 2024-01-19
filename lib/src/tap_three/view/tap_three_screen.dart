import 'package:flutter/material.dart';

import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/util/localization/app_localizations.dart';

class TapThreeScreen extends StatelessWidget {
  const TapThreeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          centerTitle: true,
          title: Text(
            'Tab 3',
            style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                .headingMedium2
                .copyWith(
                  color: AppColors.black,
                ),
          ),
        ),
        body: Center(
          child: Text(
            'Coming soon...',
            style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                .headingSimiBold2
                .copyWith(
                  color: AppColors.black,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
        ));
  }
}
