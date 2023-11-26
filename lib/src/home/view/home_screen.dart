import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restart_app/restart_app.dart';
import 'package:wteq_demo/src/home/view/widget/product_widget.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/components/app_custom_refresh_indicator/app_custom_refresh_indicator.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../main_screen/view/main_screen.dart';
import '../data/models/Product_model.dart';
import 'home_screen_view_model.dart';

class HomeScreen extends StatefulWidget {
  final HomeScreenViewModel viewModel;

  const HomeScreen({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    widget.viewModel.getProductsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          centerTitle: true,
          title: Text(
            'Home',
            style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                .headingMedium2
                .copyWith(
                  color: AppColors.black,
                ),
          ),
        ),
        body: BlocBuilder<GenericCubit<List<ProductModel>>,
                GenericCubitState<List<ProductModel>>>(
            bloc: widget.viewModel.allProductsList,
            builder: (context, states) {
              if (states is GenericLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              } else if (states is GenericErrorState) {
                return Center(
                  child: Text(
                    'error',
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                            .bodyMedium1
                            .copyWith(
                              color: AppColors.red,
                            ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (states is GenericConnectionError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No Internet Connection Available\nPlease Retry Again',
                        style: AppFontStyleGlobal(
                                AppLocalizations.of(context)!.locale)
                            .subTitle2
                            .copyWith(
                              color: AppColors.primaryColor,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      IconButton(
                          onPressed: () => Restart.restartApp(
                              webOrigin: MainScreen.routeName),
                          icon: const Icon(
                            Icons.refresh_outlined,
                            color: AppColors.primaryColor,
                          ))
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: Scrollbar(
                      child: CustomRefreshIndicator(
                        refresh: () => widget.viewModel.getProductsList(),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              GridView.builder(
                                padding: EdgeInsets.only(
                                    top: 20.h,
                                    bottom: 35.h,
                                    left: 16.w,
                                    right: 16.w),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.6,
                                        crossAxisSpacing: 10.w,
                                        mainAxisSpacing: 10.h),
                                clipBehavior: Clip.none,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => ProductWidget(
                                  productData: states.data[index],
                                  addToFav: () => widget.viewModel
                                      .changeProductFav(
                                          title: states.data[index].title!),
                                  fromFav: false,
                                ),
                                itemCount: states.data.length,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}
