// To parse this JSON data, do
//
//     final brandNameClass = brandNameClassFromJson(jsonString);

import 'dart:convert';

BrandNameClass brandNameClassFromJson(String str) => BrandNameClass.fromJson(json.decode(str));

String brandNameClassToJson(BrandNameClass data) => json.encode(data.toJson());

class BrandNameClass {
  List<Datam>? data;
  Meta? meta;

  BrandNameClass({
    this.data,
    this.meta,
  });

  factory BrandNameClass.fromJson(Map<String, dynamic> json) => BrandNameClass(
    data: json["data"] == null ? [] : List<Datam>.from(json["data"]!.map((x) => Datam.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
  };
}

class Datam {
  int? id;
  Attributes? attributes;

  Datam({
    this.id,
    this.attributes,
  });

  factory Datam.fromJson(Map<String, dynamic> json) => Datam(
    id: json["id"],
    attributes: json["attributes"] == null ? null : Attributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attributes": attributes?.toJson(),
  };
}

class Attributes {
  String? brandName;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;

  Attributes({
    this.brandName,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    brandName: json["brandName"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    publishedAt: json["publishedAt"] == null ? null : DateTime.parse(json["publishedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "brandName": brandName,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "publishedAt": publishedAt?.toIso8601String(),
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
