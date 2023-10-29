import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wteq_demo/core/common/app_colors/app_colors.dart';

import '../../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../../core/util/custom_network_image.dart';
import '../home_screen_view_model.dart';

class HomeSlider extends StatelessWidget {
  final HomeScreenViewModel controller;

  const HomeSlider({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<List<String>>,
            GenericCubitState<List<String>>>(
        bloc: controller.adsList,
        builder: (context, states) {
          if (states is GenericLoadingState) {
            return SizedBox(
              height: 150.h,
              width: ScreenUtil().screenWidth,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
            );
          }
          return Column(
            children: [
              SizedBox(
                height: 150.h,
                width: ScreenUtil().screenWidth,
                child: CarouselSlider.builder(
                  itemCount: states.data.length,
                  itemBuilder: (context, index, pageViewIndex) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: CustomNetworkImage(
                        url: states.data[index],
                        width: double.maxFinite,
                        height: double.maxFinite,
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                  carouselController: controller.carouselController,
                  options: CarouselOptions(
                    autoPlay: true,
                    viewportFraction: 1,
                    enlargeCenterPage: true,
                    height: double.maxFinite,
                    onPageChanged: controller.updateCarouselIndex,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              BlocBuilder<GenericCubit<int>, GenericCubitState<int>>(
                bloc: controller.carouselIndex,
                builder: (context, state) {
                  return DotsIndicator(
                    dotsCount: 3,
                    position: state.data,
                    decorator: DotsDecorator(
                      color: AppColors.grey.withOpacity(0.3),
                      activeSize: const Size(13, 7),
                      activeColor: AppColors.primaryColor,
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }
}
