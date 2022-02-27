class SubscriptionResponse {
  String? status;
  String? reason;

  SubscriptionResponse({this.status, this.reason});

  SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['reason'] = this.reason;
    return data;
  }
}
