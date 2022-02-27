class AddDogResponse {
  String? status;
  String? reason;
  String? dogId;

  AddDogResponse({this.status, this.reason, this.dogId});

  AddDogResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    reason = json['reason'];
    dogId = json['dogId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['reason'] = this.reason;
    data['dogId'] = this.dogId;
    return data;
  }
}