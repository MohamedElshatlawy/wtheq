import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/util/shared_preferences_helper.dart';

class SelectTheEmployeeViewModel {
  SelectTheEmployeeViewModel();
  GenericCubit<dynamic> selectedIndex = GenericCubit(null);
  changeSelectedIndex({required int index}) {
    selectedIndex.onChangeState();
    selectedIndex.onUpdateData(index);
    if (selectedIndex.state.data != null) {
      PreferenceManager.getInstance()!
          .saveInt('selectedIndex', selectedIndex.state.data);
    }
  }
}
