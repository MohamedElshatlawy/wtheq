import '../../../../core/util/network_service.dart';
import '../models/Product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    required int pageNumber,
    required int pageSize,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final NetworkService networkService;

  HomeRemoteDataSourceImpl(this.networkService);
  @override
  Future<List<ProductModel>> getProducts({
    required int pageNumber,
    required int pageSize,
  }) async {
    Map<String, dynamic> queryParams = {
      "pageNumber": pageNumber,
      "pageSize": pageSize,
    };
    final response = await networkService.get(
      'api/1.0/deals',
      queryParams: queryParams,
      headers: {},
    );
    List<ProductModel> products = [];
    response.data.forEach((v) {
      products.add(ProductModel.fromJson(v));
    });
    return products;
  }
}
