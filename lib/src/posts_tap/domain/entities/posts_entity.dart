class PostsResponseEntity {
  List<PostEntity>? postData;
  int? total;
  int? page;
  int? limit;

  PostsResponseEntity({this.postData, this.total, this.page, this.limit});

  PostsResponseEntity copyWith({
    List<PostEntity>? postData,
    int? total,
    int? page,
    int? limit,
  }) {
    return PostsResponseEntity(
      postData: postData ?? this.postData,
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }
}

class PostEntity {
  String? id;
  String? image;
  int? likes;
  List<String>? tags;
  String? text;
  String? publishDate;
  OwnerEntity? owner;

  PostEntity(
      {this.id,
      this.image,
      this.likes,
      this.tags,
      this.text,
      this.publishDate,
      this.owner});

  PostEntity copyWith({
    String? id,
    String? image,
    int? likes,
    List<String>? tags,
    String? text,
    String? publishDate,
    OwnerEntity? owner,
  }) {
    return PostEntity(
      id: id ?? this.id,
      image: image ?? this.image,
      likes: likes ?? this.likes,
      tags: tags ?? this.tags,
      text: text ?? this.text,
      publishDate: publishDate ?? this.publishDate,
      owner: owner ?? this.owner,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['likes'] = likes;
    data['tags'] = tags;
    data['text'] = text;
    data['publishDate'] = publishDate;
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    return data;
  }

  String tagsToString() {
    return tags!.join(",");
  }
}

class OwnerEntity {
  String? id;
  String? title;
  String? firstName;
  String? lastName;
  String? picture;

  OwnerEntity(
      {this.id, this.title, this.firstName, this.lastName, this.picture});

  OwnerEntity copyWith({
    String? id,
    String? title,
    String? firstName,
    String? lastName,
    String? picture,
  }) {
    return OwnerEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      picture: picture ?? this.picture,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['picture'] = picture;
    return data;
  }
}
