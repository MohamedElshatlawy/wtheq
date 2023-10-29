class ProductModel {
  String? internalName;
  String? title;
  String? metacriticLink;
  String? dealID;
  String? storeID;
  String? gameID;
  String? salePrice;
  String? normalPrice;
  String? isOnSale;
  String? savings;
  String? metacriticScore;
  String? steamRatingText;
  String? steamRatingPercent;
  String? steamRatingCount;
  String? steamAppID;
  int? releaseDate;
  int? lastChange;
  String? dealRating;
  String? thumb;
  bool? isFav = false;
  int? qty = 0;
  ProductModel({
    this.internalName,
    this.title,
    this.metacriticLink,
    this.dealID,
    this.storeID,
    this.gameID,
    this.salePrice,
    this.normalPrice,
    this.isOnSale,
    this.savings,
    this.metacriticScore,
    this.steamRatingText,
    this.steamRatingPercent,
    this.steamRatingCount,
    this.steamAppID,
    this.releaseDate,
    this.lastChange,
    this.dealRating,
    this.thumb,
    this.isFav,
    this.qty,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    internalName = json['internalName'];
    title = json['title'];
    metacriticLink = json['metacriticLink'];
    dealID = json['dealID'];
    storeID = json['storeID'];
    gameID = json['gameID'];
    salePrice = json['salePrice'];
    normalPrice = json['normalPrice'];
    isOnSale = json['isOnSale'];
    savings = json['savings'];
    metacriticScore = json['metacriticScore'];
    steamRatingText = json['steamRatingText'];
    steamRatingPercent = json['steamRatingPercent'];
    steamRatingCount = json['steamRatingCount'];
    steamAppID = json['steamAppID'];
    releaseDate = json['releaseDate'];
    lastChange = json['lastChange'];
    dealRating = json['dealRating'];
    thumb = json['thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['internalName'] = internalName;
    data['title'] = title;
    data['metacriticLink'] = metacriticLink;
    data['dealID'] = dealID;
    data['storeID'] = storeID;
    data['gameID'] = gameID;
    data['salePrice'] = salePrice;
    data['normalPrice'] = normalPrice;
    data['isOnSale'] = isOnSale;
    data['savings'] = savings;
    data['metacriticScore'] = metacriticScore;
    data['steamRatingText'] = steamRatingText;
    data['steamRatingPercent'] = steamRatingPercent;
    data['steamRatingCount'] = steamRatingCount;
    data['steamAppID'] = steamAppID;
    data['releaseDate'] = releaseDate;
    data['lastChange'] = lastChange;
    data['dealRating'] = dealRating;
    data['thumb'] = thumb;
    return data;
  }
}
