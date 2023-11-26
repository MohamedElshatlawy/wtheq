import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/util/custom_network_image.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../data/models/Product_model.dart';
import '../product_details.dart';

class ProductWidget extends StatelessWidget {
  final ProductModel productData;
  final void Function() addToFav;
  final bool? fromFav;
  const ProductWidget({
    Key? key,
    required this.productData,
    required this.addToFav,
    this.fromFav = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        ProductDetailsScreen.routeName,
        arguments: {
          'productData': productData,
          'addToFav': addToFav,
          'fromFav': fromFav,
        },
      ),
      child: Container(
        padding: EdgeInsets.only(top: 8, right: 5.w, left: 5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
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
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: addToFav,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.grey.withOpacity(0.1)),
                  width: 24,
                  height: 24,
                  child: Icon(
                    productData.isFav == 1
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    size: 14,
                    color: AppColors.red,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: SizedBox(
                  height: 130.h,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: fromFav == false
                        ? CustomNetworkImage(
                            url: productData.thumb,
                            fit: BoxFit.fill,
                          )
                        : Image.file(
                            File(productData.thumb ?? ''),
                            fit: BoxFit.fill,
                          ),
                  )),
            ),
            Text(
              productData.title!,
              style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                  .subTitle2
                  .copyWith(
                    color: AppColors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Text(
                    '${productData.salePrice} SAR',
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                            .subTitle2
                            .copyWith(
                              color: AppColors.primaryColor,
                            ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '${productData.normalPrice} SAR',
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                            .bodyRegular1
                            .copyWith(
                              color: AppColors.primaryColor,
                              fontSize: 11,
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
                  initialRating: double.parse(productData.steamRatingCount!),
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 10,
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
            // AppButton(
            //   onPressed: addToCart,
            //   title: 'Add To Cart',
            // )
          ],
        ),
      ),
    );
  }
}
