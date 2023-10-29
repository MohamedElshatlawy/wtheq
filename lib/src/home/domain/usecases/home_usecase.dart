import '../../data/models/Product_model.dart';
import '../repository/home_reposatory.dart';

class HomeUseCase {
  final HomeRepository _homeRepository;

  HomeUseCase(this._homeRepository);

  Future<List<ProductModel>> call({
    required int pageNumber,
    required int pageSize,
  }) async {
    return await _homeRepository.getProducts(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
