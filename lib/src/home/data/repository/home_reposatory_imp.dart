import '../../../../core/util/network/network_info.dart';
import '../../domain/repository/home_reposatory.dart';
import '../datasources/home_remote_data_source.dart';
import '../models/Product_model.dart';

class HomeRepositoryImp implements HomeRepository {
  final HomeRemoteDataSource dataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImp({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<List<ProductModel>> getProducts(
      {required int pageNumber, required int pageSize}) async {
    if (await networkInfo.isConnected) {
      return await dataSource.getProducts(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
    } else {
      throw Exception('No Internet Connection');
    }
  }
}
