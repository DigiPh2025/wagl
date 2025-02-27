// To parse this JSON data, do
//
//     final notificationModelClass = ProductModelClassFromJson(jsonString);

import 'dart:convert';

NotificationModelClass productModelClassFromJson(String str) => NotificationModelClass.fromJson(json.decode(str));

String notificationModelClassToJson(NotificationModelClass data) => json.encode(data.toJson());

class NotificationModelClass {
  List<Datum>? data;
  Meta? meta;

  NotificationModelClass({
    this.data,
    this.meta,
  });

  factory NotificationModelClass.fromJson(Map<String, dynamic> json) => NotificationModelClass(
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
  String? name;
  dynamic productUrl;
  BrandId? brandId;
  int? waglCount;
  ProductPic? productPic;

  DatumAttributes({
    this.name,
    this.productUrl,
    this.brandId,
    this.waglCount,
    this.productPic,
  });

  factory DatumAttributes.fromJson(Map<String, dynamic> json) => DatumAttributes(
    name: json["name"],
    productUrl: json["product_url"],
    waglCount: json["wagl_count"],
    brandId: json["brand_id"] == null ? null : BrandId.fromJson(json["brand_id"]),
    productPic: json["product_pic"] == null ? null : ProductPic.fromJson(json["product_pic"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "product_url": productUrl,
    "wagl_count": waglCount,
    "brand_id": brandId?.toJson(),
    "product_pic": productPic?.toJson(),
  };
}

class BrandId {
  BrandIdData? data;

  BrandId({
    this.data,
  });

  factory BrandId.fromJson(Map<String, dynamic> json) => BrandId(
    data: json["data"] == null ? null : BrandIdData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class BrandIdData {
  int? id;
  PurpleAttributes? attributes;

  BrandIdData({
    this.id,
    this.attributes,
  });

  factory BrandIdData.fromJson(Map<String, dynamic> json) => BrandIdData(
    id: json["id"],
    attributes: json["attributes"] == null ? null : PurpleAttributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attributes": attributes?.toJson(),
  };
}

class PurpleAttributes {
  String? brandName;

  PurpleAttributes({
    this.brandName,
  });

  factory PurpleAttributes.fromJson(Map<String, dynamic> json) => PurpleAttributes(
    brandName: json["brandName"],
  );

  Map<String, dynamic> toJson() => {
    "brandName": brandName,
  };
}

class ProductPic {
  ProductPicData? data;

  ProductPic({
    this.data,
  });

  factory ProductPic.fromJson(Map<String, dynamic> json) => ProductPic(
    data: json["data"] == null ? null : ProductPicData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class ProductPicData {
  int? id;
  FluffyAttributes? attributes;

  ProductPicData({
    this.id,
    this.attributes,
  });

  factory ProductPicData.fromJson(Map<String, dynamic> json) => ProductPicData(
    id: json["id"],
    attributes: json["attributes"] == null ? null : FluffyAttributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attributes": attributes?.toJson(),
  };
}

class FluffyAttributes {
  String? name;
  Formats? formats;
  String? ext;
  String? url;

  FluffyAttributes({
    this.name,

    this.formats,

    this.ext,

    this.url,

  });

  factory FluffyAttributes.fromJson(Map<String, dynamic> json) => FluffyAttributes(
    name: json["name"],

    formats: json["formats"] == null ? null : Formats.fromJson(json["formats"]),

    ext: json["ext"],

    url: json["url"],

  );

  Map<String, dynamic> toJson() => {
    "name": name,

    "formats": formats?.toJson(),

    "ext": ext,

    "url": url,

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
  String? hash;
  String? mime;
  String? name;
  dynamic path;
  double? size;
  int? width;
  int? height;
  int? sizeInBytes;
  bool? isUrlSigned;

  Large({
    this.ext,
    this.url,
    this.hash,
    this.mime,
    this.name,
    this.path,
    this.size,
    this.width,
    this.height,
    this.sizeInBytes,
    this.isUrlSigned,
  });

  factory Large.fromJson(Map<String, dynamic> json) => Large(
    ext: json["ext"],
    url: json["url"],
    hash: json["hash"],
    mime: json["mime"],
    name: json["name"],
    path: json["path"],
    size: json["size"]?.toDouble(),
    width: json["width"],
    height: json["height"],
    sizeInBytes: json["sizeInBytes"],
    isUrlSigned: json["isUrlSigned"],
  );

  Map<String, dynamic> toJson() => {
    "ext": ext,
    "url": url,
    "hash": hash,
    "mime": mime,
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
