// To parse this JSON data, do
//
//     final notificationModelClassFromJson = notificationModelClassFromJsonFromJson(jsonString);

import 'dart:convert';

NotificationModelClassFromJson notificationModelClassFromJsonFromJson(String str) => NotificationModelClassFromJson.fromJson(json.decode(str));

String notificationModelClassFromJsonToJson(NotificationModelClassFromJson data) => json.encode(data.toJson());

class NotificationModelClassFromJson {
  NotificationData? data;
  NotificationModelClassFromJson({
    this.data,
  });

  factory NotificationModelClassFromJson.fromJson(Map<String, dynamic> json) => NotificationModelClassFromJson(
    data: json["data"] == null ? null : NotificationData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class NotificationData {
  bool? status;
  String? message;
  List<ListElement>? list;
  Meta? meta;

  NotificationData({
    this.status,
    this.message,
    this.list,
    this.meta,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    status: json["status"],
    message: json["message"],
    list: json["list"] == null ? [] : List<ListElement>.from(json["list"]!.map((x) => ListElement.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
  };
}

class ListElement {
  DateTime? createdAt;
  int? id;
  String? title;
  String? description;
  String? type;
  SenderId? senderId;
  WaglId? waglId;
  bool? isFollow;


  ListElement({
    this.createdAt,
    this.id,
    this.title,
    this.description,
    this.type,
    this.senderId,
    this.waglId,
    this.isFollow,

  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    id: json["id"],
    title: json["title"]!,
    description: json["description"],
    type: json["type"]!,
    senderId: json["sender_id"] == null ? null : SenderId.fromJson(json["sender_id"]),
    waglId: json["wagl_id"] == null ? null : WaglId.fromJson(json["wagl_id"]),
    isFollow: json["isFollow"],

  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt?.toIso8601String(),
    "id": id,
    "title": title,
    "description": description,
    "type":type,
    "sender_id": senderId?.toJson(),
    "wagl_id": waglId?.toJson(),
    "isFollow": isFollow,

  };
}
class GoodTagClass {
  int? id;
  String? name;
  String? brandName;

  GoodTagClass({
    this.id,
    this.name,
    this.brandName,
  });

  factory GoodTagClass.fromJson(Map<String, dynamic> json) => GoodTagClass(
    id: json["id"],
    name: json["name"]!,
    brandName: json["brandName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "brandName": brandName,
  };
}
class BrandClass {
  int? id;
  String? brandName;

  BrandClass({
    this.id,
    this.brandName,
  });

  factory BrandClass.fromJson(Map<String, dynamic> json) => BrandClass(
    id: json["id"],
    brandName: json["brandName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brandName": brandName,
  };
}
class ProductIdClass {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  String? productUrl;
  int? waglCount;
  ProductPicClass? productPic;
  BrandClass? brandId;

  ProductIdClass({
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

  factory ProductIdClass.fromJson(Map<String, dynamic> json) => ProductIdClass(
    id: json["id"],
    name: json["name"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    publishedAt: json["publishedAt"] == null ? null : DateTime.parse(json["publishedAt"]),
    productUrl: json["product_url"],
    waglCount: json["wagl_count"],
    productPic: json["product_pic"] == null ? null : ProductPicClass.fromJson(json["product_pic"]),
    brandId: json["brand_id"] == null ? null : BrandClass.fromJson(json["brand_id"]),
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

class ProductPicClass {
  String? name;
  ThumbnailFormats? formats;
  String? url;

  ProductPicClass({
    this.name,
    this.formats,
    this.url,
  });

  factory ProductPicClass.fromJson(Map<String, dynamic> json) => ProductPicClass(

    name: json["name"],

    formats: json["formats"] == null ? null : ThumbnailFormats.fromJson(json["formats"]),

    url: json["url"],

  );

  Map<String, dynamic> toJson() => {

    "name": name,

    "formats": formats?.toJson(),

    "url": url,

  };
}
class InterestedCategory {
  int? id;
  String? categoryName;

  InterestedCategory({
    this.id,
    this.categoryName,
  });

  factory InterestedCategory.fromJson(Map<String, dynamic> json) => InterestedCategory(
    id: json["id"],
    categoryName: json["categoryName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "categoryName": categoryName,
  };
}
class SenderId {
  int? id;
  String? username;
  String? email;
  bool? blocked;
  String? firstName;
  String? lastName;
  DateTime? dateOfBirth;
  String? location;
  int? totalWagls;
  int? totalFollowers;
  int? totalFollowing;
  int? totalViews;
  String? bio;
  ProfilePic? profilePic;

  SenderId({
    this.id,
    this.username,
    this.email,
    this.blocked,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.location,
    this.totalWagls,
    this.totalFollowers,
    this.totalFollowing,
    this.totalViews,
    this.bio,
    this.profilePic,
  });

  factory SenderId.fromJson(Map<String, dynamic> json) => SenderId(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    blocked: json["blocked"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
    totalWagls: json["totalWagls"],
    totalFollowers: json["totalFollowers"],
    totalFollowing: json["totalFollowing"],
    totalViews: json["totalViews"],
    profilePic: json["profilePic"] == null ? null : ProfilePic.fromJson(json["profilePic"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "blocked": blocked,
    "firstName": firstName,
    "lastName": lastName,
    "dateOfBirth": "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "totalWagls": totalWagls,
    "totalFollowers": totalFollowers,
    "totalFollowing": totalFollowing,
    "totalViews": totalViews,
    "profilePic": profilePic?.toJson(),
  };
}


class ProfilePic {
  int? id;
  ProfilePicFormats? formats;
  String? url;

  ProfilePic({
    this.id,
    this.formats,
    this.url,
  });

  factory ProfilePic.fromJson(Map<String, dynamic> json) => ProfilePic(
    id: json["id"],
    formats: json["formats"] == null ? null : ProfilePicFormats.fromJson(json["formats"]),
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "formats": formats?.toJson(),
    "url": url,
  };
}



class ProfilePicFormats {
  SmallClass? thumbnail;

  ProfilePicFormats({
    this.thumbnail,
  });

  factory ProfilePicFormats.fromJson(Map<String, dynamic> json) => ProfilePicFormats(
    thumbnail: json["thumbnail"] == null ? null : SmallClass.fromJson(json["thumbnail"]),
  );

  Map<String, dynamic> toJson() => {
    "thumbnail": thumbnail?.toJson(),
  };
}

class SmallClass {
  String? ext;
  String? url;

  SmallClass({
    this.ext,
    this.url,
  });

  factory SmallClass.fromJson(Map<String, dynamic> json) => SmallClass(
    ext: json["ext"],
    url: json["url"],

  );

  Map<String, dynamic> toJson() => {
    "ext": ext,
    "url": url,

  };
}

class WaglId {
  int? id;
  String? description;
  String? location;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  int? totalLikes;
  int? totalComments;
  int? totalViews;
  int? totalSaved;
  List<Media>? media;
  List<Media>? thumbnail;
  List<InterestedCategory>? interestedCategories;
  List<GoodTagClass>? goodTags;
  ProductIdClass? productId;

  WaglId({
    this.id,
    this.description,
    this.location,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.totalLikes,
    this.totalComments,
    this.totalViews,
    this.totalSaved,
    this.media,
    this.thumbnail,
    this.interestedCategories,
    this.goodTags,
    this.productId,
  });

  factory WaglId.fromJson(Map<String, dynamic> json) => WaglId(
    id: json["id"],
    description: json["description"],
    location: json["location"],
    isActive: json["isActive"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    publishedAt: json["publishedAt"] == null ? null : DateTime.parse(json["publishedAt"]),
    totalLikes: json["total_likes"],
    totalComments: json["total_comments"],
    totalViews: json["total_views"],
    totalSaved: json["total_saved"],
    media: json["media"] == null ? [] : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
    thumbnail: json["thumbnail"] == null ? [] : List<Media>.from(json["thumbnail"]!.map((x) => Media.fromJson(x))),
    interestedCategories: json["interested_categories"] == null ? [] : List<InterestedCategory>.from(json["interested_categories"]!.map((x) => InterestedCategory.fromJson(x))),
    goodTags: json["good_tags"] == null ? [] : List<GoodTagClass>.from(json["good_tags"]!.map((x) => GoodTagClass.fromJson(x))),
    productId: json["product_id"] == null ? null : ProductIdClass.fromJson(json["product_id"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "location": location,
    "isActive": isActive,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "publishedAt": publishedAt?.toIso8601String(),
    "total_likes": totalLikes,
    "total_comments": totalComments,
    "total_views": totalViews,
    "total_saved": totalSaved,
    "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x.toJson())),
    "thumbnail": thumbnail == null ? [] : List<dynamic>.from(thumbnail!.map((x) => x.toJson())),
    "interested_categories": interestedCategories == null ? [] : List<dynamic>.from(interestedCategories!.map((x) => x.toJson())),
    "good_tags": goodTags == null ? [] : List<dynamic>.from(goodTags!.map((x) => x.toJson())),
    "product_id": productId?.toJson(),
  };
}

class Media {
  String? ext;
  String? url;


  Media({
    this.ext,
    this.url,

  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(

    ext: json["ext"],

    url: json["url"],

  );

  Map<String, dynamic> toJson() => {

    "ext": ext,

    "url": url,

  };
}

class MediaFormats {
  SmallClass? large;
  SmallClass? small;
  SmallClass? medium;
  SmallClass? thumbnail;

  MediaFormats({
    this.large,
    this.small,
    this.medium,
    this.thumbnail,
  });

  factory MediaFormats.fromJson(Map<String, dynamic> json) => MediaFormats(
    large: json["large"] == null ? null : SmallClass.fromJson(json["large"]),
    small: json["small"] == null ? null : SmallClass.fromJson(json["small"]),
    medium: json["medium"] == null ? null : SmallClass.fromJson(json["medium"]),
    thumbnail: json["thumbnail"] == null ? null : SmallClass.fromJson(json["thumbnail"]),
  );

  Map<String, dynamic> toJson() => {
    "large": large?.toJson(),
    "small": small?.toJson(),
    "medium": medium?.toJson(),
    "thumbnail": thumbnail?.toJson(),
  };
}

class ThumbnailThumbnail {
  String? url;

  ThumbnailThumbnail({
    this.url,
  });

  factory ThumbnailThumbnail.fromJson(Map<String, dynamic> json) => ThumbnailThumbnail(
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
  };
}

class ThumbnailFormats {
  SmallClass? thumbnail;
  SmallClass? small;

  ThumbnailFormats({
    this.thumbnail,
    this.small,
  });

  factory ThumbnailFormats.fromJson(Map<String, dynamic> json) => ThumbnailFormats(
    thumbnail: json["thumbnail"] == null ? null : SmallClass.fromJson(json["thumbnail"]),
    small: json["small"] == null ? null : SmallClass.fromJson(json["small"]),
  );

  Map<String, dynamic> toJson() => {
    "thumbnail": thumbnail?.toJson(),
    "small": small?.toJson(),
  };
}

class Meta {
  Pagination? pagination;

  Meta({
    this.pagination,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
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

  Pagination({
    this.page,
    this.pageSize,
    this.pageCount,
    this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: json["page"],
    pageSize: json["pageSize"],
    pageCount: json["pageCount"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "pageSize": pageSize,
    "pageCount": pageCount,
    "total": total,
  };
}
