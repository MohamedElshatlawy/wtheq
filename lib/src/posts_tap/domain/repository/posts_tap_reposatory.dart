import '../../data/models/posts_model.dart';

abstract class PostsTapRepository {
  Future<PostsResponseModel> getPosts({
    required int page,
    required int limit,
  });
}
