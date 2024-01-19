import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wteq_demo/core/common/app_colors/app_colors.dart';

import '../../../core/base/depindancy_injection.dart';
import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../posts_tap/view/posts_tap_screen.dart';
import '../../tap_three/view/tap_three_screen.dart';
import '../../tap_two/view/tap_two_screen.dart';
import 'main_screen_view_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routeName = 'Main Screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final viewModel = sl<MainScreenViewModel>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<int>, GenericCubitState<int>>(
        bloc: viewModel.screenIndex,
        builder: (context, screenIndexStates) {
          return Scaffold(
            extendBody: true,
            bottomNavigationBar: Container(
              height: 70,
              padding: const EdgeInsets.only(
                right: 15,
                left: 15,
                top: 5,
              ),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r))),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                elevation: 0,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedItemColor: AppColors.primaryColor,
                unselectedItemColor: AppColors.grey.withOpacity(0.3),
                selectedIconTheme:
                    const IconThemeData(color: AppColors.primaryColor),
                unselectedIconTheme:
                    IconThemeData(color: AppColors.grey.withOpacity(0.3)),
                onTap: (value) {
                  viewModel.screenIndexChanged(index: value);
                  viewModel.pageController.jumpToPage(value);
                },
                currentIndex: screenIndexStates.data,
                backgroundColor: AppColors.white,
                items: [
                  BottomNavigationBarItem(
                    label: '',
                    icon: Text(
                      "Posts",
                      style: TextStyle(
                          color: screenIndexStates.data == 0
                              ? AppColors.primaryColor
                              : AppColors.grey.withOpacity(0.3),
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp),
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: '',
                    icon: Text(
                      "Tab 2",
                      style: TextStyle(
                          color: screenIndexStates.data == 1
                              ? AppColors.primaryColor
                              : AppColors.grey.withOpacity(0.3),
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp),
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: '',
                    icon: Text(
                      "Tab 3",
                      style: TextStyle(
                          color: screenIndexStates.data == 2
                              ? AppColors.primaryColor
                              : AppColors.grey.withOpacity(0.3),
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp),
                    ),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: SizedBox.expand(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: viewModel.pageController,
                  onPageChanged: (index) {},
                  children: [
                    PostsTapScreen(viewModel: viewModel.postsTapViewModel),
                    const TapTwoScreen(),
                    const TapThreeScreen(),
                  ],
                ),
              ),
            ),
            // viewModel.screens[screenIndexStates.data],
          );
        });
  }
}
