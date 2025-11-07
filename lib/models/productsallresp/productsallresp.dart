// ignore_for_file: no_leading_underscores_for_local_identifiers

class Productsall {
  String? msg;
  List<Data>? data;

  Productsall({this.msg, this.data});

  Productsall.fromJson(Map<String, dynamic> json) {
    if (json["Msg"] is String) {
      msg = json["Msg"];
    }
    if (json["data"] is List) {
      data = json["data"] == null
          ? null
          : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
    }
  }

  static List<Productsall> fromList(List<Map<String, dynamic>> list) {
    return list.map(Productsall.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["Msg"] = msg;
    if (data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Data {
  int? id;
  String? name;
  String? description;
  int? price;
  int? stock;
  String? category;
  dynamic imageUrl;
  int? user;

  Data({
    this.id,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.category,
    this.imageUrl,
    this.user,
  });

  Data.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["price"] is int) {
      price = json["price"];
    }
    if (json["stock"] is int) {
      stock = json["stock"];
    }
    if (json["category"] is String) {
      category = json["category"];
    }
    imageUrl = json["image_url"];
    if (json["user"] is int) {
      user = json["user"];
    }
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["description"] = description;
    _data["price"] = price;
    _data["stock"] = stock;
    _data["category"] = category;
    _data["image_url"] = imageUrl;
    _data["user"] = user;
    return _data;
  }
}
