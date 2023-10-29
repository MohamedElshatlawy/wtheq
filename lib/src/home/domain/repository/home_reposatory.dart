import '../../data/models/Product_model.dart';

abstract class HomeRepository {
  Future<List<ProductModel>> getProducts({
    required int pageNumber,
    required int pageSize,
  });
}
