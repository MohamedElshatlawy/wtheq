import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/models/failure.dart';
import '../../../core/util/network/network_info.dart';
import '../../../core/util/sql_service/sql_service.dart';
import '../data/models/posts_model.dart';
import '../domain/entities/posts_entity.dart';
import '../domain/usecases/posts_tap_usecase.dart';

class PostsTapViewModel {
  final PostsTapUseCase postsTapUseCase;
  final NetworkInfo networkInfo;

  PostsTapViewModel({required this.postsTapUseCase, required this.networkInfo});

  SqlService? dbInstance;

  GenericCubit<List<PostEntity>> allPostsList = GenericCubit([]);
  int limit = 5;
  int pageNumber = 0;
  int totalIteration = -1;
  int iterationCount = 0;
  RefreshController scrollController = RefreshController(initialRefresh: false);
  PostsResponseModel? response;
  List<PostEntity> allPosts = [];
  bool networkConnected = false;

  init() async {
    await setupDb();
    await getPostsList();
  }

  Future<void> setupDb() async {
    dbInstance = await SqlService.getInstance();
  }

  Future<bool> networkConnection() async {
    networkConnected = await networkInfo.isConnected;
    return networkConnected;
  }

  onRefresh() async {
    if (await networkConnection()) {
      pageNumber = 0;
      totalIteration = -1;
      iterationCount = 0;
      allPostsList.onUpdateData([]);
      allPosts = [];
      dbInstance!.clearDataBase();
      getPostsList();
    } else {
      List<PostModel> postsFromDataBase = await getPostFromDataBase();
      if (postsFromDataBase.isEmpty) {
        allPostsList.onConnectionError();
        scrollController.loadNoData();
      } else {
        allPostsList.onUpdateData(postsFromDataBase);
        scrollController.refreshCompleted();
        scrollController.loadComplete();
      }
    }
  }

  getPostsList() async {
    if (await networkConnection()) {
      if (iterationCount == 0) {
        allPostsList.onLoadingState();
      }
      try {
        if (totalIteration == -1 || totalIteration >= iterationCount) {
          response = await postsTapUseCase.call(
            page: pageNumber,
            limit: limit,
          );
          totalIteration = (response!.total! / limit).floor();
          if (response!.postData != null) {
            iterationCount = iterationCount + 1;
            pageNumber = pageNumber + 1;
            allPosts.addAll(response!.postData!);
            scrollController.loadComplete();
          }
        } else {
          scrollController.loadNoData();
        }
        allPostsList.onUpdateData(allPosts);
        for (var element in response!.postData!) {
          await insertPostIntoDataBase(post: element);
        }
      } on Failure catch (e) {
        allPostsList.onErrorState(e);
      }
    } else {
      List<PostModel> postsFromDataBase = await getPostFromDataBase();
      if (postsFromDataBase.isEmpty) {
        allPostsList.onConnectionError();
        scrollController.loadNoData();
      } else {
        allPostsList.onUpdateData(postsFromDataBase);
        scrollController.refreshCompleted();
        scrollController.loadComplete();
      }
    }
  }

  insertPostIntoDataBase({required PostEntity post}) async {
    File postImage = await getFileFromNetworkImage(post.image ?? '');
    File postOwnerPicture =
        await getFileFromNetworkImage(post.owner!.picture ?? '');
    dbInstance!.insertProduct(
      id: post.id!,
      image: postImage.path,
      likes: post.likes!.toString(),
      tags: post.tagsToString(),
      text: post.text!,
      publishDate: post.publishDate!,
      owner:
          '{"id":"${post.owner!.id}" , "title":"${post.owner!.title}" , "firstName":"${post.owner!.firstName}" , "lastName":"${post.owner!.lastName}", "picture":"${postOwnerPicture.path}"}',
    );
  }

  Future<File> getFileFromNetworkImage(String imageUrl) async {
    Uint8List bytes =
        (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl))
            .buffer
            .asUint8List();

    final documentDirectory = await getApplicationDocumentsDirectory();
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    File file = File(path.join(documentDirectory.path, '$fileName.png'));
    file.writeAsBytes(bytes);
    return file;
  }

  Future<List<PostModel>> getPostFromDataBase() async {
    List<PostModel> allPosts = [];
    await dbInstance!.loadSavedProduct().then((value) {
      for (final element in value) {
        final PostModel product = PostModel(
          id: element.id,
          image: element.image,
          likes: element.likes,
          tags: element.tags,
          text: element.text,
          publishDate: element.publishDate,
          owner: element.owner,
        );
        allPosts.add(product);
      }
    });
    return allPosts;
  }
}
