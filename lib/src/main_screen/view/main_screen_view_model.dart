import 'package:flutter/cupertino.dart';

import '../../../core/base/depindancy_injection.dart';
import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../employee/view/employee_view_model.dart';

class MainScreenViewModel {
  MainScreenViewModel();

  final employeeViewModel = sl<EmployeeViewModel>()..init();
  GenericCubit<int> screenIndex = GenericCubit<int>(0);
  PageController pageController = PageController();

  screenIndexChanged({required int index}) {
    screenIndex.onUpdateData(index);
  }
}
