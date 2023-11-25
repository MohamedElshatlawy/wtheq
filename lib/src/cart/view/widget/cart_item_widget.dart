import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/util/custom_network_image.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../../home/data/models/Product_model.dart';

class CartItem extends StatefulWidget {
  final ProductModel productData;
  final void Function() addToFav;
  final void Function() decrementProduct;
  final void Function() incrementProduct;
  final void Function() removeProduct;

  const CartItem({
    Key? key,
    required this.productData,
    required this.addToFav,
    required this.decrementProduct,
    required this.incrementProduct,
    required this.removeProduct,
  }) : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
          color: AppColors.white,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: CustomNetworkImage(
                url: widget.productData.thumb,
                height: 130.h,
                width: 130.w,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.productData.title ?? '',
                            maxLines: 3,
                            style: AppFontStyleGlobal(
                                    AppLocalizations.of(context)!.locale)
                                .subTitle2
                                .copyWith(
                                  color: AppColors.black,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: widget.incrementProduct,
                              child: Container(
                                margin: EdgeInsetsDirectional.only(end: 10.w),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColors.grey.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: const Icon(Icons.add,
                                    size: 18, color: AppColors.primaryColor),
                              ),
                            ),
                            Text(
                              widget.productData.qty.toString(),
                              style: AppFontStyleGlobal(
                                      AppLocalizations.of(context)!.locale)
                                  .subTitle2
                                  .copyWith(
                                    color: AppColors.black,
                                  ),
                            ),
                            InkWell(
                              onTap: widget.decrementProduct,
                              child: Container(
                                margin: EdgeInsetsDirectional.only(start: 10.w),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColors.grey.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: const Icon(Icons.remove_outlined,
                                    size: 18, color: AppColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(children: [
                      InkWell(
                        onTap: widget.addToFav,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppColors.grey.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: widget.productData.isFav == 1
                              ? const Icon(Icons.favorite,
                                  size: 18, color: AppColors.red)
                              : Row(
                                  children: [
                                    const Icon(Icons.favorite_border_outlined,
                                        size: 18,
                                        color: AppColors.primaryColor),
                                    Text(
                                      'Add to Fav',
                                      style: AppFontStyleGlobal(
                                              AppLocalizations.of(context)!
                                                  .locale)
                                          .caption
                                          .copyWith(
                                            color: AppColors.primaryColor,
                                          ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      InkWell(
                        onTap: widget.removeProduct,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppColors.grey.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.delete_outlined,
                                  size: 18, color: AppColors.primaryColor),
                              Text(
                                'Delete',
                                style: AppFontStyleGlobal(
                                        AppLocalizations.of(context)!.locale)
                                    .caption
                                    .copyWith(
                                      color: AppColors.primaryColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
