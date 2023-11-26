import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/util/custom_network_image.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../data/models/Product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel productData;
  final void Function() addToFav;
  final bool? fromFav;

  const ProductDetailsScreen({
    Key? key,
    required this.productData,
    required this.addToFav,
    this.fromFav = false,
  }) : super(key: key);
  static const String routeName = 'Product Details Screen';

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.chevron_left_outlined,
            size: 30,
            color: AppColors.primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border:
                          Border.all(color: AppColors.grey.withOpacity(0.3)),
                    ),
                    height: 250.h,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r)),
                        child: widget.fromFav == false
                            ? CustomNetworkImage(
                                url: widget.productData.thumb,
                                fit: BoxFit.fill,
                              )
                            : Image.file(
                                File(widget.productData.thumb ?? ''),
                                fit: BoxFit.fill,
                              ))),
                SizedBox(height: 30.h),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        widget.productData.title!,
                        style: AppFontStyleGlobal(
                                AppLocalizations.of(context)!.locale)
                            .subTitle1
                            .copyWith(
                              color: AppColors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          widget.addToFav();
                          setState(() {});
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.grey.withOpacity(0.1)),
                          width: 30,
                          height: 30,
                          child: Icon(
                            widget.productData.isFav == 1
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            size: 20,
                            color: AppColors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Row(
                    children: [
                      Text(
                        '${widget.productData.salePrice} SAR',
                        style: AppFontStyleGlobal(
                                AppLocalizations.of(context)!.locale)
                            .subTitle1
                            .copyWith(
                              color: AppColors.primaryColor,
                            ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        '${widget.productData.normalPrice} SAR',
                        style: AppFontStyleGlobal(
                                AppLocalizations.of(context)!.locale)
                            .bodyRegular1
                            .copyWith(
                              color: AppColors.primaryColor,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: RatingBar.builder(
                      initialRating:
                          double.parse(widget.productData.steamRatingCount!),
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 14,
                      ignoreGestures: true,
                      unratedColor: AppColors.grey.withOpacity(0.2),
                      itemPadding: EdgeInsets.zero,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: AppColors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
