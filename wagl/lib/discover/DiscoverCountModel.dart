// To parse this JSON data, do
//
//     final discoverWaglCount = discoverWaglCountFromJson(jsonString);

import 'dart:convert';

DiscoverWaglCount discoverWaglCountFromJson(String str) => DiscoverWaglCount.fromJson(json.decode(str));

String discoverWaglCountToJson(DiscoverWaglCount data) => json.encode(data.toJson());

class DiscoverWaglCount {
  Meta? meta;

  DiscoverWaglCount({
    this.meta,
  });

  factory DiscoverWaglCount.fromJson(Map<String, dynamic> json) => DiscoverWaglCount(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
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


