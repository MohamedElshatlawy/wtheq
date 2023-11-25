import 'package:flutter/material.dart';

import '../../common/app_colors/app_colors.dart';

class CustomRefreshIndicator extends StatelessWidget {
  const CustomRefreshIndicator({super.key, this.refresh, this.child});

  final Function? refresh;
  final Widget? child;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        color: AppColors.white,
        backgroundColor: AppColors.primaryColor,
        strokeWidth: 4,
        onRefresh: () => refresh!(),
        child: child!,
      );
}
