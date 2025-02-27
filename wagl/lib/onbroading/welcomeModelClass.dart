

import 'dart:convert';

WelcomeModel getWelcomeModelFromJson(String str) => WelcomeModel.fromJson(json.decode(str));

String getWelcomeModelToJson(WelcomeModel dataFields) => json.encode(dataFields.toJson());
class WelcomeModel {
  WelcomeModel({
    required this.dataFields,
  });

  final List<Datum> dataFields;

  factory WelcomeModel.fromJson(Map<String, dynamic> json){
    return WelcomeModel(
      dataFields: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "data": dataFields.map((x) => x.toJson()).toList(),
  };

}

class Datum {
  Datum({
    required this.id,
    required this.attributes,
  });

  final int? id;
  final Attributes? attributes;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"],
      attributes: json["attributes"] == null ? null : Attributes.fromJson(json["attributes"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "attributes": attributes?.toJson(),
  };

}

class Attributes {
  Attributes({
    required this.title,
    required this.description,
  });

  final String? title;
  final String? description;

  factory Attributes.fromJson(Map<String, dynamic> json){
    return Attributes(
      title: json["title"],
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
  };

}
