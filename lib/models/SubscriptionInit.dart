class SubscriptionInit {
  String? reason;
  String? customerId;
  String? clientSecret;
  String? subscriptionId;
  String? status;

  SubscriptionInit(
      {this.reason,
        this.customerId,
        this.clientSecret,
        this.subscriptionId,
        this.status});

  SubscriptionInit.fromJson(Map<String, dynamic> json) {
    reason = json['reason'];
    customerId = json['customerId'];
    clientSecret = json['clientSecret'];
    subscriptionId = json['subscriptionId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reason'] = this.reason;
    data['customerId'] = this.customerId;
    data['clientSecret'] = this.clientSecret;
    data['subscriptionId'] = this.subscriptionId;
    data['status'] = this.status;
    return data;
  }
}