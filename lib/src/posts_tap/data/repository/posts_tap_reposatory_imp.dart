import '../../../../core/util/network/network_info.dart';
import '../../domain/repository/posts_tap_reposatory.dart';
import '../datasources/posts_tap_remote_data_source.dart';
import '../models/posts_model.dart';

class PostsTapRepositoryImp implements PostsTapRepository {
  final PostsTapRemoteDataSource dataSource;
  final NetworkInfo networkInfo;

  PostsTapRepositoryImp({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<PostsResponseModel> getPosts(
      {required int page, required int limit}) async {
    if (await networkInfo.isConnected) {
      return await dataSource.getPosts(
        page: page,
        limit: limit,
      );
    } else {
      throw Exception('No Internet Connection');
    }
  }
}
