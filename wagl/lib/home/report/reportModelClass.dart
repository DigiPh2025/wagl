// To parse this JSON data, do
//
//     final reportDetails = reportDetailsFromJson(jsonString);

import 'dart:convert';

ReportDetails reportDetailsFromJson(String str) => ReportDetails.fromJson(json.decode(str));

String reportDetailsToJson(ReportDetails data) => json.encode(data.toJson());

class ReportDetails {
  bool? status;
  List<ReportMessage>? reportMessage;
  List<ReportType>? reportType;
  String? message;

  ReportDetails({
    this.status,
    this.reportMessage,
    this.reportType,
    this.message,
  });

  factory ReportDetails.fromJson(Map<String, dynamic> json) => ReportDetails(
    status: json["status"],
    reportMessage: json["reportMessage"] == null ? [] : List<ReportMessage>.from(json["reportMessage"]!.map((x) => ReportMessage.fromJson(x))),
    reportType: json["reportType"] == null ? [] : List<ReportType>.from(json["reportType"]!.map((x) => ReportType.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "reportMessage": reportMessage == null ? [] : List<dynamic>.from(reportMessage!.map((x) => x.toJson())),
    "reportType": reportType == null ? [] : List<dynamic>.from(reportType!.map((x) => x.toJson())),
    "message": message,
  };
}

class ReportMessage {
  int? id;
  String? title;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic publishedAt;

  ReportMessage({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
  });

  factory ReportMessage.fromJson(Map<String, dynamic> json) => ReportMessage(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    publishedAt: json["publishedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "publishedAt": publishedAt,
  };
}

class ReportType {
  int? id;
  String? reason;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;

  ReportType({
    this.id,
    this.reason,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
  });

  factory ReportType.fromJson(Map<String, dynamic> json) => ReportType(
    id: json["id"],
    reason: json["reason"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    publishedAt: json["publishedAt"] == null ? null : DateTime.parse(json["publishedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reason": reason,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "publishedAt": publishedAt?.toIso8601String(),
  };
}
