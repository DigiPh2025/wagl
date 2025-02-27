
import 'dart:convert';

SearchModel searchModelFromJson(String str) => SearchModel.fromJson(json.decode(str));

class SearchModel {
  final bool status;
  final SearchData data;

  SearchModel({
    required this.status,
    required this.data,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
    status: json['status'],
    data: SearchData.fromJson(json['data']),
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data.toJson(),
  };
}

class SearchData {
  final List<GoodTag> goodTags;
  final List<InterestedCategory> interestedCategories;
  final List<SearchUser> users;

  SearchData({
    required this.goodTags,
    required this.interestedCategories,
    required this.users,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
    goodTags: List<GoodTag>.from(json['goodTags'].map((x) => GoodTag.fromJson(x))),
    interestedCategories: List<InterestedCategory>.from(json['interestedCategories'].map((x) => InterestedCategory.fromJson(x))),
    users: List<SearchUser>.from(json['users'].map((x) => SearchUser.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'goodTags': List<dynamic>.from(goodTags.map((x) => x.toJson())),
    'interestedCategories': List<dynamic>.from(interestedCategories.map((x) => x.toJson())),
    'users': List<dynamic>.from(users.map((x) => x.toJson())),
  };
}


class GoodTag {
  final int id;
  final GoodTagAttributes attributes;

  GoodTag({
    required this.id,
    required this.attributes,
  });

  factory GoodTag.fromJson(Map<String, dynamic> json) => GoodTag(
    id: json['id'],
    attributes: GoodTagAttributes.fromJson(json['attributes']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'attributes': attributes.toJson(),
  };
}

class GoodTagAttributes {
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  final TagImage? image;

  GoodTagAttributes({
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    this.image,
  });

  factory GoodTagAttributes.fromJson(Map<String, dynamic> json) => GoodTagAttributes(
    name: json['name'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    publishedAt: DateTime.parse(json['publishedAt']),
    image: json['image'] != null && json['image']['data'] != null
        ? TagImage.fromJson(json['image'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'publishedAt': publishedAt.toIso8601String(),
    'image': image?.toJson(),
  };
}

class TagImage {
  final ImageData? data;

  TagImage({
    required this.data,
  });

  factory TagImage.fromJson(Map<String, dynamic> json) => TagImage(
    data: json['data'] != null ? ImageData.fromJson(json['data']) : null,
  );

  Map<String, dynamic> toJson() => {
    'data': data?.toJson(),
  };
}

class ImageData {
  final int id;
  final ImageAttributes attributes;

  ImageData({
    required this.id,
    required this.attributes,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
    id: json['id'],
    attributes: ImageAttributes.fromJson(json['attributes']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'attributes': attributes.toJson(),
  };
}

class ImageAttributes {
  final String name;
  final String? alternativeText;
  final String? caption;
  final int width;
  final int height;
  final dynamic formats;
  final String hash;
  final String ext;
  final String mime;
  final double size;
  final String url;
  final String? previewUrl;
  final String provider;
  final dynamic providerMetadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isUrlSigned;

  ImageAttributes({
    required this.name,
    this.alternativeText,
    this.caption,
    required this.width,
    required this.height,
    this.formats,
    required this.hash,
    required this.ext,
    required this.mime,
    required this.size,
    required this.url,
    this.previewUrl,
    required this.provider,
    this.providerMetadata,
    required this.createdAt,
    required this.updatedAt,
    required this.isUrlSigned,
  });

  factory ImageAttributes.fromJson(Map<String, dynamic> json) => ImageAttributes(
    name: json['name'],
    alternativeText: json['alternativeText'],
    caption: json['caption'],
    width: json['width'],
    height: json['height'],
    formats: json['formats'],
    hash: json['hash'],
    ext: json['ext'],
    mime: json['mime'],
    size: json['size'].toDouble(),
    url: json['url'],
    previewUrl: json['previewUrl'],
    provider: json['provider'],
    providerMetadata: json['provider_metadata'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    isUrlSigned: json['isUrlSigned'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'alternativeText': alternativeText,
    'caption': caption,
    'width': width,
    'height': height,
    'formats': formats,
    'hash': hash,
    'ext': ext,
    'mime': mime,
    'size': size,
    'url': url,
    'previewUrl': previewUrl,
    'provider': provider,
    'provider_metadata': providerMetadata,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'isUrlSigned': isUrlSigned,
  };
}


class InterestedCategory {
  final int id;
  final InterestedCategoryAttributes attributes;

  InterestedCategory({
    required this.id,
    required this.attributes,
  });

  factory InterestedCategory.fromJson(Map<String, dynamic> json) => InterestedCategory(
    id: json['id'],
    attributes: InterestedCategoryAttributes.fromJson(json['attributes']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'attributes': attributes.toJson(),
  };
}

class InterestedCategoryAttributes {
  final String categoryName;
  // final List<TagImage>? categoryIcon;
  final CategoriesImage? categoryIcon;

  InterestedCategoryAttributes({
    required this.categoryName,
    this.categoryIcon,
  });

  factory InterestedCategoryAttributes.fromJson(Map<String, dynamic> json) => InterestedCategoryAttributes(
    categoryName: json['categoryName'],
    /*  categoryIcon: json['categoryIcon'] != null
        ? List<TagImage>.from(json['categoryIcon']['data'].map((x) => TagImage.fromJson(x)))
        : null,*/
    categoryIcon: json['categoryIcon'] != null && json['categoryIcon']['data'] != null
        ? CategoriesImage.fromJson(json['categoryIcon'])
        : null,

  );

  Map<String, dynamic> toJson() => {
    'categoryName': categoryName,
    'categoryIcon': categoryIcon?.toJson(),
    // 'categoryIcon': categoryIcon != null ? List<dynamic>.from(categoryIcon!.map((x) => x.toJson())) : null,
  };
}
class CategoriesImage {
  final ImageData? data;

  CategoriesImage({
    required this.data,
  });

  factory CategoriesImage.fromJson(Map<String, dynamic> json) => CategoriesImage(
    data: json['data'] != null ? ImageData.fromJson(json['data']) : null,
  );

  Map<String, dynamic> toJson() => {
    'data': data?.toJson(),
  };
}

class SearchUser {
  final int id;
  final UserAttributes attributes;

  SearchUser({
    required this.id,
    required this.attributes,
  });

  factory SearchUser.fromJson(Map<String, dynamic> json) => SearchUser(
    id: json['id'],
    attributes: UserAttributes.fromJson(json['attributes']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'attributes': attributes.toJson(),
  };
}

class UserAttributes {
  final int userID;
  final int totalFollowers;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  late bool following;
  final ProfilePic? profilePic;

  UserAttributes({
    required this.userID,
    required this.username,
    required this.email,
    required this.following,
    required this.totalFollowers,
    required this.lastName,
    required this.firstName,

    this.profilePic,
  });

  factory UserAttributes.fromJson(Map<String, dynamic> json) => UserAttributes(
    userID: json['userID'],
    username: json['username'],
    firstName: json['firstName'] ?? "",
    lastName: json['lastName'] ?? "",

    email: json['email'],
    totalFollowers: json['totalFollowers'],
    following: json['following'],
    profilePic: json['profilePic'] != null ? ProfilePic.fromJson(json['profilePic']) : null,
  );

  Map<String, dynamic> toJson() => {
    'userID': userID,
    'username': username,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'totalFollowers': totalFollowers,
    'following': following,
    'profilePic': profilePic?.toJson(),
  };
}

class ProfilePic {
  final int id;
  final String url;
  final bool isUrlSigned;

  ProfilePic({
    required this.id,
    required this.url,
    required this.isUrlSigned,
  });

  factory ProfilePic.fromJson(Map<String, dynamic> json) => ProfilePic(
    id: json['id'],
    url: json['url'],
    isUrlSigned: json['isUrlSigned'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'url': url,
    'isUrlSigned': isUrlSigned,
  };
}
