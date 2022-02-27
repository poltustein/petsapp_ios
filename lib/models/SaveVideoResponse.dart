class SaveVideoResponse {
  String? reason;
  String? status;

  SaveVideoResponse({this.reason, this.status});

  SaveVideoResponse.fromJson(Map<String, dynamic> json) {
    reason = json['reason'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reason'] = this.reason;
    data['status'] = this.status;
    return data;
  }
}