import 'package:flutter/cupertino.dart';

import '../../../core/base/depindancy_injection.dart';
import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../home/view/home_screen_view_model.dart';

class MainScreenViewModel {
  MainScreenViewModel();

  final homeScreenViewModel = sl<HomeScreenViewModel>()..init();

  GenericCubit<int> screenIndex = GenericCubit<int>(0);
  PageController pageController = PageController();

  screenIndexChanged({required int index}) {
    screenIndex.onUpdateData(index);
  }
}
