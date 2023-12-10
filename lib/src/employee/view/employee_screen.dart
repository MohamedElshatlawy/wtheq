import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wteq_demo/src/employee/view/widget/employee_widget.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/components/app_custom_refresh_indicator/app_custom_refresh_indicator.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../data/models/employee_model.dart';
import 'employee_view_model.dart';

class EmployeeScreen extends StatefulWidget {
  final EmployeeViewModel viewModel;

  final int selectedIndex;
  const EmployeeScreen({
    Key? key,
    required this.selectedIndex,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'POC',
          style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
              .headingMedium2
              .copyWith(
                color: AppColors.black,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => widget.viewModel.signOut(context: context),
            child: Text(
              'SignOut',
              style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                  .bodyRegular1
                  .copyWith(
                    color: AppColors.black,
                  ),
            ),
          )
        ],
      ),
      body: BlocBuilder<GenericCubit<List<Employee>>,
              GenericCubitState<List<Employee>>>(
          bloc: widget.viewModel.employeeList,
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
                      refresh: () => widget.viewModel.getEmployeeList(
                          role: widget.selectedIndex == 0 ? "IT" : "HR"),
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 15.h),
                        padding: EdgeInsets.only(
                            top: 20.h, bottom: 35.h, left: 16.w, right: 16.w),
                        clipBehavior: Clip.none,
                        shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => EmployeeWidget(
                          employeeInfo: states.data[index],
                          onBookmarkTap: () => widget.viewModel
                              .changeMarkBookState(id: states.data[index].id!),
                        ),
                        itemCount: states.data.length,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
