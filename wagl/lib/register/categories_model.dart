import 'dart:convert';

DataModel getCategoriesModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String getCategoriesModelToJson(DataModel dataFields) => json.encode(dataFields.toJson());


class DataModel {
  final List<CategoryList> data;

  DataModel({required this.data});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      data: List<CategoryList>.from(json['data'].map((item) => CategoryList.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class CategoryList {
  final int id;
  final Attributes attributes;

  CategoryList({required this.id, required this.attributes});

  factory CategoryList.fromJson(Map<String, dynamic> json) {
    return CategoryList(
      id: json['id'],
      attributes: Attributes.fromJson(json['attributes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': attributes.toJson(),
    };
  }
}

class Attributes {
  final String categoryName;
   CategoryImage? categoryImage;
   CategoryIcon? categoryIcon;

  Attributes({required this.categoryName, this.categoryImage,this.categoryIcon});

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
      categoryName: json['categoryName'],
      categoryIcon: json["categoryIcon"] == null ? null : CategoryIcon.fromJson(json["categoryIcon"]),
      categoryImage: CategoryImage.fromJson(json['categoryImage']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      "categoryIcon": categoryIcon?.toJson(),
      'categoryImage': categoryImage?.toJson(),
    };
  }
}

class CategoryIcon {
  final List<IconData> data;

  CategoryIcon({required this.data});

  factory CategoryIcon.fromJson(Map<String, dynamic> json) {
    return CategoryIcon(
      data: List<IconData>.from(json['data'].map((item) => IconData.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class CategoryImage {
  final IconData data;

  CategoryImage({required this.data});

  factory CategoryImage.fromJson(Map<String, dynamic> json) {
    return CategoryImage(
      data: IconData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
    };
  }
}

class IconData {
  final int id;
  final IconAttributes attributes;

  IconData({required this.id, required this.attributes});

  factory IconData.fromJson(Map<String, dynamic> json) {
    return IconData(
      id: json['id'],
      attributes: IconAttributes.fromJson(json['attributes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': attributes.toJson(),
    };
  }
}

class IconAttributes {
  final String url;
  final bool? isUrlSigned;

  IconAttributes({required this.url, required this.isUrlSigned});

  factory IconAttributes.fromJson(Map<String, dynamic> json) {
    return IconAttributes(
      url: json['url'],
      isUrlSigned: json['isUrlSigned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'isUrlSigned': isUrlSigned,
    };
  }
}