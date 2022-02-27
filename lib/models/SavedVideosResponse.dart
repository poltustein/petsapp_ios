class SavedVideosResponse {
  int? count;
  List<SavedVideo>? videos;
  String? status;
  String? reason;

  SavedVideosResponse({this.count, this.videos, this.status, this.reason});

  SavedVideosResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['videos'] != null) {
      videos = <SavedVideo>[];
      json['videos'].forEach((v) {
        videos!.add(new SavedVideo.fromJson(v));
      });
    }
    status = json['status'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.videos != null) {
      data['videos'] = this.videos!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['reason'] = this.reason;
    return data;
  }
}

class SavedVideo {
  String? savedId;
  String? videoId;
  String? userId;
  String? videoUrl;
  String? savedOn;
  String? time;
  String? title;
  String? createdOn;
  List<Categories>? categories;

  SavedVideo(
      {this.savedId,
        this.videoId,
        this.userId,
        this.videoUrl,
        this.savedOn,
        this.time,
        this.title,
        this.createdOn,
        this.categories});

  SavedVideo.fromJson(Map<String, dynamic> json) {
    savedId = json['savedId'];
    videoId = json['videoId'];
    userId = json['userId'];
    videoUrl = json['videoUrl'];
    savedOn = json['savedOn'];
    time = json['time'];
    title = json['title'];
    createdOn = json['createdOn'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['savedId'] = this.savedId;
    data['videoId'] = this.videoId;
    data['userId'] = this.userId;
    data['videoUrl'] = this.videoUrl;
    data['savedOn'] = this.savedOn;
    data['time'] = this.time;
    data['title'] = this.title;
    data['createdOn'] = this.createdOn;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
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