import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/app_colors/app_colors.dart';
import '../../data/models/employee_model.dart';
import 'info_widget.dart';

class EmployeeWidget extends StatelessWidget {
  final Employee employeeInfo;
  final void Function() onBookmarkTap;
  const EmployeeWidget(
      {Key? key, required this.employeeInfo, required this.onBookmarkTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.primaryColorLight, width: 1.5),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black12.withOpacity(0.06),
              offset: const Offset(0, 3),
              blurRadius: 15)
        ],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          height: 86,
          width: 86,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.primaryColorLight)),
          child: Image.asset("assets/images/profile.png",
              color: AppColors.primaryColor, fit: BoxFit.contain),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoWidget(
                title: "First Name:",
                value: "${employeeInfo.firstName}",
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                child: InfoWidget(
                  title: "Last Name:",
                  value: "${employeeInfo.lastName}",
                ),
              ),
              InfoWidget(
                title: "Employee Id:",
                value: "${employeeInfo.id}",
              ),
            ],
          ),
        ),
        SizedBox(width: 5.w),
        InkWell(
          onTap: onBookmarkTap,
          child: Icon(
            employeeInfo.isSaved == 0 ? Icons.bookmark_border : Icons.bookmark,
            size: 30,
            color: AppColors.primaryColorLight,
          ),
        ),
      ]),
    );
  }
}
