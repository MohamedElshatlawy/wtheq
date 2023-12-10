import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wteq_demo/core/base/route_genrator.dart';

import '../../src/employee/data/datasources/employee_remote_data_source.dart';
import '../../src/employee/data/repository/employee_reposatory_imp.dart';
import '../../src/employee/domain/repository/employee_reposatory.dart';
import '../../src/employee/domain/usecases/employee_usecase.dart';
import '../../src/employee/view/employee_view_model.dart';
import '../../src/main_screen/view/main_screen_view_model.dart';
import '../../src/select_employee/view/select_the_employee_view_model.dart';
import '../common/config.dart';
import '../util/localization/cubit/localization_cubit.dart';
import '../util/network/network_info.dart';
import '../util/network_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => LocalizationCubit());
  sl.registerFactory(() => RouteGenerator(routs: sl()));

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerLazySingleton(() => InternetConnectionChecker());

  sl.registerLazySingleton<NetworkService>(() => NetworkServiceImpl());

  sl.registerLazySingleton(() => Dio(
        BaseOptions(
          baseUrl: Config.baseUrl,
          connectTimeout: 100000,
          receiveTimeout: 100000,
          headers: Config.headers,
        ),
      )..interceptors.add(
          LogInterceptor(
            responseBody: true,
            requestBody: true,
          ),
        ));

  /// VIEW MODELS
  sl.registerFactory(() => MainScreenViewModel());
  sl.registerFactory(() => SelectTheEmployeeViewModel());
  sl.registerFactory(
      () => EmployeeViewModel(employeeUseCase: sl(), networkInfo: sl()));

  /// USECASES
  sl.registerLazySingleton(() => EmployeeUseCase(sl()));

  /// REPOSITORIES
  sl.registerLazySingleton<EmployeeRepository>(() => EmployeeRepositoryImp(
        dataSource: sl(),
        networkInfo: sl(),
      ));

  /// DATA SOURCE
  sl.registerLazySingleton<EmployeeRemoteDataSource>(
      () => EmployeeRemoteDataSourceImpl(sl()));
}
