import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:restart_app/restart_app.dart';

import '../../../src/main_screen/view/main_screen.dart';
import '../../common/app_colors/app_colors.dart';
import '../../common/app_font_style/app_font_style_global.dart';
import '../../util/localization/app_localizations.dart';

class AppAlertDialog {
  Future showInternetConnectionDialog({
    required BuildContext context,
    void Function()? retry,
    required String title,
  }) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          title,
          style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
              .subTitle2
              .copyWith(
                color: AppColors.primaryColor,
              ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: retry ??
                () {
                  if (Platform.isIOS) {
                    Navigator.pop(context);
                  } else {
                    Restart.restartApp(webOrigin: MainScreen.routeName);
                  }
                },
            child: Text(
              'retry',
              style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                  .subTitle2
                  .copyWith(
                    fontSize: 13,
                    color: AppColors.black,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
