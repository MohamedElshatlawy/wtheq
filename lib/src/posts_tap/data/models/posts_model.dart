import 'dart:convert';

import '../../domain/entities/posts_entity.dart';

class PostsResponseModel extends PostsResponseEntity {
  PostsResponseModel({
    super.postData,
    super.total,
    super.page,
    super.limit,
  });

  factory PostsResponseModel.fromJson(Map<String, dynamic> json) {
    return PostsResponseModel(
      postData:
          (json['data'] as List).map((e) => PostModel.fromJson(e)).toList(),
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
    );
  }
}

class PostModel extends PostEntity {
  PostModel({
    super.id,
    super.image,
    super.likes,
    super.tags,
    super.text,
    super.publishDate,
    super.owner,
  });
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      image: json['image'],
      likes: json['likes'],
      tags: json['tags'].cast<String>(),
      text: json['text'],
      publishDate: json['publishDate'],
      owner: json['owner'] != null ? OwnerModel.fromJson(json['owner']) : null,
    );
  }
  factory PostModel.fromDataBase(Map<String, dynamic> data) {
    return PostModel(
      id: data['postId'],
      image: data['image'],
      likes: int.parse(data['likes']),
      tags: data['tags'].split(',').toList(),
      text: data['text'],
      publishDate: data['publishDate'],
      owner: data['owner'] != null
          ? OwnerModel(
              id: jsonDecode(data['owner'])['id'],
              title: jsonDecode(data['owner'])['title'],
              firstName: jsonDecode(data['owner'])['firstName'],
              lastName: jsonDecode(data['owner'])['lastName'],
              picture: jsonDecode(data['owner'])['picture'],
            )
          : null,
    );
  }
}

class OwnerModel extends OwnerEntity {
  OwnerModel({
    super.id,
    super.title,
    super.firstName,
    super.lastName,
    super.picture,
  });
  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      id: json['id'],
      title: json['title'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      picture: json['picture'],
    );
  }
}
