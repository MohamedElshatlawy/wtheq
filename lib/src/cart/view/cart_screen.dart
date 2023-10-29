import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wteq_demo/src/cart/view/widget/cart_item_widget.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../home/data/models/Product_model.dart';
import '../../home/view/home_screen_view_model.dart';

class CartScreen extends StatelessWidget {
  final HomeScreenViewModel viewModel;

  const CartScreen({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        title: Text(
          'Cart',
          style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
              .headingMedium2
              .copyWith(
                color: AppColors.black,
              ),
        ),
      ),
      body: BlocBuilder<GenericCubit<List<ProductModel>>,
          GenericCubitState<List<ProductModel>>>(
        bloc: viewModel.cartList,
        builder: (context, states) {
          return BlocBuilder<GenericCubit<List<ProductModel>>,
                  GenericCubitState<List<ProductModel>>>(
              bloc: viewModel.favProductsList,
              builder: (context, fav) {
                return states.data.isEmpty
                    ? Center(
                        child: Text(
                          'No Products Found',
                          style: AppFontStyleGlobal(
                                  AppLocalizations.of(context)!.locale)
                              .subTitle2
                              .copyWith(
                                color: AppColors.black,
                                overflow: TextOverflow.ellipsis,
                              ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(
                            top: 10.h, bottom: 35.h, left: 16.w, right: 16.w),
                        clipBehavior: Clip.none,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return CartItem(
                            productData: states.data[index],
                            addToFav: () => viewModel.changeProductFav(
                                title: states.data[index].title!),
                            decrementProduct: () => viewModel.decrementProduct(
                                title: states.data[index].title!),
                            incrementProduct: () => viewModel.addProductToCart(
                                title: states.data[index].title!),
                            removeProduct: () =>
                                viewModel.removeProductFromCart(
                                    title: states.data[index].title!),
                          );
                        },
                        itemCount: states.data.length,
                      );
              });
        },
      ),
    );
  }
}
