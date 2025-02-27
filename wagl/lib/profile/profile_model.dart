import 'dart:convert';

ProfileDetailsModel profileDetailsFromJson(String str) => ProfileDetailsModel.fromJson(json.decode(str));

class ProfileDetailsModel {
  final int id;
  final String username;
  final String email;
  final String provider;
  final bool confirmed;
  final bool blocked;
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String location;
  final String gender;
  final String pronouns;
  final String accountType;
  final DateTime createdAt;
  final DateTime updatedAt;
  late final int totalWagls;
  late  int totalFollowers=0;
  final int totalFollowing;
  final int totalViews;
  final String bio;
  final String linkAccountBy;
  final bool emailNotification;
  final bool pushNotification;
  final List<InterestedCategoryProfile>? interestedCategories;
  final List<InterestedCategoryProfile>? recentCategories;
  final ProfilePic? profilePic;

  ProfileDetailsModel({
    required this.id,
    required this.username,
    required this.email,
    required this.provider,
    required this.confirmed,
    required this.blocked,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.location,
    required this.gender,
    required this.pronouns,
    required this.accountType,
    required this.createdAt,
    required this.updatedAt,
    required this.totalWagls,
    required this.totalFollowers,
    required this.totalFollowing,
    required this.totalViews,
    required this.bio,
    required this.linkAccountBy,
    required this.emailNotification,
    required this.pushNotification,
    this.interestedCategories,
    this.recentCategories,
    this.profilePic,
  });

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) => ProfileDetailsModel(
    id: json['id'],
    username: json['username'],
    email: json['email'],
    provider: json['provider'],
    confirmed: json['confirmed'],
    blocked: json['blocked'],
    firstName: json['firstName'] ?? "",
    lastName: json['lastName'] ?? "",
    dateOfBirth: json['dateOfBirth'] ?? "",
    location: json['location']??"",
    gender: json['gender']??"",
    pronouns: json['pronouns']??"",
    accountType: json['accountType']??"",
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    totalWagls: json['totalWagls'],
    totalFollowers: json['totalFollowers'],
    totalFollowing: json['totalFollowing'],
    totalViews: json['totalViews'],
    bio: json['bio'],
    linkAccountBy: json['linkAccountBy'],
    emailNotification: json['emailNotification'],
    pushNotification: json['pushNotification'],
    interestedCategories: json['recentCategories'] != null
        ? List<InterestedCategoryProfile>.from(json['interestedCategories'].map((x) => InterestedCategoryProfile.fromJson(x)))
        : null,
    recentCategories: json['interestedCategories'] != null
        ? List<InterestedCategoryProfile>.from(json['recentCategories'].map((x) => InterestedCategoryProfile.fromJson(x)))
        : null,
    profilePic: json['profilePic'] != null ? ProfilePic.fromJson(json['profilePic']) : null,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'provider': provider,
      'confirmed': confirmed,
      'blocked': blocked,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'location': location,
      'gender': gender,
      'pronouns': pronouns,
      'accountType': accountType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'totalWagls': totalWagls,
      'totalFollowers': totalFollowers,
      'totalFollowing': totalFollowing,
      'totalViews': totalViews,
      'bio': bio,
      'linkAccountBy': linkAccountBy,
      'emailNotification': emailNotification,
      'pushNotification': pushNotification,
      'interestedCategories': interestedCategories != null
          ? List<dynamic>.from(interestedCategories!.map((x) => x.toJson()))
          : null,
      'recentCategories': recentCategories != null
          ? List<dynamic>.from(recentCategories!.map((x) => x.toJson()))
          : null,
      'profilePic': profilePic?.toJson(),
    };
  }
}

class InterestedCategoryProfile {
  final int id;
  final String categoryName;

  InterestedCategoryProfile({
    required this.id,
    required this.categoryName,
  });

  factory InterestedCategoryProfile.fromJson(Map<String, dynamic> json) => InterestedCategoryProfile(
    id: json['id'],
    categoryName: json['categoryName'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'categoryName': categoryName,
  };
}

class ProfilePic {
  final int id;
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

  ProfilePic({
    required this.id,
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
  });

  factory ProfilePic.fromJson(Map<String, dynamic> json) => ProfilePic(
    id: json['id'],
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
  );

  Map<String, dynamic> toJson() => {
    'id': id,
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
  };
}
