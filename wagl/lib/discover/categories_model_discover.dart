import 'dart:convert';

DiscoverCategories viewAllCategoriesModelFromJson(String str) => DiscoverCategories.fromJson(json.decode(str));


class DiscoverCategories {
  List<Data>? data;
  Meta? meta;

  DiscoverCategories({this.data, this.meta});

  DiscoverCategories.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  CategoryAttributes? attributes;

  Data({this.id, this.attributes});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributes = json['attributes'] != null
        ? new CategoryAttributes.fromJson(json['attributes'])
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
class DataImage {
  int? id;
  AttributesImage? attributesImage;

  DataImage({this.id, this.attributesImage});

  DataImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributesImage = json['attributes'] != null
        ? new AttributesImage.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attributesImage != null) {
      data['attributes'] = this.attributesImage!.toJson();
    }
    return data;
  }
}

class CategoryIconData {
  int? id;
  AttributesIcon? attributes;

  CategoryIconData({this.id, this.attributes});

  CategoryIconData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributes = json['attributes'] != null
        ? new AttributesIcon.fromJson(json['attributes'])
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

class CategoryAttributes {
  String? categoryName;
  int? totalWagls;
  CategoryIcon? categoryIcon;
  CategoryImage? categoryImage;

  CategoryAttributes({this.categoryName, this.categoryIcon, this.categoryImage});

  CategoryAttributes.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    totalWagls = json['totalWagls'];
    categoryIcon = json['categoryIcon'] != null
        ? new CategoryIcon.fromJson(json['categoryIcon'])
        : null;
    categoryImage = json['categoryImage'] != null
        ? new CategoryImage.fromJson(json['categoryImage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryName'] = this.categoryName;
    data['totalWagls'] = this.totalWagls;
    if (this.categoryIcon != null) {
      data['categoryIcon'] = this.categoryIcon!.toJson();
    }
    if (this.categoryImage != null) {
      data['categoryImage'] = this.categoryImage!.toJson();
    }
    return data;
  }
}

class CategoryIcon {
  List<CategoryIconData>? data;

  CategoryIcon({this.data});

  CategoryIcon.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CategoryIconData>[];
      json['data'].forEach((v) {
        data!.add(new CategoryIconData.fromJson(v));
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

class AttributesIcon {
  String? name;

  String? url;


  AttributesIcon(
      {this.name,

        this.url,
       });

  AttributesIcon.fromJson(Map<String, dynamic> json) {
    name = json['name'];

    url = json['url'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;

    data['url'] = this.url;

    return data;
  }
}

class CategoryImage {
  DataImage? data;

  CategoryImage({this.data});

  CategoryImage.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new DataImage.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AttributesImage {

  Formats? formats;

  String? ext;

  String? url;


  AttributesImage(
      {
        this.formats,

        this.ext,

        this.url,
        t});

  AttributesImage.fromJson(Map<String, dynamic> json) {

    formats =
    json['formats'] != null ? new Formats.fromJson(json['formats']) : null;

    ext = json['ext'];

    url = json['url'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.formats != null) {
      data['formats'] = this.formats!.toJson();
    }

    data['ext'] = this.ext;

    data['url'] = this.url;

    return data;
  }
}

class Formats {
  Small? small;
  Small? medium;
  Small? thumbnail;

  Formats({this.small, this.medium, this.thumbnail});

  Formats.fromJson(Map<String, dynamic> json) {
    small = json['small'] != null ? new Small.fromJson(json['small']) : null;
    medium = json['medium'] != null ? new Small.fromJson(json['medium']) : null;
    thumbnail = json['thumbnail'] != null
        ? new Small.fromJson(json['thumbnail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

class Small {
  String? ext;
  String? url;
  String? hash;
  String? mime;
  String? name;
  Null? path;
  double? size;
  int? width;
  int? height;
  int? sizeInBytes;
  bool? isUrlSigned;

  Small(
      {this.ext,
        this.url,
        this.hash,
        this.mime,
        this.name,
        this.path,
        this.size,
        this.width,
        this.height,
        this.sizeInBytes,
        this.isUrlSigned});

  Small.fromJson(Map<String, dynamic> json) {
    ext = json['ext'];
    url = json['url'];
    hash = json['hash'];
    mime = json['mime'];
    name = json['name'];
    path = json['path'];
    size = json['size'];
    width = json['width'];
    height = json['height'];
    sizeInBytes = json['sizeInBytes'];
    isUrlSigned = json['isUrlSigned'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ext'] = this.ext;
    data['url'] = this.url;
    data['hash'] = this.hash;
    data['mime'] = this.mime;
    data['name'] = this.name;
    data['path'] = this.path;
    data['size'] = this.size;
    data['width'] = this.width;
    data['height'] = this.height;
    data['sizeInBytes'] = this.sizeInBytes;
    data['isUrlSigned'] = this.isUrlSigned;
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
