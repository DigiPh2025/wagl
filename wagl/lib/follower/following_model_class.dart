// To parse this JSON data, do
//
//     final followerModelClass = followerModelClassFromJson(jsonString);

import 'dart:convert';

FollowerModelClass followingModelClassFromJson(String str) =>
    FollowerModelClass.fromJson(json.decode(str));

String followerModelClassToJson(FollowerModelClass data) =>
    json.encode(data.toJson());

class FollowerModelClass {
  List<Datum>? data;
  Meta? meta;

  FollowerModelClass({
    this.data,
    this.meta,
  });

  factory FollowerModelClass.fromJson(Map<String, dynamic> json) =>
      FollowerModelClass(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "meta": meta?.toJson(),
      };
}

class Datum {
  int? id;
  DatumAttributes? attributes;

  Datum({
    this.id,
    this.attributes,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : DatumAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class DatumAttributes {
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  FollowersId? followersId;

  DatumAttributes({
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.followersId,
  });

  factory DatumAttributes.fromJson(Map<String, dynamic> json) =>
      DatumAttributes(
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        followersId: json["followersID"] == null
            ? null
            : FollowersId.fromJson(json["followersID"]),
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "publishedAt": publishedAt?.toIso8601String(),
        "followersID": followersId?.toJson(),
      };
}

class FollowersId {
  FollowersIdData? data;

  FollowersId({
    this.data,
  });

  factory FollowersId.fromJson(Map<String, dynamic> json) => FollowersId(
        data: json["data"] == null
            ? null
            : FollowersIdData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class FollowersIdData {
  int? id;
  PurpleAttributes? attributes;

  FollowersIdData({
    this.id,
    this.attributes,
  });

  factory FollowersIdData.fromJson(Map<String, dynamic> json) =>
      FollowersIdData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : PurpleAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class PurpleAttributes {
  String? username;
  String? email;
  bool isFollow=true;
  bool? confirmed;
  bool? blocked;
  String? firstName;
  String? lastName;
  DateTime? dateOfBirth;
  String? location;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? totalWagls;
  int? totalFollowers;
  int? totalFollowing;
  int? totalViews;
  String? bio;
  bool? emailNotification;
  bool? pushNotification;
  String? fcm;
  ProfilePic? profilePic;

  PurpleAttributes({
    this.username,
    this.email,
    this.isFollow = true,
    this.confirmed,
    this.blocked,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.totalWagls,
    this.totalFollowers,
    this.totalFollowing,
    this.totalViews,
    this.bio,
    this.emailNotification,
    this.pushNotification,
    this.fcm,
    this.profilePic,
  });

  factory PurpleAttributes.fromJson(Map<String, dynamic> json) =>
      PurpleAttributes(
        username: json["username"],
        email: json["email"],
        confirmed: json["confirmed"],
        blocked: json["blocked"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        dateOfBirth: json["dateOfBirth"] == null
            ? null
            : DateTime.parse(json["dateOfBirth"]),
        location: json["location"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        totalWagls: json["totalWagls"],
        totalFollowers: json["totalFollowers"],
        totalFollowing: json["totalFollowing"],
        totalViews: json["totalViews"],
        bio: json["bio"],
        emailNotification: json["emailNotification"],
        pushNotification: json["pushNotification"],
        fcm: json["fcm"],
        profilePic: json["profilePic"] == null
            ? null
            : ProfilePic.fromJson(json["profilePic"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "confirmed": confirmed,
        "blocked": blocked,
        "firstName": firstName,
        "lastName": lastName,
        "dateOfBirth":
            "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
        "location": location,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "totalWagls": totalWagls,
        "totalFollowers": totalFollowers,
        "totalFollowing": totalFollowing,
        "totalViews": totalViews,
        "bio": bio,
        "emailNotification": emailNotification,
        "pushNotification": pushNotification,
        "fcm": fcm,
        "profilePic": profilePic?.toJson(),
      };
}

class ProfilePic {
  ProfilePicData? data;

  ProfilePic({
    this.data,
  });

  factory ProfilePic.fromJson(Map<String, dynamic> json) => ProfilePic(
        data:
            json["data"] == null ? null : ProfilePicData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class ProfilePicData {
  int? id;
  FluffyAttributes? attributes;

  ProfilePicData({
    this.id,
    this.attributes,
  });

  factory ProfilePicData.fromJson(Map<String, dynamic> json) => ProfilePicData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : FluffyAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class FluffyAttributes {
  String? name;
  dynamic alternativeText;
  dynamic caption;
  int? width;
  int? height;
  Formats? formats;
  String? hash;
  double? size;
  String? url;
  dynamic previewUrl;
  dynamic providerMetadata;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isUrlSigned;

  FluffyAttributes({
    this.name,
    this.alternativeText,
    this.caption,
    this.width,
    this.height,
    this.formats,
    this.hash,
    this.size,
    this.url,
    this.previewUrl,
    this.providerMetadata,
    this.createdAt,
    this.updatedAt,
    this.isUrlSigned,
  });

  factory FluffyAttributes.fromJson(Map<String, dynamic> json) =>
      FluffyAttributes(
        name: json["name"],
        alternativeText: json["alternativeText"],
        caption: json["caption"],
        width: json["width"],
        height: json["height"],
        formats:
            json["formats"] == null ? null : Formats.fromJson(json["formats"]),
        hash: json["hash"],
        size: json["size"]?.toDouble(),
        url: json["url"],
        previewUrl: json["previewUrl"],
        providerMetadata: json["provider_metadata"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        isUrlSigned: json["isUrlSigned"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "alternativeText": alternativeText,
        "caption": caption,
        "width": width,
        "height": height,
        "formats": formats?.toJson(),
        "hash": hash,
        "size": size,
        "url": url,
        "previewUrl": previewUrl,
        "provider_metadata": providerMetadata,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "isUrlSigned": isUrlSigned,
      };
}

class Formats {
  Thumbnail? thumbnail;

  Formats({
    this.thumbnail,
  });

  factory Formats.fromJson(Map<String, dynamic> json) => Formats(
        thumbnail: json["thumbnail"] == null
            ? null
            : Thumbnail.fromJson(json["thumbnail"]),
      );

  Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail?.toJson(),
      };
}

class Thumbnail {
  String? url;
  String? hash;
  String? name;
  dynamic path;
  double? size;
  int? width;
  int? height;
  int? sizeInBytes;
  bool? isUrlSigned;

  Thumbnail({
    this.url,
    this.hash,
    this.name,
    this.path,
    this.size,
    this.width,
    this.height,
    this.sizeInBytes,
    this.isUrlSigned,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        url: json["url"],
        hash: json["hash"],
        name: json["name"],
        path: json["path"],
        size: json["size"]?.toDouble(),
        width: json["width"],
        height: json["height"],
        sizeInBytes: json["sizeInBytes"],
        isUrlSigned: json["isUrlSigned"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "hash": hash,
        "name": name,
        "path": path,
        "size": size,
        "width": width,
        "height": height,
        "sizeInBytes": sizeInBytes,
        "isUrlSigned": isUrlSigned,
      };
}

class Meta {
  Pagination? pagination;

  Meta({
    this.pagination,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
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
