class ProductModel {
  String? internalName;
  String? title;
  String? salePrice;
  String? normalPrice;
  String? steamRatingCount;
  String? thumb;
  int? isFav = 0;
  int? qty = 0;
  ProductModel({
    this.internalName,
    this.title,
    this.salePrice,
    this.normalPrice,
    this.steamRatingCount,
    this.thumb,
    this.isFav,
    this.qty,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    internalName = json['internalName'];
    title = json['title'];
    salePrice = json['salePrice'];
    normalPrice = json['normalPrice'];
    steamRatingCount = json['steamRatingCount'];
    thumb = json['thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['internalName'] = internalName;
    data['title'] = title;
    data['salePrice'] = salePrice;
    data['normalPrice'] = normalPrice;
    data['steamRatingCount'] = steamRatingCount;
    data['thumb'] = thumb;
    data['isFav'] = isFav;
    data['qty'] = qty;
    return data;
  }
}
