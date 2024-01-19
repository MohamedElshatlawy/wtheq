import '../../../../core/common/config.dart';
import '../../../../core/util/network_service.dart';
import '../models/posts_model.dart';

abstract class PostsTapRemoteDataSource {
  Future<PostsResponseModel> getPosts({
    required int page,
    required int limit,
  });
}

class PostsTapRemoteDataSourceImpl implements PostsTapRemoteDataSource {
  final NetworkService networkService;

  PostsTapRemoteDataSourceImpl(this.networkService);
  @override
  Future<PostsResponseModel> getPosts({
    required int page,
    required int limit,
  }) async {
    Map<String, dynamic> queryParams = {
      "page": page,
      "limit": limit,
    };
    final response = await networkService.get(
      'post',
      queryParams: queryParams,
      headers: {"app-id": Config.appId},
    );
    return PostsResponseModel.fromJson(response.data);
  }
}
