import 'package:flutter/cupertino.dart';

import '../../../core/base/depindancy_injection.dart';
import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../posts_tap/view/posts_tap_view_model.dart';

class MainScreenViewModel {
  MainScreenViewModel();

  final postsTapViewModel = sl<PostsTapViewModel>()..init();

  GenericCubit<int> screenIndex = GenericCubit<int>(0);
  PageController pageController = PageController();

  screenIndexChanged({required int index}) {
    screenIndex.onUpdateData(index);
  }
}
