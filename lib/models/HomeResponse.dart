class HomeResponse {
  List<Resources>? resources;
  List<Videos>? videos;
  int? visibility;
  bool? isVisible;
  String? subscribePlatformText;
  String? subscribeImageUrl;
  String? subscribeTitle;
  String? subscribeDescription;
  String? buyButtonText;
  int count = 0;

  HomeResponse(
      {this.resources,
      this.videos,
      this.visibility,
      this.isVisible,
      this.subscribePlatformText,
      this.subscribeImageUrl,
      this.subscribeTitle,
      this.subscribeDescription,
      this.buyButtonText,
      required this.count});

  HomeResponse.fromJson(Map<String, dynamic> json) {
    if (json['resources'] != null) {
      resources = <Resources>[];
      json['resources'].forEach((v) {
        resources!.add(new Resources.fromJson(v));
      });
    }
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(new Videos.fromJson(v));
      });
    }
    visibility = json['visibility'];
    isVisible = json['isVisible'];
    subscribePlatformText = json['subscribePlatformText'];
    subscribeImageUrl = json['subscribeImageUrl'];
    subscribeTitle = json['subscribeTitle'];
    subscribeDescription = json['subscribeDescription'];
    buyButtonText = json['buyButtonText'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.resources != null) {
      data['resources'] = this.resources!.map((v) => v.toJson()).toList();
    }
    if (this.videos != null) {
      data['videos'] = this.videos!.map((v) => v.toJson()).toList();
    }
    data['visibility'] = this.visibility;
    data['isVisible'] = this.isVisible;
    data['subscribePlatformText'] = this.subscribePlatformText;
    data['subscribeImageUrl'] = this.subscribeImageUrl;
    data['subscribeTitle'] = this.subscribeTitle;
    data['subscribeDescription'] = this.subscribeDescription;
    data['buyButtonText'] = this.buyButtonText;
    data['count'] = this.count;
    return data;
  }
}

class Resources {
  String? bannerId;
  String? resources;
  String? description;
  String? url;
  String? thumbUrl;
  String? title;
  String? createdOn;

  Resources(
      {this.bannerId,
      this.resources,
      this.description,
      this.url,
      this.thumbUrl,
      this.title,
      this.createdOn});

  Resources.fromJson(Map<String, dynamic> json) {
    bannerId = json['bannerId'];
    resources = json['resources'];
    description = json['description'];
    url = json['url'];
    thumbUrl = json['thumbUrl'];
    title = json['title'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bannerId'] = this.bannerId;
    data['resources'] = this.resources;
    data['description'] = this.description;
    data['url'] = this.url;
    data['thumbUrl'] = this.thumbUrl;
    data['title'] = this.title;
    data['createdOn'] = this.createdOn;
    return data;
  }
}

class Videos {
  String? resourceId;
  String? resourceType;
  String? title;
  List<Categories>? categories;
  String? createdOn;
  String? url;
  String? thumbUrl;
  String? time;
  bool? isLiked;

  Videos(
      {this.resourceId,
      this.resourceType,
      this.title,
      this.categories,
      this.createdOn,
      this.url,
      this.thumbUrl,
      this.time,
      this.isLiked});

  Videos.fromJson(Map<String, dynamic> json) {
    resourceId = json['resourceId'];
    resourceType = json['resourceType'];
    title = json['title'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    createdOn = json['createdOn'];
    url = json['url'];
    thumbUrl = json["thumbUrl"];
    time = json['time'];
    isLiked = json['isLiked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resourceId'] = this.resourceId;
    data['resourceType'] = this.resourceType;
    data['title'] = this.title;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    data['createdOn'] = this.createdOn;
    data['url'] = this.url;
    data["thumbUrl"] = this.thumbUrl;
    data['time'] = this.time;
    data['isLiked'] = this.isLiked;
    return data;
  }
}

class Categories {
  String? sId;
  String? categoryName;

  Categories({this.sId, this.categoryName});

  Categories.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['categoryName'] = this.categoryName;
    return data;
  }
}
