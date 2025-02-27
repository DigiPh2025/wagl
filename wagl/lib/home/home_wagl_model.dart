// To parse this JSON data, do
//
//     final homeWaglModelClass = homeWaglModelClassFromJson(jsonString);

import 'dart:convert';

HomeWaglModelClass homeWaglModelClassFromJson(String str) => HomeWaglModelClass.fromJson(json.decode(str));

String homeWaglModelClassToJson(HomeWaglModelClass data) => json.encode(data.toJson());

class HomeWaglModelClass {
  List<HomeWaglData>? data;
  MetaClass? meta;

  HomeWaglModelClass({
    this.data,
    this.meta,
  });

  factory HomeWaglModelClass.fromJson(Map<String, dynamic> json) => HomeWaglModelClass(
    data: json["data"] == null ? [] : List<HomeWaglData>.from(json["data"]!.map((x) => HomeWaglData.fromJson(x))),
    meta: json["meta"] == null ? null : MetaClass.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
  };
}

class HomeWaglData {
  DateTime? createdAt;
  int? id;
  String? description;
  String? location;
  bool? isActive;
  DateTime? updatedAt;
  DateTime? publishedAt;
  int? totalLikes;
  int? totalComments;
  int? totalViews;
  int? totalSaved;
  UserId? userId;
  List<Media>? media;
  List<GoodTag>? goodTags;
  List<InterestedCategory>? interestedCategories;
  bool isLike;
  bool isSaved;
  bool isFollow;
  ProductId? productId;

  HomeWaglData({
    this.createdAt,
    this.id,
    this.description,
    this.location,
    this.isActive,
    this.updatedAt,
    this.publishedAt,
    this.totalLikes,
    this.totalComments,
    this.totalViews,
    this.totalSaved,
    this.userId,
    this.media,
    this.goodTags,
    this.productId,
    this.interestedCategories,
    required this.isLike,
    required this.isFollow,
    required this.isSaved,
  });

  factory HomeWaglData.fromJson(Map<String, dynamic> json) => HomeWaglData(
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    id: json["id"],
    description: json["description"],
    location: json["location"],
    isActive: json["isActive"],
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    publishedAt: json["publishedAt"] == null ? null : DateTime.parse(json["publishedAt"]),
    totalLikes: json["total_likes"],
    totalComments: json["total_comments"],
    totalViews: json["total_views"],
    totalSaved: json["total_saved"],
    userId: json["user_id"] == null ? null : UserId.fromJson(json["user_id"]),
    media: json["media"] == null ? [] : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
    goodTags: json["good_tags"] == null ? [] : List<GoodTag>.from(json["good_tags"]!.map((x) => GoodTag.fromJson(x))),
    interestedCategories: json["interested_categories"] == null ? [] : List<InterestedCategory>.from(json["interested_categories"]!.map((x) => InterestedCategory.fromJson(x))),
    productId: json["product_id"] == null ? null : ProductId.fromJson(json["product_id"]),
    isLike: json["isLike"],
    isFollow: json["isFollow"],
    isSaved: json["isSaved"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt?.toIso8601String(),
    "id": id,
    "description": description,
    "location": location,
    "isActive": isActive,
    "updatedAt": updatedAt?.toIso8601String(),
    "publishedAt": publishedAt?.toIso8601String(),
    "total_likes": totalLikes,
    "total_comments": totalComments,
    "total_views": totalViews,
    "total_saved": totalSaved,
    "user_id": userId?.toJson(),
    "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x.toJson())),
    "good_tags": goodTags == null ? [] : List<dynamic>.from(goodTags!.map((x) => x.toJson())),
    "interested_categories": interestedCategories == null ? [] : List<dynamic>.from(interestedCategories!.map((x) => x.toJson())),
    "product_id": productId?.toJson(),

    "isLike": isLike,
    "isFollow": isFollow,
    "isSaved": isSaved,
  };
}

class ProductId {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  dynamic productUrl;
  int? waglCount;
  Media? productPic;
  BrandId? brandId;

  ProductId({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.productUrl,
    this.waglCount,
    this.productPic,
    this.brandId,
  });

  factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
    id: json["id"],
    name: json["name"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    publishedAt: json["publishedAt"] == null ? null : DateTime.parse(json["publishedAt"]),
    productUrl: json["product_url"],
    waglCount: json["wagl_count"],
    productPic: json["product_pic"] == null ? null : Media.fromJson(json["product_pic"]),
    brandId: json["brand_id"] == null ? null : BrandId.fromJson(json["brand_id"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "publishedAt": publishedAt?.toIso8601String(),
    "product_url": productUrl,
    "wagl_count": waglCount,
    "product_pic": productPic?.toJson(),
    "brand_id": brandId?.toJson(),
  };
}
class BrandId {
  int? id;
  String? brandName;

  BrandId({
    this.id,
    this.brandName,
  });

  factory BrandId.fromJson(Map<String, dynamic> json) => BrandId(
    id: json["id"],
    brandName: json["brandName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brandName": brandName,
  };
}
class GoodTag {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  Media? image;

  GoodTag({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.image,
  });

  factory GoodTag.fromJson(Map<String, dynamic> json) => GoodTag(
    id: json["id"],
    name: json["name"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    publishedAt: json["publishedAt"] == null ? null : DateTime.parse(json["publishedAt"]),
    image: json["image"] == null ? null : Media.fromJson(json["image"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "publishedAt": publishedAt?.toIso8601String(),
    "image": image?.toJson(),
  };
}

class Media {
  int? id;
  String? name;
  Formats? formats;
  String? ext;
  String? url;

  Media({
    this.id,
    this.name,
    this.formats,
    this.ext,
    this.url,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json["id"],
    name: json["name"],
    url: json["url"],
    ext: json["ext"],
    formats: json["formats"] == null ? null : Formats.fromJson(json["formats"]),

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}


class Formats {
  Large? large;
  Large? small;
  Large? medium;
  Large? thumbnail;

  Formats({
    this.large,
    this.small,
    this.medium,
    this.thumbnail,
  });

  factory Formats.fromJson(Map<String, dynamic> json) => Formats(
    large: json["large"] == null ? null : Large.fromJson(json["large"]),
    small: json["small"] == null ? null : Large.fromJson(json["small"]),
    medium: json["medium"] == null ? null : Large.fromJson(json["medium"]),
    thumbnail: json["thumbnail"] == null ? null : Large.fromJson(json["thumbnail"]),
  );

  Map<String, dynamic> toJson() => {
    "large": large?.toJson(),
    "small": small?.toJson(),
    "medium": medium?.toJson(),
    "thumbnail": thumbnail?.toJson(),
  };
}

class Large {
  String? ext;
  String? url;

  Large({
    this.ext,
    this.url,

  });

  factory Large.fromJson(Map<String, dynamic> json) => Large(
    ext: json["ext"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "ext": ext,
    "url": url,
  };
}







class InterestedCategory {
  int? id;
  String? categoryName;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  int? totalWagls;
  List<Media>? categoryIcon;

  InterestedCategory({
    this.id,
    this.categoryName,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.totalWagls,
    this.categoryIcon,
  });

  factory InterestedCategory.fromJson(Map<String, dynamic> json) => InterestedCategory(
    id: json["id"],
    categoryName: json["categoryName"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    publishedAt: json["publishedAt"] == null ? null : DateTime.parse(json["publishedAt"]),
    totalWagls: json["totalWagls"],
    categoryIcon: json["categoryIcon"] == null ? [] : List<Media>.from(json["categoryIcon"]!.map((x) => Media.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "categoryName": categoryName,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "publishedAt": publishedAt?.toIso8601String(),
    "totalWagls": totalWagls,
    "categoryIcon": categoryIcon == null ? [] : List<dynamic>.from(categoryIcon!.map((x) => x.toJson())),
  };
}

class UserId {
  int? id;
  String? username;
  String? email;
  bool? confirmed;
  bool? blocked;
  String? firstName;
  String? lastName;
  ProfilePic? profilePic;

  UserId({
    this.id,
    this.username,
    this.email,
    this.confirmed,
    this.blocked,
    this.firstName,
    this.lastName,
    this.profilePic,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    confirmed: json["confirmed"],
    blocked: json["blocked"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profilePic: json["profilePic"] == null ? null : ProfilePic.fromJson(json["profilePic"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "confirmed": confirmed,
    "blocked": blocked,
    "firstName": firstName,
    "lastName": lastName,
    "profilePic": profilePic?.toJson(),
  };
}
class ProfilePic {
  int? id;
  String? url;

  ProfilePic({
    this.id,
    this.url,
  });

  factory ProfilePic.fromJson(Map<String, dynamic> json) => ProfilePic(
    id: json["id"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
  };
}

class ProfilePicFormats {
  Large? thumbnail;

  ProfilePicFormats({
    this.thumbnail,
  });

  factory ProfilePicFormats.fromJson(Map<String, dynamic> json) => ProfilePicFormats(
    thumbnail: json["thumbnail"] == null ? null : Large.fromJson(json["thumbnail"]),
  );

  Map<String, dynamic> toJson() => {
    "thumbnail": thumbnail?.toJson(),
  };
}

class MetaClass {
  Pagination? pagination;

  MetaClass({
    this.pagination,
  });

  factory MetaClass.fromJson(Map<String, dynamic> json) => MetaClass(
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "pagination": pagination?.toJson(),
  };
}

class Pagination {
  int? page;
  int? pageSize;
  int? pageCount;
  int? total;
   int? unfollowLastPage;

  Pagination({
    this.page,
    this.pageSize,
    this.pageCount,
    this.total,
    this.unfollowLastPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: json["page"],
    pageSize: json["pageSize"],
    pageCount: json["pageCount"],
    total: json["total"],
    unfollowLastPage: json['unfollowLastpage'], // It's fine if it's null
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "pageSize": pageSize,
    "pageCount": pageCount,
    "total": total,
  };
}
