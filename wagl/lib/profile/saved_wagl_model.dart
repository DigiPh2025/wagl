import 'dart:convert';

import '../home/all_wagl_model.dart';

SavedWaglModel viewAllSavedWaglModelFromJson(String str) =>
    SavedWaglModel.fromJson(json.decode(str));

class SavedWaglModel {
  List<SavedData>? data;
  Meta? meta;

  SavedWaglModel getCategoriesModelFromJson(String str) =>
      SavedWaglModel.fromJson(json.decode(str));

  SavedWaglModel({this.data, this.meta});

  SavedWaglModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SavedData>[];
      json['data'].forEach((v) {
        data!.add(new SavedData.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }
}

class SavedData {
  int? id;
  Attributes? attributes;

  SavedData({this.id, this.attributes});

  SavedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
  }
}

class Attributes {
  String? createdAt;
  String? updatedAt;
  String? publishedAt;
  WaglId? waglId;
  UserDetails? userDetails;

  Attributes({
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.waglId,
    this.userDetails,
  });

  Attributes.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    publishedAt = json['publishedAt'];
    waglId =
        json['wagl_id'] != null ? new WaglId.fromJson(json['wagl_id']) : null;
    userDetails =
        json['user_id'] != null ? new UserDetails.fromJson(json['user_id']) : null;
  }

/*  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['publishedAt'] = this.publishedAt;
    if (this.waglId != null) {
      data['wagl_id'] = this.waglId!.toJson();
    }
    if (this.userId != null) {
      data['user_id'] = this.userId!.toJson();
    }
    return data;
  }*/
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

class ProfilePic {
  ProfilePicData? data;

  ProfilePic({this.data});

  ProfilePic.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? new ProfilePicData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
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

class ProfilePicAttributes {
  String? name;
  String? hash;
  String? ext;
  String? mime;
  double? size;
  String? url;

  ProfilePicAttributes({
    this.name,
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

class WaglId {
  WaglData? data;

  WaglId({this.data});

  WaglId.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new WaglData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class WaglData {
  int? id;
  WaglSavedAttributes? attributes;

  WaglData({this.id, this.attributes});

  WaglData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributes = json['attributes'] != null
        ? new WaglSavedAttributes.fromJson(json['attributes'])
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

class WaglSavedAttributes {
  String? description;
  String? location;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  String? publishedAt;
  int? totalLikes;
  int? totalComments;
  int? totalViews;
  int? totalSaved;
  Media? media;
  VideoThumbnailWagl? thumbnail;
  GoodTags? goodTags;
  CategoriesData? interestedCategories;
  UserDetails? userDetails;
  ProductId? productId;

  WaglSavedAttributes(
      {this.description,
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
      this.userDetails,
      this.goodTags,
        this.productId,
      this.interestedCategories});

  WaglSavedAttributes.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    location = json['location'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    publishedAt = json['publishedAt'];
    totalLikes = json['total_likes'];
    totalComments = json['total_comments'];
    totalViews = json['total_views'];
    totalSaved = json['total_saved'];
    productId= json["product_id"] == null ? null : ProductId.fromJson(json["product_id"]);
    userDetails=
    json["user_id"] == null ? null : UserDetails.fromJson(json["user_id"]);
    interestedCategories=
    json["interested_categories"] == null
        ? null
        : CategoriesData.fromJson(json["interested_categories"]);
    totalSaved = json['total_saved'];
    thumbnail = json['thumbnail'] != null && json['thumbnail']['data'] != null
        ? VideoThumbnailWagl.fromJson(json['thumbnail']['data'])
        : null;
    media = json['media'] != null ? new Media.fromJson(json['media']) : null;
    goodTags=
    json["good_tags"] == null ? null : GoodTags.fromJson(json["good_tags"]);
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
    data['total_saved'] = this.totalSaved;
    data['user_id'] = this.userDetails;

    data['interested_categories'] = this.interestedCategories;
    data['good_tags'] = this.goodTags;
    if (thumbnail != null) {
      data['thumbnail'] = {'data': thumbnail!.toJson()};
    } else {
      data['thumbnail'] = {'data': null};
    }   if (productId != null) {
      data['product_id'] = {'data': productId!.toJson()};
    } else {
      data['product_id'] = {'data': null};
    }
    if (this.media != null) {
      data['media'] = this.media!.toJson();
    }
    return data;
  }
}
class SavedProductId {
  ProductIdData? data;

  SavedProductId({
    this.data,
  });

  factory SavedProductId.fromJson(Map<String, dynamic> json) => SavedProductId(
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
  String? name;
  String? brandName;

  FluffyAttributes({
    this.name,
    this.brandName,
  });

  factory FluffyAttributes.fromJson(Map<String, dynamic> json) => FluffyAttributes(
    name: json["name"],
    brandName: json["brandName"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
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
class UserDetails {
  DataAttributes? data;

  UserDetails({this.data});

  UserDetails.fromJson(Map<String, dynamic> json) {
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
class DataUserAttributes {
  int? id;
  AttributesUser? attributes;

  DataUserAttributes({this.id, this.attributes});

  DataUserAttributes.fromJson(Map<String, dynamic> json) {
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
class MediaData {
  int? id;
  MediaAttributes? attributes;

  MediaData({this.id, this.attributes});

  MediaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributes = json['attributes'] != null
        ? new MediaAttributes.fromJson(json['attributes'])
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

class Media {
  List<MediaData>? data;

  Media({this.data});

  Media.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <MediaData>[];
      json['data'].forEach((v) {
        data!.add(new MediaData.fromJson(v));
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

class MediaAttributes {
  String? name;
  Formats? formats;
  String? ext;
  String? url;

  MediaAttributes({
    this.name,
    this.formats,
    this.ext,
    this.url,
  });

  MediaAttributes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    formats =
        json['formats'] != null ? new Formats.fromJson(json['formats']) : null;
    ext = json['ext'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;

    if (this.formats != null) {
      data['formats'] = this.formats!.toJson();
    }
    data['ext'] = this.ext;
    data['url'] = this.url;
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

  Large({
    this.ext,
    this.url,
  });

  Large.fromJson(Map<String, dynamic> json) {
    ext = json['ext'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ext'] = this.ext;
    data['url'] = this.url;

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
