import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wteq_demo/core/base/route_genrator.dart';

import '../../src/main_screen/view/main_screen_view_model.dart';
import '../../src/posts_tap/data/datasources/posts_tap_remote_data_source.dart';
import '../../src/posts_tap/data/repository/posts_tap_reposatory_imp.dart';
import '../../src/posts_tap/domain/repository/posts_tap_reposatory.dart';
import '../../src/posts_tap/domain/usecases/posts_tap_usecase.dart';
import '../../src/posts_tap/view/posts_tap_view_model.dart';
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
  sl.registerFactory(
      () => PostsTapViewModel(postsTapUseCase: sl(), networkInfo: sl()));

  /// USECASES
  sl.registerLazySingleton(() => PostsTapUseCase(sl()));

  /// REPOSITORIES
  sl.registerLazySingleton<PostsTapRepository>(() => PostsTapRepositoryImp(
        dataSource: sl(),
        networkInfo: sl(),
      ));

  /// DATA SOURCE
  sl.registerLazySingleton<PostsTapRemoteDataSource>(
      () => PostsTapRemoteDataSourceImpl(sl()));
}
