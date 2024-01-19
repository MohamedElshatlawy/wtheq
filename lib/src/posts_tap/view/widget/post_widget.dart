import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/util/custom_network_image.dart';
import '../../../../core/util/formaters/time_formatter.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../domain/entities/posts_entity.dart';

class PostWidget extends StatelessWidget {
  final PostEntity postData;
  final bool networkConnection;
  const PostWidget({
    Key? key,
    required this.postData,
    required this.networkConnection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(start: 20.w),
            child: Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: AppColors.primaryColor, shape: BoxShape.circle),
                  padding: const EdgeInsets.all(1.5),
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(25.sp),
                      child: networkConnection
                          ? CustomNetworkImage(
                              url: '${postData.owner!.picture}',
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(postData.owner!.picture ?? ''),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${postData.owner!.firstName} ${postData.owner!.lastName}',
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .subTitle1
                          .copyWith(
                            color: AppColors.black,
                          ),
                    ),
                    Text(
                      TimeFormatter.convertToTimeAgo(postData.publishDate!),
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .caption
                          .copyWith(
                            color: AppColors.grey.withOpacity(0.5),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsetsDirectional.only(start: 20.w, top: 10.h),
              child: postData.text != null
                  ? Text(
                      '${postData.text}',
                      maxLines: 5,
                      style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .bodyRegular1
                          .copyWith(
                            color: AppColors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                    )
                  : const SizedBox()),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 20.w, top: 5.h),
            child: postData.tags != null
                ? Wrap(
                    runSpacing: 5.w,
                    spacing: 5.w,
                    children: postData.tags!
                        .map(
                          (e) => Text(
                            '#$e',
                            style: AppFontStyleGlobal(
                                    AppLocalizations.of(context)!.locale)
                                .bodyRegular1
                                .copyWith(
                                  color: AppColors.black,
                                ),
                          ),
                        )
                        .toList(),
                  )
                : const SizedBox(),
          ),
          if (postData.image != null)
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: SizedBox(
                  height: 270.h,
                  width: MediaQuery.of(context).size.width,
                  child: networkConnection
                      ? CustomNetworkImage(
                          url: '${postData.image}',
                          fit: BoxFit.fill,
                        )
                      : Image.file(
                          File(postData.image ?? ''),
                          fit: BoxFit.fill,
                        )),
            ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 20.w, top: 10.h),
            child: Text(
              '${postData.likes ?? 0} Likes',
              style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                  .subTitle1
                  .copyWith(
                    color: AppColors.black,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
