import 'dart:convert';

import 'package:wagl/home/all_wagl_model.dart';
CommentModel viewCommentFromJsonModel(String str) => CommentModel.fromJson(json.decode(str));
class CommentModel {
  List<Data>? data;
  Meta? meta;

  CommentModel({this.data, this.meta});

  CommentModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

}

class Data {
  int? id;
  CommentAttributes? attributes;

  Data({this.id, this.attributes});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributes = json['attributes'] != null
        ? new CommentAttributes.fromJson(json['attributes'])
        : null;
  }

}


class CommentAttributes {
  String? commentText;
  int? totalCommentLikes;
  String? createdAt;
  String? updatedAt;
  String? publishedAt;
  WaglId? waglId;
  UserId? userId;
  AttributesCommentMedia? commentMedia;

  CommentAttributes(
      {this.commentText,
        this.totalCommentLikes,
        this.createdAt,
        this.updatedAt,
        this.publishedAt,
        this.waglId,
        this.userId,
        this.commentMedia});

  CommentAttributes.fromJson(Map<String, dynamic> json) {
    commentText = json['comment_text'];
    totalCommentLikes = json['total_comment_likes'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    publishedAt = json['publishedAt'];
    waglId =
    json['wagl_id'] != null ? new WaglId.fromJson(json['wagl_id']) : null;
    userId =
    json['user_id'] != null ? new UserId.fromJson(json['user_id']) : null;
    commentMedia = json['comment_media'] != null
        ? new AttributesCommentMedia.fromJson(json['comment_media'])
        : null;
  }

}

class WaglId {
  WaglData? data;

  WaglId({this.data});

  WaglId.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? WaglData.fromJson(json['data']) : null;
  }
}
class WaglData {
  int? id;
  AttributesComments? attributes;

  WaglData({this.id, this.attributes});

  WaglData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributes = json['attributes'] != null
        ? new AttributesComments.fromJson(json['attributes'])
        : null;
  }

}
class AttributesComments {
  String? description;
  String? location;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  String? publishedAt;
  int? totalLikes;
  int? totalComments;
  int? totalViews;

  AttributesComments(
      {this.description,
        this.location,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.publishedAt,
        this.totalLikes,
        this.totalComments,
        this.totalViews});

  AttributesComments.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    location = json['location'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    publishedAt = json['publishedAt'];
    totalLikes = json['total_likes'];
    totalComments = json['total_comments'];
    totalViews = json['total_views'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['location'] = this.location;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['publishedAt'] = this.publishedAt;
    data['total_likes'] = this.totalLikes;
    data['total_comments'] = this.totalComments;
    data['total_views'] = this.totalViews;
    return data;
  }
}

class AttributesUser {
  String? username;

  AttributesUser(
      {this.username,}
  );

  AttributesUser.fromJson(Map<String, dynamic> json) {
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    return data;
  }
}

class AttributesCommentMedia {
  String? name;
  Null? alternativeText;
  Null? caption;
  int? width;
  int? height;
  Formats? formats;
  String? hash;
  String? ext;
  String? mime;
  double? size;
  String? url;
  Null? previewUrl;
  String? provider;
  Null? providerMetadata;
  String? createdAt;
  String? updatedAt;
  bool? isUrlSigned;

  AttributesCommentMedia(
      {this.name,
        this.alternativeText,
        this.caption,
        this.width,
        this.height,
        this.formats,
        this.hash,
        this.ext,
        this.mime,
        this.size,
        this.url,
        this.previewUrl,
        this.provider,
        this.providerMetadata,
        this.createdAt,
        this.updatedAt,
        this.isUrlSigned});

  AttributesCommentMedia.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    alternativeText = json['alternativeText'];
    caption = json['caption'];
    width = json['width'];
    height = json['height'];
    formats =
    json['formats'] != null ? new Formats.fromJson(json['formats']) : null;
    hash = json['hash'];
    ext = json['ext'];
    mime = json['mime'];
    size = json['size'];
    url = json['url'];
    previewUrl = json['previewUrl'];
    provider = json['provider'];
    providerMetadata = json['provider_metadata'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isUrlSigned = json['isUrlSigned'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['alternativeText'] = this.alternativeText;
    data['caption'] = this.caption;
    data['width'] = this.width;
    data['height'] = this.height;
    if (this.formats != null) {
      data['formats'] = this.formats!.toJson();
    }
    data['hash'] = this.hash;
    data['ext'] = this.ext;
    data['mime'] = this.mime;
    data['size'] = this.size;
    data['url'] = this.url;
    data['previewUrl'] = this.previewUrl;
    data['provider'] = this.provider;
    data['provider_metadata'] = this.providerMetadata;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['isUrlSigned'] = this.isUrlSigned;
    return data;
  }
}

class Formats {
  Large? large;
  Large? small;
  Large? medium;
  Large? thumbnail;

  Formats({this.large, this.small, this.medium, this.thumbnail});

  Formats.fromJson(Map<String, dynamic> json) {
    large = json['large'] != null ? new Large.fromJson(json['large']) : null;
    small = json['small'] != null ? new Large.fromJson(json['small']) : null;
    medium = json['medium'] != null ? new Large.fromJson(json['medium']) : null;
    thumbnail = json['thumbnail'] != null
        ? new Large.fromJson(json['thumbnail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.large != null) {
      data['large'] = this.large!.toJson();
    }
    if (this.small != null) {
      data['small'] = this.small!.toJson();
    }
    if (this.medium != null) {
      data['medium'] = this.medium!.toJson();
    }
    if (this.thumbnail != null) {
      data['thumbnail'] = this.thumbnail!.toJson();
    }
    return data;
  }
}

class Large {
  String? ext;
  String? url;
  String? hash;
  String? mime;
  String? name;
  Null? path;
  double? size;
  int? width;
  int? height;
  int? sizeInBytes;
  bool? isUrlSigned;

  Large(
      {this.ext,
        this.url,
        this.hash,
        this.mime,
        this.name,
        this.path,
        this.size,
        this.width,
        this.height,
        this.sizeInBytes,
        this.isUrlSigned});

  Large.fromJson(Map<String, dynamic> json) {
    ext = json['ext'];
    url = json['url'];
    hash = json['hash'];
    mime = json['mime'];
    name = json['name'];
    path = json['path'];
    size = json['size'];
    width = json['width'];
    height = json['height'];
    sizeInBytes = json['sizeInBytes'];
    isUrlSigned = json['isUrlSigned'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ext'] = this.ext;
    data['url'] = this.url;
    data['hash'] = this.hash;
    data['mime'] = this.mime;
    data['name'] = this.name;
    data['path'] = this.path;
    data['size'] = this.size;
    data['width'] = this.width;
    data['height'] = this.height;
    data['sizeInBytes'] = this.sizeInBytes;
    data['isUrlSigned'] = this.isUrlSigned;
    return data;
  }
}

class Meta {
  Pagination? pagination;

  Meta({this.pagination});

  Meta.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Pagination {
  int? page;
  int? pageSize;
  int? pageCount;
  int? total;

  Pagination({this.page, this.pageSize, this.pageCount, this.total});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    pageSize = json['pageSize'];
    pageCount = json['pageCount'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['pageSize'] = this.pageSize;
    data['pageCount'] = this.pageCount;
    data['total'] = this.total;
    return data;
  }
}
