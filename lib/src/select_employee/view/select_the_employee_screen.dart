import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wteq_demo/src/select_employee/view/select_the_employee_view_model.dart';
import 'package:wteq_demo/src/select_employee/view/widget/selection_widget.dart';

import '../../../core/base/depindancy_injection.dart';
import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/components/app_button/app_button.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../main_screen/view/main_screen.dart';

class SelectTheEmployeeScreen extends StatelessWidget {
  SelectTheEmployeeScreen({Key? key}) : super(key: key);
  static const String routeName = 'Select The Employee Screen';
  final viewModel = sl<SelectTheEmployeeViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          centerTitle: true,
          title: Text(
            'Select The Employee',
            style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                .headingMedium2
                .copyWith(
                  color: AppColors.black,
                ),
          ),
        ),
        body: BlocBuilder<GenericCubit<dynamic>, GenericCubitState<dynamic>>(
            bloc: viewModel.selectedIndex,
            builder: (context, states) {
              return Padding(
                padding: EdgeInsets.only(
                    left: 20.w, right: 20.w, top: 200.h, bottom: 30.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SelectionWidget(
                            data: 'IT',
                            icon: Icons.person,
                            onTap: () =>
                                viewModel.changeSelectedIndex(index: 0),
                            selected: states.data == 0 ? true : false,
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: SelectionWidget(
                            data: 'HR',
                            icon: Icons.people,
                            onTap: () =>
                                viewModel.changeSelectedIndex(index: 1),
                            selected: states.data == 1 ? true : false,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    AppButton(
                      onPressed: states.data != null
                          ? () {
                              Navigator.pushNamed(
                                context,
                                MainScreen.routeName,
                                arguments: {
                                  'selectedIndex': states.data,
                                },
                              );
                            }
                          : null,
                      height: 48.h,
                      titleStyle: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale)
                          .subTitle1
                          .copyWith(
                            color: AppColors.white,
                          ),
                      color: states.data != null
                          ? AppColors.primaryColor
                          : AppColors.grey.withOpacity(0.3),
                      title: 'Apply',
                    )
                  ],
                ),
              );
            }));
  }
}
