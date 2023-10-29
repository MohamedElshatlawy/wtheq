import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../../core/util/notification_helper.dart';
import '../data/models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  static const String routeName = 'Notification Screen';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool initialized = false;
  List<NotificationModel> notificationsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
              .headingMedium2
              .copyWith(
                color: AppColors.black,
              ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.chevron_left_outlined,
            size: 30,
            color: AppColors.primaryColor,
          ),
        ),
      ),
      body: Container(
          constraints: const BoxConstraints.expand(),
          child: FutureBuilder(
            future: NotificationHelper.notificationStorage.ready,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.primaryColor),
                );
              }
              if (!initialized) {
                var items = NotificationHelper.notificationStorage
                    .getItem('notifications');

                if (items != null) {
                  notificationsList = List<NotificationModel>.from(
                    (items as List).map(
                      (item) => NotificationModel(
                        messageId: item['messageId'],
                        messageTitle: item['messageTitle'],
                        messageBody: item['messageBody'],
                        seen: item['seen'],
                      ),
                    ),
                  );
                }

                initialized = true;
              }

              List<Widget> widgets = notificationsList.map((item) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.w,
                    horizontal: 20.w,
                  ),
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        blurRadius: 14,
                        color: AppColors.grey.withOpacity(0.15),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.messageTitle ?? '',
                        style: AppFontStyleGlobal(
                                AppLocalizations.of(context)!.locale)
                            .subTitle2
                            .copyWith(
                              color: AppColors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        item.messageBody ?? '',
                        style: AppFontStyleGlobal(
                                AppLocalizations.of(context)!.locale)
                            .subTitle2
                            .copyWith(
                              color: AppColors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                      ),
                    ],
                  ),
                );
              }).toList();

              return Column(
                children: <Widget>[
                  ListView(
                    padding: EdgeInsets.symmetric(
                      vertical: 20.h,
                      horizontal: 20.w,
                    ),
                    shrinkWrap: true,
                    children: widgets,
                  ),
                ],
              );
            },
          )),
    );
  }
}
