import 'dart:convert';

import 'package:wagl/profile/saved_wagl_model.dart';

WaglModel viewAllWaglModelFromJson(String str) => WaglModel.fromJson(json.decode(str));
CountArrayModel viewCountModelFromJson(String str) => CountArrayModel.fromJson(json.decode(str));


class WaglModel {
  List<DataWagl>? data;
  Meta? meta;

  WaglModel({this.data});

  WaglModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataWagl>[];
      json['data'].forEach((v) {
        data!.add(new DataWagl.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }

}

class DataWagl {
  int? id;
  WaglAttributes? attributes;

  DataWagl({this.id, this.attributes});

  DataWagl.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributes = json['attributes'] != null
        ? new WaglAttributes.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    return data;
  }
}


class DataAttributes {
  int? id;
  AttributesUser? attributes;

  DataAttributes({this.id, this.attributes});

  DataAttributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributes = json['attributes'] != null
        ? new AttributesUser.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    return data;
  }
}
class ProfilePicData {
  int? id;
  ProfilePicAttributes? attributes;

  ProfilePicData({this.id, this.attributes});

  ProfilePicData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributes = json['attributes'] != null
        ? new ProfilePicAttributes.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    return data;
  }
}
class WaglAttributes {
  String? description;
  String? location;
  bool? isActive;
  int? totalLikes;
  int? totalComments;
  int? totalViews;
  int? totalSaved;
  Media? media;
  VideoThumbnailWagl? thumbnail;
  UserId? userId;
  CategoriesData? interestedCategories;
  GoodTags? goodTags;
  ProductId? productId;


  WaglAttributes(
      {this.description,
        this.location,
        this.isActive,
        this.thumbnail,
        this.totalLikes,
        this.totalComments,
        this.totalViews,
        this.totalSaved,
        this.media,
        this.userId,    this.productId,
        this.interestedCategories,
        this.goodTags});

  WaglAttributes.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    location = json['location'];
    isActive = json['isActive'];
    totalLikes = json['total_likes'];
    totalComments = json['total_comments'];
    totalViews = json['total_views'];
    totalSaved = json['total_saved'];
    media = json['media'] != null ? new Media.fromJson(json['media']) : null;
    productId= json["product_id"] == null ? null : ProductId.fromJson(json["product_id"]);
    thumbnail= json['thumbnail'] != null && json['thumbnail']['data'] != null
        ? VideoThumbnailWagl.fromJson(json['thumbnail']['data'])
        : null;
    userId =
    json['user_id'] != null ? new UserId.fromJson(json['user_id']) : null;
    interestedCategories = json['interested_categories'] != null
        ? new CategoriesData.fromJson(json['interested_categories'])
        : null;
    goodTags = json['good_tags'] != null
        ? new GoodTags.fromJson(json['good_tags'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['location'] = this.location;
    data['isActive'] = this.isActive;
    data['product_id'] = this.productId;
    data['total_likes'] = this.totalLikes;
    data['total_comments'] = this.totalComments;
    data['total_views'] = this.totalViews;
    data['total_saved'] = this.totalSaved;
    if (thumbnail != null) {
      data['thumbnail'] = {'data': thumbnail!.toJson()};
    } else {
      data['thumbnail'] = {'data': null};
    }
    if (this.media != null) {
      data['media'] = this.media!.toJson();
    }
    if (this.userId != null) {
      data['user_id'] = this.userId!.toJson();
    }
    if (this.interestedCategories != null) {
      data['interested_categories'] = this.interestedCategories!.toJson();
    }
    if (this.goodTags != null) {
      data['good_tags'] = this.goodTags!.toJson();
    }
    return data;
  }
}

class ProductId {
  ProductIdData? data;

  ProductId({
    this.data,
  });

  factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
    data: json["data"] == null ? null : ProductIdData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class ProductIdData {
  int? id;
  IndigoAttributes? attributes;

  ProductIdData({
    this.id,
    this.attributes,
  });

  factory ProductIdData.fromJson(Map<String, dynamic> json) => ProductIdData(
    id: json["id"],
    attributes: json["attributes"] == null ? null : IndigoAttributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attributes": attributes?.toJson(),
  };
}

class IndigoAttributes {
  String? name;
  String? productUrl;
  int? waglCount;
  BrandId? brandId;
  ProductPic? productPic;

  IndigoAttributes({
    this.name,
    this.productUrl,
    this.waglCount,
    this.brandId,
    this.productPic,
  });

  factory IndigoAttributes.fromJson(Map<String, dynamic> json) => IndigoAttributes(
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
  GoodTagsDatum? data;

  BrandId({
    this.data,
  });

  factory BrandId.fromJson(Map<String, dynamic> json) => BrandId(
    data: json["data"] == null ? null : GoodTagsDatum.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class GoodTagsDatum {
  int? id;
  FluffyAttributes? attributes;

  GoodTagsDatum({
    this.id,
    this.attributes,
  });

  factory GoodTagsDatum.fromJson(Map<String, dynamic> json) => GoodTagsDatum(
    id: json["id"],
    attributes: json["attributes"] == null ? null : FluffyAttributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attributes": attributes?.toJson(),
  };
}

class FluffyAttributes {
  // String? name;
  String? brandName;

  FluffyAttributes({
    // this.name,
    this.brandName,
  });

  factory FluffyAttributes.fromJson(Map<String, dynamic> json) => FluffyAttributes(
    // name: json["name"],
    brandName: json["brandName"],
  );

  Map<String, dynamic> toJson() => {
    // "name": name,
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
  IndecentAttributes? attributes;

  ProductPicData({
    this.id,
    this.attributes,
  });

  factory ProductPicData.fromJson(Map<String, dynamic> json) => ProductPicData(
    id: json["id"],
    attributes: json["attributes"] == null ? null : IndecentAttributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attributes": attributes?.toJson(),
  };
}

class IndecentAttributes {
  String? name;
  FluffyFormats? formats;
  String? url;

  IndecentAttributes({
    this.name,
    this.formats,
    this.url,
  });

  factory IndecentAttributes.fromJson(Map<String, dynamic> json) => IndecentAttributes(
    name: json["name"],
    formats: json["formats"] == null ? null : FluffyFormats.fromJson(json["formats"]),
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "formats": formats?.toJson(),
    "url": url,
  };
}

class FluffyFormats {
  Large? small;
  Large? thumbnail;

  FluffyFormats({
    this.small,
    this.thumbnail,
  });

  factory FluffyFormats.fromJson(Map<String, dynamic> json) => FluffyFormats(
    small: json["small"] == null ? null : Large.fromJson(json["small"]),
    thumbnail: json["thumbnail"] == null ? null : Large.fromJson(json["thumbnail"]),
  );

  Map<String, dynamic> toJson() => {
    "small": small?.toJson(),
    "thumbnail": thumbnail?.toJson(),
  };
}


class VideoThumbnailWagl {
  int? id;
  MediaAttributes? attributes;

  VideoThumbnailWagl({this.id, this.attributes});

  factory VideoThumbnailWagl.fromJson(Map<String, dynamic> json) {
    return VideoThumbnailWagl(
      id: json['id'],
      attributes: json['attributes'] != null
          ? MediaAttributes.fromJson(json['attributes'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (attributes != null) {
      data['attributes'] = attributes!.toJson();
    }
    return data;
  }
}
class DataMedia {
  int? id;
  AttributesMedia? attributesMedia;

  DataMedia({this.id, this.attributesMedia});

  DataMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributesMedia = json['attributes'] != null
        ? new AttributesMedia.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attributesMedia != null) {
      data['attributes'] = this.attributesMedia!.toJson();
    }
    return data;
  }
}

class Media {
  List<DataMedia>? data;

  Media({this.data});

  Media.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataMedia>[];
      json['data'].forEach((v) {
        data!.add(new DataMedia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttributesMedia {
  String? name;
  int? width;
  int? height;
  Formats? formats;
  String? hash;
  String? ext;
  String? mime;
  String? url;



  AttributesMedia(
      {this.name,
        this.width,
        this.height,
        this.formats,
        this.hash,
        this.ext,
        this.mime,

        this.url,
      });

  AttributesMedia.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    width = json['width'];
    height = json['height'];
    formats =
    json['formats'] != null ? new Formats.fromJson(json['formats']) : null;
    hash = json['hash'];
    ext = json['ext'];
    mime = json['mime'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['width'] = this.width;
    data['height'] = this.height;
    if (this.formats != null) {
      data['formats'] = this.formats!.toJson();
    }
    data['hash'] = this.hash;
    data['ext'] = this.ext;
    data['mime'] = this.mime;
    data['url'] = this.url;


    return data;
  }
}
class CategoriesData {
  List<CategoriesMedia>? data;

  CategoriesData({this.data});

  CategoriesData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CategoriesMedia>[];
      json['data'].forEach((v) {
        data!.add(new CategoriesMedia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class CategoriesMedia {
  int? id;
  AttributesCategories? attributesMedia;

  CategoriesMedia({this.id, this.attributesMedia});

  CategoriesMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributesMedia = json['attributes'] != null
        ? new AttributesCategories.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attributesMedia != null) {
      data['attributes'] = this.attributesMedia!.toJson();
    }
    return data;
  }
}
class Formats {
  Thumbnail? thumbnail;
  Thumbnail? large;
  Thumbnail? small;
  Thumbnail? medium;

  Formats({this.thumbnail, this.large, this.small, this.medium});

  Formats.fromJson(Map<String, dynamic> json) {
    thumbnail = json['thumbnail'] != null
        ? new Thumbnail.fromJson(json['thumbnail'])
        : null;
    large =
    json['large'] != null ? new Thumbnail.fromJson(json['large']) : null;
    small =
    json['small'] != null ? new Thumbnail.fromJson(json['small']) : null;
    medium =
    json['medium'] != null ? new Thumbnail.fromJson(json['medium']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.thumbnail != null) {
      data['thumbnail'] = this.thumbnail!.toJson();
    }
    if (this.large != null) {
      data['large'] = this.large!.toJson();
    }
    if (this.small != null) {
      data['small'] = this.small!.toJson();
    }
    if (this.medium != null) {
      data['medium'] = this.medium!.toJson();
    }
    return data;
  }
}

class Thumbnail {
  String? ext;
  String? url;
  String? hash;
  String? mime;
  String? name;
  Null? path;
  int? width;
  int? height;
  int?  InBytes;
  bool? isUrlSigned;

  Thumbnail(
      {this.ext,
        this.url,
        this.hash,
        this.mime,
        this.name,
        this.path,
        this.width,
        this.height,
        this. InBytes,
        this.isUrlSigned});

  Thumbnail.fromJson(Map<String, dynamic> json) {
    ext = json['ext'];
    url = json['url'];
    hash = json['hash'];
    mime = json['mime'];
    name = json['name'];
    path = json['path'];
    width = json['width'];
    height = json['height'];
    InBytes = json[' InBytes'];
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
    data['width'] = this.width;
    data['height'] = this.height;
    data[' InBytes'] = this. InBytes;

    return data;
  }
}

class UserId {
  DataAttributes? data;

  UserId({this.data});

  UserId.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new DataAttributes.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProfilePic {
  ProfilePicData? data;
  ProfilePic({this.data});

  ProfilePic.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ProfilePicData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AttributesUser {
  String? username;
  String? email;
  String? provider;
  bool? confirmed;
  bool? blocked;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? location;
  String? gender;
  String? pronouns;
  String? accountType;
  int? totalWagls;
  int? totalFollowers;
  int? totalFollowing;
  int? totalViews;
  String? bio;
  String? linkAccountBy;
  bool? emailNotification;
  bool? pushNotification;
  ProfilePic? profilePicData;

  AttributesUser(
      {this.username,
        this.email,
        this.provider,
        this.confirmed,
        this.blocked,
        this.firstName,
        this.lastName,
        this.dateOfBirth,
        this.location,
        this.gender,
        this.pronouns,
        this.accountType,
        this.totalWagls,
        this.totalFollowers,
        this.totalFollowing,
        this.totalViews,
        this.bio,
        this.linkAccountBy,
        this.emailNotification,
        this.profilePicData,
        this.pushNotification});

  AttributesUser.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    provider = json['provider'];
    confirmed = json['confirmed'];
    blocked = json['blocked'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    dateOfBirth = json['dateOfBirth'];
    location = json['location'];
    gender = json['gender'];
    pronouns = json['pronouns'];
    accountType = json['accountType'];
    totalWagls = json['totalWagls'];
    totalFollowers = json['totalFollowers'];
    totalFollowing = json['totalFollowing'];
    totalViews = json['totalViews'];
    bio = json['bio'];
    linkAccountBy = json['linkAccountBy'];
    emailNotification = json['emailNotification'];
    pushNotification = json['pushNotification'];
    profilePicData = json['profilePic'] != null
        ? new ProfilePic.fromJson(json['profilePic'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['provider'] = this.provider;
    data['confirmed'] = this.confirmed;
    data['blocked'] = this.blocked;

    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['dateOfBirth'] = this.dateOfBirth;
    data['location'] = this.location;
    data['gender'] = this.gender;
    data['pronouns'] = this.pronouns;
    data['accountType'] = this.accountType;
    data['totalWagls'] = this.totalWagls;
    data['totalFollowers'] = this.totalFollowers;
    data['totalFollowing'] = this.totalFollowing;
    data['totalViews'] = this.totalViews;
    data['bio'] = this.bio;
    data['linkAccountBy'] = this.linkAccountBy;
    data['emailNotification'] = this.emailNotification;
    data['pushNotification'] = this.pushNotification;
    if (profilePicData != null) {
      data['profilePic'] = profilePicData!.toJson();
    } else {
      data['profilePic'] = null; // Ensure null is handled in toJson
    }
    return data;
  }
}

class AttributesCategories {
  String? categoryName;



  AttributesCategories(
      {this.categoryName});
  AttributesCategories.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryName'] = this.categoryName;
    return data;
  }
}

class ProfilePicAttributes {
  String? name;
  String? hash;
  String? ext;
  String? mime;
  double? size;
  String? url;


  ProfilePicAttributes(
      {this.name,
        this.hash,
        this.ext,
        this.mime,
        this.size,
        this.url,
      });

  ProfilePicAttributes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    hash = json['hash'];
    ext = json['ext'];
    mime = json['mime'];
    size = json['size'];
    url = json['url'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['hash'] = this.hash;
    data['ext'] = this.ext;
    data['mime'] = this.mime;
    data['size'] = this.size;
    data['url'] = this.url;

    return data;
  }
}

class CountArrayModel {
  bool status;
  List<int> result;
  String message;

  CountArrayModel({
    required this.status,
    required this.result,
    required this.message,
  });

  // Factory constructor to create an instance from JSON
  factory CountArrayModel.fromJson(Map<String, dynamic> json) {
    return CountArrayModel(
      status: json['status'],
      result: List<int>.from(json['result']),
      message: json['message'],
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'result': result,
      'message': message,
    };
  }
}
class GoodTags {
  List<TagData> data;

  GoodTags({required this.data});

  factory GoodTags.fromJson(Map<String, dynamic> json) {
    return GoodTags(
      data: json['data'] != null && json['data'].isNotEmpty
          ? List<TagData>.from(json['data'].map((x) => TagData.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class TagData {
  int id;
  TagAttributes? attributes;

  TagData({required this.id, this.attributes});

  factory TagData.fromJson(Map<String, dynamic> json) {
    return TagData(
      id: json['id'],
      attributes: json['attributes'] != null
          ? TagAttributes.fromJson(json['attributes'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': attributes?.toJson(),
    };
  }
}

class TagAttributes {
  String name;
  String createdAt;
  String updatedAt;
  String publishedAt;
  TagImage? image;

  TagAttributes({
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    this.image,
  });

  factory TagAttributes.fromJson(Map<String, dynamic> json) {
    return TagAttributes(
      name: json['name'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      publishedAt: json['publishedAt'],
      image: json['image'] != null ? TagImage.fromJson(json['image']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'publishedAt': publishedAt,
      'image': image?.toJson(),
    };
  }
}

class TagImage {
  TagImageData? data;

  TagImage({this.data});

  factory TagImage.fromJson(Map<String, dynamic> json) {
    return TagImage(
      data: json['data'] != null ? TagImageData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class TagImageData {
  int id;
  TagImageAttributes? attributes;

  TagImageData({required this.id, this.attributes});

  factory TagImageData.fromJson(Map<String, dynamic> json) {
    return TagImageData(
      id: json['id'],
      attributes: json['attributes'] != null
          ? TagImageAttributes.fromJson(json['attributes'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': attributes?.toJson(),
    };
  }
}

class TagImageAttributes {
  String name;
  String ext;
  String mime;
  double size;
  String url;
  int width;
  int height;
  bool? isUrlSigned;

  TagImageAttributes({
    required this.name,
    required this.ext,
    required this.mime,
    required this.size,
    required this.url,
    required this.width,
    required this.height,
    required this.isUrlSigned,
  });

  factory TagImageAttributes.fromJson(Map<String, dynamic> json) {
    return TagImageAttributes(
      name: json['name'],
      ext: json['ext'],
      mime: json['mime'],
      size: (json['size'] as num).toDouble(),
      url: json['url'],
      width: json['width'],
      height: json['height'],
      isUrlSigned: json['isUrlSigned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ext': ext,
      'mime': mime,
      'size': size,
      'url': url,
      'width': width,
      'height': height,
      'isUrlSigned': isUrlSigned,
    };
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
/*
import 'dart:convert';

WaglModel viewAllWaglModelFromJson(String str) => WaglModel.fromJson(json.decode(str));
CountArrayModel viewCountModelFromJson(String str) => CountArrayModel.fromJson(json.decode(str));


class WaglModel {
  List<DataWagl>? data;
  Meta? meta;

  WaglModel({this.data});

  WaglModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataWagl>[];
      json['data'].forEach((v) {
        data!.add(new DataWagl.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }

}

class DataWagl {
  int? id;
  Attributes? attributes;

  DataWagl({this.id, this.attributes});

  DataWagl.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    return data;
  }
}


class DataAttributes {
  int? id;
  AttributesUser? attributes;

  DataAttributes({this.id, this.attributes});

  DataAttributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributes = json['attributes'] != null
        ? new AttributesUser.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    return data;
  }
}
class ProfilePicData {
  int? id;
  ProfilePicAttributes? attributes;

  ProfilePicData({this.id, this.attributes});

  ProfilePicData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributes = json['attributes'] != null
        ? new ProfilePicAttributes.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    return data;
  }
}
class Attributes {
  String? description;
  String? location;
  bool? isActive;
  int? totalLikes;
  int? totalComments;
  int? totalViews;
  Media? media;
  Media? thumbnail;
  UserId? userId;
  CategoriesData? interestedCategories;
  GoodTags? goodTags;

  Attributes(
      {this.description,
        this.location,
        this.isActive,
        this.totalLikes,
        this.totalComments,
        this.totalViews,
        this.media,
        this.thumbnail,
        this.userId,
        this.interestedCategories,
        this.goodTags});

  Attributes.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    location = json['location'];
    isActive = json['isActive'];
    totalLikes = json['total_likes'];
    totalComments = json['total_comments'];
    totalViews = json['total_views'];
    media = json['media'] != null ? new Media.fromJson(json['media']) : null;
    thumbnail = json['thumbnail'] != null ? new Media.fromJson(json['thumbnail']) : null;
    userId =
    json['user_id'] != null ? new UserId.fromJson(json['user_id']) : null;
    interestedCategories = json['interested_categories'] != null
        ? new CategoriesData.fromJson(json['interested_categories'])
        : null;
    goodTags = json['good_tags'] != null
        ? new GoodTags.fromJson(json['good_tags'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['location'] = this.location;
    data['isActive'] = this.isActive;

    data['total_likes'] = this.totalLikes;
    data['total_comments'] = this.totalComments;
    data['total_views'] = this.totalViews;
    if (this.media != null) {
      data['media'] = this.media!.toJson();
    }
    if (this.thumbnail != null) {
      data['thumbnail'] = this.thumbnail!.toJson();
    }
    if (this.userId != null) {
      data['user_id'] = this.userId!.toJson();
    }
    if (this.interestedCategories != null) {
      data['interested_categories'] = this.interestedCategories!.toJson();
    }
    if (this.goodTags != null) {
      data['good_tags'] = this.goodTags!.toJson();
    }
    return data;
  }
}

class DataMedia {
  int? id;
  AttributesMedia? attributesMedia;

  DataMedia({this.id, this.attributesMedia});

  DataMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributesMedia = json['attributes'] != null
        ? new AttributesMedia.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attributesMedia != null) {
      data['attributes'] = this.attributesMedia!.toJson();
    }
    return data;
  }
}

class Media {
  List<DataMedia>? data;

  Media({this.data});

  Media.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataMedia>[];
      json['data'].forEach((v) {
        data!.add(new DataMedia.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttributesMedia {
  String? name;
  int? width;
  int? height;
  Formats? formats;
  String? hash;
  String? ext;
  String? mime;
  String? url;



  AttributesMedia(
      {this.name,
        this.width,
        this.height,
        this.formats,
        this.hash,
        this.ext,
        this.mime,

        this.url,
        });

  AttributesMedia.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    width = json['width'];
    height = json['height'];
    formats =
    json['formats'] != null ? new Formats.fromJson(json['formats']) : null;
    hash = json['hash'];
    ext = json['ext'];
    mime = json['mime'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['width'] = this.width;
    data['height'] = this.height;
    if (this.formats != null) {
      data['formats'] = this.formats!.toJson();
    }
    data['hash'] = this.hash;
    data['ext'] = this.ext;
    data['mime'] = this.mime;
    data['url'] = this.url;


    return data;
  }
}
class CategoriesData {
  List<CategoriesMedia>? data;

  CategoriesData({this.data});

  CategoriesData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CategoriesMedia>[];
      json['data'].forEach((v) {
        data!.add(new CategoriesMedia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class CategoriesMedia {
  int? id;
  AttributesCategories? attributesMedia;

  CategoriesMedia({this.id, this.attributesMedia});

  CategoriesMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributesMedia = json['attributes'] != null
        ? new AttributesCategories.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attributesMedia != null) {
      data['attributes'] = this.attributesMedia!.toJson();
    }
    return data;
  }
}
class Formats {
  Thumbnail? thumbnail;
  Thumbnail? large;
  Thumbnail? small;
  Thumbnail? medium;

  Formats({this.thumbnail, this.large, this.small, this.medium});

  Formats.fromJson(Map<String, dynamic> json) {
    thumbnail = json['thumbnail'] != null
        ? new Thumbnail.fromJson(json['thumbnail'])
        : null;
    large =
    json['large'] != null ? new Thumbnail.fromJson(json['large']) : null;
    small =
    json['small'] != null ? new Thumbnail.fromJson(json['small']) : null;
    medium =
    json['medium'] != null ? new Thumbnail.fromJson(json['medium']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.thumbnail != null) {
      data['thumbnail'] = this.thumbnail!.toJson();
    }
    if (this.large != null) {
      data['large'] = this.large!.toJson();
    }
    if (this.small != null) {
      data['small'] = this.small!.toJson();
    }
    if (this.medium != null) {
      data['medium'] = this.medium!.toJson();
    }
    return data;
  }
}

class Thumbnail {
  String? ext;
  String? url;
  String? hash;
  String? mime;
  String? name;
  Null? path;
  int? width;
  int? height;
  int?  InBytes;
  bool? isUrlSigned;

  Thumbnail(
      {this.ext,
        this.url,
        this.hash,
        this.mime,
        this.name,
        this.path,
        this.width,
        this.height,
        this. InBytes,
        this.isUrlSigned});

  Thumbnail.fromJson(Map<String, dynamic> json) {
    ext = json['ext'];
    url = json['url'];
    hash = json['hash'];
    mime = json['mime'];
    name = json['name'];
    path = json['path'];
    width = json['width'];
    height = json['height'];
     InBytes = json[' InBytes'];
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
    data['width'] = this.width;
    data['height'] = this.height;
    data[' InBytes'] = this. InBytes;

    return data;
  }
}

class UserId {
  DataAttributes? data;

  UserId({this.data});

  UserId.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new DataAttributes.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProfilePic {
  ProfilePicData? data;
  ProfilePic({this.data});

  ProfilePic.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ProfilePicData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AttributesUser {
  String? username;
  String? email;
  String? provider;
  bool? confirmed;
  bool? blocked;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? location;
  String? gender;
  String? pronouns;
  String? accountType;
  int? totalWagls;
  int? totalFollowers;
  int? totalFollowing;
  int? totalViews;
  String? bio;
  String? linkAccountBy;
  bool? emailNotification;
  bool? pushNotification;
  ProfilePic? profilePicData;


  AttributesUser(
      {this.username,
        this.email,
        this.provider,
        this.confirmed,
        this.blocked,
        this.firstName,
        this.lastName,
        this.dateOfBirth,
        this.location,
        this.gender,
        this.pronouns,
        this.accountType,
        this.totalWagls,
        this.totalFollowers,
        this.totalFollowing,
        this.totalViews,
        this.bio,
        this.linkAccountBy,
        this.emailNotification,
        this.profilePicData,
        this.pushNotification});

  AttributesUser.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    provider = json['provider'];
    confirmed = json['confirmed'];
    blocked = json['blocked'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    dateOfBirth = json['dateOfBirth'];
    location = json['location'];
    gender = json['gender'];
    pronouns = json['pronouns'];
    accountType = json['accountType'];
    totalWagls = json['totalWagls'];
    totalFollowers = json['totalFollowers'];
    totalFollowing = json['totalFollowing'];
    totalViews = json['totalViews'];
    bio = json['bio'];
    linkAccountBy = json['linkAccountBy'];
    emailNotification = json['emailNotification'];
    pushNotification = json['pushNotification'];
    profilePicData = json['profilePic'] != null
        ? new ProfilePic.fromJson(json['profilePic'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['provider'] = this.provider;
    data['confirmed'] = this.confirmed;
    data['blocked'] = this.blocked;

    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['dateOfBirth'] = this.dateOfBirth;
    data['location'] = this.location;
    data['gender'] = this.gender;
    data['pronouns'] = this.pronouns;
    data['accountType'] = this.accountType;
    data['totalWagls'] = this.totalWagls;
    data['totalFollowers'] = this.totalFollowers;
    data['totalFollowing'] = this.totalFollowing;
    data['totalViews'] = this.totalViews;
    data['bio'] = this.bio;
    data['linkAccountBy'] = this.linkAccountBy;
    data['emailNotification'] = this.emailNotification;
    data['pushNotification'] = this.pushNotification;
    if (profilePicData != null) {
      data['profilePic'] = profilePicData!.toJson();
    } else {
      data['profilePic'] = null; // Ensure null is handled in toJson
    }
    return data;
  }
}

  class AttributesCategories {
  String? categoryName;



  AttributesCategories(
      {this.categoryName});
  AttributesCategories.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryName'] = this.categoryName;
    return data;
  }
}

class ProfilePicAttributes {
  String? name;
  String? hash;
  String? ext;
  String? mime;
  double? size;
  String? url;


  ProfilePicAttributes(
      {this.name,
        this.hash,
        this.ext,
        this.mime,
        this.size,
        this.url,
        });

  ProfilePicAttributes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    hash = json['hash'];
    ext = json['ext'];
    mime = json['mime'];
    size = json['size'];
    url = json['url'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['hash'] = this.hash;
    data['ext'] = this.ext;
    data['mime'] = this.mime;
    data['size'] = this.size;
    data['url'] = this.url;

    return data;
  }
}

class CountArrayModel {
  bool status;
  List<int> result;
  String message;

  CountArrayModel({
    required this.status,
    required this.result,
    required this.message,
  });

  // Factory constructor to create an instance from JSON
  factory CountArrayModel.fromJson(Map<String, dynamic> json) {
    return CountArrayModel(
      status: json['status'],
      result: List<int>.from(json['result']),
      message: json['message'],
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'result': result,
      'message': message,
    };
  }
}
class GoodTags {
  List<TagData> data;

  GoodTags({required this.data});

  factory GoodTags.fromJson(Map<String, dynamic> json) {
    return GoodTags(
      data: json['data'] != null && json['data'].isNotEmpty
          ? List<TagData>.from(json['data'].map((x) => TagData.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class TagData {
  int id;
  TagAttributes? attributes;

  TagData({required this.id, this.attributes});

  factory TagData.fromJson(Map<String, dynamic> json) {
    return TagData(
      id: json['id'],
      attributes: json['attributes'] != null
          ? TagAttributes.fromJson(json['attributes'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': attributes?.toJson(),
    };
  }
}

class TagAttributes {
  String name;
  String createdAt;
  String updatedAt;
  String publishedAt;
  TagImage? image;

  TagAttributes({
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    this.image,
  });

  factory TagAttributes.fromJson(Map<String, dynamic> json) {
    return TagAttributes(
      name: json['name'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      publishedAt: json['publishedAt'],
      image: json['image'] != null ? TagImage.fromJson(json['image']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'publishedAt': publishedAt,
      'image': image?.toJson(),
    };
  }
}

class TagImage {
  TagImageData? data;

  TagImage({this.data});

  factory TagImage.fromJson(Map<String, dynamic> json) {
    return TagImage(
      data: json['data'] != null ? TagImageData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class TagImageData {
  int id;
  TagImageAttributes? attributes;

  TagImageData({required this.id, this.attributes});

  factory TagImageData.fromJson(Map<String, dynamic> json) {
    return TagImageData(
      id: json['id'],
      attributes: json['attributes'] != null
          ? TagImageAttributes.fromJson(json['attributes'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': attributes?.toJson(),
    };
  }
}

class TagImageAttributes {
  String name;
  String ext;
  String mime;
  double size;
  String url;
  int width;
  int height;
  bool? isUrlSigned;

  TagImageAttributes({
    required this.name,
    required this.ext,
    required this.mime,
    required this.size,
    required this.url,
    required this.width,
    required this.height,
    required this.isUrlSigned,
  });

  factory TagImageAttributes.fromJson(Map<String, dynamic> json) {
    return TagImageAttributes(
      name: json['name'],
      ext: json['ext'],
      mime: json['mime'],
      size: (json['size'] as num).toDouble(),
      url: json['url'],
      width: json['width'],
      height: json['height'],
      isUrlSigned: json['isUrlSigned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ext': ext,
      'mime': mime,
      'size': size,
      'url': url,
      'width': width,
      'height': height,
      'isUrlSigned': isUrlSigned,
    };
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
}*/
