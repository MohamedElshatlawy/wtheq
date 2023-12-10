import 'package:flutter/cupertino.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/util/network/network_info.dart';
import '../../../core/util/shared_preferences_helper.dart';
import '../../../core/util/sql_service/sql_service.dart';
import '../../select_employee/view/select_the_employee_screen.dart';
import '../data/models/employee_model.dart';
import '../domain/usecases/employee_usecase.dart';

class EmployeeViewModel {
  final EmployeeUseCase employeeUseCase;
  final NetworkInfo networkInfo;

  EmployeeViewModel({required this.employeeUseCase, required this.networkInfo});

  SqlService? dbInstance;

  GenericCubit<List<Employee>> employeeList = GenericCubit([]);
  GenericCubit<List<Employee>> markBookEmployeeList = GenericCubit([]);
  List<String> markBookEmployeeId = [];
  init() async {
    await setupDb();
    int selectedIndex =
        await PreferenceManager.getInstance()!.getInt('selectedIndex');
    getEmployeeList(role: selectedIndex == 0 ? "IT" : "HR");
  }

  Future<void> setupDb() async {
    dbInstance = await SqlService.getInstance();
  }

  getEmployeeList({required String role}) async {
    employeeList.onLoadingState();
    var response = await employeeUseCase.call(role: role);
    response.fold((l) {
      employeeList.onErrorState(l);
    }, (r) async {
      await getMarkBookEmployee().then((value) {
        if (markBookEmployeeList.state.data.isNotEmpty) {
          for (var e in r) {
            if (markBookEmployeeId.contains(e.id)) {
              e.isSaved = 1;
            } else {
              e.isSaved = 0;
            }
          }
        }
        employeeList.onUpdateData(r);
      });
    });
  }

  changeMarkBookState({required String id}) async {
    List<Employee> markBookEmployee = [];
    employeeList.onChangeState();
    markBookEmployeeList.onChangeState();
    if (employeeList.state.data.isNotEmpty) {
      for (var element in employeeList.state.data) {
        if (element.id == id) {
          if (element.isSaved == 0) {
            element.isSaved = 1;
            dbInstance!.insertEmployee(
              employeeModel: Employee(
                id: element.id,
                firstName: element.firstName,
                lastName: element.lastName,
                role: element.role,
                isSaved: 1,
              ),
            );
          } else {
            element.isSaved = 0;
            dbInstance!.deleteEmployee(element.id ?? '');
          }
        }
      }
      employeeList.onUpdateData(employeeList.state.data);
      markBookEmployee = await dbInstance!.loadSavedEmployee();
      markBookEmployeeList.onUpdateData(markBookEmployee);
    }
  }

  Future<void> getMarkBookEmployee() async {
    List<Employee> favProducts = [];
    markBookEmployeeId = [];
    markBookEmployeeList.onChangeState();
    await dbInstance!.loadSavedEmployee().then((value) {
      for (final element in value) {
        final Employee employee = Employee(
          id: element.id,
          firstName: element.firstName,
          lastName: element.lastName,
          role: element.role,
          isSaved: 1,
        );
        favProducts.add(employee);
      }
    });
    for (var element in favProducts) {
      markBookEmployeeId.add(element.id!);
    }
    markBookEmployeeList.onUpdateData(favProducts);
  }

  signOut({
    required BuildContext context,
  }) async {
    PreferenceManager.getInstance()!.remove('selectedIndex');
    await dbInstance!.clearSavedEmployeeList()!.then((value) {
      Navigator.pushNamed(
        context,
        SelectTheEmployeeScreen.routeName,
      );
    });
  }
}
