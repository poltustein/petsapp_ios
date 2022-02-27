class IssueResponse {
  String? reason;
  String? status;

  IssueResponse({this.reason, this.status});

  IssueResponse.fromJson(Map<String, dynamic> json) {
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