import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wteq_demo/core/components/app_snake_bar/app_snake_bar.dart';
import 'package:wteq_demo/src/home/view/widget/product_widget.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/components/app_alert_dialog/app_alert_dialog.dart';
import '../../../core/components/app_custom_refresh_indicator/app_custom_refresh_indicator.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../../core/util/notification_helper.dart';
import '../../notification_screen/data/models/notification_model.dart';
import '../../notification_screen/view/notification_screen.dart';
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
    widget.viewModel.connectionChecker(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          actions: [
            BlocConsumer<GenericCubit<List<NotificationModel>>,
                GenericCubitState<List<NotificationModel>>>(
              bloc: NotificationHelper.notificationsCubit,
              builder: (context, states) {
                return Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          NotificationScreen.routeName,
                        );
                        NotificationHelper.changeNotificationStatus();
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.notifications,
                        size: 24,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Positioned(
                      bottom: 22,
                      left: 13,
                      child: Visibility(
                        visible:
                            states.data.any((element) => element.seen == false),
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: AppColors.red),
                        ),
                      ),
                    )
                  ],
                );
              },
              listener: (BuildContext context,
                  GenericCubitState<List<NotificationModel>> state) {},
            ),
          ],
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
        body: BlocConsumer<GenericCubit<List<ProductModel>>,
                GenericCubitState<List<ProductModel>>>(
            bloc: widget.viewModel.allProductsList,
            listener: (context, states) async {
              if (states is GenericConnectionError) {
                await AppAlertDialog().showInternetConnectionDialog(
                  context: context,
                  title: 'No Internet Connection Available\nPlease Retry Again',
                );
              }
            },
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
                              // BlocBuilder<GenericCubit<bool>, GenericCubitState<bool>>(
                              //     bloc: widget.viewModel.enableAdsValue,
                              //     builder: (context, states) {
                              //       if (states.data) {
                              //         return Padding(
                              //             padding: EdgeInsets.only(
                              //                 top: 30.h, left: 16.w, right: 16.w),
                              //             child:
                              //                 HomeSlider(controller: widget.viewModel));
                              //       } else {
                              //         return const SizedBox();
                              //       }
                              //     }),
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
                                        // 0.52,
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
                                  addToCart: () {
                                    AppSnakeBar.showSnakeBar(
                                        context: context,
                                        message:
                                            'Product Added To Cart Successfully');
                                    widget.viewModel.addProductToCart(
                                        title: states.data[index].title!);
                                  },
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
