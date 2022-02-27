class CategoriesResponse {
  List<Categories>? categories;
  String? status;
  String? reason;

  CategoriesResponse({this.categories, this.status, this.reason});

  CategoriesResponse.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    status = json['status'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['reason'] = this.reason;
    return data;
  }
}

class Categories {
  String? sId;
  String? categoryName;
  bool? isEnabled;

  Categories({this.sId, this.categoryName, this.isEnabled});

  Categories.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    categoryName = json['categoryName'];
    isEnabled = json['isEnabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['categoryName'] = this.categoryName;
    data['isEnabled'] = this.isEnabled;
    return data;
  }
}