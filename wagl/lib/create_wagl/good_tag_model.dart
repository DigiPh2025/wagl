import 'dart:convert';

GoodTagModel goodTagModelFromJson(String str) => GoodTagModel.fromJson(json.decode(str));

String goodTagModelToJson(GoodTagModel data) => json.encode(data.toJson());

class GoodTagModel {
  final List<DataItem> data;

  GoodTagModel({required this.data});
  factory GoodTagModel.fromJson(Map<String, dynamic> json) {
    return GoodTagModel(
      data: List<DataItem>.from(json['data'].map((item) => DataItem.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class DataItem {
  final int id;
  final Attributes attributes;

  DataItem({required this.id, required this.attributes});

  factory DataItem.fromJson(Map<String, dynamic> json) {
    return DataItem(
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
  final String name;
  final ImageData image;

  Attributes({
    required this.name,
    required this.image,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
      name: json['name'],
      image: ImageData.fromJson(json['image']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image.toJson(),
    };
  }

}
class ImageData {
  ImageAttributes data;

  ImageData({required this.data});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      data: ImageAttributes.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
    };
  }
}

class ImageAttributes {
  int id;
  ImageDetail attributes;

  ImageAttributes({required this.id, required this.attributes});

  factory ImageAttributes.fromJson(Map<String, dynamic> json) {
    return ImageAttributes(
      id: json['id'],
      attributes: ImageDetail.fromJson(json['attributes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': attributes.toJson(),
    };
  }
}

class ImageDetail {
  String ext;
  String url;

  ImageDetail({
    required this.ext,
    required this.url,
  });

  factory ImageDetail.fromJson(Map<String, dynamic> json) {
    return ImageDetail(
      ext: json['ext'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ext': ext,
      'url': url,
    };
  }
}



