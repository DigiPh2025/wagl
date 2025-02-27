import 'dart:convert';

LoginModel loginResponseFromJson(String str) => LoginModel.fromJson(json.decode(str));


class LoginModel {
  LoginModel({
    required this.jwt,
    required this.user,
  });

  final String jwt;
  final UserDetails user;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    jwt: json["jwt"],
    user: UserDetails.fromJson(json["user"]),
  );


}

class UserDetails {
  int id;
  String username;
  String email;
  String provider;
  bool confirmed;
  bool blocked;
  DateTime createdAt;
  DateTime updatedAt;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? location;
  String? gender;
  String? pronouns;
  String accountType;
  int totalWagls;
  int totalFollowers;
  int totalFollowing;
  int totalViews;
  String bio;
  String linkAccountBy;
  bool emailNotification;
  bool pushNotification;

  UserDetails({
    required this.id,
    required this.username,
    required this.email,
    required this.provider,
    required this.confirmed,
    required this.blocked,
    required this.createdAt,
    required this.updatedAt,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.location,
    this.gender,
    this.pronouns,
    required this.accountType,
    required this.totalWagls,
    required this.totalFollowers,
    required this.totalFollowing,
    required this.totalViews,
    required this.bio,
    required this.linkAccountBy,
    required this.emailNotification,
    required this.pushNotification,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      provider: json['provider'],
      confirmed: json['confirmed'],
      blocked: json['blocked'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: json['dateOfBirth'],
      location: json['location'],
      gender: json['gender'],
      pronouns: json['pronouns'],
      accountType: json['accountType'],
      totalWagls: json['totalWagls'],
      totalFollowers: json['totalFollowers'],
      totalFollowing: json['totalFollowing'],
      totalViews: json['totalViews'],
      bio: json['bio'] ?? '', // Provide default value
      linkAccountBy: json['linkAccountBy'] ?? '', // Provide default value
      emailNotification: json['emailNotification'],
      pushNotification: json['pushNotification'],
    );
  }
}


