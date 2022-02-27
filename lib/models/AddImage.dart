class AddImageResponse {
  String? reason;
  String? status;
  String? url;

  AddImageResponse({this.reason, this.status, this.url});

  AddImageResponse.fromJson(Map<String, dynamic> json) {
    reason = json['reason'];
    status = json['status'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reason'] = this.reason;
    data['status'] = this.status;
    data['url'] = this.url;
    return data;
  }
}