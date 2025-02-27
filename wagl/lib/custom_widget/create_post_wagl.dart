import 'package:flutter/material.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/services/remote_services.dart';
import '../home/home_page.dart';
import '../util/SizeConfig.dart';
import 'custom_loading_popup.dart';
import 'package:http/http.dart' as http; // Make sure to add http package in pubspec.yaml
import 'dart:convert';


class CustCreateWaglPost extends StatefulWidget {
  final Function() onSelected;
  final isCancelButtonVisible;
  final Function(bool isShow) isDiscard;

  const CustCreateWaglPost({Key? key, required this.onSelected,@required this.isCancelButtonVisible,required this.isDiscard(value)}) : super(key: key);

  @override
  _CustCreateWaglPostState createState() => _CustCreateWaglPostState();
}

class _CustCreateWaglPostState extends State<CustCreateWaglPost> {
  String postPrompt = "Loading..."; // Default text while loading
  bool isShow=true;
  @override
  void initState() {
    super.initState();
    updateTextApi(); // Fetch the post prompt when the widget is initialized
  }

  Future<void> updateTextApi() async {
    try {
      var response = await RemoteServices.fetchGetData(
          'api/category-dialogs');
      if (response.statusCode == 200) {
        var apiDetails = categoryDialogsFromJson(response.body);
        setState(() {
          postPrompt = apiDetails.data?[0].attributes?.message ?? "Join the conversation, and post your own wagl"; // Adjust based on your API response structure
widget.isDiscard(false);
        });
      } else {
        setState(() {
          postPrompt = "Error fetching prompt"; // Handle error accordingly
        });
      }
    } catch (e) {
      setState(() {
        postPrompt = "Join the conversation, and post your own wagl"; // Handle exceptions
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // updateTextApi();
    return isShow?Container(
      height: 18 * SizeConfig.heightMultiplier,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber.shade600,
          borderRadius: BorderRadius.all(Radius.circular(2 * SizeConfig.heightMultiplier)),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.asset(
                  "assets/images/background_web.png",
                  width: 48 * SizeConfig.widthMultiplier,
                  fit: BoxFit.fill,
                  height: 18 * SizeConfig.heightMultiplier,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 4 * SizeConfig.widthMultiplier,
                vertical: 2 * SizeConfig.heightMultiplier,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 60 * SizeConfig.widthMultiplier,
                    child: CustTextBold(
                      name: postPrompt, // Updated text based on API call
                      size: 2.0,
                      colors: colorBlack,

                      textAlign: TextAlign.start,
                      borderColors: Colors.transparent,
                      fontWeightName: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (await homeController.checkPermission()){
                      widget.onSelected();
                      }
                      else{
                        print("check permission");
                      }
                    },
                    child: Container(
                      width: double.maxFinite,
                      height: 6 * SizeConfig.heightMultiplier,
                      decoration: BoxDecoration(
                        color: colorBlack,
                        borderRadius: BorderRadius.all(Radius.circular(1.5 * SizeConfig.imageSizeMultiplier)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 7 * SizeConfig.widthMultiplier),
                          CustText(
                            name: "Create a post",
                            size: 1.8,
                            fontWeightName: FontWeight.w800,
                            colors: colorWhite,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 5.0 * SizeConfig.widthMultiplier),
                            child: Image.asset(
                              "assets/images/wagl_logo.png",
                              fit: BoxFit.contain,
                              height: 3 * SizeConfig.heightMultiplier,
                              width: 5 * SizeConfig.widthMultiplier,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 2 * SizeConfig.widthMultiplier,
              top: 1 * SizeConfig.heightMultiplier,
              child: GestureDetector(
                onTap: () {
                  // Close functionality
                  setState(() {
                    isShow=false;
                    widget.isDiscard(true);
                  });

                },
                child: Container(
                  width: 9 * SizeConfig.widthMultiplier,
                  height: 5 * SizeConfig.heightMultiplier,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorWhite,
                  ),
                  child: Icon(Icons.close_rounded, color: colorBlack, size: 5 * SizeConfig.imageSizeMultiplier),
                ),
              ),
            ),
          ],
        ),
      ),
    ):Container();
  }
}
// To parse this JSON data, do
//
//     final categoryDialogs = categoryDialogsFromJson(jsonString);


// To parse this JSON data, do
//
//     final categoryDialogs = categoryDialogsFromJson(jsonString);


CategoryDialogs categoryDialogsFromJson(String str) => CategoryDialogs.fromJson(json.decode(str));

String categoryDialogsToJson(CategoryDialogs data) => json.encode(data.toJson());

class CategoryDialogs {
  List<Datum>? data;
  Meta? meta;

  CategoryDialogs({
    this.data,
    this.meta,
  });

  factory CategoryDialogs.fromJson(Map<String, dynamic> json) => CategoryDialogs(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
  };
}

class Datum {
  int? id;
  Attributes? attributes;

  Datum({
    this.id,
    this.attributes,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    attributes: json["attributes"] == null ? null : Attributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attributes": attributes?.toJson(),
  };
}

class Attributes {
  String? title;
  String? message;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;

  Attributes({
    this.title,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    title: json["title"],
    message: json["message"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    publishedAt: json["publishedAt"] == null ? null : DateTime.parse(json["publishedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "message": message,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "publishedAt": publishedAt?.toIso8601String(),
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
