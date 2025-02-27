import 'dart:convert';

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));
User userFromJsonModel(String str) => User.fromJson(json.decode(str));

String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProfilePic {
  final int id;
  final String name;
  final String? alternativeText;
  final String? caption;
  final int width;
  final int height;
  final Map<String, Format> formats;
  final String hash;
  final String ext;
  final String mime;
  final double size;
  final String url;
  final String? previewUrl;
  final String provider;
  final dynamic providerMetadata;
  final String createdAt;
  final String updatedAt;
  final bool isUrlSigned;

  ProfilePic({
    required this.id,
    required this.name,
    this.alternativeText,
    this.caption,
    required this.width,
    required this.height,
    required this.formats,
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

  factory ProfilePic.fromJson(Map<String, dynamic> json) {
    return ProfilePic(
      id: json['id'],
      name: json['name'],
      alternativeText: json['alternativeText'],
      caption: json['caption'],
      width: json['width'],
      height: json['height'],
      formats: (json['formats'] as Map<String, dynamic>).map((k, v) => MapEntry(k, Format.fromJson(v))),
      hash: json['hash'],
      ext: json['ext'],
      mime: json['mime'],
      size: (json['size'] as num).toDouble(),
      url: json['url'],
      previewUrl: json['previewUrl'],
      provider: json['provider'],
      providerMetadata: json['provider_metadata'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isUrlSigned: json['isUrlSigned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'alternativeText': alternativeText,
      'caption': caption,
      'width': width,
      'height': height,
      'formats': formats.map((k, v) => MapEntry(k, v.toJson())),
      'hash': hash,
      'ext': ext,
      'mime': mime,
      'size': size,
      'url': url,
      'previewUrl': previewUrl,
      'provider': provider,
      'provider_metadata': providerMetadata,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isUrlSigned': isUrlSigned,
    };
  }
}

class Format {
  final String ext;
  final String url;
  final String hash;
  final String mime;
  final String name;
  final dynamic path;
  final double size;
  final int width;
  final int height;
  final int sizeInBytes;
  final bool isUrlSigned;

  Format({
    required this.ext,
    required this.url,
    required this.hash,
    required this.mime,
    required this.name,
    this.path,
    required this.size,
    required this.width,
    required this.height,
    required this.sizeInBytes,
    required this.isUrlSigned,
  });

  factory Format.fromJson(Map<String, dynamic> json) {
    return Format(
      ext: json['ext'],
      url: json['url'],
      hash: json['hash'],
      mime: json['mime'],
      name: json['name'],
      path: json['path'],
      size: (json['size'] as num).toDouble(),
      width: json['width'],
      height: json['height'],
      sizeInBytes: json['sizeInBytes'],
      isUrlSigned: json['isUrlSigned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ext': ext,
      'url': url,
      'hash': hash,
      'mime': mime,
      'name': name,
      'path': path,
      'size': size,
      'width': width,
      'height': height,
      'sizeInBytes': sizeInBytes,
      'isUrlSigned': isUrlSigned,
    };
  }
}

class User {
  final int id;
  final String username;
  final String email;
  final String provider;
  final bool confirmed;
  final bool blocked;
  final String? firstName;
  final String? lastName;
  final String? dateOfBirth;
  final String? location;
  final String? gender;
  final String? pronouns;
  final String? accountType;
  final String createdAt;
  final String updatedAt;
  final int totalWagls;
  final int totalFollowers;
  final int totalFollowing;
  final int totalViews;
  final String? bio;
  final String? linkAccountBy;
  final bool? emailNotification;
  final bool? pushNotification;
  final ProfilePic? profilePic;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.provider,
    required this.confirmed,
    required this.blocked,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.location,
    this.gender,
    this.pronouns,
    this.accountType,
    required this.createdAt,
    required this.updatedAt,
    required this.totalWagls,
    required this.totalFollowers,
    required this.totalFollowing,
    required this.totalViews,
    this.bio,
    this.linkAccountBy,
    this.emailNotification,
    this.pushNotification,
    this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      provider: json['provider'],
      confirmed: json['confirmed'],
      blocked: json['blocked'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: json['dateOfBirth'],
      location: json['location'],
      gender: json['gender'],
      pronouns: json['pronouns'],
      accountType: json['accountType'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      totalWagls: json['totalWagls'],
      totalFollowers: json['totalFollowers'],
      totalFollowing: json['totalFollowing'],
      totalViews: json['totalViews'],
      bio: json['bio'],
      linkAccountBy: json['linkAccountBy'],
      emailNotification: json['emailNotification'],
      pushNotification: json['pushNotification'],
      profilePic: json['profilePic'] != null ? ProfilePic.fromJson(json['profilePic']) : null,
    );
  }

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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'totalWagls': totalWagls,
      'totalFollowers': totalFollowers,
      'totalFollowing': totalFollowing,
      'totalViews': totalViews,
      'bio': bio,
      'linkAccountBy': linkAccountBy,
      'emailNotification': emailNotification,
      'pushNotification': pushNotification,
      'profilePic': profilePic?.toJson(),
    };
  }
}

List<User> parseUsers(String jsonString) {
  final parsed = jsonDecode(jsonString).cast<Map<String, dynamic>>();
  return parsed.map<User>((json) => User.fromJson(json)).toList();
}
