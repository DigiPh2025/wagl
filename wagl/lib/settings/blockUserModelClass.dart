// To parse this JSON data, do
//
//     final blockUserModelClass = blockUserModelClassFromJson(jsonString);

import 'dart:convert';

BlockUserModelClass blockUserModelClassFromJson(String str) => BlockUserModelClass.fromJson(json.decode(str));

String blockUserModelClassToJson(BlockUserModelClass data) => json.encode(data.toJson());

class BlockUserModelClass {
  List<Datum>? data;
  Meta? meta;

  BlockUserModelClass({
    this.data,
    this.meta,
  });

  factory BlockUserModelClass.fromJson(Map<String, dynamic> json) => BlockUserModelClass(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
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
    attributes: json["attributes"] == null ? null : DatumAttributes.fromJson(json["attributes"]),
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
  BlockId? blockId;

  DatumAttributes({
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.blockId,
  });

  factory DatumAttributes.fromJson(Map<String, dynamic> json) => DatumAttributes(
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    publishedAt: json["publishedAt"] == null ? null : DateTime.parse(json["publishedAt"]),
    blockId: json["block_id"] == null ? null : BlockId.fromJson(json["block_id"]),
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "publishedAt": publishedAt?.toIso8601String(),
    "block_id": blockId?.toJson(),
  };
}

class BlockId {
  BlockIdData? data;

  BlockId({
    this.data,
  });

  factory BlockId.fromJson(Map<String, dynamic> json) => BlockId(
    data: json["data"] == null ? null : BlockIdData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class BlockIdData {
  int? id;
  PurpleAttributes? attributes;

  BlockIdData({
    this.id,
    this.attributes,
  });

  factory BlockIdData.fromJson(Map<String, dynamic> json) => BlockIdData(
    id: json["id"],
    attributes: json["attributes"] == null ? null : PurpleAttributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attributes": attributes?.toJson(),
  };
}

class PurpleAttributes {
  String? username;
  String? firstName;
  dynamic lastName;
  ProfilePic? profilePic;

  PurpleAttributes({
    this.username,
    this.firstName,
    this.lastName,
    this.profilePic,
  });

  factory PurpleAttributes.fromJson(Map<String, dynamic> json) => PurpleAttributes(
    username: json["username"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profilePic: json["profilePic"] == null ? null : ProfilePic.fromJson(json["profilePic"]),
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "firstName": firstName,
    "lastName": lastName,
    "profilePic": profilePic?.toJson(),
  };
}

class ProfilePic {
  ProfilePicData? data;

  ProfilePic({
    this.data,
  });

  factory ProfilePic.fromJson(Map<String, dynamic> json) => ProfilePic(
    data: json["data"] == null ? null : ProfilePicData.fromJson(json["data"]),
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
    attributes: json["attributes"] == null ? null : FluffyAttributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attributes": attributes?.toJson(),
  };
}

class FluffyAttributes {
  String? url;

  FluffyAttributes({
    this.url,
  });

  factory FluffyAttributes.fromJson(Map<String, dynamic> json) => FluffyAttributes(
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
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
