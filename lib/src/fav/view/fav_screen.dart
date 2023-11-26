import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../home/data/models/Product_model.dart';
import '../../home/view/home_screen_view_model.dart';
import '../../home/view/widget/product_widget.dart';

class FavScreen extends StatefulWidget {
  final HomeScreenViewModel viewModel;
  const FavScreen({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  @override
  void initState() {
    widget.viewModel.getFavProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        title: Text(
          'My Favourites',
          style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
              .headingMedium2
              .copyWith(
                color: AppColors.black,
              ),
        ),
      ),
      body: BlocBuilder<GenericCubit<List<ProductModel>>,
          GenericCubitState<List<ProductModel>>>(
        bloc: widget.viewModel.favProductsList,
        builder: (context, states) {
          return states.data.isEmpty
              ? Center(
                  child: Text(
                    'No Products Found',
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                            .subTitle2
                            .copyWith(
                              color: AppColors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.only(
                      top: 10.h, bottom: 35.h, left: 16.w, right: 16.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h),
                  clipBehavior: Clip.none,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return ProductWidget(
                      productData: states.data[index],
                      addToFav: () => widget.viewModel
                          .changeProductFav(title: states.data[index].title!),
                      fromFav: true,
                    );
                  },
                  itemCount: states.data.length,
                );
        },
      ),
    );
  }
}
