import '../../data/models/posts_model.dart';
import '../repository/posts_tap_reposatory.dart';

class PostsTapUseCase {
  final PostsTapRepository _postsTapRepository;

  PostsTapUseCase(this._postsTapRepository);

  Future<PostsResponseModel> call({
    required int page,
    required int limit,
  }) async {
    return await _postsTapRepository.getPosts(
      page: page,
      limit: limit,
    );
  }
}
