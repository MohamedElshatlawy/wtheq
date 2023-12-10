import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/app_colors/app_colors.dart';
import '../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../core/util/localization/app_localizations.dart';
import '../../employee/data/models/employee_model.dart';
import '../../employee/view/employee_view_model.dart';
import '../../employee/view/widget/employee_widget.dart';

class BookMarkScreen extends StatefulWidget {
  final EmployeeViewModel viewModel;
  const BookMarkScreen({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<BookMarkScreen> createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  @override
  void initState() {
    widget.viewModel.getMarkBookEmployee();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Book Marks',
          style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
              .headingMedium2
              .copyWith(
                color: AppColors.black,
              ),
        ),
      ),
      body: BlocBuilder<GenericCubit<List<Employee>>,
          GenericCubitState<List<Employee>>>(
        bloc: widget.viewModel.markBookEmployeeList,
        builder: (context, states) {
          return states.data.isEmpty
              ? Center(
                  child: Text(
                    'No Book Marks Found',
                    style:
                        AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
                            .subTitle2
                            .copyWith(
                              color: AppColors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                  ),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 15.h),
                  padding: EdgeInsets.only(
                      top: 20.h, bottom: 35.h, left: 16.w, right: 16.w),
                  clipBehavior: Clip.none,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => EmployeeWidget(
                    employeeInfo: states.data[index],
                    onBookmarkTap: () => widget.viewModel
                        .changeMarkBookState(id: states.data[index].id!),
                  ),
                  itemCount: states.data.length,
                );
        },
      ),
    );
  }
}
