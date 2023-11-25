import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wteq_demo/core/base/route_genrator.dart';

import '../../src/home/data/datasources/home_remote_data_source.dart';
import '../../src/home/data/repository/home_reposatory_imp.dart';
import '../../src/home/domain/repository/home_reposatory.dart';
import '../../src/home/domain/usecases/home_usecase.dart';
import '../../src/home/view/home_screen_view_model.dart';
import '../../src/main_screen/view/main_screen_view_model.dart';
import '../common/config.dart';
import '../util/localization/cubit/localization_cubit.dart';
import '../util/network/network_info.dart';
import '../util/network_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => LocalizationCubit());
  sl.registerFactory(() => RouteGenrator(routs: sl()));

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
  sl.registerFactory(
      () => HomeScreenViewModel(homeUseCase: sl(), networkInfo: sl()));

  /// USECASES
  sl.registerLazySingleton(() => HomeUseCase(sl()));

  /// REPOSITORIES
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImp(
        dataSource: sl(),
        networkInfo: sl(),
      ));

  /// DATA SOURCE
  sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(sl()));
}
